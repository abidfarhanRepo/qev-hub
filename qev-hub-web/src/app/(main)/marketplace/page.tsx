'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { useRouter } from 'next/navigation'
import { Card, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { CarIcon, BatteryIcon, CheckIcon, ClockIcon } from '@/components/icons'

interface Vehicle {
  id: string
  manufacturer: string
  model: string
  year: number
  range_km: number
  battery_kwh: number
  price_qar: number
  image_url: string | null
  description: string
  specs: Record<string, string>
  stock_count: number
  status: string
}

export default function MarketplacePage() {
  const router = useRouter()
  const [vehicles, setVehicles] = useState<Vehicle[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState<'all' | 'tesla' | 'byd'>('all')

  useEffect(() => {
    fetchVehicles()
  }, [])

  const fetchVehicles = async () => {
    try {
      setLoading(true)
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
      setLoading(false)
    }
  }

  const filteredVehicles = vehicles.filter((vehicle) => {
    if (filter === 'tesla') return vehicle.manufacturer.toLowerCase() === 'tesla'
    if (filter === 'byd') return vehicle.manufacturer.toLowerCase() === 'byd'
    return true
  })

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR'
    }).format(price)
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            EV Marketplace
          </h1>
          <p className="text-gray-600">
            Browse and purchase electric vehicles directly from manufacturers
          </p>
        </div>

        {/* Filters */}
        <div className="mb-8 flex gap-4 flex-wrap">
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'all'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            All Vehicles ({vehicles.length})
          </button>
          <button
            onClick={() => setFilter('tesla')}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'tesla'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            Tesla
          </button>
          <button
            onClick={() => setFilter('byd')}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'byd'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            BYD
          </button>
        </div>

        {loading ? (
          <div className="flex justify-center items-center py-20">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
          </div>
        ) : filteredVehicles.length === 0 ? (
          <div className="text-center py-20">
            <p className="text-gray-600">No vehicles available</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredVehicles.map((vehicle) => (
              <Card
                key={vehicle.id}
                className="overflow-hidden hover:shadow-lg transition cursor-pointer"
                onClick={() => router.push(`/marketplace/${vehicle.id}`)}
              >
                {/* Vehicle Image */}
                <div className="h-48 bg-gradient-to-br from-gray-100 to-gray-200 flex items-center justify-center">
                  {vehicle.image_url ? (
                    <img
                      src={vehicle.image_url}
                      alt={`${vehicle.manufacturer} ${vehicle.model}`}
                      className="h-full w-full object-cover"
                    />
                  ) : (
                    <CarIcon className="h-16 w-16 text-gray-400" />
                  )}
                </div>

                {/* Vehicle Details */}
                <CardContent className="p-6">
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h3 className="text-xl font-bold text-gray-900">
                        {vehicle.manufacturer} {vehicle.model}
                      </h3>
                      <p className="text-sm text-gray-500">{vehicle.year}</p>
                    </div>
                    {vehicle.stock_count > 0 ? (
                      <Badge variant="secondary">
                        In Stock ({vehicle.stock_count})
                      </Badge>
                    ) : (
                      <Badge variant="destructive">Out of Stock</Badge>
                    )}
                  </div>

                  <p className="text-gray-600 text-sm mb-4 line-clamp-2">
                    {vehicle.description}
                  </p>

                  {/* Specs */}
                  <div className="grid grid-cols-2 gap-2 mb-4">
                    <div className="bg-muted p-2 rounded">
                      <div className="flex items-center gap-1 mb-1">
                        <BatteryIcon className="h-3 w-3 text-muted-foreground" />
                        <p className="text-xs text-muted-foreground">Range</p>
                      </div>
                      <p className="text-sm font-medium text-gray-900">
                        {vehicle.range_km} km
                      </p>
                    </div>
                    <div className="bg-muted p-2 rounded">
                      <div className="flex items-center gap-1 mb-1">
                        <BatteryIcon className="h-3 w-3 text-muted-foreground" />
                        <p className="text-xs text-muted-foreground">Battery</p>
                      </div>
                      <p className="text-sm font-medium text-gray-900">
                        {vehicle.battery_kwh} kWh
                      </p>
                    </div>
                  </div>

                  {/* Price and CTA */}
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-2xl font-bold text-primary">
                        {formatPrice(vehicle.price_qar)}
                      </p>
                      <p className="text-xs text-gray-500">Direct from manufacturer</p>
                    </div>
                    <Button
                      size="sm"
                      onClick={(e) => {
                        e.stopPropagation()
                        router.push(`/marketplace/${vehicle.id}`)
                      }}
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
    </div>
  )
}
