'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { AlertCircle, CheckCircleIcon } from '@/components/icons'
import { useToast } from '@/components/ui/use-toast'

export default function NewVehiclePage() {
  const router = useRouter()
  const { toast } = useToast()
  const [loading, setLoading] = useState(false)
  const [manufacturer, setManufacturer] = useState<any>(null)
  const [error, setError] = useState<string | null>(null)

  const [formData, setFormData] = useState({
    make: '',
    model: '',
    year: new Date().getFullYear(),
    vehicle_type: 'EV',
    price: '',
    battery_capacity: '',
    range: '',
    charging_time: '',
    top_speed: '',
    acceleration: '',
    seating_capacity: '5',
    cargo_space: '',
    availability: 'available',
    description: '',
    warranty_years: '5',
    warranty_km: '100000',
    origin_country: 'China',
  })

  useEffect(() => {
    fetchManufacturer()
  }, [])

  const fetchManufacturer = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { data: manufacturerData } = await supabase
        .from('manufacturers')
        .select('*')
        .eq('user_id', user.id)
        .single()

      setManufacturer(manufacturerData)
    } catch (error) {
      console.error('Error fetching manufacturer:', error)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    try {
      if (!manufacturer) {
        throw new Error('Manufacturer not found')
      }

      // Validate required fields
      if (!formData.make || !formData.model || !formData.price) {
        throw new Error('Please fill in all required fields')
      }

      // Insert vehicle
      const { data: vehicleData, error: vehicleError } = await supabase
        .from('vehicles')
        .insert([
          {
            manufacturer_id: manufacturer.id,
            make: formData.make,
            model: formData.model,
            year: formData.year,
            vehicle_type: formData.vehicle_type,
            price: parseFloat(formData.price),
            battery_capacity: formData.battery_capacity ? parseFloat(formData.battery_capacity) : null,
            range: formData.range ? parseInt(formData.range) : null,
            charging_time: formData.charging_time || null,
            top_speed: formData.top_speed ? parseInt(formData.top_speed) : null,
            acceleration: formData.acceleration || null,
            seating_capacity: parseInt(formData.seating_capacity),
            cargo_space: formData.cargo_space ? parseInt(formData.cargo_space) : null,
            availability: formData.availability,
            description: formData.description || null,
            warranty_years: parseInt(formData.warranty_years),
            warranty_km: parseInt(formData.warranty_km),
            origin_country: formData.origin_country,
            manufacturer_direct_price: parseFloat(formData.price),
          }
        ])
        .select()

      if (vehicleError) throw vehicleError

      toast({
        title: 'Success',
        description: 'Vehicle added successfully',
      })

      router.push('/manufacturer/vehicles')
    } catch (error: any) {
      console.error('Error adding vehicle:', error)
      setError(error.message || 'Failed to add vehicle')
    } finally {
      setLoading(false)
    }
  }

  const updateFormData = (field: string, value: any) => {
    setFormData({ ...formData, [field]: value })
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Add New Vehicle</h1>
        <p className="text-muted-foreground mt-1">
          Add a new vehicle to your marketplace listings
        </p>
      </div>

      <form onSubmit={handleSubmit}>
        <Card>
          <CardHeader>
            <CardTitle>Vehicle Information</CardTitle>
            <CardDescription>
              Enter the details of the vehicle you want to list
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            {error && (
              <div className="bg-destructive/10 text-destructive px-4 py-3 rounded-lg flex items-start gap-3">
                <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
                <p className="text-sm">{error}</p>
              </div>
            )}

            {/* Basic Information */}
            <div className="space-y-4">
              <h3 className="font-semibold text-lg">Basic Information</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="make">Make *</Label>
                  <Input
                    id="make"
                    placeholder="e.g., BYD, Tesla, NIO"
                    value={formData.make}
                    onChange={(e) => updateFormData('make', e.target.value)}
                    required
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="model">Model *</Label>
                  <Input
                    id="model"
                    placeholder="e.g., Seal, Model 3, ET5"
                    value={formData.model}
                    onChange={(e) => updateFormData('model', e.target.value)}
                    required
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="year">Year</Label>
                  <Input
                    id="year"
                    type="number"
                    min="2020"
                    max="2030"
                    value={formData.year}
                    onChange={(e) => updateFormData('year', parseInt(e.target.value))}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="vehicle_type">Vehicle Type</Label>
                  <Select value={formData.vehicle_type} onValueChange={(value: string) => updateFormData('vehicle_type', value)}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="EV">Battery Electric (EV)</SelectItem>
                      <SelectItem value="PHEV">Plug-in Hybrid (PHEV)</SelectItem>
                      <SelectItem value="FCEV">Fuel Cell (FCEV)</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="price">Price (QAR) *</Label>
                  <Input
                    id="price"
                    type="number"
                    placeholder="150000"
                    value={formData.price}
                    onChange={(e) => updateFormData('price', e.target.value)}
                    required
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="availability">Availability</Label>
                  <Select value={formData.availability} onValueChange={(value: string) => updateFormData('availability', value)}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="available">Available</SelectItem>
                      <SelectItem value="pre-order">Pre-Order</SelectItem>
                      <SelectItem value="sold-out">Sold Out</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </div>

            {/* Technical Specifications */}
            <div className="space-y-4">
              <h3 className="font-semibold text-lg">Technical Specifications</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="battery_capacity">Battery Capacity (kWh)</Label>
                  <Input
                    id="battery_capacity"
                    type="number"
                    step="0.1"
                    placeholder="75.0"
                    value={formData.battery_capacity}
                    onChange={(e) => updateFormData('battery_capacity', e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="range">Range (km)</Label>
                  <Input
                    id="range"
                    type="number"
                    placeholder="500"
                    value={formData.range}
                    onChange={(e) => updateFormData('range', e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="charging_time">Charging Time</Label>
                  <Input
                    id="charging_time"
                    placeholder="e.g., 30 min (10-80%)"
                    value={formData.charging_time}
                    onChange={(e) => updateFormData('charging_time', e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="top_speed">Top Speed (km/h)</Label>
                  <Input
                    id="top_speed"
                    type="number"
                    placeholder="180"
                    value={formData.top_speed}
                    onChange={(e) => updateFormData('top_speed', e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="acceleration">Acceleration (0-100 km/h)</Label>
                  <Input
                    id="acceleration"
                    placeholder="e.g., 6.5s"
                    value={formData.acceleration}
                    onChange={(e) => updateFormData('acceleration', e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="seating_capacity">Seating Capacity</Label>
                  <Input
                    id="seating_capacity"
                    type="number"
                    min="2"
                    max="9"
                    value={formData.seating_capacity}
                    onChange={(e) => updateFormData('seating_capacity', e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="cargo_space">Cargo Space (liters)</Label>
                  <Input
                    id="cargo_space"
                    type="number"
                    placeholder="500"
                    value={formData.cargo_space}
                    onChange={(e) => updateFormData('cargo_space', e.target.value)}
                  />
                </div>
              </div>
            </div>

            {/* Warranty & Origin */}
            <div className="space-y-4">
              <h3 className="font-semibold text-lg">Warranty & Origin</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="warranty_years">Warranty (years)</Label>
                  <Input
                    id="warranty_years"
                    type="number"
                    value={formData.warranty_years}
                    onChange={(e) => updateFormData('warranty_years', e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="warranty_km">Warranty (km)</Label>
                  <Input
                    id="warranty_km"
                    type="number"
                    value={formData.warranty_km}
                    onChange={(e) => updateFormData('warranty_km', e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="origin_country">Origin Country</Label>
                  <Input
                    id="origin_country"
                    value={formData.origin_country}
                    onChange={(e) => updateFormData('origin_country', e.target.value)}
                  />
                </div>
              </div>
            </div>

            {/* Description */}
            <div className="space-y-2">
              <Label htmlFor="description">Description</Label>
              <Textarea
                id="description"
                placeholder="Provide a detailed description of the vehicle, its features, and benefits..."
                rows={5}
                value={formData.description}
                onChange={(e: React.ChangeEvent<HTMLTextAreaElement>) => updateFormData('description', e.target.value)}
              />
            </div>

            {/* Actions */}
            <div className="flex gap-4 pt-6">
              <Button
                type="submit"
                className="flex-1"
                disabled={loading}
              >
                {loading ? 'Adding Vehicle...' : 'Add Vehicle'}
              </Button>
              <Button
                type="button"
                variant="outline"
                onClick={() => router.push('/manufacturer/vehicles')}
                disabled={loading}
              >
                Cancel
              </Button>
            </div>
          </CardContent>
        </Card>
      </form>
    </div>
  )
}
