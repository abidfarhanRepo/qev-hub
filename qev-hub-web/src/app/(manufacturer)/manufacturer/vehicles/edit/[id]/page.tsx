'use client'

import { useState, useEffect, useRef } from 'react'
import { useRouter, useParams } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { AlertCircle } from '@/components/icons'
import { useToast } from '@/components/ui/use-toast'
import { Progress } from '@/components/ui/progress'
import { Badge } from '@/components/ui/badge'

interface VehicleImage {
  url: string
  is_primary: boolean
  isNew?: boolean
  file?: File
}

export default function EditVehiclePage() {
  const router = useRouter()
  const params = useParams()
  const vehicleId = params.id as string
  const { toast } = useToast()
  const [loading, setLoading] = useState(false)
  const [loadingVehicle, setLoadingVehicle] = useState(true)
  const [manufacturer, setManufacturer] = useState<any>(null)
  const [error, setError] = useState<string | null>(null)

  // Image upload state
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [images, setImages] = useState<VehicleImage[]>([])
  const [newImageFiles, setNewImageFiles] = useState<File[]>([])
  const [uploadingImages, setUploadingImages] = useState(false)
  const [uploadProgress, setUploadProgress] = useState(0)

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
    fetchVehicle()
  }, [vehicleId])

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

  const fetchVehicle = async () => {
    try {
      const { data: vehicle, error } = await supabase
        .from('vehicles')
        .select('*')
        .eq('id', vehicleId)
        .single()

      if (error) throw error

      setFormData({
        make: vehicle.make || '',
        model: vehicle.model || '',
        year: vehicle.year || new Date().getFullYear(),
        vehicle_type: vehicle.vehicle_type || 'EV',
        price: vehicle.price?.toString() || '',
        battery_capacity: vehicle.battery_capacity?.toString() || '',
        range: vehicle.range?.toString() || '',
        charging_time: vehicle.charging_time || '',
        top_speed: vehicle.top_speed?.toString() || '',
        acceleration: vehicle.acceleration || '',
        seating_capacity: vehicle.seating_capacity?.toString() || '5',
        cargo_space: vehicle.cargo_space?.toString() || '',
        availability: vehicle.availability || 'available',
        description: vehicle.description || '',
        warranty_years: vehicle.warranty_years?.toString() || '5',
        warranty_km: vehicle.warranty_km?.toString() || '100000',
        origin_country: vehicle.origin_country || 'China',
      })

      // Fetch vehicle images
      const { data: vehicleImages } = await supabase
        .from('vehicle_images')
        .select('*')
        .eq('vehicle_id', vehicleId)
        .order('is_primary', { ascending: false })

      if (vehicleImages && vehicleImages.length > 0) {
        setImages(vehicleImages.map(img => ({
          url: img.image_url,
          is_primary: img.is_primary
        })))
      } else if (vehicle.image_url) {
        setImages([{ url: vehicle.image_url, is_primary: true }])
      }

    } catch (error) {
      console.error('Error fetching vehicle:', error)
      setError('Failed to load vehicle')
    } finally {
      setLoadingVehicle(false)
    }
  }

  const handleImageSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || [])
    const maxImages = 5
    
    const validFiles = files.filter(file => {
      if (!['image/jpeg', 'image/jpg', 'image/png', 'image/webp'].includes(file.type)) {
        toast({
          title: 'Invalid file type',
          description: `${file.name} is not valid. Only JPEG, PNG, and WebP allowed.`,
          variant: 'destructive'
        })
        return false
      }
      if (file.size > 5 * 1024 * 1024) {
        toast({
          title: 'File too large',
          description: `${file.name} exceeds 5MB limit.`,
          variant: 'destructive'
        })
        return false
      }
      return true
    })

    if (images.length + validFiles.length > maxImages) {
      toast({
        title: 'Too many images',
        description: `Maximum ${maxImages} images allowed.`,
        variant: 'destructive'
      })
      return
    }

    setNewImageFiles([...newImageFiles, ...validFiles])
    const newImages = validFiles.map((file, index) => ({
      url: URL.createObjectURL(file),
      is_primary: images.length === 0 && index === 0,
      isNew: true,
      file
    }))
    setImages([...images, ...newImages])
  }

  const removeImage = async (index: number) => {
    const image = images[index]
    
    if (!image.isNew && vehicleId) {
      // Delete from server
      try {
        const { data: { session } } = await supabase.auth.getSession()
        if (!session) throw new Error('Not authenticated')

        await fetch(`/api/admin/vehicles/${vehicleId}/images`, {
          method: 'DELETE',
          headers: {
            'Authorization': `Bearer ${session.access_token}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ imageUrl: image.url })
        })
      } catch (error) {
        console.error('Error deleting image:', error)
      }
    }

    if (image.isNew && image.url.startsWith('blob:')) {
      URL.revokeObjectURL(image.url)
      setNewImageFiles(newImageFiles.filter(f => f !== image.file))
    }

    const newImages = images.filter((_, i) => i !== index)
    
    // If we removed the primary, make the first remaining image primary
    if (image.is_primary && newImages.length > 0) {
      newImages[0].is_primary = true
    }
    
    setImages(newImages)
  }

  const setPrimaryImage = (index: number) => {
    setImages(images.map((img, i) => ({
      ...img,
      is_primary: i === index
    })))
  }

  const uploadNewImages = async (): Promise<string | null> => {
    const newImages = images.filter(img => img.isNew && img.file)
    if (newImages.length === 0) return null

    setUploadingImages(true)
    setUploadProgress(0)

    try {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) throw new Error('Not authenticated')

      let primaryImageUrl: string | null = null
      
      for (let i = 0; i < newImages.length; i++) {
        const image = newImages[i]
        if (!image.file) continue

        const formData = new FormData()
        formData.append('file', image.file)
        formData.append('isPrimary', image.is_primary.toString())

        const response = await fetch(`/api/admin/vehicles/${vehicleId}/images`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${session.access_token}`
          },
          body: formData
        })

        if (response.ok) {
          const result = await response.json()
          if (image.is_primary) {
            primaryImageUrl = result.image.url
          }
        }

        setUploadProgress(((i + 1) / newImages.length) * 100)
      }

      return primaryImageUrl
    } catch (error) {
      console.error('Image upload error:', error)
      return null
    } finally {
      setUploadingImages(false)
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

      // Upload any new images first
      const primaryImageUrl = await uploadNewImages()

      // Find the current primary image URL
      const currentPrimary = images.find(img => img.is_primary && !img.isNew)
      const imageUrl = primaryImageUrl || currentPrimary?.url || images[0]?.url || null

      // Update vehicle
      const { error: vehicleError } = await supabase
        .from('vehicles')
        .update({
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
          image_url: imageUrl,
        })
        .eq('id', vehicleId)

      if (vehicleError) throw vehicleError

      toast({
        title: 'Success',
        description: 'Vehicle updated successfully',
      })

      router.push('/manufacturer/vehicles')
    } catch (error: any) {
      console.error('Error updating vehicle:', error)
      setError(error.message || 'Failed to update vehicle')
    } finally {
      setLoading(false)
    }
  }

  const updateFormData = (field: string, value: any) => {
    setFormData({ ...formData, [field]: value })
  }

  if (loadingVehicle) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto"></div>
          <p className="mt-2 text-muted-foreground">Loading vehicle...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Edit Vehicle</h1>
        <p className="text-muted-foreground mt-1">
          Update vehicle information and images
        </p>
      </div>

      <form onSubmit={handleSubmit}>
        <Card>
          <CardHeader>
            <CardTitle>Vehicle Information</CardTitle>
            <CardDescription>
              Edit the details of your vehicle listing
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

            {/* Vehicle Images */}
            <div className="space-y-4">
              <h3 className="font-semibold text-lg">Vehicle Images</h3>
              <p className="text-sm text-muted-foreground">
                Upload up to 5 images. The first image will be used as the primary display image.
              </p>
              
              <div className="flex items-center gap-4">
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => fileInputRef.current?.click()}
                  disabled={images.length >= 5 || loading}
                >
                  <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  Add Images ({images.length}/5)
                </Button>
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/jpeg,image/jpg,image/png,image/webp"
                  multiple
                  onChange={handleImageSelect}
                  className="hidden"
                />
                <span className="text-xs text-muted-foreground">
                  JPEG, PNG, or WebP • Max 5MB each
                </span>
              </div>

              {uploadingImages && (
                <div className="space-y-2">
                  <Progress value={uploadProgress} className="h-2" />
                  <p className="text-xs text-muted-foreground text-center">
                    Uploading images... {Math.round(uploadProgress)}%
                  </p>
                </div>
              )}

              {images.length > 0 && (
                <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
                  {images.map((image, index) => (
                    <div key={image.url} className="relative group rounded-lg overflow-hidden border">
                      <img
                        src={image.url}
                        alt={`Image ${index + 1}`}
                        className="w-full h-24 object-cover"
                      />
                      {image.is_primary && (
                        <Badge className="absolute top-1 left-1 text-xs bg-primary">
                          Primary
                        </Badge>
                      )}
                      {image.isNew && (
                        <Badge variant="secondary" className="absolute bottom-1 left-1 text-xs">
                          New
                        </Badge>
                      )}
                      <div className="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-1">
                        {!image.is_primary && (
                          <button
                            type="button"
                            onClick={() => setPrimaryImage(index)}
                            className="p-1.5 bg-white text-black rounded text-xs"
                            title="Set as primary"
                          >
                            Primary
                          </button>
                        )}
                        <button
                          type="button"
                          onClick={() => removeImage(index)}
                          className="p-1.5 bg-destructive text-destructive-foreground rounded"
                          title="Remove"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                          </svg>
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}

              {images.length === 0 && (
                <div 
                  className="border-2 border-dashed border-border rounded-lg p-8 text-center cursor-pointer hover:border-primary/50 transition-colors"
                  onClick={() => fileInputRef.current?.click()}
                >
                  <div className="flex flex-col items-center gap-2">
                    <svg className="w-10 h-10 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    <p className="text-sm text-muted-foreground">
                      Click to upload vehicle images
                    </p>
                    <p className="text-xs text-muted-foreground">
                      First image will be the primary display image
                    </p>
                  </div>
                </div>
              )}
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
                disabled={loading || uploadingImages}
              >
                {loading ? 'Saving...' : uploadingImages ? 'Uploading Images...' : 'Save Changes'}
              </Button>
              <Button
                type="button"
                variant="outline"
                onClick={() => router.push('/manufacturer/vehicles')}
                disabled={loading || uploadingImages}
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
