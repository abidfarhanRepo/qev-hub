'use client'

import { motion } from 'framer-motion'
import { useRef, useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { CarIcon, BatteryIcon } from '@/components/icons'

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

export default function VehicleCarousel() {
  const router = useRouter()
  const [vehicles, setVehicles] = useState<Vehicle[]>([])
  const [loading, setLoading] = useState(true)
  const [width, setWidth] = useState(0)
  const carousel = useRef<HTMLDivElement>(null)

  useEffect(() => {
    fetchVehicles()
  }, [])

  // Recalculate width after vehicles load and on resize
  useEffect(() => {
    const calculateWidth = () => {
      if (carousel.current && vehicles.length > 0) {
        // Use requestAnimationFrame to ensure DOM is updated
        requestAnimationFrame(() => {
          if (carousel.current) {
            setWidth(carousel.current.scrollWidth - carousel.current.offsetWidth)
          }
        })
      }
    }

    calculateWidth()

    // Recalculate on resize
    const resizeObserver = new ResizeObserver(calculateWidth)
    if (carousel.current) {
      resizeObserver.observe(carousel.current)
    }

    return () => resizeObserver.disconnect()
  }, [vehicles, loading])

  const fetchVehicles = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('vehicles')
        .select('*')
        .eq('status', 'approved')
        .order('manufacturer', { ascending: true })
        .limit(6)

      if (error) throw error
      setVehicles(data || [])
    } catch (error) {
      console.error('Error fetching vehicles:', error)
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

  return (
    <section className="py-24 bg-background overflow-hidden relative">
       {/* Background Grid */}
       <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-20 pointer-events-none"></div>

      <div className="container px-4 md:px-6 mb-12 relative z-10">
        <motion.h2 
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          className="text-3xl md:text-5xl font-bold text-foreground uppercase tracking-wider"
        >
          Featured <span className="text-primary">Models</span>
        </motion.h2>
      </div>

      {loading ? (
        <div className="flex justify-center items-center py-20 px-4 md:px-6">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
        </div>
      ) : vehicles.length === 0 ? (
        <div className="text-center py-20 px-4 md:px-6">
          <p className="text-muted-foreground">No vehicles available</p>
        </div>
      ) : (
        <motion.div ref={carousel} className="cursor-grab active:cursor-grabbing overflow-hidden px-4 md:px-6 relative z-10">
          <motion.div
            drag="x"
            dragConstraints={{ right: 0, left: -width }}
            className="flex gap-8"
          >
            {vehicles.map((vehicle) => (
              <motion.div
                key={vehicle.id}
                className="min-w-[300px] md:min-w-[400px] h-[520px] relative"
              >
                <Card
                  className="bg-card/50 border-border backdrop-blur-md overflow-hidden hover:border-primary transition-all hover:-translate-y-1 cursor-pointer group rounded-2xl shadow-2xl h-full"
                  onClick={() => router.push(`/marketplace/${vehicle.id}`)}
                >
                  <div className="h-56 bg-gradient-to-br from-black/40 to-black/60 flex items-center justify-center relative overflow-hidden">
                    {vehicle.image_url ? (
                      <img
                        src={vehicle.image_url}
                        alt={`${vehicle.manufacturer} ${vehicle.model}`}
                        className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                      />
                    ) : (
                      <CarIcon className="h-20 w-20 text-muted-foreground/50 group-hover:text-primary transition-colors" />
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
                          {vehicle.stock_count}
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

                    {vehicle.price_transparency_enabled && vehicle.broker_market_price ? (
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
                            Save {formatPrice(vehicle.broker_market_price - vehicle.manufacturer_direct_price)}
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
              </motion.div>
            ))}
          </motion.div>
        </motion.div>
      )}
    </section>
  )
}
