'use client'

import { useState, useRef, useEffect, useCallback } from 'react'
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Progress } from '@/components/ui/progress'
import { useToast } from '@/components/ui/use-toast'

interface ImageUploadProps {
  vehicleId?: string
  existingImages?: Array<{ url: string; is_primary: boolean }>
  onImageUpload?: (imageUrl: string, isPrimary: boolean) => void
  onImageDelete?: (imageUrl: string) => void
  maxImages?: number
}

export function VehicleImageUpload({
  vehicleId,
  existingImages = [],
  onImageUpload,
  onImageDelete,
  maxImages = 5
}: ImageUploadProps) {
  const { toast } = useToast()
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [uploading, setUploading] = useState(false)
  const [uploadProgress, setUploadProgress] = useState(0)
  const [images, setImages] = useState<Array<{ url: string; is_primary: boolean }>>(existingImages)
  const [pendingFiles, setPendingFiles] = useState<File[]>([])
  // Track blob URLs for cleanup to prevent memory leaks
  const blobUrlsRef = useRef<Set<string>>(new Set())

  // Cleanup blob URLs on unmount to prevent memory leaks
  useEffect(() => {
    return () => {
      blobUrlsRef.current.forEach(url => {
        URL.revokeObjectURL(url)
      })
      blobUrlsRef.current.clear()
    }
  }, [])

  const handleFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || [])
    
    // Validate files
    const validFiles = files.filter(file => {
      if (!['image/jpeg', 'image/jpg', 'image/png', 'image/webp'].includes(file.type)) {
        toast({
          title: 'Invalid file type',
          description: `${file.name} is not a valid image. Only JPEG, PNG, and WebP are allowed.`,
          variant: 'destructive'
        })
        return false
      }
      if (file.size > 5 * 1024 * 1024) {
        toast({
          title: 'File too large',
          description: `${file.name} is too large. Maximum size is 5MB.`,
          variant: 'destructive'
        })
        return false
      }
      return true
    })

    if (images.length + validFiles.length > maxImages) {
      toast({
        title: 'Too many images',
        description: `You can only upload up to ${maxImages} images.`,
        variant: 'destructive'
      })
      return
    }

    // If we have a vehicleId, upload immediately
    if (vehicleId) {
      await uploadFiles(validFiles)
    } else {
      // Store pending files for later upload
      setPendingFiles([...pendingFiles, ...validFiles])
      // Create preview URLs and track them for cleanup
      const newImages = validFiles.map((file, index) => {
        const blobUrl = URL.createObjectURL(file)
        blobUrlsRef.current.add(blobUrl)
        return {
          url: blobUrl,
          is_primary: images.length === 0 && index === 0,
          file
        }
      })
      setImages([...images, ...newImages])
    }
  }

  const uploadFiles = async (files: File[]) => {
    if (!vehicleId) return

    setUploading(true)
    setUploadProgress(0)

    try {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) {
        throw new Error('Not authenticated')
      }

      const totalFiles = files.length
      let uploadedCount = 0

      for (const file of files) {
        const formData = new FormData()
        formData.append('file', file)
        formData.append('isPrimary', (images.length === 0 && uploadedCount === 0).toString())

        const response = await fetch(`/api/admin/vehicles/${vehicleId}/images`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${session.access_token}`
          },
          body: formData
        })

        const result = await response.json()

        if (!response.ok) {
          throw new Error(result.error || 'Upload failed')
        }

        const newImage = { url: result.image.url, is_primary: result.image.isPrimary }
        setImages(prev => [...prev, newImage])
        onImageUpload?.(result.image.url, result.image.isPrimary)

        uploadedCount++
        setUploadProgress((uploadedCount / totalFiles) * 100)
      }

      toast({
        title: 'Upload complete',
        description: `${totalFiles} image(s) uploaded successfully`
      })
    } catch (error: any) {
      console.error('Upload error:', error)
      toast({
        title: 'Upload failed',
        description: error.message || 'Failed to upload images',
        variant: 'destructive'
      })
    } finally {
      setUploading(false)
      setUploadProgress(0)
    }
  }

  const handleDelete = async (imageUrl: string) => {
    if (!vehicleId) {
      // For pending files, revoke blob URL and remove from state
      if (imageUrl.startsWith('blob:')) {
        URL.revokeObjectURL(imageUrl)
        blobUrlsRef.current.delete(imageUrl)
      }
      setImages(images.filter(img => img.url !== imageUrl))
      // Find and remove the corresponding pending file by matching stored URL
      const imageToRemove = images.find(img => img.url === imageUrl)
      if (imageToRemove) {
        setPendingFiles(prev => prev.filter((_, idx) => {
          const storedUrl = images[existingImages.length + idx]?.url
          return storedUrl !== imageUrl
        }))
      }
      return
    }

    try {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) throw new Error('Not authenticated')

      const response = await fetch(`/api/admin/vehicles/${vehicleId}/images`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${session.access_token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ imageUrl })
      })

      const result = await response.json()

      if (!response.ok) {
        throw new Error(result.error || 'Delete failed')
      }

      setImages(images.filter(img => img.url !== imageUrl))
      onImageDelete?.(imageUrl)

      toast({
        title: 'Image deleted',
        description: 'Image removed successfully'
      })
    } catch (error: any) {
      console.error('Delete error:', error)
      toast({
        title: 'Delete failed',
        description: error.message || 'Failed to delete image',
        variant: 'destructive'
      })
    }
  }

  const handleSetPrimary = async (imageUrl: string) => {
    if (!vehicleId) {
      // For pending files, just update local state
      setImages(images.map(img => ({
        ...img,
        is_primary: img.url === imageUrl
      })))
      return
    }

    try {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) throw new Error('Not authenticated')

      // Delete and re-upload as primary
      const response = await fetch(`/api/admin/vehicles/${vehicleId}/images`, {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${session.access_token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ imageUrl, isPrimary: true })
      })

      if (response.ok) {
        setImages(images.map(img => ({
          ...img,
          is_primary: img.url === imageUrl
        })))

        toast({
          title: 'Primary image updated',
          description: 'Image set as primary'
        })
      }
    } catch (error: any) {
      console.error('Set primary error:', error)
    }
  }

  // Upload pending files when vehicleId becomes available
  const uploadPendingFiles = async (newVehicleId: string) => {
    if (pendingFiles.length === 0) return

    const formData = new FormData()
    pendingFiles.forEach((file, index) => {
      formData.append('file', file)
      formData.append('isPrimary', (index === 0).toString())
    })

    // Use the API to upload
    try {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) throw new Error('Not authenticated')

      for (let i = 0; i < pendingFiles.length; i++) {
        const file = pendingFiles[i]
        const formData = new FormData()
        formData.append('file', file)
        formData.append('isPrimary', (i === 0).toString())

        await fetch(`/api/admin/vehicles/${newVehicleId}/images`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${session.access_token}`
          },
          body: formData
        })
      }
    } catch (error) {
      console.error('Error uploading pending files:', error)
    }
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <label className="text-sm font-medium">
          Vehicle Images ({images.length}/{maxImages})
        </label>
        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => fileInputRef.current?.click()}
          disabled={uploading || images.length >= maxImages}
        >
          {uploading ? 'Uploading...' : 'Add Images'}
        </Button>
        <input
          ref={fileInputRef}
          type="file"
          accept="image/jpeg,image/jpg,image/png,image/webp"
          multiple
          onChange={handleFileSelect}
          className="hidden"
        />
      </div>

      {uploading && (
        <div className="space-y-2">
          <Progress value={uploadProgress} className="h-2" />
          <p className="text-xs text-muted-foreground text-center">
            Uploading... {Math.round(uploadProgress)}%
          </p>
        </div>
      )}

      {images.length > 0 ? (
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          {images.map((image, index) => (
            <Card key={image.url} className="relative overflow-hidden group">
              <CardContent className="p-0">
                <img
                  src={image.url}
                  alt={`Vehicle image ${index + 1}`}
                  className="w-full h-32 object-cover"
                />
                {image.is_primary && (
                  <Badge className="absolute top-2 left-2 bg-primary text-xs">
                    Primary
                  </Badge>
                )}
                <div className="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-2">
                  {!image.is_primary && (
                    <Button
                      type="button"
                      size="sm"
                      variant="secondary"
                      onClick={() => handleSetPrimary(image.url)}
                    >
                      Set Primary
                    </Button>
                  )}
                  <Button
                    type="button"
                    size="sm"
                    variant="destructive"
                    onClick={() => handleDelete(image.url)}
                  >
                    Delete
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        <div 
          className="border-2 border-dashed border-border rounded-lg p-8 text-center cursor-pointer hover:border-primary/50 transition-colors"
          onClick={() => fileInputRef.current?.click()}
        >
          <div className="flex flex-col items-center gap-2">
            <svg className="w-10 h-10 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
            <p className="text-sm text-muted-foreground">
              Click to upload images
            </p>
            <p className="text-xs text-muted-foreground">
              JPEG, PNG, or WebP • Max 5MB each
            </p>
          </div>
        </div>
      )}

      {/* Export pending files uploader for parent component */}
      <input type="hidden" data-pending-count={pendingFiles.length} />
    </div>
  )
}

// Export the upload function for use after vehicle creation
export async function uploadVehicleImages(
  vehicleId: string,
  files: File[],
  accessToken: string
): Promise<string[]> {
  const uploadedUrls: string[] = []

  for (let i = 0; i < files.length; i++) {
    const file = files[i]
    const formData = new FormData()
    formData.append('file', file)
    formData.append('isPrimary', (i === 0).toString())

    const response = await fetch(`/api/admin/vehicles/${vehicleId}/images`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${accessToken}`
      },
      body: formData
    })

    if (response.ok) {
      const result = await response.json()
      uploadedUrls.push(result.image.url)
    }
  }

  return uploadedUrls
}
