# Vehicle Images Management System

## Overview

This document explains the vehicle image management system implemented for QEV Hub, which includes:

- Supabase Storage bucket for vehicle images
- Database migration for proper image URLs
- API routes for admin and manufacturer image uploads
- Bulk upload script for initial image setup

---

## Step 1: Apply Database Migration

### Option A: Via Supabase Dashboard (Recommended)

1. Go to Supabase SQL Editor: https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new
2. Copy the SQL from: `supabase/migrations/025_vehicle_images_storage.sql`
3. Paste and run the SQL

This will:
- Create `vehicle-images` storage bucket
- Set up RLS policies (public read, admin/manufacturer write)
- Update all existing vehicles with correct image URLs

### Option B: Via Supabase CLI

If you have Supabase CLI installed:

```bash
# Install CLI (if not installed)
npm install -g supabase

# Link project (if not linked)
supabase link --project-ref wmumpqvvoydngcbffozu

# Apply migration
supabase db push
```

---

## Step 2: Upload Vehicle Images

After applying the migration, upload the vehicle images using:

```bash
node scripts/simple-upload-images.js
```

This will download proper vehicle images and upload them to Supabase Storage.

### Images to be uploaded:

| Filename | Vehicle | Source |
|----------|-----------|---------|
| tesla-model-3.jpg | Tesla Model 3 | Motor1.com |
| tesla-model-y.jpg | Tesla Model Y | Motor1.com |
| byd-atto-3.jpg | BYD Atto 3 | Electrek.co |
| byd-han-plus.jpg | BYD Han Plus | AutoExpress |
| nio-es8.jpg | NIO ES8 | Unsplash |
| xpeng-p7i.jpg | XPeng P7i | Unsplash |
| aion-y-plus.jpg | GAC AION Y Plus | Unsplash |

---

## API Endpoints

### Upload Vehicle Image

**POST** `/api/admin/vehicles/[id]/images`

Upload an image for a specific vehicle.

**Headers:**
- `Authorization: Bearer <token>`

**Body (FormData):**
- `file`: Image file (JPEG, PNG, or WebP, max 5MB)
- `isPrimary`: `true` or `false` (optional, default false)

**Response:**
```json
{
  "success": true,
  "image": {
    "url": "https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/vehicle-xxx-1234567890.jpg",
    "filename": "vehicle-xxx-1234567890.jpg",
    "isPrimary": true
  }
}
```

**Authorization:**
- **Admins**: Can upload images for any vehicle
- **Verified Manufacturers**: Can upload images for their own vehicles

### Get Vehicle Images

**GET** `/api/admin/vehicles/[id]/images`

Get all images for a vehicle.

**Headers:**
- `Authorization: Bearer <token>`

**Response:**
```json
{
  "success": true,
  "images": [
    {
      "url": "https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/...",
      "is_primary": true
    }
  ]
}
```

### Delete Vehicle Image

**DELETE** `/api/admin/vehicles/[id]/images`

Delete an image from a vehicle.

**Headers:**
- `Authorization: Bearer <token>`

**Body:**
```json
{
  "imageUrl": "https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/..."
}
```

**Response:**
```json
{
  "success": true,
  "message": "Image deleted successfully"
}
```

---

## File Naming Convention

When uploading via API, images are automatically named: `vehicle-{vehicleId}-{timestamp}.{ext}`

For manual uploads, use the convention: `{manufacturer}-{model}.{ext}`

Examples:
- `tesla-model-3.jpg`
- `byd-atto-3.jpg`
- `nio-es8.jpg`

---

## Storage Configuration

**Bucket:** `vehicle-images`
**Public:** Yes (images accessible without auth)
**Max File Size:** 5MB per image
**Allowed Types:** JPEG, PNG, WebP

**RLS Policies:**

| Policy | Description | Access |
|--------|-------------|---------|
| Public can view vehicle images | Anyone can view images | `anon`, `authenticated` (SELECT) |
| Admins can upload vehicle images | Admins can upload any image | `authenticated` (INSERT) |
| Verified manufacturers can upload own vehicle images | Manufacturers can upload for their vehicles | `authenticated` (INSERT) |
| Admins can delete vehicle images | Admins can delete any image | `authenticated` (DELETE) |
| Manufacturers can delete own vehicle images | Manufacturers can delete their images | `authenticated` (DELETE) |

---

## Public URL Format

All images are accessible at:
```
https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/{filename}
```

Example:
```
https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-3.jpg
```

---

## Usage Examples

### Upload via cURL

```bash
curl -X POST \
  https://qev-hub.com/api/admin/vehicles/{vehicle-id}/images \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@/path/to/image.jpg" \
  -F "isPrimary=true"
```

### Upload via JavaScript (Frontend)

```javascript
const formData = new FormData()
formData.append('file', imageFile)
formData.append('isPrimary', 'true')

const response = await fetch('/api/admin/vehicles/${vehicleId}/images', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`
  },
  body: formData
})

const result = await response.json()
console.log('Image URL:', result.image.url)
```

---

## Troubleshooting

### Error: "Bucket already exists"

This is normal. The migration uses `ON CONFLICT DO NOTHING` to avoid errors.

### Error: "Unauthorized"

Make sure:
- You're using a valid auth token
- You're either an admin or a verified manufacturer
- For manufacturers, the vehicle belongs to your manufacturer account

### Error: "File too large"

Maximum file size is 5MB. Compress or resize the image before uploading.

### Error: "Invalid file type"

Only JPEG, PNG, and WebP formats are allowed.

---

## Next Steps

After completing this setup:

1. ✅ Run the migration in Supabase Dashboard
2. ✅ Run the upload script to populate images
3. ✅ Verify images appear correctly in the marketplace
4. ✅ Test the API endpoints for uploads/deletes
5. ✅ Update manufacturer portal to include image upload UI

---

## Files Created

- `supabase/migrations/025_vehicle_images_storage.sql` - Database migration
- `src/app/api/admin/vehicles/[id]/images/route.ts` - Image management API
- `scripts/simple-upload-images.js` - Bulk image upload script
- `scripts/upload-vehicle-images.js` - Advanced upload script with manufacturer URLs
