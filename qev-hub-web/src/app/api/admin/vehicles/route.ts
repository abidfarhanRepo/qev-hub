import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'

// POST /api/admin/vehicles - Create new vehicle
export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const {
      manufacturer_id,
      manufacturer,
      model,
      year,
      vehicle_type,
      origin_country,
      range_km,
      battery_kwh,
      price_qar,
      manufacturer_direct_price,
      broker_market_price,
      price_transparency_enabled,
      image_url,
      images,
      description,
      specs,
      stock_count,
      warranty_years,
      warranty_km,
    } = body

    if (!manufacturer_id || !manufacturer || !model || !price_qar || !manufacturer_direct_price) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      )
    }

    // Create vehicle
    const { data, error } = await supabase
      .from('vehicles')
      .insert({
        manufacturer_id,
        manufacturer,
        model,
        year,
        vehicle_type: vehicle_type || 'EV',
        origin_country: origin_country || 'China',
        range_km,
        battery_kwh,
        price_qar,
        manufacturer_direct_price,
        broker_market_price: broker_market_price || manufacturer_direct_price * 1.3,
        price_transparency_enabled: price_transparency_enabled !== undefined ? price_transparency_enabled : true,
        image_url: image_url || null,
        images: images || [],
        description: description || '',
        specs: specs || {},
        stock_count: stock_count || 0,
        status: 'available',
        warranty_years: warranty_years || 5,
        warranty_km: warranty_km || 100000,
      })
      .select()
      .single()

    if (error) {
      console.error('Vehicle creation error:', error)
      return NextResponse.json(
        { error: 'Failed to create vehicle' },
        { status: 500 }
      )
    }

    return NextResponse.json({
      success: true,
      vehicle: data,
    })
  } catch (error) {
    console.error('Vehicle API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

// PUT /api/admin/vehicles - Update existing vehicle
export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updateData } = body

    if (!id) {
      return NextResponse.json(
        { error: 'Vehicle ID is required' },
        { status: 400 }
      )
    }

    // Update vehicle
    const { data, error } = await supabase
      .from('vehicles')
      .update({
        ...updateData,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single()

    if (error) {
      console.error('Vehicle update error:', error)
      return NextResponse.json(
        { error: 'Failed to update vehicle' },
        { status: 500 }
      )
    }

    return NextResponse.json({
      success: true,
      vehicle: data,
    })
  } catch (error) {
    console.error('Vehicle API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

// DELETE /api/admin/vehicles - Delete vehicle
export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const vehicleId = searchParams.get('id')

    if (!vehicleId) {
      return NextResponse.json(
        { error: 'Vehicle ID is required' },
        { status: 400 }
      )
    }

    // Delete vehicle
    const { error } = await supabase
      .from('vehicles')
      .delete()
      .eq('id', vehicleId)

    if (error) {
      console.error('Vehicle deletion error:', error)
      return NextResponse.json(
        { error: 'Failed to delete vehicle' },
        { status: 500 }
      )
    }

    return NextResponse.json({
      success: true,
      message: 'Vehicle deleted successfully',
    })
  } catch (error) {
    console.error('Vehicle API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

// GET /api/admin/vehicles - Get vehicles with optional filtering
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const manufacturerId = searchParams.get('manufacturer_id')
    const vehicleType = searchParams.get('vehicle_type')
    const status = searchParams.get('status')

    let query = supabase
      .from('vehicles')
      .select('*')

    if (manufacturerId) {
      query = query.eq('manufacturer_id', manufacturerId)
    }

    if (vehicleType) {
      query = query.eq('vehicle_type', vehicleType)
    }

    if (status) {
      query = query.eq('status', status)
    }

    query = query.order('created_at', { ascending: false })

    const { data, error } = await query

    if (error) {
      return NextResponse.json(
        { error: 'Failed to fetch vehicles' },
        { status: 500 }
      )
    }

    return NextResponse.json({ vehicles: data })
  } catch (error) {
    console.error('Vehicle API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
