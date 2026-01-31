'use client'

import { motion } from 'framer-motion'
import { useRef, useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { CarIcon, BatteryIcon, ArrowRight } from 'lucide-react'

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
          transition={{ duration: 0.6 }}
          className="text-3xl md:text-5xl font-bold text-foreground uppercase tracking-wider mb-4 text-center"
        >
          Premium <span className="text-primary">Selection</span>
        </motion.h2>
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="h-1 w-24 bg-primary mx-auto rounded-full shadow-lg"
        />
      </div>

      {loading ? (
        <div className="container px-4 md:px-6 relative z-10">
          <div className="flex gap-6 overflow-x-auto pb-8">
            {[1, 2, 3].map((i) => (
              <div key={i} className="min-w-[300px] md:min-w-[350px] h-[400px] bg-muted/30 rounded-2xl animate-pulse" />
            ))}
          </div>
        </div>
      ) : (
        <div className="relative">
          {/* Scroll Buttons */}
          {width > 0 && (
            <>
              <button
                onClick={() => carousel.current?.scrollBy({ left: -300, behavior: 'smooth' })}
                className="absolute left-0 top-1/2 -translate-y-1/2 z-20 w-12 h-12 bg-background border border-border rounded-full shadow-lg flex items-center justify-center hover:bg-primary hover:text-primary-foreground hover:border-primary transition-all ml-4"
                aria-label="Scroll left"
              >
                ←
              </button>
              <button
                onClick={() => carousel.current?.scrollBy({ left: 300, behavior: 'smooth' })}
                className="absolute right-0 top-1/2 -translate-y-1/2 z-20 w-12 h-12 bg-background border border-border rounded-full shadow-lg flex items-center justify-center hover:bg-primary hover:text-primary-foreground hover:border-primary transition-all mr-4"
                aria-label="Scroll right"
              >
                →
              </button>
            </>
          )}

          <motion.div
            ref={carousel}
            className="flex gap-6 overflow-x-auto pb-8 px-4 scroll-smooth"
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
          >
            {vehicles.map((vehicle, index) => (
              <motion.div
                key={vehicle.id}
                initial={{ opacity: 0, y: 50 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
                className="min-w-[300px] md:min-w-[350px] flex-shrink-0"
              >
                <Card className="group hover:shadow-2xl transition-all duration-300 border border-border bg-card hover:border-primary/50">
                  <CardContent className="p-6">
                    {/* Vehicle Image/Icon */}
                    <div className="h-48 bg-gradient-to-br from-primary/20 to-primary/5 rounded-lg mb-4 flex items-center justify-center group-hover:from-primary group-hover:to-primary transition-all duration-500">
                      <CarIcon className="w-20 h-20 text-primary group-hover:text-primary-foreground" />
                    </div>

                    {/* Vehicle Info */}
                    <div className="space-y-3">
                      <div className="flex justify-between items-start">
                        <div>
                          <h3 className="text-xl font-bold text-foreground">{vehicle.manufacturer}</h3>
                          <p className="text-lg font-semibold text-primary">{vehicle.model}</p>
                        </div>
                        <Badge variant={vehicle.vehicle_type === 'EV' ? 'default' : 'secondary'}>
                          {vehicle.vehicle_type}
                        </Badge>
                      </div>

                      <div className="grid grid-cols-2 gap-3 text-sm">
                        <div className="flex items-center gap-1 text-foreground/70">
                          <BatteryIcon className="w-4 h-4 text-primary" />
                          <span>{vehicle.battery_kwh} kWh</span>
                        </div>
                        <div className="text-foreground/70">
                          {vehicle.range_km} km
                        </div>
                      </div>

                      <div className="pt-3 border-t border-border">
                        <p className="text-2xl font-bold text-primary mb-1">{formatPrice(vehicle.price_qar)}</p>
                        <p className="text-xs text-muted-foreground">Starting price</p>
                      </div>

                      <Button
                        onClick={() => router.push(`/marketplace/${vehicle.id}`)}
                        className="w-full group mt-4"
                      >
                        View Details
                        <ArrowRight className="ml-2 h-4 w-4 group-hover:translate-x-1 transition-transform" />
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              </motion.div>
            ))}
          </motion.div>
        </div>
      )}

      {/* View All Button */}
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6 }}
        className="text-center mt-8 relative z-10 px-4"
      >
        <Button
          size="lg"
          variant="outline"
          className="rounded-full px-8 py-6"
          onClick={() => router.push('/marketplace')}
        >
          View All Vehicles
          <ArrowRight className="ml-2 h-5 w-5" />
        </Button>
      </motion.div>
    </section>
  )
}
