'use client'

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
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
  description: string
  stock_count: number
}

interface OrderDetailsProps {
  vehicle: Vehicle
  onPurchase: (vehicle: Vehicle) => void
}

export function OrderDetails({ vehicle, onPurchase }: OrderDetailsProps) {
  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR'
    }).format(price)
  }

  const depositAmount = vehicle.price_qar * 0.2

  return (
    <Card className="w-full">
      <CardHeader>
        <div className="flex items-start justify-between">
          <div>
            <CardTitle className="text-2xl">
              {vehicle.manufacturer} {vehicle.model}
            </CardTitle>
            <p className="text-sm text-muted-foreground mt-1">
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
      <CardContent className="space-y-6">
        {/* Vehicle Image Placeholder */}
        <div className="h-48 bg-gradient-to-br from-gray-100 to-gray-200 rounded-lg flex items-center justify-center">
          <CarIcon className="h-24 w-24 text-gray-400" />
        </div>

        {/* Description */}
        <div>
          <h3 className="font-semibold mb-2">Description</h3>
          <p className="text-sm text-muted-foreground">{vehicle.description}</p>
        </div>

        {/* Specifications */}
        <div className="grid grid-cols-2 gap-4">
          <div className="p-4 bg-muted rounded-lg">
            <div className="flex items-center gap-2 mb-2">
              <BatteryIcon className="h-4 w-4" />
              <span className="text-xs text-muted-foreground">Range</span>
            </div>
            <p className="text-lg font-semibold">{vehicle.range_km} km</p>
          </div>
          <div className="p-4 bg-muted rounded-lg">
            <div className="flex items-center gap-2 mb-2">
              <BatteryIcon className="h-4 w-4" />
              <span className="text-xs text-muted-foreground">Battery</span>
            </div>
            <p className="text-lg font-semibold">{vehicle.battery_kwh} kWh</p>
          </div>
        </div>

        {/* Pricing */}
        <div className="border-t pt-4">
          <div className="flex justify-between items-center mb-2">
            <span className="text-muted-foreground">Total Price</span>
            <span className="text-2xl font-bold">{formatPrice(vehicle.price_qar)}</span>
          </div>
          <div className="flex justify-between items-center mb-4">
            <span className="text-muted-foreground">Deposit (20%)</span>
            <span className="text-xl font-semibold">{formatPrice(depositAmount)}</span>
          </div>
          <p className="text-xs text-muted-foreground mb-4">
            Save 30-40% by purchasing directly from manufacturer
          </p>
          <Button
            className="w-full"
            onClick={() => onPurchase(vehicle)}
            disabled={vehicle.stock_count === 0}
          >
            {vehicle.stock_count > 0 ? 'Purchase Now' : 'Out of Stock'}
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}
