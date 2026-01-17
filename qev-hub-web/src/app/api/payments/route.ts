import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { requireAuth } from '@/lib/api-auth'

export async function POST(request: NextRequest) {
  // Require authentication for processing payments
  const { response: authResponse, user } = await requireAuth(request)
  if (authResponse) return authResponse

  try {
    const body = await request.json()
    const { order_id, amount, payment_method, transaction_id } = body

    if (!order_id || !amount || !payment_method) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      )
    }

    // Get order details and verify ownership
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .select('*')
      .eq('id', order_id)
      .eq('user_id', user!.id) // Ensure user owns this order
      .single()

    if (orderError || !order) {
      return NextResponse.json(
        { error: 'Order not found or access denied' },
        { status: 404 }
      )
    }

    // Check if already paid
    if (order.payment_status === 'Completed') {
      return NextResponse.json(
        { error: 'Order has already been paid' },
        { status: 400 }
      )
    }

    // Create payment record
    const { data: payment, error: paymentError } = await supabase
      .from('payments')
      .insert({
        order_id,
        amount,
        currency: 'QAR',
        payment_method,
        payment_gateway: payment_method === 'card' ? 'QEV Payments' : 'Bank Transfer',
        transaction_id,
        status: 'Completed',
      })
      .select()
      .single()

    if (paymentError) {
      console.error('Payment creation error:', paymentError)
      return NextResponse.json(
        { error: 'Failed to process payment' },
        { status: 500 }
      )
    }

    // Update order payment status
    await supabase
      .from('orders')
      .update({ payment_status: 'Completed' })
      .eq('id', order_id)

    // Generate compliance document (customs declaration)
    const complianceDocError = await generateComplianceDocument(order_id)

    if (complianceDocError) {
      console.error('Compliance document generation warning:', complianceDocError)
    }

    return NextResponse.json({
      success: true,
      payment: {
        id: payment.id,
        amount: payment.amount,
        status: payment.status,
        transaction_id: payment.transaction_id,
      },
      order_tracking_id: order.tracking_id,
    })
  } catch (error) {
    console.error('Payment API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

async function generateComplianceDocument(orderId: string): Promise<any> {
  const mockDocumentUrl = `https://storage.qev-hub.qa/compliance/customs-declaration-${orderId}.pdf`

  const { error } = await supabase
    .from('compliance_documents')
    .insert({
      order_id: orderId,
      document_type: 'Customs Declaration',
      document_url: mockDocumentUrl,
      document_name: `Customs_Declaration_${orderId}`,
      status: 'Generated',
      generated_at: new Date().toISOString(),
    })

  return error
}
