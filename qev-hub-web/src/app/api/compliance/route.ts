import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { getAdminClient } from '@/lib/api-auth'

export async function POST(request: NextRequest) {
  const adminSupabase = getAdminClient()

  try {
    const body = await request.json()
    const { order_id, document_type } = body

    if (!order_id || !document_type) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      )
    }

    // Get order details
    const { data: order, error: orderError } = await adminSupabase
      .from('orders')
      .select('*, vehicle:vehicles(*)')
      .eq('id', order_id)
      .single()

    if (orderError || !order) {
      return NextResponse.json(
        { error: 'Order not found' },
        { status: 404 }
      )
    }

    // Generate mock document URL (in production, this would generate a real PDF)
    const mockDocumentUrl = `https://storage.qev-hub.qa/compliance/${document_type.toLowerCase().replace(' ', '-')}-${order_id}.pdf`

    // Create compliance document record
    const { data: document, error: docError } = await adminSupabase
      .from('compliance_documents')
      .insert({
        order_id,
        document_type,
        document_url: mockDocumentUrl,
        document_name: `${document_type.replace(/\s+/g, '_')}_${order_id}`,
        status: 'Generated',
        generated_at: new Date().toISOString(),
      })
      .select()
      .single()

    if (docError) {
      console.error('Compliance document creation error:', docError)
      return NextResponse.json(
        { error: 'Failed to generate compliance document' },
        { status: 500 }
      )
    }

    return NextResponse.json({
      success: true,
      document: {
        id: document.id,
        document_type: document.document_type,
        document_url: document.document_url,
        status: document.status,
        generated_at: document.generated_at,
      },
    })
  } catch (error) {
    console.error('Compliance API error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function GET(request: NextRequest) {
  const adminSupabase = getAdminClient()

  try {
    const { searchParams } = new URL(request.url)
    const orderId = searchParams.get('order_id')

    if (!orderId) {
      return NextResponse.json(
        { error: 'Order ID is required' },
        { status: 400 }
      )
    }

    console.log('[GET /api/compliance] Fetching documents for order:', orderId)

    const { data: documents, error } = await adminSupabase
      .from('compliance_documents')
      .select('*')
      .eq('order_id', orderId)

    console.log('[GET /api/compliance] Result:', { documents, error })

    if (error) {
      return NextResponse.json(
        { error: 'Failed to fetch compliance documents' },
        { status: 500 }
      )
    }

    return NextResponse.json({ documents: documents || [] })
  } catch (error) {
    console.error('Fetch compliance documents error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
