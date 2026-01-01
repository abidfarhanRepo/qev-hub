import { NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { fetchChargingStations } from '@/lib/charging-data-provider'

export async function POST(request: Request) {
  try {
    const stations = await fetchChargingStations()
    
    const results = []
    for (const station of stations) {
      const { data, error } = await supabase
        .from('charging_stations')
        .upsert(
          {
            ...station,
            last_scraped_at: new Date().toISOString(),
          }
        )

      if (error) {
        results.push({ station: station.name, status: 'error', error: error.message })
      } else {
        results.push({ station: station.name, status: 'success' })
      }
    }

    return NextResponse.json({
      success: true,
      message: `Synced ${stations.length} stations`,
      results,
    })
  } catch (error) {
    console.error('Sync error:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to sync stations' },
      { status: 500 }
    )
  }
}

export async function GET() {
  try {
    const { data, error } = await supabase
      .from('charging_stations')
      .select('last_scraped_at')
      .order('last_scraped_at', { ascending: false })
      .limit(1)
      .single()

    if (error) throw error

    return NextResponse.json({
      success: true,
      lastSync: data?.last_scraped_at || null,
    })
  } catch (error) {
    return NextResponse.json(
      { success: false, error: 'Failed to get sync status' },
      { status: 500 }
    )
  }
}
