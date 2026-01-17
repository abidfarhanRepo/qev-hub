'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { useRouter } from 'next/navigation'
import { Card, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { CarIcon, BatteryIcon, CheckIcon, ClockIcon } from '@/components/icons'
import { SavingsBadge } from '@/components/SavingsBadge'

interface Vehicle {
  id: string
  manufacturer: string
  model: string
  year: number
  range_km: number
  battery_kwh: number
  price_qar: number
  manufacturer_direct_price: number
  broker_market_price: number | null
  price_transparency_enabled: boolean
  vehicle_type: 'EV' | 'PHEV' | 'FCEV'
  origin_country: string
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
  const [filter, setFilter] = useState<'all' | 'EV' | 'PHEV' | 'FCEV'>('all')

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
    if (filter === 'all') return true
    return vehicle.vehicle_type === filter
  })

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR'
    }).format(price)
  }

  return (
    <div className="min-h-screen bg-background relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 relative z-10">
        <div className="mb-8">
          <h1 className="text-4xl font-black uppercase tracking-widest text-foreground mb-2">
            EV <span className="text-primary">Marketplace</span>
          </h1>
          <p className="text-muted-foreground">
            Browse and purchase electric vehicles directly from manufacturers
          </p>
          <div className="mt-3">
            <Button
              variant="outline"
              size="sm"
              onClick={() => router.push('/marketplace/manufacturers')}
              className="text-primary border-primary hover:bg-primary/10"
            >
              View All Verified Manufacturers →
            </Button>
          </div>
        </div>

        <div className="mb-8 flex gap-3 flex-wrap">
          <button
            onClick={() => setFilter('all')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'all'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">All Vehicles ({vehicles.length})</span>
          </button>
          <button
            onClick={() => setFilter('EV')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'EV'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">Electric (EV)</span>
          </button>
          <button
            onClick={() => setFilter('PHEV')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'PHEV'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">Plug-in Hybrid (PHEV)</span>
          </button>
          <button
            onClick={() => setFilter('FCEV')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'FCEV'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">Fuel Cell (FCEV)</span>
          </button>
        </div>

        {loading ? (
          <div className="flex justify-center items-center py-20">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
          </div>
        ) : filteredVehicles.length === 0 ? (
          <div className="text-center py-20">
            <p className="text-muted-foreground">No vehicles available</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredVehicles.map((vehicle) => (
              <Card
                key={vehicle.id}
                className="bg-card/50 border-border backdrop-blur-md overflow-hidden hover:border-primary transition-all hover:-translate-y-1 cursor-pointer group rounded-xl shadow-2xl"
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

                  {vehicle.price_transparency_enabled && vehicle.broker_market_price && vehicle.manufacturer_direct_price ? (
                    <div className="mb-4">
                      <SavingsBadge
                        manufacturerPrice={vehicle.manufacturer_direct_price}
                        greyMarketPrice={vehicle.broker_market_price}
                        size="md"
                      />
                    </div>
                  ) : vehicle.price_transparency_enabled && vehicle.broker_market_price ? (
                    <div className="mb-4 p-3 bg-green-500/10 rounded-lg border border-green-500/30">
                      <div className="flex justify-between items-center mb-1">
                        <span className="text-xs text-muted-foreground">Factory Direct:</span>
                        <span className="text-lg font-bold text-green-600">
                          {formatPrice(vehicle.manufacturer_direct_price)}
                        </span>
                      </div>
                      <div className="flex justify-between items-center mb-1">
                        <span className="text-xs text-muted-foreground">Broker Market:</span>
                        <span className="text-sm line-through text-muted-foreground">
                          {formatPrice(vehicle.broker_market_price)}
                        </span>
                      </div>
                      <div className="pt-1 border-t border-green-500/20 mt-1">
                        <span className="text-xs font-semibold text-green-600">
                          Save {formatPrice(vehicle.broker_market_price - vehicle.manufacturer_direct_price)} ({Math.round(((vehicle.broker_market_price - vehicle.manufacturer_direct_price) / vehicle.broker_market_price) * 100)}%)
                        </span>
                      </div>
                    </div>
                  ) : (
                    <div className="mb-4">
                      <p className="text-2xl font-bold text-primary">
                        {formatPrice(vehicle.price_qar)}
                      </p>
                      <p className="text-xs text-muted-foreground">Direct from manufacturer</p>
                    </div>
                  )}

                  <div className="flex items-center justify-between">
                    <Badge variant="outline" className="text-xs">
                      {vehicle.vehicle_type} · {vehicle.origin_country}
                    </Badge>
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
    </div>
  )
}
