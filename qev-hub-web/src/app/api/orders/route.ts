import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { vehicle_id, user_id, total_price, deposit_amount } = body

    if (!vehicle_id || !user_id || !total_price || !deposit_amount) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      )
    }

    // Check if vehicle is available
    const { data: vehicle, error: vehicleError } = await supabase
      .from('vehicles')
      .select('*')
      .eq('id', vehicle_id)
      .single()

    if (vehicleError || !vehicle || vehicle.stock_count < 1) {
      return NextResponse.json(
        { error: 'Vehicle not available' },
        { status: 400 }
      )
    }

    // Generate tracking ID
    const trackingId = await generateTrackingId()

    // Create order
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .insert({
        user_id,
        vehicle_id,
        tracking_id: trackingId,
        total_price,
        deposit_amount,
        status: 'Order Placed',
        payment_status: 'Pending',
      })
      .select()
      .single()

    if (orderError) {
      console.error('Order creation error:', orderError)
      return NextResponse.json(
        { error: 'Failed to create order' },
        { status: 500 }
      )
    }

    // Create logistics entry
    const { error: logisticsError } = await supabase
      .from('logistics')
      .insert({
        order_id: order.id,
        current_location: 'Manufacturer Facility',
        destination: 'Hamad Port, Qatar',
        status: 'Order Placed',
        tracking_events: [
          {
            status: 'Order Placed',
            location: 'Manufacturer Facility',
            timestamp: new Date().toISOString(),
          },
        ],
      })

    if (logisticsError) {
      console.error('Logistics creation error:', logisticsError)
    }

    // Update vehicle stock
    await supabase
      .from('vehicles')
      .update({ stock_count: vehicle.stock_count - 1 })
      .eq('id', vehicle_id)

    return NextResponse.json({
      success: true,
      order: {
        id: order.id,
        tracking_id: order.tracking_id,
        status: order.status,
        total_price: order.total_price,
        deposit_amount: order.deposit_amount,
      },
    })
  } catch (error) {
    console.error('Order API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

async function generateTrackingId(): Promise<string> {
  const randomNum = Math.floor(Math.random() * 9999)
  return `QEV-${randomNum.toString().padStart(4, '0')}`
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const userId = searchParams.get('user_id')

    if (!userId) {
      return NextResponse.json(
        { error: 'User ID is required' },
        { status: 400 }
      )
    }

    const { data: orders, error } = await supabase
      .from('orders')
      .select(`
        *,
        vehicle:vehicles(*),
        logistics(*),
        payments(*)
      `)
      .eq('user_id', userId)
      .order('created_at', { ascending: false })

    if (error) {
      return NextResponse.json(
        { error: 'Failed to fetch orders' },
        { status: 500 }
      )
    }

    return NextResponse.json({ orders })
  } catch (error) {
    console.error('Fetch orders error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
