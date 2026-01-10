'use client'

import { useState, useEffect } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { useRouter, useParams } from 'next/navigation'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Separator } from '@/components/ui/separator'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { PlusIcon, PencilIcon, TrashIcon, TrendingUp, EyeIcon, AlertCircle, CarIcon, ZapIcon } from '@/components/icons'

interface Vehicle {
  id: string
  manufacturer_id: string
  manufacturer: string
  model: string
  year: number
  vehicle_type: string
  origin_country: string
  range_km: number
  battery_kwh: number
  price_qar: number
  manufacturer_direct_price: number
  broker_market_price: number
  price_transparency_enabled: boolean
  image_url: string
  images: any[]
  description: string
  specs: Record<string, string>
  stock_count: number
  status: string
  warranty_years: number
  warranty_km: number
}

interface Manufacturer {
  id: string
  company_name: string
  company_name_ar: string
  country: string
  city: string
  verification_status: string
  contact_email?: string
  contact_phone?: string
}

export default function AdminDashboard() {
  const { user, getSupabaseClient } = useAuth()
  const router = useRouter()
  const [activeTab, setActiveTab] = useState<'inventory' | 'analytics' | 'settings'>('inventory')
  const [vehicles, setVehicles] = useState<Vehicle[]>([])
  const [manufacturer, setManufacturer] = useState<Manufacturer | null>(null)
  const [loading, setLoading] = useState(true)
  const [selectedVehicle, setSelectedVehicle] = useState<Vehicle | null>(null)
  const [editMode, setEditMode] = useState(false)
  const [showDeleteDialog, setShowDeleteDialog] = useState(false)
  const [filter, setFilter] = useState<'all' | 'ev' | 'phev'>('all')
  const [stats, setStats] = useState({
    totalVehicles: 0,
    totalInquiries: 0,
    totalOrders: 0,
    avgViews: 0,
  })

  useEffect(() => {
    fetchManufacturerData()
    fetchVehicles()
    fetchStats()
  }, [])

  const fetchManufacturerData = async () => {
    try {
      if (!user) {
        router.push('/login')
        return
      }

      const authSupabase = getSupabaseClient()

      const { data: mfr } = await authSupabase
        .from('manufacturers')
        .select('*')
        .eq('user_id', user.id)
        .single()

      if (mfr) {
        setManufacturer(mfr)
      }
      // If no manufacturer profile, show access denied (removed auto-redirect to signup)
    } catch (error) {
      console.error('Error fetching manufacturer data:', error)
    }
  }

  const fetchVehicles = async () => {
    if (!manufacturer) return

    try {
      setLoading(true)
      const authSupabase = getSupabaseClient()
      const { data, error } = await authSupabase
        .from('vehicles')
        .select('*')
        .eq('manufacturer_id', manufacturer.id)
        .order('created_at', { ascending: false })

      if (error) throw error
      setVehicles(data || [])
    } catch (error) {
      console.error('Error fetching vehicles:', error)
    } finally {
      setLoading(false)
    }
  }

  const fetchStats = async () => {
    if (!manufacturer) return

    try {
      const authSupabase = getSupabaseClient()
      const { data: vehiclesData } = await authSupabase
        .from('vehicles')
        .select('id')
        .eq('manufacturer_id', manufacturer.id)

      const { data: inquiriesData } = await authSupabase
        .from('vehicle_inquiries')
        .select('id')
        .in('vehicle_id', vehiclesData?.map((v: any) => v.id) || [])

      setStats({
        totalVehicles: vehiclesData?.length || 0,
        totalInquiries: inquiriesData?.length || 0,
        totalOrders: 0,
        avgViews: 0,
      })
    } catch (error) {
      console.error('Error fetching stats:', error)
    }
  }

  const handleAddVehicle = () => {
    setSelectedVehicle({
      id: '',
      manufacturer_id: manufacturer?.id || '',
      manufacturer: manufacturer?.company_name || '',
      model: '',
      year: new Date().getFullYear(),
      vehicle_type: 'EV',
      origin_country: 'China',
      range_km: 0,
      battery_kwh: 0,
      price_qar: 0,
      manufacturer_direct_price: 0,
      broker_market_price: 0,
      price_transparency_enabled: true,
      image_url: '',
      images: [],
      description: '',
      specs: {},
      stock_count: 0,
      status: 'available',
      warranty_years: 5,
      warranty_km: 100000,
    })
    setEditMode(false)
  }

  const handleEditVehicle = (vehicle: Vehicle) => {
    setSelectedVehicle(vehicle)
    setEditMode(true)
  }

  const handleDeleteVehicle = async (vehicleId: string) => {
    try {
      const authSupabase = getSupabaseClient()
      const { error } = await authSupabase
        .from('vehicles')
        .delete()
        .eq('id', vehicleId)

      if (error) throw error

      setVehicles(vehicles.filter((v) => v.id !== vehicleId))
      setShowDeleteDialog(false)
      setSelectedVehicle(null)
    } catch (error) {
      console.error('Error deleting vehicle:', error)
      alert('Failed to delete vehicle')
    }
  }

  const handleSaveVehicle = async (vehicleData: Partial<Vehicle>) => {
    if (!manufacturer) return

    try {
      const authSupabase = getSupabaseClient()
      if (editMode) {
        const { error } = await authSupabase
          .from('vehicles')
          .update({
            ...vehicleData,
            updated_at: new Date().toISOString(),
          })
          .eq('id', selectedVehicle?.id)

        if (error) throw error
      } else {
        const { error } = await authSupabase
          .from('vehicles')
          .insert({
            ...vehicleData,
            manufacturer_id: manufacturer.id,
            manufacturer: manufacturer.company_name,
            stock_count: 0,
            status: 'available',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          })

        if (error) throw error
      }

      setSelectedVehicle(null)
      fetchVehicles()
      fetchStats()
    } catch (error) {
      console.error('Error saving vehicle:', error)
      alert('Failed to save vehicle')
    }
  }

  const filteredVehicles = vehicles.filter((vehicle) => {
    if (filter === 'all') return true
    return vehicle.vehicle_type.toLowerCase() === filter
  })

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR',
      maximumFractionDigits: 0,
    }).format(price)
  }

  if (!manufacturer || manufacturer.verification_status !== 'verified') {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background p-8">
        <Card className="glass-card tech-border max-w-md">
          <CardContent className="p-8 text-center">
            {!manufacturer && (
              <>
                <AlertCircle className="h-16 w-16 text-primary mx-auto mb-4" />
                <h2 className="text-2xl font-bold text-foreground mb-2">Access Denied</h2>
                <p className="text-muted-foreground mb-6">
                  You need a manufacturer account to access this portal. Apply through the link at the bottom of our homepage.
                </p>
                <div className="flex gap-3">
                  <Button
                    variant="outline"
                    onClick={() => router.push('/')}
                  >
                    Go to Homepage
                  </Button>
                  <Button
                    onClick={() => router.push('/manufacturer-signup')}
                  >
                    Apply as Manufacturer
                  </Button>
                </div>
              </>
            )}
            {manufacturer?.verification_status === 'pending' && (
              <>
                <AlertCircle className="h-16 w-16 text-yellow-600 mx-auto mb-4" />
                <h2 className="text-2xl font-bold text-foreground mb-2">Account Under Review</h2>
                <p className="text-muted-foreground">
                  Your manufacturer application is pending verification. We'll review your documents and contact you within 2-3 business days.
                </p>
              </>
            )}
            {manufacturer?.verification_status === 'rejected' && (
              <>
                <AlertCircle className="h-16 w-16 text-red-600 mx-auto mb-4" />
                <h2 className="text-2xl font-bold text-foreground mb-2">Application Rejected</h2>
                <p className="text-muted-foreground mb-6">
                  Your manufacturer application was rejected. Please contact support for more information.
                </p>
                <Button
                  onClick={() => window.location.href = 'mailto:manufacturers@qev-hub.qa'}
                  className="mt-6"
                >
                  Contact Support
                </Button>
              </>
            )}
          </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary/10 to-primary/5 border-b border-border/50 p-6">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-foreground">
              {manufacturer.company_name} <span className="text-primary">Admin</span>
            </h1>
            <p className="text-sm text-muted-foreground">
              Verified Manufacturer • {manufacturer.city}, {manufacturer.country}
            </p>
          </div>
          <Badge className="bg-green-500 text-white">
            {manufacturer.verification_status}
          </Badge>
        </div>
      </div>

      <div className="max-w-7xl mx-auto p-6">
        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
          <Card className="glass-card tech-border p-4">
            <div className="flex items-center justify-between mb-2">
              <CarIcon className="h-8 w-8 text-primary" />
              <span className="text-xs text-muted-foreground">Total</span>
            </div>
            <p className="text-3xl font-bold text-foreground">{stats.totalVehicles}</p>
            <p className="text-sm text-muted-foreground">Vehicles</p>
          </Card>

          <Card className="glass-card tech-border p-4">
            <div className="flex items-center justify-between mb-2">
              <EyeIcon className="h-8 w-8 text-primary" />
              <span className="text-xs text-muted-foreground">Total</span>
            </div>
            <p className="text-3xl font-bold text-foreground">{stats.totalInquiries}</p>
            <p className="text-sm text-muted-foreground">Inquiries</p>
          </Card>

          <Card className="glass-card tech-border p-4">
            <div className="flex items-center justify-between mb-2">
              <ZapIcon className="h-8 w-8 text-primary" />
              <span className="text-xs text-muted-foreground">Avg</span>
            </div>
            <p className="text-3xl font-bold text-foreground">{stats.avgViews}</p>
            <p className="text-sm text-muted-foreground">Daily Views</p>
          </Card>

          <Card className="glass-card tech-border p-4">
            <div className="flex items-center justify-between mb-2">
              <TrendingUp className="h-8 w-8 text-primary" />
              <span className="text-xs text-muted-foreground">This</span>
            </div>
            <p className="text-3xl font-bold text-foreground">{stats.totalOrders}</p>
            <p className="text-sm text-muted-foreground">Month Orders</p>
          </Card>
        </div>

        {/* Tabs */}
        <Tabs value={activeTab} onValueChange={(v) => setActiveTab(v as any)}>
          <TabsList className="grid w-full grid-cols-3 mb-6">
            <TabsTrigger value="inventory" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">
              <CarIcon className="h-4 w-4 mr-2" />
              Inventory
            </TabsTrigger>
            <TabsTrigger value="analytics">
              <TrendingUp className="h-4 w-4 mr-2" />
              Analytics
            </TabsTrigger>
            <TabsTrigger value="settings">
              <PencilIcon className="h-4 w-4 mr-2" />
              Settings
            </TabsTrigger>
          </TabsList>

          {/* Inventory Tab */}
          <TabsContent value="inventory">
            <Card className="glass-card tech-border">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle>Vehicle Inventory</CardTitle>
                  <div className="flex items-center gap-4">
                    <div className="flex gap-2">
                      <Button
                        variant={filter === 'all' ? 'default' : 'outline'}
                        size="sm"
                        onClick={() => setFilter('all')}
                      >
                        All
                      </Button>
                      <Button
                        variant={filter === 'ev' ? 'default' : 'outline'}
                        size="sm"
                        onClick={() => setFilter('ev')}
                      >
                        EV Only
                      </Button>
                      <Button
                        variant={filter === 'phev' ? 'default' : 'outline'}
                        size="sm"
                        onClick={() => setFilter('phev')}
                      >
                        PHEV Only
                      </Button>
                    </div>
                    <Button
                      onClick={handleAddVehicle}
                      className="bg-primary text-primary-foreground"
                    >
                      <PlusIcon className="h-4 w-4 mr-2" />
                      Add Vehicle
                    </Button>
                  </div>
                </div>
              </CardHeader>
              <CardContent>
                {loading ? (
                  <div className="flex justify-center py-12">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
                  </div>
                ) : filteredVehicles.length === 0 ? (
                  <div className="text-center py-12">
                    <CarIcon className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
                    <p className="text-muted-foreground">No vehicles found</p>
                    <p className="text-sm text-muted-foreground mt-2">
                      Add your first vehicle to start selling on QEV Hub
                    </p>
                  </div>
                ) : (
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    {filteredVehicles.map((vehicle) => (
                      <Card
                        key={vehicle.id}
                        className="hover:border-primary transition-all hover:-translate-y-1 cursor-pointer group"
                        onClick={() => handleEditVehicle(vehicle)}
                      >
                        <CardContent className="p-4">
                          <div className="relative mb-3">
                            {vehicle.image_url ? (
                              <img
                                src={vehicle.image_url}
                                alt={vehicle.model}
                                className="w-full h-32 object-cover rounded-lg"
                              />
                            ) : (
                              <div className="w-full h-32 bg-gradient-to-br from-primary/20 to-primary/5 rounded-lg flex items-center justify-center">
                                <CarIcon className="h-12 w-12 text-primary" />
                              </div>
                            )}
                            <Badge
                              variant={vehicle.vehicle_type === 'EV' ? 'default' : 'secondary'}
                              className="absolute top-2 right-2"
                            >
                              {vehicle.vehicle_type}
                            </Badge>
                          </div>

                          <h3 className="font-bold text-foreground mb-1 group-hover:text-primary transition-colors">
                            {vehicle.manufacturer} {vehicle.model}
                          </h3>
                          <p className="text-xs text-muted-foreground mb-2">
                            {vehicle.year} • {vehicle.origin_country}
                          </p>

                          <div className="space-y-2 mb-3">
                            <div className="flex justify-between text-sm">
                              <span className="text-muted-foreground">Range:</span>
                              <span className="font-medium text-foreground">{vehicle.range_km} km</span>
                            </div>
                            <div className="flex justify-between text-sm">
                              <span className="text-muted-foreground">Battery:</span>
                              <span className="font-medium text-foreground">{vehicle.battery_kwh} kWh</span>
                            </div>
                            <div className="flex justify-between text-sm">
                              <span className="text-muted-foreground">Stock:</span>
                              <span className={`font-medium ${vehicle.stock_count > 0 ? 'text-green-600' : 'text-red-600'}`}>
                                {vehicle.stock_count > 0 ? `${vehicle.stock_count} units` : 'Out of Stock'}
                              </span>
                            </div>
                          </div>

                          {vehicle.price_transparency_enabled && (
                            <div className="p-3 bg-green-500/5 rounded-lg border border-green-500/30">
                              <div className="flex justify-between items-center mb-1">
                                <span className="text-sm font-medium text-foreground">Direct Price:</span>
                                <span className="text-lg font-bold text-green-600">
                                  {formatPrice(vehicle.manufacturer_direct_price)}
                                </span>
                              </div>
                              <div className="flex justify-between items-center text-xs">
                                <span className="text-muted-foreground">Broker Market:</span>
                                <span className="line-through text-muted-foreground">
                                  {formatPrice(vehicle.broker_market_price)}
                                </span>
                              </div>
                            </div>
                          )}

                          <div className="flex gap-2 mt-3 pt-3 border-t border-border/50">
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={(e) => {
                                e.stopPropagation()
                                handleEditVehicle(vehicle)
                              }}
                              className="flex-1"
                            >
                              <PencilIcon className="h-4 w-4 mr-1" />
                              Edit
                            </Button>
                            <Button
                              size="sm"
                              variant="destructive"
                              onClick={(e) => {
                                e.stopPropagation()
                                setSelectedVehicle(vehicle)
                                setShowDeleteDialog(true)
                              }}
                              className="flex-1"
                            >
                              <TrashIcon className="h-4 w-4 mr-1" />
                              Delete
                            </Button>
                          </div>
                        </CardContent>
                      </Card>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>

          {/* Analytics Tab */}
          <TabsContent value="analytics">
            <Card className="glass-card tech-border">
              <CardHeader>
                <CardTitle>Analytics Overview</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-center py-12 text-muted-foreground">
                  Detailed analytics coming soon. Track views, inquiries, and sales performance.
                </p>
              </CardContent>
            </Card>
          </TabsContent>

          {/* Settings Tab */}
          <TabsContent value="settings">
            <Card className="glass-card tech-border">
              <CardHeader>
                <CardTitle>Manufacturer Settings</CardTitle>
              </CardHeader>
              <CardContent className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Company Name
                  </label>
                  <Input
                    value={manufacturer.company_name}
                    disabled
                    className="bg-muted/30"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Company Name (Arabic)
                  </label>
                  <Input
                    value={manufacturer.company_name_ar}
                    disabled
                    className="bg-muted/30"
                    dir="rtl"
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-foreground mb-2">
                      Contact Email
                    </label>
                    <Input
                      type="email"
                      value={manufacturer.contact_email || ''}
                      disabled
                      className="bg-muted/30"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-foreground mb-2">
                      Contact Phone
                    </label>
                    <Input
                      type="tel"
                      value={manufacturer.contact_phone || ''}
                      disabled
                      className="bg-muted/30"
                    />
                  </div>
                </div>

                <Separator className="my-6" />

                <div className="p-4 bg-primary/5 rounded-lg border border-primary/30">
                  <h4 className="font-semibold text-foreground mb-2">
                    Price Transparency Mode
                  </h4>
                  <p className="text-sm text-muted-foreground">
                    Enable to show your manufacturer direct price alongside estimated broker market prices, giving buyers transparency and trust.
                  </p>
                  <div className="mt-4">
                    <Badge className="bg-green-500/10 text-green-600 border-green-500/30">
                      Currently Enabled
                    </Badge>
                  </div>
                </div>

                <Separator className="my-6" />

                <Button className="w-full" variant="outline">
                  Manage Account
                </Button>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>

      {/* Add/Edit Vehicle Dialog */}
      <Dialog open={!!selectedVehicle} onOpenChange={() => setSelectedVehicle(null)}>
        <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {editMode ? 'Edit Vehicle' : 'Add New Vehicle'}
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-6 py-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Manufacturer *
                </label>
                <Input
                  value={selectedVehicle?.manufacturer}
                  onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, manufacturer: e.target.value })}
                  disabled
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Model *
                </label>
                <Input
                  value={selectedVehicle?.model}
                  onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, model: e.target.value })}
                  placeholder="Model 3"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Year *
                </label>
                <Input
                  type="number"
                  value={selectedVehicle?.year}
                  onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, year: parseInt(e.target.value) })}
                  placeholder="2024"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Vehicle Type *
                </label>
                <select
                  value={selectedVehicle?.vehicle_type}
                  onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, vehicle_type: e.target.value })}
                  className="w-full px-3 py-2 border border-border bg-background rounded-md"
                >
                  <option value="EV">EV (Electric Vehicle)</option>
                  <option value="PHEV">PHEV (Plug-in Hybrid)</option>
                  <option value="FCEV">FCEV (Fuel Cell)</option>
                </select>
              </div>
            </div>

            <div className="grid grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Range (km) *
                </label>
                <Input
                  type="number"
                  value={selectedVehicle?.range_km}
                  onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, range_km: parseInt(e.target.value) })}
                  placeholder="500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Battery (kWh) *
                </label>
                <Input
                  type="number"
                  value={selectedVehicle?.battery_kwh}
                  onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, battery_kwh: parseFloat(e.target.value) })}
                  placeholder="75.0"
                  step="0.1"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Stock Count
                </label>
                <Input
                  type="number"
                  value={selectedVehicle?.stock_count}
                  onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, stock_count: parseInt(e.target.value) })}
                  placeholder="10"
                />
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <h4 className="font-semibold text-foreground">Pricing (QAR)</h4>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Manufacturer Direct Price *
                  </label>
                  <Input
                    type="number"
                    value={selectedVehicle?.manufacturer_direct_price}
                    onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, manufacturer_direct_price: parseFloat(e.target.value) })}
                    placeholder="175000"
                  />
                  <p className="text-xs text-muted-foreground mt-1">
                    Your factory direct price
                  </p>
                </div>
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Broker Market Price
                  </label>
                  <Input
                    type="number"
                    value={selectedVehicle?.broker_market_price}
                    onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, broker_market_price: parseFloat(e.target.value) })}
                    placeholder="227500"
                  />
                  <p className="text-xs text-muted-foreground mt-1">
                    Estimated dealer/broker price (30% markup default)
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <input
                  type="checkbox"
                  id="price-transparency"
                  checked={selectedVehicle?.price_transparency_enabled}
                  onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, price_transparency_enabled: e.target.checked })}
                />
                <label htmlFor="price-transparency" className="text-sm text-foreground">
                  Enable Price Transparency Mode
                </label>
              </div>
            </div>

            <Separator />

            <div>
              <label className="block text-sm font-medium text-foreground mb-2">
                Description
              </label>
              <textarea
                value={selectedVehicle?.description}
                onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, description: e.target.value })}
                placeholder="Brief vehicle description..."
                rows={3}
                className="w-full px-3 py-2 border border-border bg-background rounded-md"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-foreground mb-2">
                Image URL
              </label>
              <Input
                type="url"
                value={selectedVehicle?.image_url}
                onChange={(e) => setSelectedVehicle({ ...selectedVehicle!, image_url: e.target.value })}
                placeholder="https://..."
              />
            </div>

            <div className="flex justify-end gap-3 pt-4 border-t border-border/50">
              <Button
                variant="outline"
                onClick={() => setSelectedVehicle(null)}
              >
                Cancel
              </Button>
              <Button
                onClick={() => handleSaveVehicle(selectedVehicle!)}
                className="bg-primary text-primary-foreground"
              >
                {editMode ? 'Update Vehicle' : 'Add Vehicle'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={showDeleteDialog} onOpenChange={setShowDeleteDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Vehicle</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <p className="text-sm text-muted-foreground">
              Are you sure you want to delete this vehicle? This action cannot be undone.
            </p>
            {selectedVehicle && (
              <div className="p-4 bg-muted/30 rounded-lg border border-border/50">
                <p className="font-semibold text-foreground">
                  {selectedVehicle.manufacturer} {selectedVehicle.model}
                </p>
                <p className="text-xs text-muted-foreground mt-1">
                  {selectedVehicle.year} • {selectedVehicle.vehicle_type}
                </p>
              </div>
            )}
            <div className="flex justify-end gap-3">
              <Button
                variant="outline"
                onClick={() => setShowDeleteDialog(false)}
              >
                Cancel
              </Button>
              <Button
                variant="destructive"
                onClick={() => selectedVehicle && handleDeleteVehicle(selectedVehicle.id)}
              >
                Delete
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
