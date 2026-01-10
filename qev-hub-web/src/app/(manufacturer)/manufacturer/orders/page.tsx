'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { TruckIcon, PackageIcon, ClockIcon } from '@/components/icons'

export default function ManufacturerOrdersPage() {
  const [loading, setLoading] = useState(true)
  const [orders, setOrders] = useState<any[]>([])
  const [manufacturer, setManufacturer] = useState<any>(null)

  useEffect(() => {
    fetchOrders()
  }, [])

  const fetchOrders = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      // Get manufacturer profile
      const { data: manufacturerData } = await supabase
        .from('manufacturers')
        .select('*')
        .eq('user_id', user.id)
        .single()

      if (manufacturerData) {
        setManufacturer(manufacturerData)

        // Get orders for manufacturer's vehicles
        const { data: ordersData } = await supabase
          .from('orders')
          .select(`
            *,
            vehicles (
              make,
              model,
              year,
              manufacturer_id
            )
          `)
          .eq('vehicles.manufacturer_id', manufacturerData.id)
          .order('created_at', { ascending: false })

        setOrders(ordersData || [])
      }
    } catch (error) {
      console.error('Error fetching orders:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusBadge = (status: string) => {
    const variants: Record<string, any> = {
      pending: { variant: 'secondary', label: 'Pending' },
      confirmed: { variant: 'default', label: 'Confirmed' },
      processing: { variant: 'default', label: 'Processing' },
      shipped: { variant: 'default', label: 'Shipped' },
      delivered: { variant: 'default', label: 'Delivered' },
      cancelled: { variant: 'destructive', label: 'Cancelled' },
    }

    const config = variants[status] || variants.pending
    return <Badge variant={config.variant}>{config.label}</Badge>
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Orders</h1>
        <p className="text-muted-foreground mt-1">
          View and manage orders for your vehicles
        </p>
      </div>

      {orders.length === 0 ? (
        <Card>
          <CardContent className="py-12 text-center">
            <PackageIcon className="w-16 h-16 mx-auto mb-4 text-muted-foreground opacity-50" />
            <h3 className="text-xl font-semibold mb-2">No orders yet</h3>
            <p className="text-muted-foreground">
              Orders for your vehicles will appear here
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-4">
          {orders.map((order) => (
            <Card key={order.id}>
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle className="text-lg">
                      Order #{order.tracking_id}
                    </CardTitle>
                    <p className="text-sm text-muted-foreground mt-1">
                      {order.vehicles?.make} {order.vehicles?.model} {order.vehicles?.year}
                    </p>
                  </div>
                  {getStatusBadge(order.status)}
                </div>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                  <div>
                    <p className="text-muted-foreground flex items-center gap-2">
                      <PackageIcon className="w-4 h-4" />
                      Order Total
                    </p>
                    <p className="font-medium mt-1">
                      {new Intl.NumberFormat('en-QA', {
                        style: 'currency',
                        currency: 'QAR',
                        maximumFractionDigits: 0
                      }).format(order.total_price)}
                    </p>
                  </div>
                  <div>
                    <p className="text-muted-foreground flex items-center gap-2">
                      <TruckIcon className="w-4 h-4" />
                      Delivery Status
                    </p>
                    <p className="font-medium mt-1">{order.status}</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground flex items-center gap-2">
                      <ClockIcon className="w-4 h-4" />
                      Order Date
                    </p>
                    <p className="font-medium mt-1">
                      {new Date(order.created_at).toLocaleDateString()}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  )
}
