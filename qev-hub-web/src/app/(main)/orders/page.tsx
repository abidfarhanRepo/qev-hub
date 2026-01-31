'use client'

import { useState, useEffect, Suspense } from 'react'
import { useSearchParams, useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { useAuth } from '@/contexts/AuthContext'
import { OrderDetails } from '@/components/OrderDetails'
import { PaymentForm } from '@/components/PaymentForm'
import { OrderTracking } from '@/components/OrderTracking'
import { ComplianceDocuments } from '@/components/ComplianceDocuments'
import type { Session } from '@supabase/supabase-js'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { toast } from '@/components/ui/use-toast'
import { PackageIcon, TruckIcon, ClockIcon, CheckIcon } from '@/components/icons'

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

interface Order {
  id: string
  tracking_id: string
  status: string
  total_price: number
  payment_status: string
  created_at: string
  vehicle: Vehicle
}

function OrdersListView() {
  const router = useRouter()
  const { user } = useAuth()
  const [orders, setOrders] = useState<Order[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchOrders()
  }, [user])

  const fetchOrders = async () => {
    try {
      setLoading(true)
      // Use demo-user-id if not authenticated (for demo purposes)
      const userId = user?.id || 'demo-user-id'
      
      const { data, error } = await supabase
        .from('orders')
        .select(`
          *,
          vehicle:vehicles(*)
        `)
        .eq('user_id', userId)
        .order('created_at', { ascending: false })

      if (error) throw error
      setOrders(data || [])
    } catch (error) {
      console.error('Error fetching orders:', error)
    } finally {
      setLoading(false)
    }
  }

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR'
    }).format(price)
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-QA', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    })
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'Delivered':
        return <CheckIcon className="h-4 w-4 text-green-500" />
      case 'In Transit':
      case 'In Customs':
        return <TruckIcon className="h-4 w-4 text-blue-500" />
      case 'Processing':
        return <ClockIcon className="h-4 w-4 text-yellow-500" />
      default:
        return <PackageIcon className="h-4 w-4 text-muted-foreground" />
    }
  }

  const getStatusBadgeVariant = (status: string) => {
    switch (status) {
      case 'Delivered':
        return 'default'
      case 'In Transit':
      case 'In Customs':
        return 'secondary'
      default:
        return 'outline'
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
          <p>Loading your orders...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background py-8 relative overflow-hidden">
      <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>
      
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="mb-8">
          <h1 className="text-3xl font-black uppercase tracking-widest text-foreground mb-2">
            My <span className="text-primary">Orders</span>
          </h1>
          <p className="text-muted-foreground">
            Track and manage your vehicle orders
          </p>
        </div>

        {orders.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center">
              <PackageIcon className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
              <h3 className="text-xl font-semibold mb-2">No Orders Yet</h3>
              <p className="text-muted-foreground mb-6">
                You haven't placed any orders yet. Browse our marketplace to find your perfect EV!
              </p>
              <Button onClick={() => router.push('/marketplace')}>
                Browse Marketplace
              </Button>
            </CardContent>
          </Card>
        ) : (
          <div className="space-y-4">
            {orders.map((order) => (
              <Card 
                key={order.id} 
                className="hover:border-primary/50 transition-colors cursor-pointer"
                onClick={() => router.push(`/orders?order_id=${order.id}`)}
              >
                <CardContent className="p-6">
                  <div className="flex items-start justify-between mb-4">
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        {getStatusIcon(order.status)}
                        <h3 className="font-semibold">
                          {order.vehicle?.manufacturer} {order.vehicle?.model}
                        </h3>
                      </div>
                      <p className="text-sm text-muted-foreground">
                        Tracking ID: {order.tracking_id}
                      </p>
                    </div>
                    <Badge variant={getStatusBadgeVariant(order.status) as any}>
                      {order.status}
                    </Badge>
                  </div>
                  
                  <div className="grid grid-cols-3 gap-4 text-sm">
                    <div>
                      <p className="text-muted-foreground">Total</p>
                      <p className="font-semibold">{formatPrice(order.total_price)}</p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Payment</p>
                      <p className="font-semibold">{order.payment_status}</p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Ordered</p>
                      <p className="font-semibold">{formatDate(order.created_at)}</p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

function OrdersPageContent() {
  const searchParams = useSearchParams()
  const router = useRouter()
  const { user, session } = useAuth()
  const vehicleId = searchParams.get('vehicle_id')
  const existingOrderId = searchParams.get('order_id')

  const [step, setStep] = useState<Step>('details')
  const [vehicle, setVehicle] = useState<Vehicle | null>(null)
  const [orderId, setOrderId] = useState<string | null>(existingOrderId)
  const [trackingId, setTrackingId] = useState<string | null>(null)
  const [depositAmount, setDepositAmount] = useState<number>(0)
  const [loading, setLoading] = useState(false)
  const [logistics, setLogistics] = useState<any>(null)
  const [documents, setDocuments] = useState<any[]>([])
  const [orderDetails, setOrderDetails] = useState<any>(null)

  // Redirect to login if not authenticated and trying to purchase
  useEffect(() => {
    if (vehicleId && !user) {
      // Store the return URL for after login
      sessionStorage.setItem('returnUrl', `/orders?vehicle_id=${vehicleId}`)
      toast({
        title: 'Authentication Required',
        description: 'Please log in to complete your purchase',
        variant: 'default',
      })
      router.push('/login')
    }
  }, [vehicleId, user, router])

  useEffect(() => {
    if (vehicleId && user) {
      fetchVehicle(vehicleId)
    } else if (existingOrderId) {
      // Viewing existing order - go directly to tracking
      setStep('tracking')
      fetchExistingOrderDetails(existingOrderId)
    }
  }, [vehicleId, existingOrderId, user])

  const fetchExistingOrderDetails = async (id: string) => {
    try {
      const [logisticsRes, docsRes, orderRes] = await Promise.all([
        fetch(`/api/logistics/${id}`),
        fetch(`/api/compliance?order_id=${id}`),
        fetch(`/api/orders?id=${id}`),
      ])

      if (orderRes.ok) {
        const orderData = await orderRes.json()
        if (orderData.orders && orderData.orders.length > 0) {
          const order = orderData.orders[0]
          setOrderDetails(order)
          setOrderId(order.id)
          setTrackingId(order.tracking_id)
          setDepositAmount(order.deposit_amount)
        }
      }

      if (logisticsRes.ok) {
        const logisticsData = await logisticsRes.json()
        setLogistics(logisticsData.logistics)
      }

      if (docsRes.ok) {
        const docsData = await docsRes.json()
        setDocuments(docsData.documents || [])
      }
    } catch (error) {
      console.error('Error fetching order details:', error)
    }
  }

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
    if (!user || !session?.access_token) {
      toast({
        title: 'Authentication Required',
        description: 'Please log in to complete your purchase',
        variant: 'destructive',
      })
      sessionStorage.setItem('returnUrl', `/orders?vehicle_id=${selectedVehicle.id}`)
      router.push('/login')
      return
    }

    // Validate vehicle data
    if (!selectedVehicle.price_qar || selectedVehicle.price_qar <= 0) {
      toast({
        title: 'Invalid Vehicle',
        description: 'This vehicle has no pricing information. Please select a different vehicle.',
        variant: 'destructive',
      })
      return
    }

    setLoading(true)
    try {
      const payload = {
        vehicle_id: selectedVehicle.id,
        total_price: selectedVehicle.price_qar,
        deposit_amount: selectedVehicle.price_qar * 0.2,
      }
      console.log('Creating order with payload:', payload)

      const response = await fetch('/api/orders', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${session.access_token}`,
        },
        body: JSON.stringify(payload),
      })

      const data = await response.json()
      console.log('Order API response:', { status: response.status, data })

      if (!response.ok) {
        // Handle 401 Unauthorized specifically
        if (response.status === 401) {
          toast({
            title: 'Authentication Required',
            description: 'Please log in to complete your purchase',
            variant: 'destructive',
          })
          sessionStorage.setItem('returnUrl', `/orders?vehicle_id=${selectedVehicle.id}`)
          router.push('/login')
          return
        }
        throw new Error(data.error || `HTTP ${response.status}: ${response.statusText}`)
      }

      if (data.success) {
        setOrderId(data.order.id)
        setTrackingId(data.order.tracking_id)
        setDepositAmount(data.order.deposit_amount)
        setStep('payment')
      } else {
        throw new Error(data.error || 'Failed to create order')
      }
    } catch (error) {
      console.error('Purchase error:', error)
      toast({
        title: 'Error',
        description: error instanceof Error ? error.message : 'An error occurred while creating your order',
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
      const [logisticsRes, docsRes, orderRes] = await Promise.all([
        fetch(`/api/logistics/${orderId}`),
        fetch(`/api/compliance?order_id=${orderId}`),
        fetch(`/api/orders?id=${orderId}`),
      ])

      if (orderRes.ok) {
        const orderData = await orderRes.json()
        if (orderData.orders && orderData.orders.length > 0) {
          setOrderDetails(orderData.orders[0])
        }
      }

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

  const handleBackToOrders = () => {
    window.location.href = '/orders'
  }

  // Show orders list if no vehicle_id or order_id provided
  if (!vehicleId && !existingOrderId) {
    return <OrdersListView />
  }

  if (!vehicle && vehicleId) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
          <p>Loading vehicle details...</p>
        </div>
      </div>
    )
  }

  if (existingOrderId && !logistics && step === 'tracking') {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
          <p>Loading order details...</p>
        </div>
      </div>
    )
  }

   return (
     <div className="min-h-screen bg-background py-8 relative overflow-hidden">
       {/* Background Elements */}
       <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>
       
       <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
         <div className="mb-8">
           <h1 className="text-3xl font-black uppercase tracking-widest text-foreground mb-2">
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

         <div className="mb-8 flex items-center justify-between">
           {['details', 'payment', 'confirmation', 'tracking'].map((s, index) => (
             <div key={s} className="flex items-center flex-1">
               <div
                 className={`w-10 h-10 rounded-full flex items-center justify-center font-semibold transition-all ${
                   step === s || (step === 'tracking' && index < 4)
                     ? 'bg-primary text-primary-foreground shadow-lg scale-110'
                     : 'bg-muted/20 text-muted-foreground'
                 }`}
              >
                {index + 1}
               </div>
               {index < 3 && (
                 <div className="flex-1 h-0.5 bg-muted/20 mx-2 relative">
                   {(['details', 'payment', 'confirmation'].includes(step) &&
                     index < ['details', 'payment', 'confirmation'].indexOf(step)) ||
                   (step === 'tracking' && index < 3) ? (
                     <div className="h-full bg-primary absolute left-0 top-0 transition-all duration-500" style={{ width: '100%' }} />
                   ) : null}
                 </div>
               )}
             </div>
           ))}
         </div>

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
           <div className="glass-card tech-border text-center py-16">
             <div className="w-20 h-20 bg-gradient-to-br from-primary to-primary-light rounded-full flex items-center justify-center mx-auto mb-6 shadow-lg shadow-primary/25">
               <svg
                 className="w-10 h-10 text-white"
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

        {step === 'tracking' && (
          <>
            {(() => {
              console.log('[Tracking Step] logistics:', logistics, 'orderDetails:', orderDetails, 'orderId:', orderId)
              return null
            })()}
          <div className="space-y-6">
            {!logistics ? (
              <Card>
                <CardContent className="py-12 text-center">
                  <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
                  <p>Loading tracking information...</p>
                </CardContent>
              </Card>
            ) : (
              <>
                {orderDetails && (
                  <Card>
                    <CardHeader>
                      <CardTitle>Order Details</CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-4">
                      <div className="flex items-start justify-between">
                        <div>
                          <h3 className="text-xl font-bold">
                            {orderDetails.vehicle?.manufacturer} {orderDetails.vehicle?.model}
                          </h3>
                          <p className="text-sm text-muted-foreground">
                            Tracking ID: {trackingId}
                          </p>
                        </div>
                        <Badge variant="outline">{orderDetails.status}</Badge>
                      </div>

                      <Separator />

                      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <div>
                          <p className="text-sm text-muted-foreground">Total Price</p>
                          <p className="font-semibold">{formatPrice(orderDetails.total_price)}</p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">Deposit Paid</p>
                          <p className="font-semibold">{formatPrice(orderDetails.deposit_amount)}</p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">Remaining</p>
                          <p className="font-semibold">{formatPrice(orderDetails.total_price - orderDetails.deposit_amount)}</p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">Payment Status</p>
                          <p className="font-semibold capitalize">{orderDetails.payment_status}</p>
                        </div>
                      </div>

                      <Separator />

                      <div className="grid grid-cols-2 gap-4 text-sm">
                        <div>
                          <p className="text-muted-foreground">Order Date</p>
                          <p className="font-medium">{formatDate(orderDetails.created_at)}</p>
                        </div>
                        <div>
                          <p className="text-muted-foreground">Vehicle Year</p>
                          <p className="font-medium">{orderDetails.vehicle?.year}</p>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                )}

                <OrderTracking logistics={logistics} />
                {documents.length > 0 && (
                  <ComplianceDocuments documents={documents} orderId={orderId!} />
                )}
              </>
            )}
          </div>
          </>
        )}

        {/* Back button */}
        {step === 'details' && (
          <div className="mt-6">
            <Button variant="outline" onClick={handleBackToMarketplace}>
              Back to Marketplace
            </Button>
          </div>
        )}
        {step === 'tracking' && (
          <div className="mt-6 flex gap-4">
            <Button variant="outline" onClick={handleBackToOrders}>
              Back to My Orders
            </Button>
            <Button variant="outline" onClick={handleBackToMarketplace}>
              Browse Marketplace
            </Button>
          </div>
        )}
      </div>
    </div>
  )
}

export default function OrdersPage() {
  return (
    <Suspense
      fallback={
        <div className="min-h-screen bg-gray-50 flex items-center justify-center">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
            <p>Loading...</p>
          </div>
        </div>
      }
    >
      <OrdersPageContent />
    </Suspense>
  )
}
