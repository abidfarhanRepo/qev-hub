import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@supabase/supabase-js'
import { exec } from 'child_process'
import { promisify } from 'util'

const execAsync = promisify(exec)

// Initialize Supabase
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient(supabaseUrl, supabaseKey)

export async function POST(request: NextRequest) {
  try {
    // Verify admin access
    const authHeader = request.headers.get('authorization')
    if (authHeader !== `Bearer ${process.env.SCRAPER_API_KEY}`) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      )
    }

    const body = await request.json()
    const { source = 'qatarsale', fullScrape = false } = body

    // Check if a scrape is already running
    const { data: existingJob } = await supabase
      .from('scrape_jobs')
      .select('*')
      .eq('status', 'running')
      .order('created_at', { ascending: false })
      .limit(1)

    if (existingJob && existingJob.length > 0) {
      return NextResponse.json({
        error: 'Scrape already in progress',
        jobId: existingJob[0].id
      }, { status: 409 })
    }

    // Create scrape job record
    const { data: job, error: jobError } = await supabase
      .from('scrape_jobs')
      .insert({
        source,
        status: 'running',
        full_scrape: fullScrape,
        started_at: new Date().toISOString()
      })
      .select()
      .single()

    if (jobError) throw jobError

    // Run scraper asynchronously
    const scriptPath = './scripts/scrape-gmarket-prices.js'
    
    // Run in background
    execAsync(`node ${scriptPath}`, {
      cwd: process.cwd()
    })
      .then(({ stdout, stderr }) => {
        console.log('Scraping completed:', stdout)
        
        supabase
          .from('scrape_jobs')
          .update({
            status: 'completed',
            completed_at: new Date().toISOString(),
            result: stdout.substring(0, 1000)
          })
          .eq('id', job.id)
      })
      .catch(async (error) => {
        console.error('Scraping failed:', error)
        
        await supabase
          .from('scrape_jobs')
          .update({
            status: 'failed',
            completed_at: new Date().toISOString(),
            error: error.message.substring(0, 500)
          })
          .eq('id', job.id)
      })

    return NextResponse.json({
      success: true,
      message: 'Scraping started',
      jobId: job.id
    })
  } catch (error) {
    console.error('Error triggering scrape:', error)
    return NextResponse.json(
      { error: 'Failed to trigger scraping' },
      { status: 500 }
    )
  }
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const status = searchParams.get('status')

    let query = supabase
      .from('scrape_jobs')
      .select('*')
      .order('created_at', { ascending: false })

    if (status) {
      query = query.eq('status', status)
    }

    query = query.limit(10)

    const { data: jobs, error } = await query

    if (error) throw error

    return NextResponse.json({
      success: true,
      jobs
    })
  } catch (error) {
    console.error('Error fetching scrape jobs:', error)
    return NextResponse.json(
      { error: 'Failed to fetch scrape jobs' },
      { status: 500 }
    )
  }
}
