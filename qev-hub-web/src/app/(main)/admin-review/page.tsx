'use client'

import { useState, useEffect } from 'react'
import { createClient } from '@supabase/supabase-js'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { CheckIcon, XIcon, EyeIcon } from 'lucide-react'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
const supabase = createClient(supabaseUrl, supabaseKey)

interface Vehicle {
  id: string
  make: string
  model: string
  year: number
  trim_level?: string
  vehicle_type: string
  range_km?: number
  battery_kwh?: number
  price?: number
  manufacturer_direct_price?: number
  grey_market_price?: number
  gcc_spec?: boolean
  chinese_spec?: boolean
  description?: string
  images?: any[]
  specs?: any
  status: string
  created_at: string
}

export default function AdminReviewPage() {
  const [vehicles, setVehicles] = useState<Vehicle[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState<'pending' | 'approved' | 'rejected' | 'all'>('pending')
  const [selectedVehicle, setSelectedVehicle] = useState<Vehicle | null>(null)

  useEffect(() => {
    fetchVehicles()
  }, [filter])

  const fetchVehicles = async () => {
    try {
      setLoading(true)
      let query = supabase
        .from('vehicles')
        .select('*')
        .order('created_at', { ascending: false })

      if (filter !== 'all') {
        query = query.eq('status', filter)
      }

      const { data, error } = await query

      if (error) throw error
      setVehicles(data || [])
    } catch (error) {
      console.error('Error fetching vehicles:', error)
    } finally {
      setLoading(false)
    }
  }

  const updateStatus = async (vehicleId: string, newStatus: string) => {
    try {
      const { error } = await supabase
        .from('vehicles')
        .update({ status: newStatus })
        .eq('id', vehicleId)

      if (error) throw error

      setVehicles(vehicles.map(v =>
        v.id === vehicleId ? { ...v, status: newStatus } : v
      ))

      if (selectedVehicle?.id === vehicleId) {
        setSelectedVehicle({ ...selectedVehicle, status: newStatus })
      }
    } catch (error) {
      console.error('Error updating status:', error)
      alert('Failed to update status')
    }
  }

  const filteredVehicles = vehicles

  const formatPrice = (price?: number) => {
    if (!price) return 'N/A'
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR',
      maximumFractionDigits: 0,
    }).format(price)
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending': return 'bg-yellow-500/10 text-yellow-600 border-yellow-500/30'
      case 'approved': return 'bg-green-500/10 text-green-600 border-green-500/30'
      case 'rejected': return 'bg-red-500/10 text-red-600 border-red-500/30'
      case 'available': return 'bg-blue-500/10 text-blue-600 border-blue-500/30'
      default: return ''
    }
  }

  return (
    <div className="min-h-screen bg-background p-6">
      <div className="max-w-7xl mx-auto">
        <div className="mb-6">
          <h1 className="text-3xl font-bold text-foreground">Vehicle Review Admin</h1>
          <p className="text-muted-foreground mt-2">
            Review and approve/reject pending vehicle submissions
          </p>
        </div>

        <Card className="mb-6">
          <CardHeader>
            <CardTitle>Filter by Status</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex gap-2 flex-wrap">
              <Button
                variant={filter === 'pending' ? 'default' : 'outline'}
                onClick={() => setFilter('pending')}
              >
                Pending ({vehicles.filter(v => v.status === 'pending').length})
              </Button>
              <Button
                variant={filter === 'approved' ? 'default' : 'outline'}
                onClick={() => setFilter('approved')}
              >
                Approved
              </Button>
              <Button
                variant={filter === 'rejected' ? 'default' : 'outline'}
                onClick={() => setFilter('rejected')}
              >
                Rejected
              </Button>
              <Button
                variant={filter === 'all' ? 'default' : 'outline'}
                onClick={() => setFilter('all')}
              >
                All ({vehicles.length})
              </Button>
            </div>
          </CardContent>
        </Card>

        {loading ? (
          <div className="flex justify-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
          </div>
        ) : filteredVehicles.length === 0 ? (
          <Card>
            <CardContent className="text-center py-12">
              <p className="text-muted-foreground">No vehicles found</p>
            </CardContent>
          </Card>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredVehicles.map((vehicle) => (
              <Card
                key={vehicle.id}
                className="hover:border-primary transition-all"
              >
                <CardContent className="p-4">
                  <div className="flex items-start justify-between mb-3">
                    <Badge className={getStatusColor(vehicle.status)}>
                      {vehicle.status}
                    </Badge>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => setSelectedVehicle(vehicle)}
                    >
                      <EyeIcon className="h-4 w-4" />
                    </Button>
                  </div>

                  {vehicle.images && vehicle.images.length > 0 && (
                    <img
                      src={vehicle.images[0].url}
                      alt={`${vehicle.make} ${vehicle.model}`}
                      className="w-full h-32 object-cover rounded-lg mb-3"
                    />
                  )}

                  <h3 className="font-bold text-foreground mb-1">
                    {vehicle.make} {vehicle.model}
                  </h3>
                  <p className="text-sm text-muted-foreground mb-2">
                    {vehicle.year} {vehicle.trim_level && `• ${vehicle.trim_level}`}
                  </p>

                  <div className="space-y-1 text-sm mb-3">
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Type:</span>
                      <span className="font-medium">{vehicle.vehicle_type}</span>
                    </div>
                    {vehicle.range_km && (
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">Range:</span>
                        <span className="font-medium">{vehicle.range_km} km</span>
                      </div>
                    )}
                    {vehicle.battery_kwh && (
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">Battery:</span>
                        <span className="font-medium">{vehicle.battery_kwh} kWh</span>
                      </div>
                    )}
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Price:</span>
                      <span className="font-medium">{formatPrice(vehicle.price || vehicle.manufacturer_direct_price)}</span>
                    </div>
                  </div>

                  <div className="flex gap-2 pt-2 border-t border-border/50">
                    {vehicle.status === 'pending' && (
                      <>
                        <Button
                          size="sm"
                          variant="default"
                          onClick={() => updateStatus(vehicle.id, 'approved')}
                          className="flex-1"
                        >
                          <CheckIcon className="h-4 w-4 mr-1" />
                          Approve
                        </Button>
                        <Button
                          size="sm"
                          variant="destructive"
                          onClick={() => updateStatus(vehicle.id, 'rejected')}
                          className="flex-1"
                        >
                          <XIcon className="h-4 w-4 mr-1" />
                          Reject
                        </Button>
                      </>
                    )}
                    {vehicle.status === 'rejected' && (
                      <Button
                        size="sm"
                        variant="default"
                        onClick={() => updateStatus(vehicle.id, 'approved')}
                        className="w-full"
                      >
                        Approve Anyway
                      </Button>
                    )}
                    {vehicle.status === 'approved' && (
                      <Button
                        size="sm"
                        variant="destructive"
                        onClick={() => updateStatus(vehicle.id, 'rejected')}
                        className="w-full"
                      >
                        Reject
                      </Button>
                    )}
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        {/* Detail Modal */}
        {selectedVehicle && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
            <Card className="max-w-2xl w-full max-h-[90vh] overflow-y-auto">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle>
                    {selectedVehicle.make} {selectedVehicle.model} ({selectedVehicle.year})
                  </CardTitle>
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => setSelectedVehicle(null)}
                  >
                    ✕
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="space-y-4">
                {selectedVehicle.images && selectedVehicle.images.length > 0 && (
                  <div className="grid grid-cols-2 gap-2">
                    {selectedVehicle.images.map((img: any, i: number) => (
                      <img
                        key={i}
                        src={img.url}
                        alt={`Image ${i + 1}`}
                        className="w-full h-40 object-cover rounded-lg"
                      />
                    ))}
                  </div>
                )}

                <div>
                  <h4 className="font-semibold mb-2">Specifications</h4>
                  <div className="grid grid-cols-2 gap-2 text-sm">
                    <div>
                      <span className="text-muted-foreground">Trim:</span>{' '}
                      {selectedVehicle.trim_level || 'N/A'}
                    </div>
                    <div>
                      <span className="text-muted-foreground">Type:</span>{' '}
                      {selectedVehicle.vehicle_type}
                    </div>
                    <div>
                      <span className="text-muted-foreground">Range:</span>{' '}
                      {selectedVehicle.range_km || 'N/A'} km
                    </div>
                    <div>
                      <span className="text-muted-foreground">Battery:</span>{' '}
                      {selectedVehicle.battery_kwh || 'N/A'} kWh
                    </div>
                    <div>
                      <span className="text-muted-foreground">GCC Spec:</span>{' '}
                      {selectedVehicle.gcc_spec ? 'Yes' : 'No'}
                    </div>
                    <div>
                      <span className="text-muted-foreground">Chinese Spec:</span>{' '}
                      {selectedVehicle.chinese_spec ? 'Yes' : 'No'}
                    </div>
                  </div>
                </div>

                <div>
                  <h4 className="font-semibold mb-2">Pricing</h4>
                  <div className="space-y-1 text-sm">
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Price:</span>
                      <span className="font-medium">{formatPrice(selectedVehicle.price)}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Manufacturer Direct:</span>
                      <span className="font-medium">{formatPrice(selectedVehicle.manufacturer_direct_price)}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Grey Market:</span>
                      <span className="font-medium">{formatPrice(selectedVehicle.grey_market_price)}</span>
                    </div>
                  </div>
                </div>

                {selectedVehicle.description && (
                  <div>
                    <h4 className="font-semibold mb-2">Description</h4>
                    <p className="text-sm text-muted-foreground">{selectedVehicle.description}</p>
                  </div>
                )}

                {selectedVehicle.specs && (
                  <div>
                    <h4 className="font-semibold mb-2">Full Specs</h4>
                    <pre className="text-xs bg-muted p-3 rounded-lg overflow-auto max-h-40">
                      {JSON.stringify(selectedVehicle.specs, null, 2)}
                    </pre>
                  </div>
                )}

                <div className="flex gap-2 pt-4 border-t">
                  <Button
                    variant="default"
                    onClick={() => {
                      updateStatus(selectedVehicle.id, 'approved')
                      setSelectedVehicle(null)
                    }}
                    className="flex-1"
                  >
                    Approve
                  </Button>
                  <Button
                    variant="destructive"
                    onClick={() => {
                      updateStatus(selectedVehicle.id, 'rejected')
                      setSelectedVehicle(null)
                    }}
                    className="flex-1"
                  >
                    Reject
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </div>
    </div>
  )
}
