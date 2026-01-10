import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

// Helper to get authenticated Supabase client from request
function getSupabaseClient(request: NextRequest) {
  const authHeader = request.headers.get('authorization')
  const token = authHeader?.replace('Bearer ', '')
  
  if (token) {
    return createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    })
  }
  
  return createClient(supabaseUrl, supabaseAnonKey)
}

// GET /api/manufacturers - Get all manufacturers or filter by user
export async function GET(request: NextRequest) {
  try {
    const supabase = getSupabaseClient(request)
    const { searchParams } = new URL(request.url)
    const country = searchParams.get('country')
    const userId = searchParams.get('user_id')
    const verificationStatus = searchParams.get('verification_status')

    let query = supabase
      .from('manufacturers')
      .select('*')

    if (userId) {
      query = query.eq('user_id', userId)
    }

    if (country) {
      query = query.eq('country', country)
    }

    if (verificationStatus) {
      query = query.eq('verification_status', verificationStatus)
    }

    query = query.order('created_at', { ascending: false })

    const { data, error } = await query

    if (error) {
      return NextResponse.json(
        { error: 'Failed to fetch manufacturers' },
        { status: 500 }
      )
    }

    return NextResponse.json({ manufacturers: data })
  } catch (error) {
    console.error('Manufacturers API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

// POST /api/manufacturers - Create new manufacturer (factory signup)
export async function POST(request: NextRequest) {
  try {
    const supabase = getSupabaseClient(request)
    const body = await request.json()
    const {
      user_id,
      company_name,
      company_name_ar,
      country,
      city,
      region,
      contact_email,
      contact_phone,
      website_url,
      description,
      description_ar,
      business_license,
      business_license_expiry,
      verified_documents,
    } = body

    if (!user_id || !company_name || !contact_email || !business_license) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      )
    }

    // Validate business license expiry
    if (business_license_expiry) {
      const expiryDate = new Date(business_license_expiry)
      const today = new Date()
      today.setHours(0, 0, 0, 0)
      
      if (expiryDate < today) {
        return NextResponse.json(
          { error: 'Business license has expired' },
          { status: 400 }
        )
      }
    }

    // Create manufacturer profile
    const { data, error } = await supabase
      .from('manufacturers')
      .insert({
        user_id,
        company_name,
        company_name_ar: company_name_ar || null,
        country: country || 'China',
        city: city || null,
        region: region || null,
        contact_email,
        contact_phone: contact_phone || null,
        website_url: website_url || null,
        description: description || null,
        description_ar: description_ar || null,
        business_license,
        business_license_expiry: business_license_expiry ? new Date(business_license_expiry).toISOString() : null,
        verification_status: 'pending',
        verified_documents: verified_documents || [],
      })
      .select()
      .single()

    if (error) {
      console.error('Manufacturer creation error:', error)
      return NextResponse.json(
        { error: 'Failed to create manufacturer profile' },
        { status: 500 }
      )
    }

    return NextResponse.json({
      success: true,
      manufacturer: data,
    })
  } catch (error) {
    console.error('Manufacturers API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
