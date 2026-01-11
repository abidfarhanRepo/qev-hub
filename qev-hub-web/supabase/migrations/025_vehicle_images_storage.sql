-- Migration: Vehicle Images Storage
-- Creates Supabase Storage bucket for vehicle images and sets up RLS policies

-- Create storage bucket for vehicle images
-- Public bucket allows frontend to display images without authentication
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'vehicle-images',
  'vehicle-images',
  true,
  5242880,
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
) ON CONFLICT (id) DO NOTHING;

-- RLS Policies for vehicle-images bucket

-- Public read access for all vehicle images
CREATE POLICY "Public can view vehicle images"
ON storage.objects FOR SELECT
TO anon, authenticated
USING (
  bucket_id = 'vehicle-images'
);

-- Admins can upload vehicle images
CREATE POLICY "Admins can upload vehicle images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'vehicle-images' AND
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
  )
);

-- Verified manufacturers can upload images for their vehicles
CREATE POLICY "Verified manufacturers can upload own vehicle images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'vehicle-images' AND
  EXISTS (
    SELECT 1 FROM manufacturers
    WHERE manufacturers.user_id = auth.uid()
    AND manufacturers.verification_status = 'verified'
  )
);

-- Admins can delete vehicle images
CREATE POLICY "Admins can delete vehicle images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'vehicle-images' AND
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
  )
);

-- Manufacturers can delete their own vehicle images
CREATE POLICY "Manufacturers can delete own vehicle images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'vehicle-images' AND
  EXISTS (
    SELECT 1 FROM manufacturers
    WHERE manufacturers.user_id = auth.uid()
    AND manufacturers.verification_status = 'verified'
  )
);

-- Update existing vehicles with correct image URLs
-- These will reference images in Supabase Storage after upload

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-3.jpg',
        'is_primary', true
      )
    )
WHERE manufacturer ILIKE 'Tesla' AND model ILIKE 'Model 3';

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-y.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-y.jpg',
        'is_primary', true
      )
    )
WHERE manufacturer ILIKE 'Tesla' AND model ILIKE 'Model Y';

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
        'is_primary', true
      )
    )
WHERE manufacturer ILIKE '%BYD%' AND model ILIKE 'Atto 3';

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
        'is_primary', true
      )
    )
WHERE manufacturer ILIKE '%BYD%' AND model ILIKE 'Han Plus';

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/nio-es8.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/nio-es8.jpg',
        'is_primary', true
      )
    )
WHERE manufacturer ILIKE 'NIO' AND model ILIKE 'ES8';

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/xpeng-p7i.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/xpeng-p7i.jpg',
        'is_primary', true
      )
    )
WHERE manufacturer ILIKE '%XPeng%' AND model ILIKE 'P7i';

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/aion-y-plus.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/aion-y-plus.jpg',
        'is_primary', true
      )
    )
WHERE manufacturer ILIKE '%GAC%' AND model ILIKE '%AION Y Plus%';

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✓ Vehicle images storage bucket created successfully!';
  RAISE NOTICE '✓ RLS policies configured for public access, admin uploads, and manufacturer uploads';
  RAISE NOTICE '✓ Vehicle image URLs updated in database';
  RAISE NOTICE '✓ Images will be accessible at: https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/{filename}';
END
$$;
