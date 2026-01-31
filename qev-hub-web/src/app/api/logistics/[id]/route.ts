import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { getAdminClient } from '@/lib/api-auth'

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  // Use admin client to bypass RLS for logistics fetching
  const adminSupabase = getAdminClient()

  try {
    const orderId = params.id

    console.log('[GET /api/logistics/' + orderId + '] Fetching logistics for order:', orderId)

    // Fetch logistics entry by order_id
    const { data: logistics, error } = await adminSupabase
      .from('logistics')
      .select('*')
      .eq('order_id', orderId)
      .single()

    console.log('[GET /api/logistics] Result:', { logistics, error })

    if (error || !logistics) {
      console.error('[GET /api/logistics] Error:', error)
      return NextResponse.json(
        { error: 'Logistics entry not found', details: error?.message },
        { status: 404 }
      )
    }

    return NextResponse.json({
      success: true,
      logistics,
    })
  } catch (error) {
    console.error('[GET /api/logistics] Unhandled error:', error)
    return NextResponse.json(
      { error: 'Internal server error', details: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    )
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  // Use admin client to bypass RLS
  const adminSupabase = getAdminClient()

  try {
    const logisticsId = params.id
    const body = await request.json()
    const { status, current_location, vessel_name, estimated_arrival } = body

    // Get current logistics entry
    const { data: logistics, error: fetchError } = await adminSupabase
      .from('logistics')
      .select('*')
      .eq('id', logisticsId)
      .single()

    if (fetchError || !logistics) {
      return NextResponse.json(
        { error: 'Logistics entry not found' },
        { status: 404 }
      )
    }

    // Create new tracking event
    const newEvent = {
      status: status || logistics.status,
      location: current_location || logistics.current_location,
      timestamp: new Date().toISOString(),
    }

    // Update logistics
    const { data: updatedLogistics, error: updateError } = await adminSupabase
      .from('logistics')
      .update({
        status: status || logistics.status,
        current_location: current_location || logistics.current_location,
        vessel_name: vessel_name || logistics.vessel_name,
        estimated_arrival: estimated_arrival || logistics.estimated_arrival,
        actual_arrival:
          status === 'Delivered'
            ? new Date().toISOString()
            : logistics.actual_arrival,
        tracking_events: [...logistics.tracking_events, newEvent],
      })
      .eq('id', logisticsId)
      .select()
      .single()

    if (updateError) {
      console.error('Logistics update error:', updateError)
      return NextResponse.json(
        { error: 'Failed to update logistics' },
        { status: 500 }
      )
    }

    // Update order status
    await adminSupabase
      .from('orders')
      .update({ status: status || logistics.status })
      .eq('id', logistics.order_id)

    return NextResponse.json({
      success: true,
      logistics: updatedLogistics,
    })
  } catch (error) {
    console.error('Logistics API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
