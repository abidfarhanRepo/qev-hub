'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { CarIcon, PackageIcon, TruckIcon, CheckCircleIcon, ClockIcon, AlertCircle } from '@/components/icons'
import Link from 'next/link'

interface DashboardStats {
  totalVehicles: number
  activeListings: number
  totalOrders: number
  pendingOrders: number
  verificationStatus: string
}

export default function ManufacturerDashboard() {
  const [loading, setLoading] = useState(true)
  const [stats, setStats] = useState<DashboardStats | null>(null)
  const [manufacturer, setManufacturer] = useState<any>(null)
  const [recentVehicles, setRecentVehicles] = useState<any[]>([])

  useEffect(() => {
    fetchDashboardData()
  }, [])

  const fetchDashboardData = async () => {
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

        // Get vehicle count
        const { count: vehicleCount } = await supabase
          .from('vehicles')
          .select('*', { count: 'exact', head: true })
          .eq('manufacturer_id', manufacturerData.id)

        const { count: activeCount } = await supabase
          .from('vehicles')
          .select('*', { count: 'exact', head: true })
          .eq('manufacturer_id', manufacturerData.id)
          .eq('availability', 'available')

        // Get order count
        const { count: orderCount } = await supabase
          .from('orders')
          .select('*', { count: 'exact', head: true })
          .eq('vehicle_id', manufacturerData.id)

        const { count: pendingCount } = await supabase
          .from('orders')
          .select('*', { count: 'exact', head: true })
          .eq('vehicle_id', manufacturerData.id)
          .eq('status', 'pending')

        setStats({
          totalVehicles: vehicleCount || 0,
          activeListings: activeCount || 0,
          totalOrders: orderCount || 0,
          pendingOrders: pendingCount || 0,
          verificationStatus: manufacturerData.verification_status,
        })

        // Get recent vehicles
        const { data: vehiclesData } = await supabase
          .from('vehicles')
          .select('*')
          .eq('manufacturer_id', manufacturerData.id)
          .order('created_at', { ascending: false })
          .limit(5)

        setRecentVehicles(vehiclesData || [])
      }
    } catch (error) {
      console.error('Error fetching dashboard data:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
      </div>
    )
  }

  const getVerificationBadge = () => {
    switch (stats?.verificationStatus) {
      case 'verified':
        return <Badge className="bg-green-500"><CheckCircleIcon className="w-3 h-3 mr-1" /> Verified</Badge>
      case 'pending':
        return <Badge variant="secondary"><ClockIcon className="w-3 h-3 mr-1" /> Pending Verification</Badge>
      case 'rejected':
        return <Badge variant="destructive"><AlertCircle className="w-3 h-3 mr-1" /> Rejected</Badge>
      default:
        return <Badge variant="outline">Unknown</Badge>
    }
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 className="text-3xl font-bold">Manufacturer Dashboard</h1>
          <p className="text-muted-foreground mt-1">
            Welcome back, {manufacturer?.company_name}
          </p>
        </div>
        <div className="flex items-center gap-2">
          {getVerificationBadge()}
        </div>
      </div>

      {/* Verification Alert */}
      {stats?.verificationStatus !== 'verified' && (
        <Card className="border-primary/50 bg-primary/5">
          <CardContent className="pt-6">
            <div className="flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-primary flex-shrink-0 mt-0.5" />
              <div>
                <h3 className="font-semibold mb-1">Account Verification Pending</h3>
                <p className="text-sm text-muted-foreground">
                  Your manufacturer account is pending verification. You can add vehicles, but they won't be visible to customers until your account is verified.
                </p>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Total Vehicles
            </CardTitle>
            <CarIcon className="w-5 h-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">{stats?.totalVehicles || 0}</div>
            <p className="text-xs text-muted-foreground mt-1">
              {stats?.activeListings || 0} active listings
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Active Listings
            </CardTitle>
            <PackageIcon className="w-5 h-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">{stats?.activeListings || 0}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Available for purchase
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Total Orders
            </CardTitle>
            <TruckIcon className="w-5 h-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">{stats?.totalOrders || 0}</div>
            <p className="text-xs text-muted-foreground mt-1">
              All time
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Pending Orders
            </CardTitle>
            <ClockIcon className="w-5 h-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">{stats?.pendingOrders || 0}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Awaiting processing
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Quick Actions */}
      <Card>
        <CardHeader>
          <CardTitle>Quick Actions</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <Link href="/manufacturer/vehicles/new">
              <Button className="w-full h-24 flex flex-col gap-2">
                <CarIcon className="w-6 h-6" />
                <span>Add New Vehicle</span>
              </Button>
            </Link>
            <Link href="/manufacturer/vehicles">
              <Button variant="outline" className="w-full h-24 flex flex-col gap-2">
                <PackageIcon className="w-6 h-6" />
                <span>Manage Vehicles</span>
              </Button>
            </Link>
            <Link href="/manufacturer/orders">
              <Button variant="outline" className="w-full h-24 flex flex-col gap-2">
                <TruckIcon className="w-6 h-6" />
                <span>View Orders</span>
              </Button>
            </Link>
          </div>
        </CardContent>
      </Card>

      {/* Recent Vehicles */}
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle>Recent Vehicles</CardTitle>
          <Link href="/manufacturer/vehicles">
            <Button variant="outline" size="sm">View All</Button>
          </Link>
        </CardHeader>
        <CardContent>
          {recentVehicles.length === 0 ? (
            <div className="text-center py-12 text-muted-foreground">
              <CarIcon className="w-12 h-12 mx-auto mb-4 opacity-50" />
              <p>No vehicles added yet</p>
              <Link href="/manufacturer/vehicles/new">
                <Button className="mt-4">Add Your First Vehicle</Button>
              </Link>
            </div>
          ) : (
            <div className="space-y-4">
              {recentVehicles.map((vehicle) => (
                <div
                  key={vehicle.id}
                  className="flex items-center justify-between p-4 border rounded-lg hover:bg-muted/50 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    <div className="w-16 h-16 bg-muted rounded-lg flex items-center justify-center">
                      <CarIcon className="w-8 h-8 text-muted-foreground" />
                    </div>
                    <div>
                      <h4 className="font-semibold">{vehicle.make} {vehicle.model}</h4>
                      <p className="text-sm text-muted-foreground">
                        {vehicle.year} • {vehicle.vehicle_type}
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold">
                      {new Intl.NumberFormat('en-QA', {
                        style: 'currency',
                        currency: 'QAR'
                      }).format(vehicle.price)}
                    </p>
                    <Badge variant={vehicle.availability === 'available' ? 'default' : 'secondary'}>
                      {vehicle.availability}
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
