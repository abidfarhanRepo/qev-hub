# 🚀 Quick Start: Vehicle Images Management

## What Was Implemented

✅ **Database Migration** - Creates storage bucket with RLS policies  
✅ **API Routes** - REST endpoints for image management (POST/GET/DELETE)  
✅ **Upload Scripts** - Bulk upload tools for initial setup  
✅ **Documentation** - Complete setup and usage guides  

---

## 📋 Files Created

| File | Purpose |
|-------|---------|
| `supabase/migrations/025_vehicle_images_storage.sql` | Database migration for storage bucket and RLS |
| `src/app/api/admin/vehicles/[id]/images/route.ts` | API routes for image CRUD operations |
| `scripts/simple-upload-images.js` | Basic bulk image upload script |
| `scripts/upload-vehicle-images.js` | Advanced upload with manufacturer URLs |
| `scripts/execute-sql.js` | SQL execution utility |
| `VEHICLE_IMAGES_SETUP.md` | Detailed setup documentation |
| `IMPLEMENTATION_COMPLETE.md` | Full implementation notes |

---

## ⚠️ Action Required: 3 Steps to Complete Setup

### Step 1: Apply Database Migration (Manual)

1. Go to: https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new
2. Copy all SQL from: `supabase/migrations/025_vehicle_images_storage.sql`
3. Paste and run

This creates:
- `vehicle-images` storage bucket
- RLS policies (public read, admin/manufacturer write)
- Updated image URLs for all existing vehicles

### Step 2: Add Service Role Key to `.env.local`

The upload scripts need the service role key to bypass RLS.

1. Go to: https://app.supabase.com/project/wmumpqvvoydngcbffozu/settings/api
2. Copy "service_role" key
3. Add to `.env.local`:

```bash
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

⚠️ **Keep this key secret!** Never commit to git.

### Step 3: Upload Vehicle Images

After adding the service role key, run:

```bash
node scripts/simple-upload-images.js
```

This will download and upload proper vehicle images to Supabase Storage.

---

## 📊 What the System Does

### Storage
- **Bucket**: `vehicle-images`
- **Public**: Yes (no auth needed to view)
- **Size Limit**: 5MB per image
- **Formats**: JPEG, PNG, WebP

### Access Control
| Who Can | Read | Write | Delete |
|----------|-------|-------|--------|
| Public | ✅ | ❌ | ❌ |
| Admins | ✅ | ✅ | ✅ (any) |
| Verified Manufacturers | ✅ | ✅ (own only) | ✅ (own only) |

### API Endpoints
- **POST** `/api/admin/vehicles/[id]/images` - Upload image
- **GET** `/api/admin/vehicles/[id]/images` - Get images
- **DELETE** `/api/admin/vehicles/[id]/images` - Delete image

---

## 🖼️ Vehicle Images Reference

| Vehicle | Expected Filename | Source URL |
|---------|------------------|--------------|
| Tesla Model 3 | `tesla-model-3.jpg` | Motor1.com |
| Tesla Model Y | `tesla-model-y.jpg` | Motor1.com |
| BYD Atto 3 | `byd-atto-3.jpg` | Electrek.co |
| BYD Han Plus | `byd-han-plus.jpg` | AutoExpress |
| NIO ES8 | `nio-es8.jpg` | Unsplash |
| XPeng P7i | `xpeng-p7i.jpg` | Unsplash |
| GAC AION Y Plus | `aion-y-plus.jpg` | Unsplash |

---

## 🔄 Usage Examples

### Upload via cURL

```bash
curl -X POST \
  https://your-domain.com/api/admin/vehicles/{vehicle-id}/images \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@/path/to/image.jpg" \
  -F "isPrimary=true"
```

### Upload via JavaScript

```javascript
const formData = new FormData()
formData.append('file', imageFile)
formData.append('isPrimary', 'true')

const response = await fetch(`/api/admin/vehicles/${vehicleId}/images`, {
  method: 'POST',
  headers: { 'Authorization': `Bearer ${token}` },
  body: formData
})

const result = await response.json()
console.log('Image URL:', result.image.url)
```

---

## 🐛 Troubleshooting

### Upload Fails with "RLS Policy Violation"
**Solution**: Add `SUPABASE_SERVICE_ROLE_KEY` to `.env.local`

### Migration Fails with "Already Exists"
**Solution**: Normal. The migration uses `ON CONFLICT DO NOTHING`

### API Returns "Unauthorized"
**Solution**: Check:
- Token is valid
- User has correct role (admin or verified manufacturer)
- For manufacturers, vehicle belongs to their manufacturer account

### Images Not Displaying in Marketplace
**Solution**: Verify:
- Migration has been run
- Images uploaded to storage
- `image_url` in database matches public URL format

---

## 📚 Documentation Files

- `VEHICLE_IMAGES_SETUP.md` - Detailed API reference and setup guide
- `IMPLEMENTATION_COMPLETE.md` - Full implementation notes
- `AGENTS.md` - Project development guidelines

---

## ✅ Checklist

After completing setup:

- [ ] Migration applied in Supabase Dashboard
- [ ] Service role key added to `.env.local`
- [ ] Images uploaded via script
- [ ] Images displaying in marketplace
- [ ] API endpoints tested
- [ ] Manufacturer portal updated with upload UI

---

## 🎯 Next Steps

1. **Test the API** - Use Postman or curl to test image upload endpoints
2. **Update Manufacturer Portal** - Add image upload UI for manufacturers
3. **Add Image Gallery** - Show multiple images on vehicle detail page
4. **Implement Image Caching** - Consider CDN or Supabase Edge Functions
5. **Add Image Alt Text** - For SEO and accessibility

---

## 🔒 Security Notes

- Service role key bypasses RLS - never use in client-side code
- Anon key has read-only access to storage
- Manufacturers can only upload/delete their own vehicle images
- Public bucket means images are accessible to anyone with the URL
- File size and type validation prevents abuse

---

## 📞 Support

If you encounter issues:

1. Check `IMPLEMENTATION_COMPLETE.md` for detailed notes
2. Review `VEHICLE_IMAGES_SETUP.md` for API documentation
3. Verify migration was applied correctly in Supabase Dashboard
4. Check browser console and server logs for errors

---

**Implementation Date**: January 11, 2026  
**Files Modified/Created**: 7 files  
**Estimated Setup Time**: 10-15 minutes  
