'use client'

import { motion } from 'framer-motion'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import { CarIcon, BatteryIcon, CheckIcon, ZapIcon } from '@/components/icons'

interface Vehicle {
  id: string
  manufacturer: string
  model: string
  year: number
  range_km: number
  charging_time_min: number
  battery_kwh: number
  price_qar: number
  market_price_qar?: number
}

interface VehicleComparisonCardProps {
  vehicle: Vehicle
  onCompare: () => void
}

export function VehicleComparisonCard({ vehicle, onCompare }: VehicleComparisonCardProps) {
  const marketPrice = vehicle.market_price_qar || vehicle.price_qar * 1.35
  const savings = marketPrice - vehicle.price_qar
  const savingsPercent = ((savings / marketPrice) * 100).toFixed(0)

  const calculateTCO = () => {
    const evElectricityPrice = 0.05
    const iceFuelPrice = 0.40
    const annualKm = 15000
    const years = 5

    const evKwhPer100km = 18
    const iceLitersPer100km = 8

    const evEnergyCost = (annualKm / 100) * evKwhPer100km * evElectricityPrice
    const iceFuelCost = (annualKm / 100) * iceLitersPer100km * iceFuelPrice

    const evTotal = vehicle.price_qar + evEnergyCost * years
    const iceTotal = marketPrice + iceFuelCost * years

    return {
      ev: evTotal,
      ice: iceTotal,
      savings: iceTotal - evTotal,
      savingsPercent: ((iceTotal - evTotal) / iceTotal * 100).toFixed(1),
      annualEv: evEnergyCost,
      annualIce: iceFuelCost,
    }
  }

  const tco = calculateTCO()

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR',
      maximumFractionDigits: 0,
    }).format(price)
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <Card className="glass-card tech-border border-primary/30 overflow-hidden">
        <CardHeader className="bg-gradient-to-r from-primary/10 to-transparent border-b border-border/50">
          <div className="flex items-center justify-between">
            <CardTitle className="text-2xl">Vehicle Comparison</CardTitle>
            <Badge className="bg-primary text-primary-foreground font-bold">
              Direct-to-Consumer
            </Badge>
          </div>
        </CardHeader>

        <CardContent className="p-6 space-y-8">
          {/* Pricing Comparison */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* QEV-Hub Price */}
            <div className="relative p-6 bg-gradient-to-br from-primary/5 to-transparent rounded-xl border-2 border-primary/30">
              <div className="absolute top-3 right-3">
                <div className="w-8 h-8 rounded-full bg-primary flex items-center justify-center">
                  <CheckIcon className="h-4 w-4 text-primary-foreground" />
                </div>
              </div>
              <p className="text-sm text-muted-foreground mb-2">QEV-Hub Price</p>
              <p className="text-3xl font-black text-primary">{formatPrice(vehicle.price_qar)}</p>
              <p className="text-xs text-muted-foreground mt-1">Direct from manufacturer</p>
              <div className="mt-4 flex items-center gap-2 text-green-600 dark:text-green-400">
                <ZapIcon className="h-4 w-4" />
                <span className="text-sm font-semibold">Save {savingsPercent}%</span>
              </div>
            </div>

            {/* Market Price */}
            <div className="p-6 bg-muted/30 rounded-xl border-2 border-border/50">
              <p className="text-sm text-muted-foreground mb-2">Market Price</p>
              <p className="text-3xl font-black text-muted-foreground line-through">
                {formatPrice(marketPrice)}
              </p>
              <p className="text-xs text-muted-foreground mt-1">Estimated dealer cost</p>
              <div className="mt-4 text-muted-foreground">
                <span className="text-sm line-through">{formatPrice(savings)}</span>
                <span className="text-sm ml-1">extra</span>
              </div>
            </div>
          </div>

          {/* Savings Highlight */}
          <div className="p-6 bg-gradient-to-r from-green-500/10 to-emerald-500/10 rounded-xl border-2 border-green-500/30">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-green-700 dark:text-green-300 font-medium">Instant Savings</p>
                <p className="text-4xl font-black text-green-600 dark:text-green-400">
                  {formatPrice(savings)}
                </p>
                <p className="text-xs text-muted-foreground mt-1">By purchasing directly</p>
              </div>
              <div className="w-20 h-20 rounded-full bg-green-500/20 flex items-center justify-center">
                <ZapIcon className="h-10 w-10 text-green-600 dark:text-green-400" />
              </div>
            </div>
          </div>

          {/* TCO Calculator */}
          <div>
            <h3 className="text-lg font-bold text-foreground mb-4 flex items-center gap-2">
              <ZapIcon className="h-5 w-5 text-primary" />
              5-Year Total Cost of Ownership
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* EV TCO */}
              <div className="p-5 bg-primary/5 rounded-xl border border-primary/20">
                <div className="flex items-center justify-between mb-4">
                  <div>
                    <p className="text-sm font-medium text-foreground">EV (This Vehicle)</p>
                    <p className="text-2xl font-bold text-primary">{formatPrice(tco.ev)}</p>
                  </div>
                  <BatteryIcon className="h-8 w-8 text-primary/50" />
                </div>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Purchase Price</span>
                    <span className="font-medium">{formatPrice(vehicle.price_qar)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Annual Energy</span>
                    <span className="font-medium">{formatPrice(tco.annualEv)}/yr</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">5-Year Energy</span>
                    <span className="font-medium">{formatPrice(tco.annualEv * 5)}</span>
                  </div>
                </div>
              </div>

              {/* ICE TCO */}
              <div className="p-5 bg-muted/30 rounded-xl border border-border/50">
                <div className="flex items-center justify-between mb-4">
                  <div>
                    <p className="text-sm font-medium text-foreground">Equivalent ICE</p>
                    <p className="text-2xl font-bold text-muted-foreground">{formatPrice(tco.ice)}</p>
                  </div>
                  <CarIcon className="h-8 w-8 text-muted-foreground/50" />
                </div>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Purchase Price</span>
                    <span className="font-medium">{formatPrice(marketPrice)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Annual Fuel</span>
                    <span className="font-medium">{formatPrice(tco.annualIce)}/yr</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">5-Year Fuel</span>
                    <span className="font-medium">{formatPrice(tco.annualIce * 5)}</span>
                  </div>
                </div>
              </div>
            </div>

            {/* TCO Savings */}
            <div className="mt-6 p-6 bg-gradient-to-r from-primary/10 to-primary/5 rounded-xl border border-primary/30">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <p className="text-sm text-muted-foreground mb-1">Total Savings Over 5 Years</p>
                  <p className="text-3xl font-black text-primary">
                    {formatPrice(tco.savings)}
                  </p>
                  <p className="text-sm text-muted-foreground mt-1">
                    That's {tco.savingsPercent}% cheaper than a petrol car
                  </p>
                </div>
                <div className="text-right">
                  <Badge className="bg-green-500 text-white mb-2">
                    {tco.savingsPercent}% Cheaper
                  </Badge>
                  <div className="w-16 h-16 rounded-full bg-green-500/20 flex items-center justify-center ml-auto">
                    <ZapIcon className="h-8 w-8 text-green-600 dark:text-green-400" />
                  </div>
                </div>
              </div>

              <Progress value={100 - parseFloat(tco.savingsPercent)} className="h-3" />
              <div className="flex justify-between mt-2 text-xs text-muted-foreground">
                <span>EV Cost: {formatPrice(tco.ev)}</span>
                <span>ICE Cost: {formatPrice(tco.ice)}</span>
              </div>
            </div>
          </div>

          {/* Vehicle Specs */}
          <div className="grid grid-cols-3 gap-4">
            <div className="p-4 bg-muted/30 rounded-lg border border-border/50 text-center">
              <BatteryIcon className="h-6 w-6 text-primary mx-auto mb-2" />
              <p className="text-2xl font-bold text-foreground">{vehicle.range_km}</p>
              <p className="text-xs text-muted-foreground">km Range</p>
            </div>
            <div className="p-4 bg-muted/30 rounded-lg border border-border/50 text-center">
              <ZapIcon className="h-6 w-6 text-primary mx-auto mb-2" />
              <p className="text-2xl font-bold text-foreground">{vehicle.battery_kwh}</p>
              <p className="text-xs text-muted-foreground">kWh Battery</p>
            </div>
            <div className="p-4 bg-muted/30 rounded-lg border border-border/50 text-center">
              <CarIcon className="h-6 w-6 text-primary mx-auto mb-2" />
              <p className="text-2xl font-bold text-foreground">{vehicle.charging_time_min}</p>
              <p className="text-xs text-muted-foreground">min Charge</p>
            </div>
          </div>

          {/* Action Button */}
          <Button
            onClick={onCompare}
            className="w-full bg-primary text-primary-foreground hover:bg-primary/90 py-6 text-lg font-bold"
          >
            View Detailed Calculator
          </Button>
        </CardContent>
      </Card>
    </motion.div>
  )
}
