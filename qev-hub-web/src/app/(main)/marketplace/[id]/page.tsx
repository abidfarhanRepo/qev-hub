'use client'

import { useEffect, useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import {
  BatteryIcon,
  CarIcon,
  ShieldIcon,
  CheckIcon,
  ClockIcon,
  TruckIcon,
  MapPinIcon,
} from '@/components/icons'

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
  manufacturer_id: string | null
  warranty_years: number | null
  warranty_km: number | null
  image_url: string | null
  description: string
  specs: Record<string, string>
  stock_count: number
  status: string
}

export default function VehicleDetailPage() {
  const params = useParams()
  const router = useRouter()
  const vehicleId = params.id as string
  const [vehicle, setVehicle] = useState<Vehicle | null>(null)
  const [loading, setLoading] = useState(true)
  const [imageError, setImageError] = useState(false)

  useEffect(() => {
    fetchVehicle()
  }, [vehicleId])

  const fetchVehicle = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('vehicles')
        .select('*')
        .eq('id', vehicleId)
        .single()

      if (error) throw error
      setVehicle(data)
    } catch (error) {
      console.error('Error fetching vehicle:', error)
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

  const formatSpec = (key: string, value: string) => {
    const formattedKey = key.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())
    return (
      <div key={key} className="flex justify-between py-2">
        <span className="text-muted-foreground">{formattedKey}</span>
        <span className="font-medium">{value}</span>
      </div>
    )
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-background to-muted/30 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
          <p>Loading vehicle details...</p>
        </div>
      </div>
    )
  }

  if (!vehicle) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-background to-muted/30 flex items-center justify-center">
        <Card className="glass-card tech-border max-w-md">
          <CardContent className="pt-6">
            <div className="text-center">
              <CarIcon className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
              <h2 className="text-xl font-bold mb-2">Vehicle Not Found</h2>
              <p className="text-muted-foreground mb-4">
                The vehicle you're looking for doesn't exist or is no longer available.
              </p>
              <Button onClick={() => router.push('/marketplace')}>
                Back to Marketplace
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    )
  }


  const depositAmount = vehicle.price_qar * 0.2
  const actualSavings = vehicle.price_transparency_enabled && vehicle.broker_market_price
    ? vehicle.broker_market_price - vehicle.manufacturer_direct_price
    : vehicle.price_qar * 0.35
  const savingsPercentage = vehicle.price_transparency_enabled && vehicle.broker_market_price
    ? Math.round((actualSavings / vehicle.broker_market_price) * 100)
    : 35

  return (
    <div className="min-h-screen bg-gradient-to-br from-background to-muted/30 pb-16">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Breadcrumb */}
        <nav className="mb-6 text-sm text-muted-foreground">
          <a href="/marketplace" className="hover:text-primary transition-colors">
            Marketplace
          </a>
          <span className="mx-2">/</span>
          <span className="text-foreground">
            {vehicle.manufacturer} {vehicle.model}
          </span>
        </nav>

        {/* Main Content */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Left Column - Images */}
          <div className="space-y-4">
            {/* Main Image */}
            <Card className="glass-card tech-border overflow-hidden">
              <CardContent className="p-0">
                {vehicle.image_url && !imageError ? (
                  <img
                    src={vehicle.image_url}
                    alt={`${vehicle.manufacturer} ${vehicle.model}`}
                    className="w-full h-96 object-cover"
                    onError={() => setImageError(true)}
                  />
                ) : (
                  <div className="h-96 bg-gradient-to-br from-muted/50 to-muted flex items-center justify-center">
                    <CarIcon className="h-32 w-32 text-muted-foreground/50" />
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Quick Specs */}
            <Card>
              <CardHeader>
                <CardTitle>Quick Specs</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <BatteryIcon className="h-5 w-5 text-primary" />
                    <span className="text-sm">Range</span>
                  </div>
                  <span className="font-semibold">{vehicle.range_km} km</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <BatteryIcon className="h-5 w-5 text-primary" />
                    <span className="text-sm">Battery</span>
                  </div>
                  <span className="font-semibold">{vehicle.battery_kwh} kWh</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <ClockIcon className="h-5 w-5 text-primary" />
                    <span className="text-sm">Year</span>
                  </div>
                  <span className="font-semibold">{vehicle.year}</span>
                </div>
              </CardContent>
            </Card>

            {/* Status */}
            <Card>
              <CardContent className="pt-6">
                <div className="flex items-center gap-3">
                  {vehicle.stock_count > 0 ? (
                    <>
                      <div className="h-10 w-10 rounded-full bg-green-100 flex items-center justify-center">
                        <CheckIcon className="h-5 w-5 text-green-600" />
                      </div>
                      <div>
                        <p className="font-semibold text-green-600">In Stock</p>
                        <p className="text-sm text-muted-foreground">
                          {vehicle.stock_count} units available
                        </p>
                      </div>
                    </>
                  ) : (
                    <>
                      <div className="h-10 w-10 rounded-full bg-red-100 flex items-center justify-center">
                        <ClockIcon className="h-5 w-5 text-red-600" />
                      </div>
                      <div>
                        <p className="font-semibold text-red-600">Out of Stock</p>
                        <p className="text-sm text-muted-foreground">
                          Check back later
                        </p>
                      </div>
                    </>
                  )}
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Right Column - Details & Purchase */}
          <div className="space-y-4">
            {/* Title and Price */}
            <Card>
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <Badge variant="secondary" className="bg-green-600 text-white">
                        ✓ Verified Manufacturer
                      </Badge>
                      <Badge variant="outline">
                        {vehicle.vehicle_type}
                      </Badge>
                      <Badge variant="outline">
                        {vehicle.origin_country}
                      </Badge>
                    </div>
                    <h1 className="text-3xl font-bold mb-2">
                      {vehicle.manufacturer} {vehicle.model}
                    </h1>
                    <p className="text-lg text-muted-foreground">
                      {vehicle.year}
                    </p>
                  </div>
                  {vehicle.stock_count > 0 ? (
                    <Badge variant="secondary">
                      In Stock ({vehicle.stock_count})
                    </Badge>
                  ) : (
                    <Badge variant="destructive">Out of Stock</Badge>
                  )}
                </div>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {vehicle.price_transparency_enabled && vehicle.broker_market_price ? (
                    <div className="space-y-3">
                      <div className="p-4 bg-green-500/10 rounded-lg border-2 border-green-500/30">
                        <div className="flex items-baseline justify-between mb-2">
                          <span className="text-sm font-medium text-muted-foreground">Factory Direct Price</span>
                          <p className="text-4xl font-bold text-green-600">
                            {formatPrice(vehicle.manufacturer_direct_price)}
                          </p>
                        </div>
                        <div className="flex items-baseline justify-between pt-2 border-t border-green-500/20">
                          <span className="text-sm text-muted-foreground">Typical Broker Market Price</span>
                          <p className="text-2xl font-semibold line-through text-muted-foreground">
                            {formatPrice(vehicle.broker_market_price)}
                          </p>
                        </div>
                      </div>
                      
                      <div className="bg-gradient-to-r from-green-50 to-emerald-50 border border-green-200 rounded-lg p-4">
                        <div className="flex items-center gap-3">
                          <div className="h-12 w-12 rounded-full bg-green-600 flex items-center justify-center">
                            <ShieldIcon className="h-6 w-6 text-white" />
                          </div>
                          <div className="flex-1">
                            <p className="text-lg font-bold text-green-800">
                              Save {formatPrice(actualSavings)} ({savingsPercentage}%)
                            </p>
                            <p className="text-sm text-green-700">
                              By purchasing directly from the manufacturer
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>
                  ) : (
                    <div className="flex items-baseline gap-3">
                      <p className="text-4xl font-bold text-primary">
                        {formatPrice(vehicle.price_qar)}
                      </p>
                      <span className="text-sm text-muted-foreground">Direct Price</span>
                    </div>
                  )}

                  <Separator />

                  {/* Deposit Info */}
                  <div>
                    <p className="text-sm text-muted-foreground mb-1">
                      Deposit Required (20%)
                    </p>
                    <p className="text-2xl font-semibold">
                      {formatPrice(depositAmount)}
                    </p>
                    <p className="text-xs text-muted-foreground mt-1">
                      Remaining balance due on delivery
                    </p>
                  </div>

                  {/* Purchase Button */}
                  <Button
                    className="w-full h-14 text-lg"
                    disabled={vehicle.stock_count === 0}
                    onClick={() =>
                      router.push(`/orders?vehicle_id=${vehicle.id}`)
                    }
                  >
                    {vehicle.stock_count > 0
                      ? 'Purchase Now'
                      : 'Out of Stock'}
                  </Button>

                  {/* Additional Info */}
                  <div className="text-xs text-muted-foreground space-y-1 pt-2">
                    <div className="flex items-center gap-2">
                      <CheckIcon className="h-3 w-3 text-primary" />
                      <span>Free delivery to Hamad Port, Qatar</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckIcon className="h-3 w-3 text-primary" />
                      <span>Customs clearance included</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckIcon className="h-3 w-3 text-primary" />
                      <span>
                        {vehicle.warranty_years || 5}-year / {(vehicle.warranty_km || 100000).toLocaleString()}km manufacturer warranty
                      </span>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Description */}
            <Card>
              <CardHeader>
                <CardTitle>Description</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-muted-foreground leading-relaxed">
                  {vehicle.description}
                </p>
              </CardContent>
            </Card>

            {/* Detailed Specs */}
            {vehicle.specs && Object.keys(vehicle.specs).length > 0 && (
              <Card>
                <CardHeader>
                  <CardTitle>Technical Specifications</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="divide-y">
                    {Object.entries(vehicle.specs).map(([key, value]) =>
                      formatSpec(key, value)
                    )}
                  </div>
                </CardContent>
              </Card>
            )}

            {/* Delivery Information */}
            <Card>
              <CardHeader>
                <CardTitle>Delivery Information</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-start gap-3">
                  <MapPinIcon className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="font-medium">Pickup Location</p>
                    <p className="text-sm text-muted-foreground">
                      Manufacturer Facility
                    </p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <TruckIcon className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="font-medium">Delivery Destination</p>
                    <p className="text-sm text-muted-foreground">
                      Hamad Port, Qatar
                    </p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <ClockIcon className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="font-medium">Estimated Delivery</p>
                    <p className="text-sm text-muted-foreground">
                      4-6 weeks from order confirmation
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Back Button */}
            <Button
              variant="outline"
              className="w-full"
              onClick={() => router.push('/marketplace')}
            >
              Back to Marketplace
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
