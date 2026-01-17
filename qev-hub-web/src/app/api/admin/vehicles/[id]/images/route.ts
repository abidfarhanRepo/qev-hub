import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

const BUCKET_NAME = 'vehicle-images'

export async function POST(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const vehicleId = params.id
    const formData = await request.formData()
    const file = formData.get('file') as File
    const isPrimary = formData.get('isPrimary') === 'true'
    const authToken = request.headers.get('authorization')?.replace('Bearer ', '')

    if (!file) {
      return NextResponse.json(
        { error: 'No file provided' },
        { status: 400 }
      )
    }

    if (!authToken) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      )
    }

    // Verify user and check permissions
    const { data: { user }, error: authError } = await supabase.auth.getUser(authToken)

    if (authError || !user) {
      return NextResponse.json(
        { error: 'Invalid authentication token' },
        { status: 401 }
      )
    }

    // Get user role
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    const isAdmin = profile?.role === 'admin'

    // Get vehicle details
    const { data: vehicle, error: vehicleError } = await supabase
      .from('vehicles')
      .select('id, manufacturer_id')
      .eq('id', vehicleId)
      .single()

    if (vehicleError || !vehicle) {
      return NextResponse.json(
        { error: 'Vehicle not found' },
        { status: 404 }
      )
    }

    // Check if user is a verified manufacturer for this vehicle
    const { data: manufacturer } = await supabase
      .from('manufacturers')
      .select('id, verification_status')
      .eq('user_id', user.id)
      .eq('id', vehicle.manufacturer_id)
      .single()

    const isVerifiedManufacturer = manufacturer?.verification_status === 'verified'

    // Authorization check: must be admin or verified manufacturer
    if (!isAdmin && !isVerifiedManufacturer) {
      return NextResponse.json(
        { error: 'Unauthorized. Only admins and verified manufacturers can upload images.' },
        { status: 403 }
      )
    }

    // Validate file type
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
    if (!allowedTypes.includes(file.type)) {
      return NextResponse.json(
        { error: 'Invalid file type. Only JPEG, PNG, and WebP are allowed.' },
        { status: 400 }
      )
    }

    // Validate file size (max 5MB)
    const maxSize = 5 * 1024 * 1024
    if (file.size > maxSize) {
      return NextResponse.json(
        { error: 'File too large. Maximum size is 5MB.' },
        { status: 400 }
      )
    }

    // Generate filename: {manufacturer}-{model}-{timestamp}.{ext}
    const ext = file.name.split('.').pop() || 'jpg'
    const timestamp = Date.now()
    const filename = `vehicle-${vehicleId}-${timestamp}.${ext}`

    // Convert file to buffer
    const arrayBuffer = await file.arrayBuffer()
    const buffer = Buffer.from(arrayBuffer)

    // Upload to Supabase Storage
    const { data: uploadData, error: uploadError } = await supabase
      .storage
      .from(BUCKET_NAME)
      .upload(filename, buffer, {
        contentType: file.type,
        upsert: true
      })

    if (uploadError) {
      console.error('Upload error:', uploadError)
      return NextResponse.json(
        { error: 'Failed to upload image to storage' },
        { status: 500 }
      )
    }

    // Get public URL
    const { data: { publicUrl } } = supabase
      .storage
      .from(BUCKET_NAME)
      .getPublicUrl(filename)

    // Update vehicle with new image
    if (isPrimary) {
      // Get current vehicle images first
      const { data: currentVehicle } = await supabase
        .from('vehicles')
        .select('images')
        .eq('id', vehicleId)
        .single()

      let newImages: Array<{url: string, is_primary: boolean}>
      const currentImages = (currentVehicle?.images || []) as Array<{url: string, is_primary: boolean}>

      if (currentImages.length === 0) {
        // No existing images, create new array with primary image
        newImages = [{ url: publicUrl, is_primary: true }]
      } else {
        // Set all existing images to non-primary and add new primary
        newImages = currentImages.map(img => ({ ...img, is_primary: false }))
        newImages.unshift({ url: publicUrl, is_primary: true })
      }

      // Set as primary image in image_url and update images array
      const { error: updateError } = await supabase
        .from('vehicles')
        .update({
          image_url: publicUrl,
          images: newImages
        })
        .eq('id', vehicleId)

      if (updateError) {
        console.error('Update error:', updateError)
        // Fallback: simpler update if complex query fails
        await supabase
          .from('vehicles')
          .update({
            image_url: publicUrl
          })
          .eq('id', vehicleId)
      }
    } else {
      // Just add to images array
      const { data: currentVehicle } = await supabase
        .from('vehicles')
        .select('images')
        .eq('id', vehicleId)
        .single()

      const currentImages = currentVehicle?.images || []
      const newImages = [
        ...currentImages,
        { url: publicUrl, is_primary: false }
      ]

      await supabase
        .from('vehicles')
        .update({ images: newImages })
        .eq('id', vehicleId)
    }

    return NextResponse.json({
      success: true,
      image: {
        url: publicUrl,
        filename: filename,
        isPrimary: isPrimary
      }
    })

  } catch (error) {
    console.error('Error uploading image:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const vehicleId = params.id
    const authToken = request.headers.get('authorization')?.replace('Bearer ', '')

    if (!authToken) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      )
    }

    // Verify user
    const { data: { user }, error: authError } = await supabase.auth.getUser(authToken)

    if (authError || !user) {
      return NextResponse.json(
        { error: 'Invalid authentication token' },
        { status: 401 }
      )
    }

    // Get user role
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    const isAdmin = profile?.role === 'admin'

    // Get vehicle and manufacturer
    const { data: vehicle } = await supabase
      .from('vehicles')
      .select('id, manufacturer_id, images')
      .eq('id', vehicleId)
      .single()

    if (!vehicle) {
      return NextResponse.json(
        { error: 'Vehicle not found' },
        { status: 404 }
      )
    }

    // Check if user is a verified manufacturer for this vehicle
    const { data: manufacturer } = await supabase
      .from('manufacturers')
      .select('id, verification_status')
      .eq('user_id', user.id)
      .eq('id', vehicle.manufacturer_id)
      .single()

    const isVerifiedManufacturer = manufacturer?.verification_status === 'verified'

    // Authorization check
    if (!isAdmin && !isVerifiedManufacturer) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 403 }
      )
    }

    return NextResponse.json({
      success: true,
      images: vehicle.images || []
    })

  } catch (error) {
    console.error('Error fetching images:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const vehicleId = params.id
    const body = await request.json()
    const { imageUrl } = body
    const authToken = request.headers.get('authorization')?.replace('Bearer ', '')

    if (!imageUrl) {
      return NextResponse.json(
        { error: 'Image URL is required' },
        { status: 400 }
      )
    }

    if (!authToken) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      )
    }

    // Verify user
    const { data: { user }, error: authError } = await supabase.auth.getUser(authToken)

    if (authError || !user) {
      return NextResponse.json(
        { error: 'Invalid authentication token' },
        { status: 401 }
      )
    }

    // Get user role
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    const isAdmin = profile?.role === 'admin'

    // Get vehicle and manufacturer
    const { data: vehicle } = await supabase
      .from('vehicles')
      .select('id, manufacturer_id, images')
      .eq('id', vehicleId)
      .single()

    if (!vehicle) {
      return NextResponse.json(
        { error: 'Vehicle not found' },
        { status: 404 }
      )
    }

    // Check if user is a verified manufacturer for this vehicle
    const { data: manufacturer } = await supabase
      .from('manufacturers')
      .select('id, verification_status')
      .eq('user_id', user.id)
      .eq('id', vehicle.manufacturer_id)
      .single()

    const isVerifiedManufacturer = manufacturer?.verification_status === 'verified'

    // Authorization check
    if (!isAdmin && !isVerifiedManufacturer) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 403 }
      )
    }

    // Delete from storage
    const filename = imageUrl.split('/').pop()
    const { error: deleteError } = await supabase
      .storage
      .from(BUCKET_NAME)
      .remove([filename])

    if (deleteError) {
      console.error('Storage delete error:', deleteError)
    }

    // Remove from vehicle images array
    const filteredImages = (vehicle.images || []).filter((img: any) => img.url !== imageUrl)

    // Update image_url if primary image was deleted
    const newPrimaryImage = filteredImages.find((img: any) => img.is_primary) || filteredImages[0]

    await supabase
      .from('vehicles')
      .update({
        images: filteredImages,
        image_url: newPrimaryImage?.url || null
      })
      .eq('id', vehicleId)

    return NextResponse.json({
      success: true,
      message: 'Image deleted successfully'
    })

  } catch (error) {
    console.error('Error deleting image:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const vehicleId = params.id
    const body = await request.json()
    const { imageUrl, isPrimary } = body
    const authToken = request.headers.get('authorization')?.replace('Bearer ', '')

    if (!imageUrl) {
      return NextResponse.json(
        { error: 'Image URL is required' },
        { status: 400 }
      )
    }

    if (!authToken) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      )
    }

    // Verify user
    const { data: { user }, error: authError } = await supabase.auth.getUser(authToken)

    if (authError || !user) {
      return NextResponse.json(
        { error: 'Invalid authentication token' },
        { status: 401 }
      )
    }

    // Get user role
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    const isAdmin = profile?.role === 'admin'

    // Get vehicle and manufacturer
    const { data: vehicle } = await supabase
      .from('vehicles')
      .select('id, manufacturer_id, images')
      .eq('id', vehicleId)
      .single()

    if (!vehicle) {
      return NextResponse.json(
        { error: 'Vehicle not found' },
        { status: 404 }
      )
    }

    // Check if user is a verified manufacturer for this vehicle
    const { data: manufacturer } = await supabase
      .from('manufacturers')
      .select('id, verification_status')
      .eq('user_id', user.id)
      .eq('id', vehicle.manufacturer_id)
      .single()

    const isVerifiedManufacturer = manufacturer?.verification_status === 'verified'

    // Authorization check
    if (!isAdmin && !isVerifiedManufacturer) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 403 }
      )
    }

    // Update images array to set new primary
    const updatedImages = (vehicle.images || []).map((img: any) => ({
      ...img,
      is_primary: img.url === imageUrl ? isPrimary : (isPrimary ? false : img.is_primary)
    }))

    // Update vehicle
    await supabase
      .from('vehicles')
      .update({
        images: updatedImages,
        image_url: isPrimary ? imageUrl : vehicle.images?.find((img: any) => img.is_primary)?.url || imageUrl
      })
      .eq('id', vehicleId)

    return NextResponse.json({
      success: true,
      message: 'Image updated successfully'
    })

  } catch (error) {
    console.error('Error updating image:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
