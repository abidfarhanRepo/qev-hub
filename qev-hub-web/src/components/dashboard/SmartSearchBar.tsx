'use client'

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Search, SlidersHorizontal, X, ChevronDown } from 'lucide-react'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { CarIcon, BatteryIcon, ClockIcon, ShipIcon } from '@/components/icons'

interface Vehicle {
  id: string
  manufacturer_id: string
  manufacturer: string
  model: string
  year: number
  range_km: number
  charging_time_min: number
  price_qar: number
  manufacturer_direct_price: number
  broker_market_price: number
  price_transparency_enabled: boolean
  vehicle_type: 'EV' | 'PHEV' | 'FCEV'
  arrival_weeks: number
  image_url: string
}

interface SmartSearchBarProps {
  onVehicleSelect: (vehicle: Vehicle | null) => void
  selectedVehicle: Vehicle | null
}

const MOCK_VEHICLES: Vehicle[] = [
  {
    id: '1',
    manufacturer_id: 'mock-manufact-1',
    manufacturer: 'BYD Auto Co Ltd',
    model: 'Atto 3',
    year: 2024,
    range_km: 420,
    charging_time_min: 60,
    price_qar: 145000,
    manufacturer_direct_price: 145000,
    broker_market_price: 188500,
    price_transparency_enabled: true,
    vehicle_type: 'EV',
    origin_country: 'China',
    arrival_weeks: 4,
  },
  {
    id: '2',
    manufacturer_id: 'mock-manufact-2',
    manufacturer: 'GAC AION',
    model: 'AION Y Plus',
    year: 2024,
    range_km: 450,
    charging_time_min: 50,
    price_qar: 135000,
    manufacturer_direct_price: 135000,
    broker_market_price: 175500,
    price_transparency_enabled: true,
    vehicle_type: 'PHEV',
    origin_country: 'China',
    arrival_weeks: 6,
  },
  {
    id: '3',
    manufacturer_id: 'mock-manufact-3',
    manufacturer: 'NIO',
    model: 'ES8',
    year: 2024,
    range_km: 500,
    charging_time_min: 40,
    price_qar: 210000,
    manufacturer_direct_price: 210000,
    broker_market_price: 273000,
    price_transparency_enabled: true,
    vehicle_type: 'EV',
    origin_country: 'China',
    arrival_weeks: 8,
  },
  {
    id: '4',
    manufacturer_id: 'mock-manufact-4',
    manufacturer: 'XPeng',
    model: 'P7i',
    year: 2024,
    range_km: 450,
    charging_time_min: 35,
    price_qar: 165000,
    manufacturer_direct_price: 165000,
    broker_market_price: 214500,
    price_transparency_enabled: true,
    vehicle_type: 'EV',
    origin_country: 'China',
    arrival_weeks: 10,
  },
  {
    id: '5',
    manufacturer_id: 'mock-manufact-5',
    manufacturer: 'BYD Auto Co Ltd',
    model: 'Han Plus',
    year: 2024,
    range_km: 1200,
    charging_time_min: 0,
    price_qar: 115000,
    manufacturer_direct_price: 115000,
    broker_market_price: 149500,
    price_transparency_enabled: true,
    vehicle_type: 'PHEV',
    origin_country: 'China',
    arrival_weeks: 6,
  },
  {
    id: '6',
    manufacturer_id: 'mock-manufact-2',
    manufacturer: 'GAC AION',
    model: 'AION S Plus',
    year: 2024,
    range_km: 480,
    charging_time_min: 45,
    price_qar: 155000,
    manufacturer_direct_price: 155000,
    broker_market_price: 201500,
    price_transparency_enabled: true,
    vehicle_type: 'EV',
    origin_country: 'China',
    arrival_weeks: 8,
  },
]

export function SmartSearchBar({ onVehicleSelect, selectedVehicle }: SmartSearchBarProps) {
  const [searchTerm, setSearchTerm] = useState('')
  const [showFilters, setShowFilters] = useState(false)
  const [filters, setFilters] = useState({
    minRange: 0,
    maxRange: 600,
    maxChargingTime: 90,
    maxPrice: 500000,
    maxArrivalTime: 15,
  })
  const [filteredVehicles, setFilteredVehicles] = useState<Vehicle[]>(MOCK_VEHICLES)
  const [showResults, setShowResults] = useState(false)

  const applyFilters = () => {
    let filtered = MOCK_VEHICLES.filter((vehicle) => {
      const matchesSearch =
        vehicle.manufacturer.toLowerCase().includes(searchTerm.toLowerCase()) ||
        vehicle.model.toLowerCase().includes(searchTerm.toLowerCase())

      const matchesRange =
        vehicle.range_km >= filters.minRange && vehicle.range_km <= filters.maxRange
      const matchesCharging = vehicle.charging_time_min <= filters.maxChargingTime
      const matchesPrice = vehicle.price_qar <= filters.maxPrice
      const matchesArrival = vehicle.arrival_weeks <= filters.maxArrivalTime

      return matchesSearch && matchesRange && matchesCharging && matchesPrice && matchesArrival
    })

    setFilteredVehicles(filtered)
    setShowResults(true)
  }

  const handleVehicleClick = (vehicle: Vehicle) => {
    onVehicleSelect(vehicle)
    setShowResults(false)
  }

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR',
      maximumFractionDigits: 0,
    }).format(price)
  }

  return (
    <div className="relative z-20">
      {/* Search Bar */}
      <Card className="glass-card border-2 border-primary/30 overflow-hidden">
        <CardContent className="p-0">
          <div className="flex items-center gap-4 p-4">
            <Search className="h-5 w-5 text-muted-foreground" />
            <input
              type="text"
              placeholder="Search vehicles by make or model..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="flex-1 bg-transparent border-none outline-none text-foreground placeholder:text-muted-foreground"
              onFocus={() => setShowResults(true)}
            />
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setShowFilters(!showFilters)}
              className={`transition-colors ${showFilters ? 'bg-primary/10 text-primary' : ''}`}
            >
              <SlidersHorizontal className="h-4 w-4" />
            </Button>
            {searchTerm && (
              <Button
                variant="ghost"
                size="sm"
                onClick={() => {
                  setSearchTerm('')
                  setShowResults(false)
                }}
              >
                <X className="h-4 w-4" />
              </Button>
            )}
            <Button
              onClick={applyFilters}
              className="bg-primary text-primary-foreground hover:bg-primary/90"
            >
              Search
            </Button>
          </div>

          {/* Advanced Filters */}
          <AnimatePresence>
            {showFilters && (
              <motion.div
                initial={{ height: 0, opacity: 0 }}
                animate={{ height: 'auto', opacity: 1 }}
                exit={{ height: 0, opacity: 0 }}
                transition={{ duration: 0.3 }}
                className="border-t border-border/50"
              >
                <div className="p-6 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6">
                  {/* Vehicle Type Filter */}
                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-foreground mb-3">
                      <CarIcon className="h-4 w-4 text-primary" />
                      Vehicle Type
                    </label>
                    <div className="grid grid-cols-3 gap-2">
                      <button
                        onClick={() => setFilters({ ...filters, vehicleType: 'all' })}
                        className={`px-3 py-2 rounded-lg text-xs font-semibold transition-all ${
                          filters.vehicleType === 'all'
                            ? 'bg-primary text-primary-foreground'
                            : 'bg-muted/50 text-foreground hover:bg-muted'
                        }`}
                      >
                        All
                      </button>
                      <button
                        onClick={() => setFilters({ ...filters, vehicleType: 'ev' })}
                        className={`px-3 py-2 rounded-lg text-xs font-semibold transition-all ${
                          filters.vehicleType === 'ev'
                            ? 'bg-primary text-primary-foreground'
                            : 'bg-muted/50 text-foreground hover:bg-muted'
                        }`}
                      >
                        EV
                      </button>
                      <button
                        onClick={() => setFilters({ ...filters, vehicleType: 'phev' })}
                        className={`px-3 py-2 rounded-lg text-xs font-semibold transition-all ${
                          filters.vehicleType === 'phev'
                            ? 'bg-primary text-primary-foreground'
                            : 'bg-muted/50 text-foreground hover:bg-muted'
                        }`}
                      >
                        PHEV
                      </button>
                    </div>
                  </div>

                  {/* Range Filter */}
                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-foreground mb-3">
                      <BatteryIcon className="h-4 w-4 text-primary" />
                      Range (km)
                    </label>
                    <div className="flex items-center gap-3">
                      <input
                        type="range"
                        min="0"
                        max="600"
                        value={filters.maxRange}
                        onChange={(e) => setFilters({ ...filters, maxRange: Number(e.target.value) })}
                        className="flex-1"
                      />
                      <span className="text-sm font-semibold text-primary w-16 text-right">
                        {filters.maxRange}
                      </span>
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">Max range: {filters.maxRange} km</p>
                  </div>

                  {/* Charging Time Filter */}
                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-foreground mb-3">
                      <ClockIcon className="h-4 w-4 text-primary" />
                      Charging Time
                    </label>
                    <div className="flex items-center gap-3">
                      <input
                        type="range"
                        min="15"
                        max="90"
                        value={filters.maxChargingTime}
                        onChange={(e) => setFilters({ ...filters, maxChargingTime: Number(e.target.value) })}
                        className="flex-1"
                      />
                      <span className="text-sm font-semibold text-primary w-16 text-right">
                        {filters.maxChargingTime}
                      </span>
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">Max: {filters.maxChargingTime} min</p>
                  </div>

                  {/* Price Filter */}
                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-foreground mb-3">
                      <span className="h-4 w-4 text-primary font-bold text-xs">QAR</span>
                      Price
                    </label>
                    <div className="flex items-center gap-3">
                      <input
                        type="range"
                        min="100000"
                        max="500000"
                        step="10000"
                        value={filters.maxPrice}
                        onChange={(e) => setFilters({ ...filters, maxPrice: Number(e.target.value) })}
                        className="flex-1"
                      />
                      <span className="text-sm font-semibold text-primary w-16 text-right">
                        {(filters.maxPrice / 1000).toFixed(0)}k
                      </span>
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">Max: {formatPrice(filters.maxPrice)}</p>
                  </div>

                  {/* Arrival Time Filter */}
                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-foreground mb-3">
                      <ShipIcon className="h-4 w-4 text-primary" />
                      Arrival Time
                    </label>
                    <div className="flex items-center gap-3">
                      <input
                        type="range"
                        min="2"
                        max="15"
                        value={filters.maxArrivalTime}
                        onChange={(e) => setFilters({ ...filters, maxArrivalTime: Number(e.target.value) })}
                        className="flex-1"
                      />
                      <span className="text-sm font-semibold text-primary w-16 text-right">
                        {filters.maxArrivalTime}
                      </span>
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">Max: {filters.maxArrivalTime} weeks</p>
                  </div>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </CardContent>
      </Card>

      {/* Search Results Dropdown */}
      <AnimatePresence>
        {showResults && filteredVehicles.length > 0 && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="absolute top-full left-0 right-0 mt-2 z-30"
          >
            <Card className="glass-card border-2 border-primary/30 shadow-2xl">
              <CardContent className="p-0">
                {filteredVehicles.slice(0, 6).map((vehicle) => (
                  <div
                    key={vehicle.id}
                    onClick={() => handleVehicleClick(vehicle)}
                    className={`flex items-center gap-4 p-4 cursor-pointer transition-all hover:bg-primary/5 border-b border-border/50 last:border-b-0 ${
                      selectedVehicle?.id === vehicle.id ? 'bg-primary/10' : ''
                    }`}
                  >
                    <div className="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center">
                      <CarIcon className="h-6 w-6 text-primary" />
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-2">
                        <h3 className="font-semibold text-foreground">
                          {vehicle.manufacturer} {vehicle.model}
                        </h3>
                        <Badge variant="secondary" className="text-xs">
                          {vehicle.year}
                        </Badge>
                      </div>
                      <div className="flex items-center gap-4 mt-1 text-xs text-muted-foreground">
                        <span className="flex items-center gap-1">
                          <BatteryIcon className="h-3 w-3" />
                          {vehicle.range_km} km
                        </span>
                        <span className="flex items-center gap-1">
                          <ClockIcon className="h-3 w-3" />
                          {vehicle.charging_time_min} min
                        </span>
                        <span className="flex items-center gap-1">
                          <ShipIcon className="h-3 w-3" />
                          {vehicle.arrival_weeks} weeks
                        </span>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="text-lg font-bold text-primary">
                        {formatPrice(vehicle.price_qar)}
                      </p>
                      <p className="text-xs text-muted-foreground">From manufacturer</p>
                    </div>
                  </div>
                ))}
              </CardContent>
            </Card>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Selected Vehicle Display */}
      {selectedVehicle && !showResults && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mt-6"
        >
          <Card className="glass-card tech-border border-primary/30">
            <CardContent className="p-6">
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-16 h-16 rounded-xl bg-gradient-to-br from-primary/20 to-primary/5 flex items-center justify-center">
                    <CarIcon className="h-8 w-8 text-primary" />
                  </div>
                  <div>
                    <h3 className="text-2xl font-bold text-foreground">
                      {selectedVehicle.manufacturer} {selectedVehicle.model}
                    </h3>
                    <div className="flex items-center gap-3 mt-2">
                      <Badge variant="secondary" className="bg-primary/10 text-primary border-primary/30">
                        {selectedVehicle.year}
                      </Badge>
                      <span className="text-sm text-muted-foreground">
                        {formatPrice(selectedVehicle.price_qar)}
                      </span>
                    </div>
                  </div>
                </div>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => onVehicleSelect(null)}
                >
                  <X className="h-4 w-4 mr-1" />
                  Clear
                </Button>
              </div>
            </CardContent>
          </Card>
        </motion.div>
      )}
    </div>
  )
}
