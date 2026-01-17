'use client'

import { useState, useMemo, useCallback } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Progress } from '@/components/ui/progress'
import { Card, CardContent } from '@/components/ui/card'
import { X, ZapIcon, CarIcon, Fuel, TrendingUp, Calculator, CheckCircle2 } from '@/components/icons'

interface SavingsCalculatorProps {
  onClose: () => void
  vehicle?: any
}

export function SavingsCalculator({ onClose, vehicle }: SavingsCalculatorProps) {
  const [annualKm, setAnnualKm] = useState(15000)
  const [electricityPrice, setElectricityPrice] = useState(0.05)
  const [fuelPrice, setFuelPrice] = useState(0.40)
  const [fuelEfficiency, setFuelEfficiency] = useState(8)
  const [evEfficiency, setEvEfficiency] = useState(18)
  const [years, setYears] = useState(5)

  const calculateSavings = useMemo(() => {
    const vehiclePrice = vehicle?.price_qar || 175000
    const marketPrice = vehicle?.market_price_qar || vehiclePrice * 1.35

    const evKwhPer100km = evEfficiency
    const iceLitersPer100km = fuelEfficiency

    const evEnergyCostPer100km = evKwhPer100km * electricityPrice
    const iceFuelCostPer100km = iceLitersPer100km * fuelPrice

    const evAnnualEnergy = (annualKm / 100) * evEnergyCostPer100km
    const iceAnnualFuel = (annualKm / 100) * iceFuelCostPer100km

    const evTotalCost = vehiclePrice + evAnnualEnergy * years
    const iceTotalCost = marketPrice + iceAnnualFuel * years

    const instantSavings = marketPrice - vehiclePrice
    const totalSavings = iceTotalCost - evTotalCost

    return {
      vehiclePrice,
      marketPrice,
      instantSavings,
      instantSavingsPercent: ((instantSavings / marketPrice) * 100).toFixed(1),
      evAnnualCost: evAnnualEnergy,
      iceAnnualCost: iceAnnualFuel,
      evTotalCost,
      iceTotalCost,
      totalSavings,
      totalSavingsPercent: ((totalSavings / iceTotalCost) * 100).toFixed(1),
      co2Saved: (annualKm / 100) * (iceLitersPer100km * 2.3 - evKwhPer100km * 0.5) * years,
    }
  }, [annualKm, electricityPrice, fuelPrice, fuelEfficiency, evEfficiency, years, vehicle])

  const savings = calculateSavings

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR',
      maximumFractionDigits: 0,
    }).format(price)
  }

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader className="flex items-center justify-between pb-4 border-b border-border/50">
          <DialogTitle className="text-2xl flex items-center gap-2">
            <Calculator className="h-6 w-6 text-primary" />
            EV vs ICE Savings Calculator
          </DialogTitle>
          <Button
            variant="ghost"
            size="sm"
            onClick={onClose}
          >
            <X className="h-4 w-4" />
          </Button>
        </DialogHeader>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 py-6">
          {/* Left Column - Inputs */}
          <div className="space-y-6">
            <Card className="glass-card border-border/50">
              <CardContent className="p-6 space-y-6">
                <h3 className="text-lg font-bold text-foreground flex items-center gap-2">
                  <Calculator className="h-5 w-5 text-primary" />
                  Your Usage
                </h3>

                {/* Annual KM */}
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Annual Distance (km)
                  </label>
                  <input
                    type="range"
                    min="5000"
                    max="50000"
                    step="1000"
                    value={annualKm}
                    onChange={(e) => setAnnualKm(Number(e.target.value))}
                    className="w-full"
                  />
                  <div className="flex justify-between mt-2 text-xs text-muted-foreground">
                    <span>5,000 km</span>
                    <span className="font-semibold text-primary">
                      {new Intl.NumberFormat('en-QA').format(annualKm)} km
                    </span>
                    <span>50,000 km</span>
                  </div>
                </div>

                {/* Years */}
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Ownership Period
                  </label>
                  <div className="grid grid-cols-5 gap-2">
                    {[1, 2, 3, 4, 5].map((y) => (
                      <button
                        key={y}
                        onClick={() => setYears(y)}
                        className={`p-3 rounded-lg text-center font-semibold transition-all ${
                          years === y
                            ? 'bg-primary text-primary-foreground'
                            : 'bg-muted/50 text-foreground hover:bg-muted'
                        }`}
                      >
                        {y}
                        <span className="block text-xs font-normal">yr</span>
                      </button>
                    ))}
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="glass-card border-border/50">
              <CardContent className="p-6 space-y-6">
                <h3 className="text-lg font-bold text-foreground flex items-center gap-2">
                  <ZapIcon className="h-5 w-5 text-primary" />
                  Energy Costs
                </h3>

                {/* Electricity Price */}
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Electricity Price (QAR/kWh)
                  </label>
                  <input
                    type="range"
                    min="0.02"
                    max="0.15"
                    step="0.01"
                    value={electricityPrice}
                    onChange={(e) => setElectricityPrice(Number(e.target.value))}
                    className="w-full"
                  />
                  <div className="text-right mt-2">
                    <Badge className="bg-primary/10 text-primary border-primary/30">
                      {electricityPrice.toFixed(2)} QAR/kWh
                    </Badge>
                  </div>
                </div>

                {/* EV Efficiency */}
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    EV Efficiency (kWh/100km)
                  </label>
                  <input
                    type="range"
                    min="12"
                    max="30"
                    step="1"
                    value={evEfficiency}
                    onChange={(e) => setEvEfficiency(Number(e.target.value))}
                    className="w-full"
                  />
                  <div className="text-right mt-2">
                    <Badge className="bg-primary/10 text-primary border-primary/30">
                      {evEfficiency} kWh/100km
                    </Badge>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="glass-card border-border/50">
              <CardContent className="p-6 space-y-6">
                <h3 className="text-lg font-bold text-foreground flex items-center gap-2">
                  <Fuel className="h-5 w-5 text-primary" />
                  Fuel Costs (ICE)
                </h3>

                {/* Fuel Price */}
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Fuel Price (QAR/Liter)
                  </label>
                  <input
                    type="range"
                    min="0.20"
                    max="0.60"
                    step="0.05"
                    value={fuelPrice}
                    onChange={(e) => setFuelPrice(Number(e.target.value))}
                    className="w-full"
                  />
                  <div className="text-right mt-2">
                    <Badge className="bg-red-500/10 text-red-600 border-red-500/30">
                      {fuelPrice.toFixed(2)} QAR/L
                    </Badge>
                  </div>
                </div>

                {/* Fuel Efficiency */}
                <div>
                  <label className="block text-sm font-medium text-foreground mb-2">
                    Fuel Efficiency (Liters/100km)
                  </label>
                  <input
                    type="range"
                    min="5"
                    max="15"
                    step="0.5"
                    value={fuelEfficiency}
                    onChange={(e) => setFuelEfficiency(Number(e.target.value))}
                    className="w-full"
                  />
                  <div className="text-right mt-2">
                    <Badge className="bg-red-500/10 text-red-600 border-red-500/30">
                      {fuelEfficiency} L/100km
                    </Badge>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Right Column - Results */}
          <div className="space-y-6">
            {/* Summary Cards */}
            <div className="grid grid-cols-2 gap-4">
              <Card className="glass-card border-green-500/30">
                <CardContent className="p-4 text-center">
                  <p className="text-xs text-muted-foreground mb-1">Instant Savings</p>
                  <p className="text-2xl font-bold text-green-600">
                    {formatPrice(savings.instantSavings)}
                  </p>
                  <Badge className="mt-2 bg-green-500 text-white text-xs">
                    {savings.instantSavingsPercent}% OFF
                  </Badge>
                </CardContent>
              </Card>

              <Card className="glass-card border-primary/30">
                <CardContent className="p-4 text-center">
                  <p className="text-xs text-muted-foreground mb-1">
                    {years}-Year Total Savings
                  </p>
                  <p className="text-2xl font-bold text-primary">
                    {formatPrice(savings.totalSavings)}
                  </p>
                  <Badge className="mt-2 bg-primary/10 text-primary border-primary/30 text-xs">
                    {savings.totalSavingsPercent}% Cheaper
                  </Badge>
                </CardContent>
              </Card>
            </div>

            {/* Breakdown */}
            <Card className="glass-card border-primary/30">
              <CardContent className="p-6 space-y-4">
                <h3 className="text-lg font-bold text-foreground flex items-center gap-2">
                  <TrendingUp className="h-5 w-5 text-primary" />
                  Cost Breakdown ({years} Years)
                </h3>

                {/* Purchase Price */}
                <div className="p-4 bg-muted/30 rounded-lg border border-border/50">
                  <div className="flex justify-between mb-2">
                    <span className="text-sm text-muted-foreground">QEV-Hub Price</span>
                    <span className="font-semibold text-green-600">
                      {formatPrice(savings.vehiclePrice)}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Market Price</span>
                    <span className="font-semibold text-muted-foreground line-through">
                      {formatPrice(savings.marketPrice)}
                    </span>
                  </div>
                  <div className="pt-2 border-t border-border/50 mt-2">
                    <span className="text-sm font-semibold text-green-600">
                      Save: {formatPrice(savings.instantSavings)}
                    </span>
                  </div>
                </div>

                {/* Energy Costs */}
                <div className="space-y-3">
                  <div className="p-4 bg-green-500/5 rounded-lg border-2 border-green-500/30">
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <ZapIcon className="h-5 w-5 text-green-600" />
                        <span className="text-sm font-medium text-foreground">EV</span>
                      </div>
                      <Badge className="bg-green-500/10 text-green-600">
                        {formatPrice(savings.evAnnualCost)}/yr
                      </Badge>
                    </div>
                    <Progress value={30} className="h-2" />
                    <p className="text-xs text-muted-foreground mt-1">
                      Total: {formatPrice(savings.evAnnualCost * years)}
                    </p>
                  </div>

                  <div className="p-4 bg-red-500/5 rounded-lg border-2 border-red-500/30">
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <Fuel className="h-5 w-5 text-red-600" />
                        <span className="text-sm font-medium text-foreground">ICE</span>
                      </div>
                      <Badge className="bg-red-500/10 text-red-600">
                        {formatPrice(savings.iceAnnualCost)}/yr
                      </Badge>
                    </div>
                    <Progress value={70} className="h-2" />
                    <p className="text-xs text-muted-foreground mt-1">
                      Total: {formatPrice(savings.iceAnnualCost * years)}
                    </p>
                  </div>
                </div>

                {/* Total Comparison */}
                <div className="p-4 bg-primary/5 rounded-lg border-2 border-primary/30">
                  <div className="flex items-center justify-between mb-3">
                    <div>
                      <p className="text-sm text-muted-foreground">Total EV Cost</p>
                      <p className="text-xl font-bold text-foreground">
                        {formatPrice(savings.evTotalCost)}
                      </p>
                    </div>
                    <div>
                      <p className="text-sm text-muted-foreground">Total ICE Cost</p>
                      <p className="text-xl font-bold text-muted-foreground line-through">
                        {formatPrice(savings.iceTotalCost)}
                      </p>
                    </div>
                  </div>
                  <div className="pt-3 border-t border-border/50">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <CheckCircle2 className="h-5 w-5 text-green-600" />
                        <span className="text-sm font-semibold text-foreground">
                          Total Savings
                        </span>
                      </div>
                      <span className="text-2xl font-black text-green-600">
                        {formatPrice(savings.totalSavings)}
                      </span>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Environmental Impact */}
            <Card className="glass-card border-green-500/30">
              <CardContent className="p-6">
                <h3 className="text-lg font-bold text-foreground flex items-center gap-2 mb-4">
                  <CarIcon className="h-5 w-5 text-green-600" />
                  Environmental Impact
                </h3>

                <div className="p-4 bg-green-500/5 rounded-lg border-2 border-green-500/30">
                  <div className="flex items-center justify-between mb-3">
                    <div>
                      <p className="text-sm text-muted-foreground mb-1">
                        CO2 Emissions Saved
                      </p>
                      <p className="text-3xl font-black text-green-600">
                        {new Intl.NumberFormat('en-QA').format(
                          Math.round(savings.co2Saved)
                        )}{' '}
                        kg
                      </p>
                    </div>
                    <div className="w-16 h-16 rounded-full bg-green-500/20 flex items-center justify-center">
                      <CheckCircle2 className="h-8 w-8 text-green-600" />
                    </div>
                  </div>

                  <div className="space-y-2 text-xs text-muted-foreground">
                    <div className="flex justify-between">
                      <span>Equivalent to:</span>
                      <span className="font-semibold text-foreground">
                        {new Intl.NumberFormat('en-QA').format(
                          Math.round(savings.co2Saved / 22)
                        )}{' '}
                        trees planted
                      </span>
                    </div>
                    <div className="flex justify-between">
                      <span>Car trips offset:</span>
                      <span className="font-semibold text-foreground">
                        {new Intl.NumberFormat('en-QA').format(
                          Math.round(savings.co2Saved / 10)
                        )}{' '}
                        Doha-Al Wakrah
                      </span>
                    </div>
                    <div className="flex justify-between">
                      <span>Contribution to Vision 2030:</span>
                      <span className="font-semibold text-green-600">
                        {((savings.co2Saved / 100000) * 100).toFixed(2)}%
                      </span>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* CTA */}
            <Button
              onClick={onClose}
              className="w-full bg-primary text-primary-foreground hover:bg-primary/90 py-6 text-lg font-bold"
            >
              Proceed with Purchase
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  )
}
