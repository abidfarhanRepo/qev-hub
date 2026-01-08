import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'

// GET /api/manufacturers/[id]/inventory - Get manufacturer's current inventory
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const manufacturerId = params.id

    // Fetch all vehicles for this manufacturer
    const { data: vehicles, error } = await supabase
      .from('vehicles')
      .select('*')
      .eq('manufacturer_id', manufacturerId)
      .order('created_at', { ascending: false })

    if (error) {
      console.error('Error fetching inventory:', error)
      return NextResponse.json(
        { error: 'Failed to fetch inventory' },
        { status: 500 }
      )
    }

    return NextResponse.json({
      success: true,
      inventory: vehicles,
      total_vehicles: vehicles.length,
      in_stock: vehicles.filter((v) => v.stock_count > 0).length,
    })
  } catch (error) {
    console.error('Inventory API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

// PUT /api/manufacturers/[id]/inventory - Update inventory from manufacturer system
export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const manufacturerId = params.id
    const updates = await request.json()

    // Validate manufacturer exists
    const { data: manufacturer, error: manufacturerError } = await supabase
      .from('manufacturers')
      .select('id, verification_status')
      .eq('id', manufacturerId)
      .single()

    if (manufacturerError || !manufacturer) {
      return NextResponse.json(
        { error: 'Manufacturer not found' },
        { status: 404 }
      )
    }

    if (manufacturer.verification_status !== 'verified') {
      return NextResponse.json(
        { error: 'Manufacturer not verified' },
        { status: 403 }
      )
    }

    // Process inventory updates
    // Expected format: { vehicles: [{ id: string, stock_count: number, price_qar: number, ... }] }
    const { vehicles } = updates

    if (!Array.isArray(vehicles)) {
      return NextResponse.json(
        { error: 'Invalid request format. Expected vehicles array' },
        { status: 400 }
      )
    }

    const updateResults = []
    const errors = []

    for (const vehicleUpdate of vehicles) {
      const { id, stock_count, price_qar, manufacturer_direct_price, status } = vehicleUpdate

      if (!id) {
        errors.push({ error: 'Vehicle ID required', vehicle: vehicleUpdate })
        continue
      }

      // Build update object with only provided fields
      const updateData: any = { updated_at: new Date().toISOString() }
      if (stock_count !== undefined) updateData.stock_count = stock_count
      if (price_qar !== undefined) updateData.price_qar = price_qar
      if (manufacturer_direct_price !== undefined) updateData.manufacturer_direct_price = manufacturer_direct_price
      if (status !== undefined) updateData.status = status

      const { data, error } = await supabase
        .from('vehicles')
        .update(updateData)
        .eq('id', id)
        .eq('manufacturer_id', manufacturerId)
        .select()
        .single()

      if (error) {
        errors.push({ vehicle_id: id, error: error.message })
      } else {
        updateResults.push(data)
      }
    }

    return NextResponse.json({
      success: true,
      updated: updateResults.length,
      errors: errors.length > 0 ? errors : undefined,
      vehicles: updateResults,
    })
  } catch (error) {
    console.error('Inventory update error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

// POST /api/manufacturers/[id]/inventory - Bulk sync inventory from manufacturer API
export async function POST(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const manufacturerId = params.id
    const { vehicles, sync_timestamp } = await request.json()

    // Validate manufacturer
    const { data: manufacturer, error: manufacturerError } = await supabase
      .from('manufacturers')
      .select('id, verification_status, company_name')
      .eq('id', manufacturerId)
      .single()

    if (manufacturerError || !manufacturer) {
      return NextResponse.json(
        { error: 'Manufacturer not found' },
        { status: 404 }
      )
    }

    if (manufacturer.verification_status !== 'verified') {
      return NextResponse.json(
        { error: 'Manufacturer not verified' },
        { status: 403 }
      )
    }

    if (!Array.isArray(vehicles)) {
      return NextResponse.json(
        { error: 'Invalid request format. Expected vehicles array' },
        { status: 400 }
      )
    }

    const results = {
      created: 0,
      updated: 0,
      errors: [] as any[],
    }

    for (const vehicle of vehicles) {
      try {
        const {
          external_id, // Manufacturer's internal ID
          model,
          year,
          vehicle_type,
          range_km,
          battery_kwh,
          price_qar,
          manufacturer_direct_price,
          broker_market_price,
          stock_count,
          image_url,
          description,
          specs,
        } = vehicle

        if (!model || !year) {
          results.errors.push({ vehicle, error: 'Missing required fields: model, year' })
          continue
        }

        // Check if vehicle exists by external_id or model+year combo
        const { data: existing } = await supabase
          .from('vehicles')
          .select('id')
          .eq('manufacturer_id', manufacturerId)
          .eq('model', model)
          .eq('year', year)
          .single()

        const vehicleData = {
          manufacturer_id: manufacturerId,
          manufacturer: manufacturer.company_name,
          model,
          year,
          vehicle_type: vehicle_type || 'EV',
          origin_country: 'China',
          range_km: range_km || 0,
          battery_kwh: battery_kwh || 0,
          price_qar: price_qar || manufacturer_direct_price || 0,
          manufacturer_direct_price: manufacturer_direct_price || price_qar || 0,
          broker_market_price: broker_market_price || null,
          price_transparency_enabled: !!broker_market_price,
          stock_count: stock_count || 0,
          status: stock_count > 0 ? 'available' : 'out_of_stock',
          image_url: image_url || null,
          description: description || '',
          specs: specs || {},
          updated_at: new Date().toISOString(),
        }

        if (existing) {
          // Update existing vehicle
          const { error } = await supabase
            .from('vehicles')
            .update(vehicleData)
            .eq('id', existing.id)

          if (error) {
            results.errors.push({ vehicle, error: error.message })
          } else {
            results.updated++
          }
        } else {
          // Create new vehicle
          const { error } = await supabase
            .from('vehicles')
            .insert(vehicleData)

          if (error) {
            results.errors.push({ vehicle, error: error.message })
          } else {
            results.created++
          }
        }
      } catch (error: any) {
        results.errors.push({ vehicle, error: error.message })
      }
    }

    return NextResponse.json({
      success: true,
      manufacturer: manufacturer.company_name,
      sync_timestamp: sync_timestamp || new Date().toISOString(),
      results,
    })
  } catch (error) {
    console.error('Bulk sync error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
