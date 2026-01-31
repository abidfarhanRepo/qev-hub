import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { requireAuth, getAdminClient } from '@/lib/api-auth'

export async function POST(request: NextRequest) {
  // Require authentication for creating orders
  const { response: authResponse, user } = await requireAuth(request)
  if (authResponse) return authResponse

  // Use admin client to bypass RLS for order creation
  const adminSupabase = getAdminClient()

  try {
    const body = await request.json()
    const { vehicle_id, total_price, deposit_amount } = body

    console.log('[POST /api/orders] Request body:', { vehicle_id, total_price, deposit_amount, user_id: user!.id })

    // Use authenticated user's ID instead of accepting it from request body
    const user_id = user!.id

    if (!vehicle_id || !total_price || !deposit_amount) {
      console.log('[POST /api/orders] Missing required fields')
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      )
    }

    // Check if vehicle is available and decrement stock atomically
    // Using a transaction-like approach to prevent race conditions
    console.log('[POST /api/orders] Fetching vehicle...')
    const { data: vehicle, error: vehicleError } = await adminSupabase
      .from('vehicles')
      .select('*')
      .eq('id', vehicle_id)
      .gt('stock_count', 0)
      .single()

    if (vehicleError) {
      console.error('[POST /api/orders] Vehicle fetch error:', vehicleError)
      return NextResponse.json(
        { error: 'Vehicle not available or out of stock', details: vehicleError.message },
        { status: 400 }
      )
    }

    if (!vehicle) {
      console.error('[POST /api/orders] Vehicle not found or out of stock')
      return NextResponse.json(
        { error: 'Vehicle not available or out of stock' },
        { status: 400 }
      )
    }

    console.log('[POST /api/orders] Vehicle found:', { id: vehicle.id, stock_count: vehicle.stock_count })

    // Atomically decrement stock count
    console.log('[POST /api/orders] Decrementing stock...')
    const { error: updateError } = await adminSupabase
      .from('vehicles')
      .update({ stock_count: vehicle.stock_count - 1 })
      .eq('id', vehicle_id)
      .eq('stock_count', vehicle.stock_count) // Optimistic locking

    if (updateError) {
      console.error('[POST /api/orders] Stock update error:', updateError)
      return NextResponse.json(
        { error: 'Vehicle stock changed, please try again' },
        { status: 409 }
      )
    }

    // Generate tracking ID
    const trackingId = await generateTrackingId()
    console.log('[POST /api/orders] Creating order with tracking_id:', trackingId)

    // Create order
    const orderData = {
      user_id,
      vehicle_id,
      tracking_id: trackingId,
      total_price,
      deposit_amount,
      status: 'Order Placed',
      payment_status: 'pending',
    }
    console.log('[POST /api/orders] Order data:', orderData)

    const { data: order, error: orderError } = await adminSupabase
      .from('orders')
      .insert(orderData)
      .select()
      .single()

    if (orderError) {
      console.error('[POST /api/orders] Order creation error:', orderError)
      return NextResponse.json(
        { error: 'Failed to create order', details: orderError.message, code: orderError.code },
        { status: 500 }
      )
    }

    console.log('[POST /api/orders] Order created:', { id: order.id, tracking_id: order.tracking_id })

    // Create logistics entry
    console.log('[POST /api/orders] Creating logistics entry...')
    const { error: logisticsError } = await adminSupabase
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
      console.error('[POST /api/orders] Logistics creation error:', logisticsError)
    } else {
      console.log('[POST /api/orders] Logistics created successfully')
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
    console.error('[POST /api/orders] Unhandled error:', error)
    return NextResponse.json(
      { error: 'Internal server error', details: error instanceof Error ? error.message : 'Unknown error' },
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
    const userId = user!.id
    const { searchParams } = new URL(request.url)
    const orderId = searchParams.get('id')

    let query = supabase
      .from('orders')
      .select(`
        *,
        vehicle:vehicles(*),
        logistics(*),
        payments(*)
      `)
      .eq('user_id', userId)

    // Filter by specific order ID if provided
    if (orderId) {
      query = query.eq('id', orderId)
    } else {
      query = query.order('created_at', { ascending: false })
    }

    const { data: orders, error } = await query

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
