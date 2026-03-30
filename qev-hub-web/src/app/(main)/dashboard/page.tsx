'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/contexts/AuthContext'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { 
  CarIcon, 
  PackageIcon, 
  BatteryIcon, 
  TruckIcon,
  CheckIcon,
  ClockIcon,
  MapPinIcon 
} from '@/components/icons'

interface DashboardStats {
  totalOrders: number
  activeOrders: number
  deliveredOrders: number
  totalSpent: number
}

interface RecentOrder {
  id: string
  tracking_id: string
  status: string
  total_price: number
  created_at: string
  vehicle: {
    manufacturer: string
    model: string
  }
}

export default function DashboardPage() {
  const router = useRouter()
  const { user, loading: authLoading } = useAuth()
  const [stats, setStats] = useState<DashboardStats>({
    totalOrders: 0,
    activeOrders: 0,
    deliveredOrders: 0,
    totalSpent: 0,
  })
  const [recentOrders, setRecentOrders] = useState<RecentOrder[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (!authLoading) {
      fetchDashboardData()
    }
  }, [user, authLoading])

  const fetchDashboardData = async () => {
    try {
      setLoading(true)
      const userId = user?.id || 'demo-user-id'

      const { data: orders, error } = await supabase
        .from('orders')
        .select(`
          *,
          vehicle:vehicles(manufacturer, model)
        `)
        .eq('user_id', userId)
        .order('created_at', { ascending: false })

      if (error) throw error

      const ordersData = orders || []

      // Calculate stats
      const totalOrders = ordersData.length
      const activeOrders = ordersData.filter(o => 
        !['Delivered', 'Cancelled'].includes(o.status)
      ).length
      const deliveredOrders = ordersData.filter(o => o.status === 'Delivered').length
      const totalSpent = ordersData.reduce((sum, o) => sum + (o.total_price || 0), 0)

      setStats({
        totalOrders,
        activeOrders,
        deliveredOrders,
        totalSpent,
      })

      setRecentOrders(ordersData.slice(0, 5))
    } catch (error) {
      console.error('Error fetching dashboard data:', error)
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

  if (authLoading || loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
          <p>Loading dashboard...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background py-8 relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-black uppercase tracking-widest text-foreground mb-2">
            Dashboard
          </h1>
          <p className="text-muted-foreground">
            Welcome back{user?.email ? `, ${user.email}` : ''}! Here's your EV overview.
          </p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-primary/10 rounded-lg">
                  <PackageIcon className="h-6 w-6 text-primary" />
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Total Orders</p>
                  <p className="text-2xl font-bold">{stats.totalOrders}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-blue-500/10 rounded-lg">
                  <TruckIcon className="h-6 w-6 text-blue-500" />
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Active Orders</p>
                  <p className="text-2xl font-bold">{stats.activeOrders}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-green-500/10 rounded-lg">
                  <CheckIcon className="h-6 w-6 text-green-500" />
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Delivered</p>
                  <p className="text-2xl font-bold">{stats.deliveredOrders}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-primary/10 rounded-lg">
                  <CarIcon className="h-6 w-6 text-primary" />
                </div>
                <div className="min-w-0">
                  <p className="text-sm text-muted-foreground">Total Spent</p>
                  <p className="text-xl font-bold truncate">{formatPrice(stats.totalSpent)}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Quick Actions */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <Card className="hover:border-primary/50 transition-colors cursor-pointer" onClick={() => router.push('/marketplace')}>
            <CardContent className="pt-6 text-center">
              <CarIcon className="h-12 w-12 text-primary mx-auto mb-3" />
              <h3 className="font-semibold mb-1">Browse EVs</h3>
              <p className="text-sm text-muted-foreground">Explore our marketplace</p>
            </CardContent>
          </Card>

          <Card className="hover:border-primary/50 transition-colors cursor-pointer" onClick={() => router.push('/charging')}>
            <CardContent className="pt-6 text-center">
              <BatteryIcon className="h-12 w-12 text-primary mx-auto mb-3" />
              <h3 className="font-semibold mb-1">Find Charging</h3>
              <p className="text-sm text-muted-foreground">Locate nearby stations</p>
            </CardContent>
          </Card>

          <Card className="hover:border-primary/50 transition-colors cursor-pointer" onClick={() => router.push('/orders')}>
            <CardContent className="pt-6 text-center">
              <PackageIcon className="h-12 w-12 text-primary mx-auto mb-3" />
              <h3 className="font-semibold mb-1">My Orders</h3>
              <p className="text-sm text-muted-foreground">Track your orders</p>
            </CardContent>
          </Card>
        </div>

        {/* Recent Orders */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle>Recent Orders</CardTitle>
              <Button variant="outline" size="sm" onClick={() => router.push('/orders')}>
                View All
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            {recentOrders.length === 0 ? (
              <div className="text-center py-8">
                <PackageIcon className="h-12 w-12 text-muted-foreground mx-auto mb-3" />
                <p className="text-muted-foreground mb-4">No orders yet</p>
                <Button onClick={() => router.push('/marketplace')}>
                  Browse Marketplace
                </Button>
              </div>
            ) : (
              <div className="space-y-4">
                {recentOrders.map((order) => (
                  <div 
                    key={order.id}
                    className="flex items-center justify-between p-4 border rounded-lg hover:bg-muted/50 transition-colors cursor-pointer"
                    onClick={() => router.push(`/orders?order_id=${order.id}`)}
                  >
                    <div className="flex items-center gap-4">
                      {getStatusIcon(order.status)}
                      <div>
                        <p className="font-semibold">
                          {order.vehicle?.manufacturer} {order.vehicle?.model}
                        </p>
                        <p className="text-sm text-muted-foreground">
                          {order.tracking_id} • {formatDate(order.created_at)}
                        </p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="font-semibold">{formatPrice(order.total_price)}</p>
                      <Badge variant="outline">{order.status}</Badge>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
