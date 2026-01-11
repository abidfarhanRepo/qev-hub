import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const vehicleId = searchParams.get('vehicle_id')

    if (vehicleId) {
      const { data, error } = await supabase
        .from('vehicles')
        .select('*')
        .eq('id', vehicleId)
        .single()

      if (error) throw error

      return NextResponse.json({
        success: true,
        data
      })
    }

    const { data, error } = await supabase
      .from('price_sources')
      .select('*')
      .eq('is_active', true)
      .order('name')

    if (error) throw error

    return NextResponse.json({
      success: true,
      sources: data
    })
  } catch (error) {
    console.error('Error fetching price data:', error)
    return NextResponse.json(
      { error: 'Failed to fetch price data' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { vehicle_id, grey_market_price, grey_market_source, grey_market_url } = body

    if (!vehicle_id || !grey_market_price) {
      return NextResponse.json(
        { error: 'Vehicle ID and price are required' },
        { status: 400 }
      )
    }

    const { data: vehicle, error: updateError } = await supabase
      .from('vehicles')
      .update({
        grey_market_price: parseFloat(grey_market_price),
        grey_market_source: grey_market_source || 'Qatar Dealership Average',
        grey_market_url: grey_market_url,
        grey_market_updated_at: new Date().toISOString()
      })
      .eq('id', vehicle_id)
      .select('*')
      .single()

    if (updateError) throw updateError

    return NextResponse.json({
      success: true,
      data: vehicle,
      message: 'Grey market price updated successfully'
    })
  } catch (error) {
    console.error('Error updating grey market price:', error)
    return NextResponse.json(
      { error: 'Failed to update grey market price' },
      { status: 500 }
    )
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { vehicle_id, grey_market_price, grey_market_source, grey_market_url } = body

    if (!vehicle_id) {
      return NextResponse.json(
        { error: 'Vehicle ID is required' },
        { status: 400 }
      )
    }

    const { data, error } = await supabase
      .from('vehicles')
      .update({
        grey_market_price: grey_market_price ? parseFloat(grey_market_price) : null,
        grey_market_source: grey_market_source || null,
        grey_market_url: grey_market_url || null,
        grey_market_updated_at: grey_market_price ? new Date().toISOString() : null
      })
      .eq('id', vehicle_id)
      .select('*')
      .single()

    if (error) throw error

    return NextResponse.json({
      success: true,
      data,
      message: 'Grey market price updated successfully'
    })
  } catch (error) {
    console.error('Error updating grey market price:', error)
    return NextResponse.json(
      { error: 'Failed to update grey market price' },
      { status: 500 }
    )
  }
}
