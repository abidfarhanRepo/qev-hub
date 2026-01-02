'use client'

import { useState, useEffect } from 'react'
import { useSearchParams } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { OrderDetails } from '@/components/OrderDetails'
import { PaymentForm } from '@/components/PaymentForm'
import { OrderTracking } from '@/components/OrderTracking'
import { ComplianceDocuments } from '@/components/ComplianceDocuments'
import { Button } from '@/components/ui/button'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { toast } from '@/components/ui/use-toast'

type Step = 'details' | 'payment' | 'confirmation' | 'tracking'

interface Vehicle {
  id: string
  manufacturer: string
  model: string
  year: number
  range_km: number
  battery_kwh: number
  price_qar: number
  description: string
  stock_count: number
}

export default function OrdersPage() {
  const searchParams = useSearchParams()
  const vehicleId = searchParams.get('vehicle_id')

  const [step, setStep] = useState<Step>('details')
  const [vehicle, setVehicle] = useState<Vehicle | null>(null)
  const [orderId, setOrderId] = useState<string | null>(null)
  const [trackingId, setTrackingId] = useState<string | null>(null)
  const [depositAmount, setDepositAmount] = useState<number>(0)
  const [loading, setLoading] = useState(false)
  const [logistics, setLogistics] = useState<any>(null)
  const [documents, setDocuments] = useState<any[]>([])

  useEffect(() => {
    if (vehicleId) {
      fetchVehicle(vehicleId)
    }
  }, [vehicleId])

  const fetchVehicle = async (id: string) => {
    try {
      const { data, error } = await supabase
        .from('vehicles')
        .select('*')
        .eq('id', id)
        .single()

      if (error) throw error
      setVehicle(data)
    } catch (error) {
      console.error('Error fetching vehicle:', error)
      toast({
        title: 'Error',
        description: 'Failed to load vehicle details',
        variant: 'destructive',
      })
    }
  }

  const handlePurchase = async (selectedVehicle: Vehicle) => {
    setLoading(true)
    try {
      const response = await fetch('/api/orders', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          vehicle_id: selectedVehicle.id,
          user_id: 'demo-user-id',
          total_price: selectedVehicle.price_qar,
          deposit_amount: selectedVehicle.price_qar * 0.2,
        }),
      })

      const data = await response.json()

      if (data.success) {
        setOrderId(data.order.id)
        setTrackingId(data.order.tracking_id)
        setDepositAmount(data.order.deposit_amount)
        setStep('payment')
      } else {
        toast({
          title: 'Error',
          description: data.error || 'Failed to create order',
          variant: 'destructive',
        })
      }
    } catch (error) {
      console.error('Purchase error:', error)
      toast({
        title: 'Error',
        description: 'An error occurred while creating your order',
        variant: 'destructive',
      })
    } finally {
      setLoading(false)
    }
  }

  const handlePaymentComplete = async (paymentData: any) => {
    toast({
      title: 'Payment Successful',
      description: `Order Confirmed. Tracking ID: ${paymentData.order_tracking_id}`,
    })

    setStep('confirmation')

    setTimeout(() => {
      fetchOrderDetails()
    }, 2000)
  }

  const fetchOrderDetails = async () => {
    if (!orderId) return

    try {
      const [logisticsRes, docsRes] = await Promise.all([
        fetch(`/api/logistics/${orderId}`),
        fetch(`/api/compliance?order_id=${orderId}`),
      ])

      if (logisticsRes.ok) {
        const logisticsData = await logisticsRes.json()
        setLogistics(logisticsData.logistics)
      }

      if (docsRes.ok) {
        const docsData = await docsRes.json()
        setDocuments(docsData.documents || [])
      }

      setStep('tracking')
    } catch (error) {
      console.error('Error fetching order details:', error)
    }
  }

  const handleBackToMarketplace = () => {
    window.location.href = '/marketplace'
  }

  if (!vehicle && vehicleId) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
          <p>Loading vehicle details...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold mb-2">
            {step === 'details' && 'Purchase Vehicle'}
            {step === 'payment' && 'Complete Payment'}
            {step === 'confirmation' && 'Order Confirmed'}
            {step === 'tracking' && 'Track Your Order'}
          </h1>
          <p className="text-muted-foreground">
            {step === 'details' && 'Review your selection and complete the purchase'}
            {step === 'payment' && 'Secure payment processing'}
            {step === 'confirmation' && 'Your order has been placed successfully'}
            {step === 'tracking' && 'Monitor your vehicle shipment in real-time'}
          </p>
        </div>

        {/* Step Indicator */}
        <div className="mb-8 flex items-center justify-between">
          {['details', 'payment', 'confirmation', 'tracking'].map((s, index) => (
            <div key={s} className="flex items-center flex-1">
              <div
                className={`w-8 h-8 rounded-full flex items-center justify-center ${
                  step === s || (step === 'tracking' && index < 4)
                    ? 'bg-primary text-white'
                    : 'bg-gray-200 text-gray-600'
                }`}
              >
                {index + 1}
              </div>
              {index < 3 && (
                <div className="flex-1 h-0.5 bg-gray-200 mx-2">
                  {(['details', 'payment', 'confirmation'].includes(step) &&
                    index < ['details', 'payment', 'confirmation'].indexOf(step)) ||
                  (step === 'tracking' && index < 3) ? (
                    <div className="h-full bg-primary" style={{ width: '100%' }} />
                  ) : null}
                </div>
              )}
            </div>
          ))}
        </div>

        {/* Content based on step */}
        {step === 'details' && vehicle && (
          <OrderDetails vehicle={vehicle} onPurchase={handlePurchase} />
        )}

        {step === 'payment' && orderId && (
          <PaymentForm
            orderId={orderId}
            depositAmount={depositAmount}
            onPaymentComplete={handlePaymentComplete}
            onCancel={handleBackToMarketplace}
          />
        )}

        {step === 'confirmation' && (
          <div className="text-center py-16">
            <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <svg
                className="w-10 h-10 text-green-600"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M5 13l4 4L19 7"
                />
              </svg>
            </div>
            <h2 className="text-2xl font-bold mb-2">Order Confirmed</h2>
            <p className="text-muted-foreground mb-4">
              Tracking ID: {trackingId}
            </p>
            <p className="text-sm text-muted-foreground mb-6">
              Redirecting to tracking page...
            </p>
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto" />
          </div>
        )}

        {step === 'tracking' && logistics && (
          <div className="space-y-6">
            <OrderTracking logistics={logistics} />
            {documents.length > 0 && (
              <ComplianceDocuments documents={documents} orderId={orderId!} />
            )}
          </div>
        )}

        {/* Back button */}
        {(step === 'details' || step === 'tracking') && (
          <div className="mt-6">
            <Button variant="outline" onClick={handleBackToMarketplace}>
              Back to Marketplace
            </Button>
          </div>
        )}
      </div>
    </div>
  )
}
