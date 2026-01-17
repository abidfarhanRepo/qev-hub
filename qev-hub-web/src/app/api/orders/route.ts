import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { requireAuth } from '@/lib/api-auth'

export async function POST(request: NextRequest) {
  // Require authentication for creating orders
  const { response: authResponse, user } = await requireAuth(request)
  if (authResponse) return authResponse

  try {
    const body = await request.json()
    const { vehicle_id, total_price, deposit_amount } = body
    
    // Use authenticated user's ID instead of accepting it from request body
    const user_id = user!.id

    if (!vehicle_id || !total_price || !deposit_amount) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      )
    }

    // Check if vehicle is available and decrement stock atomically
    // Using a transaction-like approach to prevent race conditions
    const { data: vehicle, error: vehicleError } = await supabase
      .from('vehicles')
      .select('*')
      .eq('id', vehicle_id)
      .gt('stock_count', 0)
      .single()

    if (vehicleError || !vehicle) {
      return NextResponse.json(
        { error: 'Vehicle not available or out of stock' },
        { status: 400 }
      )
    }

    // Atomically decrement stock count
    const { error: updateError } = await supabase
      .from('vehicles')
      .update({ stock_count: vehicle.stock_count - 1 })
      .eq('id', vehicle_id)
      .eq('stock_count', vehicle.stock_count) // Optimistic locking

    if (updateError) {
      return NextResponse.json(
        { error: 'Vehicle stock changed, please try again' },
        { status: 409 }
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
  // Require authentication for fetching orders
  const { response: authResponse, user } = await requireAuth(request)
  if (authResponse) return authResponse

  try {
    // Only allow users to fetch their own orders
    const userId = user!.id

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
