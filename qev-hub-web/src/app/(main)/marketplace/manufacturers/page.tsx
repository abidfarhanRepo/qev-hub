'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { useRouter } from 'next/navigation'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { CheckIcon, MapPinIcon, CarIcon } from '@/components/icons'

interface Manufacturer {
  id: string
  company_name: string
  company_name_ar: string | null
  logo_url: string | null
  country: string
  city: string | null
  region: string | null
  description: string | null
  verification_status: string
  verified_at: string | null
  vehicle_count?: number
}

export default function ManufacturersPage() {
  const router = useRouter()
  const [manufacturers, setManufacturers] = useState<Manufacturer[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState<'all' | 'China' | 'Europe' | 'USA'>('all')

  useEffect(() => {
    fetchManufacturers()
  }, [])

  const fetchManufacturers = async () => {
    try {
      setLoading(true)
      
      // Fetch verified manufacturers
      const { data: manufacturersData, error: manufacturersError } = await supabase
        .from('manufacturers')
        .select('*')
        .eq('verification_status', 'verified')
        .order('company_name', { ascending: true })

      if (manufacturersError) throw manufacturersError

      // Fetch vehicle counts for each manufacturer
      if (manufacturersData) {
        const manufacturersWithCounts = await Promise.all(
          manufacturersData.map(async (manufacturer) => {
            const { count, error: countError } = await supabase
              .from('vehicles')
              .select('*', { count: 'exact', head: true })
              .eq('manufacturer_id', manufacturer.id)
              .eq('status', 'available')

            if (countError) console.error('Error counting vehicles:', countError)

            return {
              ...manufacturer,
              vehicle_count: count || 0,
            }
          })
        )
        setManufacturers(manufacturersWithCounts)
      }
    } catch (error) {
      console.error('Error fetching manufacturers:', error)
    } finally {
      setLoading(false)
    }
  }

  const filteredManufacturers = manufacturers.filter((manufacturer) => {
    if (filter === 'all') return true
    return manufacturer.country === filter
  })

  const handleViewVehicles = (manufacturerId: string, manufacturerName: string) => {
    router.push(`/marketplace?manufacturer=${manufacturerId}`)
  }

  return (
    <div className="min-h-screen bg-background relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 relative z-10">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center gap-2 mb-2">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => router.push('/marketplace')}
              className="text-muted-foreground hover:text-primary"
            >
              ← Back to Marketplace
            </Button>
          </div>
          <h1 className="text-4xl font-black uppercase tracking-widest text-foreground mb-2">
            Verified <span className="text-primary">Manufacturers</span>
          </h1>
          <p className="text-muted-foreground">
            Browse international EV and PHEV manufacturers verified for direct sales
          </p>
        </div>

        {/* Country Filters */}
        <div className="mb-8 flex gap-3 flex-wrap">
          <button
            onClick={() => setFilter('all')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'all'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">All ({manufacturers.length})</span>
          </button>
          <button
            onClick={() => setFilter('China')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'China'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">China</span>
          </button>
          <button
            onClick={() => setFilter('Europe')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'Europe'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">Europe</span>
          </button>
          <button
            onClick={() => setFilter('USA')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'USA'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">USA</span>
          </button>
        </div>

        {/* Manufacturers Grid */}
        {loading ? (
          <div className="flex justify-center items-center py-20">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
          </div>
        ) : filteredManufacturers.length === 0 ? (
          <div className="text-center py-20">
            <p className="text-muted-foreground">No verified manufacturers found</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredManufacturers.map((manufacturer) => (
              <Card
                key={manufacturer.id}
                className="bg-card/50 border-border backdrop-blur-md overflow-hidden hover:border-primary transition-all hover:-translate-y-1 cursor-pointer group rounded-xl shadow-2xl"
                onClick={() => handleViewVehicles(manufacturer.id, manufacturer.company_name)}
              >
                <CardHeader className="pb-3">
                  <div className="flex items-start justify-between mb-2">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <Badge variant="secondary" className="bg-green-600 text-white">
                          <CheckIcon className="h-3 w-3 mr-1" />
                          Verified
                        </Badge>
                      </div>
                      <CardTitle className="text-2xl group-hover:text-primary transition-colors">
                        {manufacturer.company_name}
                      </CardTitle>
                      {manufacturer.company_name_ar && (
                        <p className="text-sm text-muted-foreground mt-1" dir="rtl">
                          {manufacturer.company_name_ar}
                        </p>
                      )}
                    </div>
                  </div>
                </CardHeader>

                <CardContent>
                  {/* Location */}
                  <div className="flex items-center gap-2 text-sm text-muted-foreground mb-3">
                    <MapPinIcon className="h-4 w-4 text-primary" />
                    <span>
                      {manufacturer.city && `${manufacturer.city}, `}
                      {manufacturer.country}
                    </span>
                  </div>

                  {/* Description */}
                  {manufacturer.description && (
                    <p className="text-sm text-muted-foreground mb-4 line-clamp-2">
                      {manufacturer.description}
                    </p>
                  )}

                  {/* Vehicle Count */}
                  <div className="flex items-center justify-between pt-3 border-t border-border">
                    <div className="flex items-center gap-2 text-sm">
                      <CarIcon className="h-4 w-4 text-primary" />
                      <span className="font-semibold text-foreground">
                        {manufacturer.vehicle_count || 0} {manufacturer.vehicle_count === 1 ? 'Vehicle' : 'Vehicles'}
                      </span>
                    </div>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={(e) => {
                        e.stopPropagation()
                        handleViewVehicles(manufacturer.id, manufacturer.company_name)
                      }}
                      className="text-primary hover:text-primary hover:bg-primary/10"
                    >
                      View Catalog →
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
