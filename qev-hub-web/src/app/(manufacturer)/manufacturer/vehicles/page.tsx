'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { CarIcon, SearchIcon, PlusIcon, EditIcon, TrashIcon } from '@/components/icons'
import Link from 'next/link'
import { useRouter } from 'next/navigation'

export default function ManufacturerVehiclesPage() {
  const router = useRouter()
  const [loading, setLoading] = useState(true)
  const [vehicles, setVehicles] = useState<any[]>([])
  const [manufacturer, setManufacturer] = useState<any>(null)
  const [searchQuery, setSearchQuery] = useState('')

  useEffect(() => {
    fetchVehicles()
  }, [])

  const fetchVehicles = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      // Get manufacturer profile
      const { data: manufacturerData } = await supabase
        .from('manufacturers')
        .select('*')
        .eq('user_id', user.id)
        .single()

      if (manufacturerData) {
        setManufacturer(manufacturerData)

        // Get vehicles
        const { data: vehiclesData } = await supabase
          .from('vehicles')
          .select('*')
          .eq('manufacturer_id', manufacturerData.id)
          .order('created_at', { ascending: false })

        setVehicles(vehiclesData || [])
      }
    } catch (error) {
      console.error('Error fetching vehicles:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (vehicleId: string) => {
    if (!confirm('Are you sure you want to delete this vehicle?')) return

    try {
      const { error } = await supabase
        .from('vehicles')
        .delete()
        .eq('id', vehicleId)

      if (error) throw error

      setVehicles(vehicles.filter(v => v.id !== vehicleId))
    } catch (error) {
      console.error('Error deleting vehicle:', error)
      alert('Failed to delete vehicle')
    }
  }

  const filteredVehicles = vehicles.filter(vehicle =>
    vehicle.make?.toLowerCase().includes(searchQuery.toLowerCase()) ||
    vehicle.model?.toLowerCase().includes(searchQuery.toLowerCase()) ||
    vehicle.year?.toString().includes(searchQuery)
  )

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 className="text-3xl font-bold">Vehicle Management</h1>
          <p className="text-muted-foreground mt-1">
            Manage your vehicle listings
          </p>
        </div>
        <Link href="/manufacturer/vehicles/new">
          <Button className="gap-2">
            <PlusIcon className="w-4 h-4" />
            Add New Vehicle
          </Button>
        </Link>
      </div>

      {/* Search */}
      <Card>
        <CardContent className="pt-6">
          <div className="relative">
            <SearchIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <Input
              placeholder="Search vehicles by make, model, or year..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10"
            />
          </div>
        </CardContent>
      </Card>

      {/* Vehicles List */}
      {filteredVehicles.length === 0 ? (
        <Card>
          <CardContent className="py-12 text-center">
            <CarIcon className="w-16 h-16 mx-auto mb-4 text-muted-foreground opacity-50" />
            <h3 className="text-xl font-semibold mb-2">No vehicles found</h3>
            <p className="text-muted-foreground mb-6">
              {searchQuery ? 'Try adjusting your search' : 'Start by adding your first vehicle'}
            </p>
            {!searchQuery && (
              <Link href="/manufacturer/vehicles/new">
                <Button>Add Your First Vehicle</Button>
              </Link>
            )}
          </CardContent>
        </Card>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {filteredVehicles.map((vehicle) => (
            <Card key={vehicle.id} className="hover:shadow-lg transition-shadow">
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle className="text-xl">
                      {vehicle.make} {vehicle.model}
                    </CardTitle>
                    <p className="text-sm text-muted-foreground mt-1">
                      {vehicle.year} • {vehicle.vehicle_type || 'EV'}
                    </p>
                  </div>
                  <Badge variant={vehicle.availability === 'available' ? 'default' : 'secondary'}>
                    {vehicle.availability}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {/* Vehicle Details */}
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div>
                      <p className="text-muted-foreground">Battery</p>
                      <p className="font-medium">{vehicle.battery_capacity || 'N/A'} kWh</p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Range</p>
                      <p className="font-medium">{vehicle.range || 'N/A'} km</p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Price</p>
                      <p className="font-medium">
                        {new Intl.NumberFormat('en-QA', {
                          style: 'currency',
                          currency: 'QAR',
                          maximumFractionDigits: 0
                        }).format(vehicle.price)}
                      </p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Warranty</p>
                      <p className="font-medium">
                        {vehicle.warranty_years || 5} years / {(vehicle.warranty_km || 100000) / 1000}k km
                      </p>
                    </div>
                  </div>

                  {/* Actions */}
                  <div className="flex gap-2 pt-4 border-t">
                    <Link href={`/manufacturer/vehicles/edit/${vehicle.id}`} className="flex-1">
                      <Button variant="outline" className="w-full gap-2">
                        <EditIcon className="w-4 h-4" />
                        Edit
                      </Button>
                    </Link>
                    <Button
                      variant="outline"
                      className="gap-2 text-destructive hover:bg-destructive hover:text-destructive-foreground"
                      onClick={() => handleDelete(vehicle.id)}
                    >
                      <TrashIcon className="w-4 h-4" />
                      Delete
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  )
}
