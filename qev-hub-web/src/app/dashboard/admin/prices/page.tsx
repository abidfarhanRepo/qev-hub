'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Badge } from '@/components/ui/badge'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { toast } from '@/components/ui/use-toast'
import { SearchIcon, EditIcon, RefreshCw } from '@/components/icons'
import { SavingsBadge } from '@/components/SavingsBadge'

interface Vehicle {
  id: string
  manufacturer: string
  model: string
  year: number
  manufacturer_direct_price: number
  grey_market_price: number | null
  grey_market_source: string | null
  grey_market_updated_at: string | null
  savings_percentage: number | null
  stock_count: number
  status: string
}

interface PriceSource {
  id: string
  name: string
  name_ar: string | null
  type: string
  url: string | null
  is_active: boolean
}

export default function AdminPricesPage() {
  const [vehicles, setVehicles] = useState<Vehicle[]>([])
  const [priceSources, setPriceSources] = useState<PriceSource[]>([])
  const [loading, setLoading] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedVehicle, setSelectedVehicle] = useState<Vehicle | null>(null)
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [formData, setFormData] = useState({
    grey_market_price: '',
    grey_market_source: '',
    grey_market_url: ''
  })
  const [updating, setUpdating] = useState(false)

  useEffect(() => {
    fetchVehicles()
    fetchPriceSources()
  }, [])

  const fetchVehicles = async () => {
    try {
      const { data, error } = await supabase
        .from('vehicles')
        .select('*')
        .order('manufacturer', { ascending: true })

      if (error) throw error
      setVehicles(data || [])
    } catch (error) {
      console.error('Error fetching vehicles:', error)
    } finally {
      setLoading(false)
    }
  }

  const fetchPriceSources = async () => {
    try {
      const { data, error } = await supabase
        .from('price_sources')
        .select('*')
        .eq('is_active', true)
        .order('name')

      if (error) throw error
      setPriceSources(data || [])
    } catch (error) {
      console.error('Error fetching price sources:', error)
    }
  }

  const handleEditPrice = (vehicle: Vehicle) => {
    setSelectedVehicle(vehicle)
    setFormData({
      grey_market_price: vehicle.grey_market_price?.toString() || '',
      grey_market_source: vehicle.grey_market_source || '',
      grey_market_url: ''
    })
    setIsDialogOpen(true)
  }

  const handleUpdatePrice = async () => {
    if (!selectedVehicle || !formData.grey_market_price) return

    setUpdating(true)
    try {
      const { error } = await supabase
        .from('vehicles')
        .update({
          grey_market_price: parseFloat(formData.grey_market_price),
          grey_market_source: formData.grey_market_source,
          grey_market_url: formData.grey_market_url || null,
          grey_market_updated_at: new Date().toISOString()
        })
        .eq('id', selectedVehicle.id)

      if (error) throw error

      toast({
        title: 'Price Updated',
        description: `Grey market price for ${selectedVehicle.manufacturer} ${selectedVehicle.model} has been updated`
      })

      setIsDialogOpen(false)
      fetchVehicles()
    } catch (error) {
      console.error('Error updating price:', error)
      toast({
        title: 'Error',
        description: 'Failed to update grey market price',
        variant: 'destructive'
      })
    } finally {
      setUpdating(false)
    }
  }

  const filteredVehicles = vehicles.filter(vehicle =>
    vehicle.manufacturer?.toLowerCase().includes(searchQuery.toLowerCase()) ||
    vehicle.model?.toLowerCase().includes(searchQuery.toLowerCase())
  )

  const formatPrice = (price: number | null) => {
    if (!price) return 'N/A'
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR',
      maximumFractionDigits: 0
    }).format(price)
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 className="text-3xl font-bold">Grey Market Prices</h1>
          <p className="text-muted-foreground mt-1">
            Manage grey market pricing for price comparison
          </p>
        </div>
        <div className="flex gap-2">
          <Button
            variant="outline"
            onClick={() => {
              fetchVehicles()
              fetchPriceSources()
              toast({
                title: 'Refreshed',
                description: 'Price data refreshed successfully'
              })
            }}
          >
            <RefreshCw className="h-4 w-4 mr-2" />
            Refresh
          </Button>
        </div>
      </div>

      <Card>
        <CardContent className="pt-6">
          <div className="relative">
            <SearchIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <Input
              placeholder="Search vehicles by make or model..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10"
            />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Active Price Sources</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex flex-wrap gap-2">
            {priceSources.map(source => (
              <Badge key={source.id} variant="secondary">
                {source.name}
                {source.name_ar && ` (${source.name_ar})`}
              </Badge>
            ))}
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Vehicles ({filteredVehicles.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex justify-center items-center py-20">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
            </div>
          ) : (
            <div className="space-y-4">
              <div className="grid grid-cols-7 gap-2 text-xs font-medium text-muted-foreground pb-2 border-b border-border">
                <div>Vehicle</div>
                <div>Factory Price</div>
                <div>Grey Market</div>
                <div>Savings</div>
                <div>Source</div>
                <div>Updated</div>
                <div>Actions</div>
              </div>
              {filteredVehicles.map((vehicle) => (
                <div key={vehicle.id} className="grid grid-cols-7 gap-2 p-3 bg-muted/30 rounded-lg border border-border/50 text-sm">
                  <div>
                    <p className="font-semibold">{vehicle.manufacturer} {vehicle.model}</p>
                    <p className="text-xs text-muted-foreground">{vehicle.year}</p>
                  </div>
                  <div>
                    <p className="font-semibold text-green-600">{formatPrice(vehicle.manufacturer_direct_price)}</p>
                  </div>
                  <div>
                    {vehicle.grey_market_price ? (
                      <p className="font-semibold text-muted-foreground">{formatPrice(vehicle.grey_market_price)}</p>
                    ) : (
                      <span className="text-muted-foreground text-xs">Not set</span>
                    )}
                  </div>
                  <div>
                    {vehicle.grey_market_price && vehicle.savings_percentage ? (
                      <SavingsBadge
                        manufacturerPrice={vehicle.manufacturer_direct_price}
                        greyMarketPrice={vehicle.grey_market_price}
                        size="sm"
                      />
                    ) : (
                      <span className="text-muted-foreground text-xs">—</span>
                    )}
                  </div>
                  <div>
                    {vehicle.grey_market_source ? (
                      <Badge variant="outline">{vehicle.grey_market_source}</Badge>
                    ) : (
                      <span className="text-muted-foreground text-xs">—</span>
                    )}
                  </div>
                  <div>
                    {vehicle.grey_market_updated_at ? (
                      <span className="text-xs text-muted-foreground">
                        {new Date(vehicle.grey_market_updated_at).toLocaleDateString()}
                      </span>
                    ) : (
                      <span className="text-muted-foreground text-xs">—</span>
                    )}
                  </div>
                  <div>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleEditPrice(vehicle)}
                    >
                      <EditIcon className="h-3 w-3 mr-1" />
                      Edit
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Update Grey Market Price</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div>
              <p className="text-sm font-medium mb-2">
                {selectedVehicle?.manufacturer} {selectedVehicle?.model} ({selectedVehicle?.year})
              </p>
              <p className="text-sm text-muted-foreground mb-4">
                Factory Price: {formatPrice(selectedVehicle?.manufacturer_direct_price)}
              </p>
            </div>

            <div className="space-y-2">
              <Label htmlFor="grey_market_price">Grey Market Price (QAR)</Label>
              <Input
                id="grey_market_price"
                type="number"
                placeholder="Enter grey market price"
                value={formData.grey_market_price}
                onChange={(e) => setFormData({ ...formData, grey_market_price: e.target.value })}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="grey_market_source">Price Source</Label>
              <Select
                value={formData.grey_market_source}
                onValueChange={(value) => setFormData({ ...formData, grey_market_source: value })}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select price source" />
                </SelectTrigger>
                <SelectContent>
                  {priceSources.map((source) => (
                    <SelectItem key={source.id} value={source.name}>
                      {source.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="grey_market_url">Source URL (Optional)</Label>
              <Input
                id="grey_market_url"
                type="url"
                placeholder="https://..."
                value={formData.grey_market_url}
                onChange={(e) => setFormData({ ...formData, grey_market_url: e.target.value })}
              />
            </div>

            <div className="flex gap-2 pt-4">
              <Button
                variant="outline"
                className="flex-1"
                onClick={() => setIsDialogOpen(false)}
              >
                Cancel
              </Button>
              <Button
                className="flex-1"
                onClick={handleUpdatePrice}
                disabled={updating || !formData.grey_market_price}
              >
                {updating ? 'Updating...' : 'Update Price'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
