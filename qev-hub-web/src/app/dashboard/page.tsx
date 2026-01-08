'use client'

import { useState, useEffect } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { LogisticsTimeline } from '@/components/dashboard/LogisticsTimeline'
import { SustainabilityDashboard } from '@/components/dashboard/SustainabilityDashboard'
import { CarIcon, ShoppingBag, ShipIcon, ZapIcon, User, Settings, LogOut, BatteryIcon } from '@/components/icons'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'

export default function DashboardPage() {
  const { user, loading, signOut } = useAuth()
  const router = useRouter()
  const [activeTab, setActiveTab] = useState<'marketplace' | 'orders' | 'charging' | 'sustainability' | 'admin' | 'settings'>('marketplace')
  const [order, setOrder] = useState<any>(null)
  const [vehicles, setVehicles] = useState<any[]>([])
  const [vehiclesLoading, setVehiclesLoading] = useState(true)
  const [vehicleFilter, setVehicleFilter] = useState<'all' | 'EV' | 'PHEV' | 'FCEV'>('all')
  const [searchQuery, setSearchQuery] = useState('')
  const [sortBy, setSortBy] = useState<'name' | 'price' | 'range'>('name')

  useEffect(() => {
    if (!loading && !user) {
      router.push('/login')
    }
  }, [user, loading, router])

  useEffect(() => {
    if (activeTab === 'marketplace') {
      fetchVehicles()
    }
  }, [activeTab])

  const fetchVehicles = async () => {
    try {
      setVehiclesLoading(true)
      const { data, error } = await supabase
        .from('vehicles')
        .select('*')
        .eq('status', 'available')
        .order('manufacturer', { ascending: true })

      if (error) throw error
      setVehicles(data || [])
    } catch (error) {
      console.error('Error fetching vehicles:', error)
    } finally {
      setVehiclesLoading(false)
    }
  }

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR'
    }).format(price)
  }

  const filteredAndSortedVehicles = vehicles
    .filter((vehicle) => {
      // Filter by type
      if (vehicleFilter !== 'all' && vehicle.vehicle_type !== vehicleFilter) {
        return false
      }
      // Filter by search query
      if (searchQuery) {
        const query = searchQuery.toLowerCase()
        return (
          vehicle.manufacturer?.toLowerCase().includes(query) ||
          vehicle.model?.toLowerCase().includes(query) ||
          vehicle.description?.toLowerCase().includes(query)
        )
      }
      return true
    })
    .sort((a, b) => {
      switch (sortBy) {
        case 'price':
          return (a.price_qar || 0) - (b.price_qar || 0)
        case 'range':
          return (b.range_km || 0) - (a.range_km || 0)
        case 'name':
        default:
          return `${a.manufacturer} ${a.model}`.localeCompare(`${b.manufacturer} ${b.model}`)
      }
    })

  const handleLogout = async () => {
    await signOut()
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
      </div>
    )
  }

  if (!user) return null

  return (
    <div className="min-h-screen bg-background overflow-hidden">
      {/* Animated Background */}
      <div className="fixed inset-0 pointer-events-none">
        <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.02)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.02)_1px,transparent_1px)] bg-[size:3rem_3rem] opacity-50"></div>
        <div className="absolute top-0 left-1/4 w-[500px] h-[500px] bg-primary/5 blur-[150px] rounded-full animate-pulse-slow" />
        <div className="absolute bottom-0 right-1/4 w-[600px] h-[600px] bg-primary/5 blur-[150px] rounded-full animate-pulse-slow" style={{ animationDelay: '1s' }} />
      </div>

      <div className="relative z-10 flex min-h-screen">
        {/* Sidebar */}
        <aside className="w-64 bg-card/30 backdrop-blur-xl border-r border-border/50 p-6 flex flex-col sticky top-0 h-screen overflow-y-auto">
          {/* Logo */}
          <div className="mb-8">
            <h1 className="text-2xl font-black tracking-widest text-foreground uppercase">
              QEV<span className="text-primary">-HUB</span>
            </h1>
            <p className="text-xs text-muted-foreground mt-1">Dashboard</p>
          </div>

          {/* Navigation */}
              <nav className="flex-1 space-y-2">
                <button
                  onClick={() => setActiveTab('marketplace')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'marketplace'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <CarIcon className="h-5 w-5" />
                  <span className="font-medium">Marketplace</span>
                </button>

                <button
                  onClick={() => setActiveTab('orders')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'orders'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <ShoppingBag className="h-5 w-5" />
                  <span className="font-medium">My Orders</span>
                </button>

                <button
                  onClick={() => setActiveTab('charging')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'charging'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <ZapIcon className="h-5 w-5" />
                  <span className="font-medium">Charging</span>
                </button>

                <button
                  onClick={() => setActiveTab('sustainability')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'sustainability'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <ZapIcon className="h-5 w-5" />
                  <span className="font-medium">Sustainability</span>
                </button>

                <button
                  onClick={() => setActiveTab('settings')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'settings'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <Settings className="h-5 w-5" />
                  <span className="font-medium">Settings</span>
                </button>

                <button
                  onClick={() => setActiveTab('admin')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'admin'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <Settings className="h-5 w-5" />
                  <span className="font-medium">Admin Portal</span>
                </button>
              </nav>

          {/* User Profile */}
          <div className="border-t border-border/50 pt-6 mt-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center">
                <User className="h-5 w-5 text-primary" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-foreground truncate">{user.email}</p>
                <p className="text-xs text-muted-foreground">Premium Member</p>
              </div>
            </div>
            <div className="flex gap-2">
              <Button
                variant="outline"
                size="sm"
                className="flex-1"
                onClick={() => setActiveTab('settings')}
              >
                <Settings className="h-4 w-4 mr-1" />
                Settings
              </Button>
              <Button
                variant="ghost"
                size="sm"
                onClick={handleLogout}
              >
                <LogOut className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </aside>

        {/* Main Content */}
        <main className="flex-1 overflow-y-auto">
          <div className="sticky top-0 z-20 bg-background/95 backdrop-blur-xl border-b border-border/50 px-8 py-4">
            <div className="flex items-center justify-between">
              <div>
                <h1 className="text-2xl font-bold text-foreground">
                  {activeTab === 'marketplace' && 'Marketplace'}
                  {activeTab === 'orders' && 'My Orders'}
                  {activeTab === 'charging' && 'Charging Stations'}
                  {activeTab === 'sustainability' && 'Sustainability'}
                  {activeTab === 'admin' && 'Admin Portal'}
                  {activeTab === 'settings' && 'Settings'}
                </h1>
                <p className="text-sm text-muted-foreground mt-1">
                  {activeTab === 'marketplace' && 'Browse and purchase vehicles directly from manufacturers'}
                  {activeTab === 'orders' && 'Track your vehicle orders and deliveries'}
                  {activeTab === 'charging' && 'Find nearby charging stations'}
                  {activeTab === 'sustainability' && 'Your environmental impact'}
                  {activeTab === 'admin' && 'Manage vehicles and inventory'}
                  {activeTab === 'settings' && 'Manage your account settings'}
                </p>
              </div>
              {activeTab === 'marketplace' && (
                <Button
                  variant="outline"
                  onClick={() => router.push('/marketplace/manufacturers')}
                  className="text-primary border-primary hover:bg-primary/10"
                >
                  View Manufacturers
                </Button>
              )}
            </div>
          </div>
          <div className="p-8">
          {activeTab === 'marketplace' && (
            <div className="space-y-6">
              <div className="flex items-center justify-between mb-6">
                <div>
                  <h1 className="text-3xl font-bold text-foreground">Marketplace</h1>
                  <p className="text-muted-foreground mt-1">Browse and purchase vehicles directly from manufacturers</p>
                </div>
                <Button
                  variant="outline"
                  onClick={() => router.push('/marketplace/manufacturers')}
                  className="text-primary border-primary hover:bg-primary/10"
                >
                  View Manufacturers
                </Button>
              </div>

              {/* Search and Filters */}
              <div className="glass-card tech-border p-6 space-y-4">
                {/* Search Bar */}
                <div className="flex gap-4">
                  <div className="flex-1 relative">
                    <input
                      type="text"
                      placeholder="Search by manufacturer, model, or keyword..."
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      className="w-full px-4 py-3 pl-10 bg-background border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                    <svg className="absolute left-3 top-3.5 h-5 w-5 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                    </svg>
                  </div>
                  <select
                    value={sortBy}
                    onChange={(e) => setSortBy(e.target.value as any)}
                    className="px-4 py-3 bg-background border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="name">Sort by Name</option>
                    <option value="price">Sort by Price</option>
                    <option value="range">Sort by Range</option>
                  </select>
                </div>

                {/* Vehicle Type Filters */}
                <div className="flex gap-3 flex-wrap">
                  <button
                    onClick={() => setVehicleFilter('all')}
                    className={`px-6 py-2.5 rounded-lg font-bold uppercase tracking-wider transition-all ${
                      vehicleFilter === 'all'
                        ? 'bg-primary text-primary-foreground shadow-lg'
                        : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
                    }`}
                  >
                    All ({vehicles.length})
                  </button>
                  <button
                    onClick={() => setVehicleFilter('EV')}
                    className={`px-6 py-2.5 rounded-lg font-bold uppercase tracking-wider transition-all ${
                      vehicleFilter === 'EV'
                        ? 'bg-primary text-primary-foreground shadow-lg'
                        : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
                    }`}
                  >
                    Electric ({vehicles.filter((v) => v.vehicle_type === 'EV').length})
                  </button>
                  <button
                    onClick={() => setVehicleFilter('PHEV')}
                    className={`px-6 py-2.5 rounded-lg font-bold uppercase tracking-wider transition-all ${
                      vehicleFilter === 'PHEV'
                        ? 'bg-primary text-primary-foreground shadow-lg'
                        : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
                    }`}
                  >
                    Plug-in Hybrid ({vehicles.filter((v) => v.vehicle_type === 'PHEV').length})
                  </button>
                  <button
                    onClick={() => setVehicleFilter('FCEV')}
                    className={`px-6 py-2.5 rounded-lg font-bold uppercase tracking-wider transition-all ${
                      vehicleFilter === 'FCEV'
                        ? 'bg-primary text-primary-foreground shadow-lg'
                        : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
                    }`}
                  >
                    Fuel Cell ({vehicles.filter((v) => v.vehicle_type === 'FCEV').length})
                  </button>
                </div>

                {/* Results count */}
                <div className="text-sm text-muted-foreground">
                  Showing {filteredAndSortedVehicles.length} of {vehicles.length} vehicles
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="glass-card tech-border p-6">
                  <div className="flex items-center justify-between mb-4">
                    <CarIcon className="h-8 w-8 text-primary" />
                    <span className="text-xs text-muted-foreground">Available</span>
                  </div>
                  <p className="text-3xl font-bold text-foreground">{vehicles.length}</p>
                  <p className="text-sm text-muted-foreground mt-1">Vehicles</p>
                </div>

                <div className="glass-card tech-border p-6">
                  <div className="flex items-center justify-between mb-4">
                    <ZapIcon className="h-8 w-8 text-primary" />
                    <span className="text-xs text-muted-foreground">Avg Range</span>
                  </div>
                  <p className="text-3xl font-bold text-foreground">
                    {vehicles.length > 0
                      ? Math.round(vehicles.reduce((sum: number, v: any) => sum + (v.range_km || 0), 0) / vehicles.length)
                      : 0}
                  </p>
                  <p className="text-sm text-muted-foreground mt-1">km</p>
                </div>

                <div className="glass-card tech-border p-6">
                  <div className="flex items-center justify-between mb-4">
                    <BatteryIcon className="h-8 w-8 text-primary" />
                    <span className="text-xs text-muted-foreground">EV Only</span>
                  </div>
                  <p className="text-3xl font-bold text-foreground">
                    {vehicles.filter((v: any) => v.vehicle_type === 'EV').length}
                  </p>
                  <p className="text-sm text-muted-foreground mt-1">Electric</p>
                </div>
              </div>

              {vehiclesLoading ? (
                <div className="flex justify-center items-center py-20">
                  <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
                </div>
              ) : filteredAndSortedVehicles.length === 0 ? (
                <div className="text-center py-20">
                  <CarIcon className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
                  <p className="text-muted-foreground">
                    {searchQuery ? `No vehicles found matching "${searchQuery}"` : 'No vehicles available'}
                  </p>
                  {searchQuery && (
                    <Button
                      variant="outline"
                      className="mt-4"
                      onClick={() => setSearchQuery('')}
                    >
                      Clear Search
                    </Button>
                  )}
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {filteredAndSortedVehicles.map((vehicle) => (
                    <Card
                      key={vehicle.id}
                      className="glass-card tech-border overflow-hidden hover:border-primary transition-all hover:-translate-y-1 cursor-pointer group"
                      onClick={() => router.push(`/marketplace/${vehicle.id}`)}
                    >
                      <div className="h-48 bg-gradient-to-br from-black/40 to-black/60 flex items-center justify-center relative overflow-hidden">
                        {vehicle.image_url ? (
                          <img
                            src={vehicle.image_url}
                            alt={`${vehicle.manufacturer} ${vehicle.model}`}
                            className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                          />
                        ) : (
                          <CarIcon className="h-16 w-16 text-muted-foreground/50 group-hover:text-primary transition-colors" />
                        )}
                        <div className="absolute inset-0 bg-gradient-to-t from-background/80 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                      </div>

                      <CardContent className="p-6">
                        <div className="flex items-start justify-between mb-2">
                          <div>
                            <h3 className="text-xl font-bold text-foreground group-hover:text-primary transition-colors">
                              {vehicle.manufacturer} {vehicle.model}
                            </h3>
                            <p className="text-sm text-muted-foreground">{vehicle.year}</p>
                          </div>
                          {vehicle.stock_count > 0 ? (
                            <Badge variant="secondary" className="bg-primary text-primary-foreground font-bold border-none">
                              In Stock ({vehicle.stock_count})
                            </Badge>
                          ) : (
                            <Badge variant="destructive" className="font-bold">Out of Stock</Badge>
                          )}
                        </div>

                        <p className="text-muted-foreground text-sm mb-4 line-clamp-2">
                          {vehicle.description}
                        </p>

                        <div className="grid grid-cols-2 gap-2 mb-4">
                          <div className="bg-muted/20 p-2.5 rounded-lg border border-border">
                            <div className="flex items-center gap-1 mb-1">
                              <BatteryIcon className="h-3 w-3 text-primary" />
                              <p className="text-xs text-muted-foreground">Range</p>
                            </div>
                            <p className="text-sm font-semibold text-foreground">
                              {vehicle.range_km} km
                            </p>
                          </div>
                          <div className="bg-muted/20 p-2.5 rounded-lg border border-border">
                            <div className="flex items-center gap-1 mb-1">
                              <BatteryIcon className="h-3 w-3 text-primary" />
                              <p className="text-xs text-muted-foreground">Battery</p>
                            </div>
                            <p className="text-sm font-semibold text-foreground">
                              {vehicle.battery_kwh} kWh
                            </p>
                          </div>
                        </div>

                        <div className="flex items-center justify-between">
                          <div>
                            <p className="text-2xl font-bold text-primary">
                              {formatPrice(vehicle.price_qar)}
                            </p>
                            <p className="text-xs text-muted-foreground">Direct from manufacturer</p>
                          </div>
                          <Button
                            size="sm"
                            onClick={(e) => {
                              e.stopPropagation()
                              router.push(`/marketplace/${vehicle.id}`)
                            }}
                            className="bg-primary text-primary-foreground font-bold hover:bg-primary/90 transition-colors"
                          >
                            View Details
                          </Button>
                        </div>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              )}
            </div>
          )}

          {activeTab === 'orders' && (
            <div className="space-y-6">
              <LogisticsTimeline order={order} />
            </div>
          )}

          {activeTab === 'sustainability' && (
            <SustainabilityDashboard />
          )}

          {activeTab === 'charging' && (
            <div className="space-y-6">
              <div className="glass-card tech-border p-8 text-center">
                <ZapIcon className="h-16 w-16 text-primary mx-auto mb-4" />
                <h2 className="text-2xl font-bold text-foreground mb-2">
                  Charging Stations
                </h2>
                <p className="text-muted-foreground mb-6">
                  Find EV charging stations near you across Qatar
                </p>
                <Button
                  onClick={() => router.push('/charging')}
                  className="bg-primary text-primary-foreground"
                >
                  Go to Full Charging Map
                </Button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="glass-card tech-border p-6">
                  <div className="flex items-center gap-3 mb-4">
                    <div className="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center">
                      <ZapIcon className="h-6 w-6 text-primary" />
                    </div>
                    <div>
                      <p className="text-2xl font-bold text-foreground">150+</p>
                      <p className="text-sm text-muted-foreground">Stations</p>
                    </div>
                  </div>
                  <p className="text-xs text-muted-foreground">Across Qatar</p>
                </div>

                <div className="glass-card tech-border p-6">
                  <div className="flex items-center gap-3 mb-4">
                    <div className="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center">
                      <CarIcon className="h-6 w-6 text-primary" />
                    </div>
                    <div>
                      <p className="text-2xl font-bold text-foreground">24/7</p>
                      <p className="text-sm text-muted-foreground">Access</p>
                    </div>
                  </div>
                  <p className="text-xs text-muted-foreground">Most stations</p>
                </div>

                <div className="glass-card tech-border p-6">
                  <div className="flex items-center gap-3 mb-4">
                    <div className="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center">
                      <ShipIcon className="h-6 w-6 text-primary" />
                    </div>
                    <div>
                      <p className="text-2xl font-bold text-foreground">Fast</p>
                      <p className="text-sm text-muted-foreground">Charging</p>
                    </div>
                  </div>
                  <p className="text-xs text-muted-foreground">Up to 150kW</p>
                </div>
              </div>
            </div>
          )}

          {activeTab === 'settings' && (
            <div className="space-y-6">
              <Card className="glass-card tech-border">
                <CardHeader>
                  <CardTitle>Account Settings</CardTitle>
                </CardHeader>
                <CardContent className="space-y-6">
                  <div>
                    <label className="block text-sm font-medium text-foreground mb-2">
                      Email Address
                    </label>
                    <input
                      type="email"
                      value={user.email}
                      disabled
                      className="w-full px-3 py-2 border border-border bg-muted/30 rounded-md text-muted-foreground"
                    />
                    <p className="text-xs text-muted-foreground mt-1">
                      Contact support to change your email
                    </p>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-foreground mb-2">
                      Account Type
                    </label>
                    <div className="flex items-center gap-2 p-3 bg-muted/30 rounded-lg border border-border/50">
                      <User className="h-5 w-5 text-primary" />
                      <span className="font-medium text-foreground">Premium Member</span>
                      <Badge className="bg-primary/10 text-primary border-primary/30">
                        Active
                      </Badge>
                    </div>
                  </div>

                  <Separator />

                  <div>
                    <h4 className="font-semibold text-foreground mb-3">Notifications</h4>
                    <div className="space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-sm text-foreground">Order Updates</span>
                        <input type="checkbox" defaultChecked className="w-4 h-4" />
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="text-sm text-foreground">Promotional Emails</span>
                        <input type="checkbox" defaultChecked className="w-4 h-4" />
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="text-sm text-foreground">Charging Alerts</span>
                        <input type="checkbox" defaultChecked className="w-4 h-4" />
                      </div>
                    </div>
                  </div>

                  <Separator />

                  <div>
                    <h4 className="font-semibold text-foreground mb-3">Language & Region</h4>
                    <div className="space-y-3">
                      <div>
                        <label className="block text-sm text-muted-foreground mb-2">
                          Preferred Language
                        </label>
                        <select className="w-full px-3 py-2 border border-border bg-background rounded-md">
                          <option value="en">English</option>
                          <option value="ar">العربية (Arabic)</option>
                        </select>
                      </div>
                    </div>
                  </div>

                  <Separator />

                  <div className="flex gap-3">
                    <Button variant="outline" className="flex-1">
                      Cancel
                    </Button>
                    <Button className="flex-1 bg-primary text-primary-foreground">
                      Save Changes
                    </Button>
                  </div>
                </CardContent>
              </Card>

              <Card className="glass-card tech-border border-red-500/50">
                <CardHeader>
                  <CardTitle className="text-red-600">Danger Zone</CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-sm text-muted-foreground mb-4">
                    Once you delete your account, there is no going back. Please be certain.
                  </p>
                  <Button variant="destructive" onClick={handleLogout}>
                    Log Out
                  </Button>
                </CardContent>
              </Card>
            </div>
          )}

          {activeTab === 'admin' && (
            <div className="space-y-6">
              <Card className="glass-card tech-border">
                <CardContent className="p-8 text-center">
                  <Settings className="h-16 w-16 text-primary mx-auto mb-4" />
                  <h3 className="text-2xl font-bold text-foreground mb-2">
                    Manufacturer Admin Portal
                  </h3>
                  <p className="text-muted-foreground mb-6">
                    Manage your vehicle inventory, track analytics, and update pricing information.
                  </p>
                  <Button
                    onClick={() => router.push('/dashboard/admin')}
                    className="bg-primary text-primary-foreground"
                  >
                    Go to Admin Dashboard
                  </Button>
                </CardContent>
              </Card>
            </div>
          )}
          </div>
        </main>
      </div>
    </div>
  )
}
