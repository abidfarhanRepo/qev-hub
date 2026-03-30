-- Migration: Add Stock Images for Vehicles
-- Assigns existing stock images to vehicles that don't have image_url

-- Helper: Update image_url and images JSONB for vehicles matching criteria
-- Using existing stock images from Supabase Storage

-- BYD Vehicles
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND (manufacturer ILIKE '%BYD%' OR manufacturer ILIKE '%BYD Auto%')
  AND (model ILIKE '%ATTO 3%' OR model ILIKE '%Atto 3%');

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND (manufacturer ILIKE '%BYD%' OR manufacturer ILIKE '%BYD Auto%')
  AND (model ILIKE '%HAN%' OR model ILIKE '%Han%');

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND (manufacturer ILIKE '%BYD%' OR manufacturer ILIKE '%BYD Auto%')
  AND (model ILIKE '%DOLPHIN%' OR model ILIKE '%Dolphin%');

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND (manufacturer ILIKE '%BYD%' OR manufacturer ILIKE '%BYD Auto%')
  AND (model ILIKE '%SEAL%' OR model ILIKE '%Seal%');

-- Tesla Vehicles
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Tesla%'
  AND model ILIKE '%Model 3%';

UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-y.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-y.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Tesla%'
  AND model ILIKE '%Model Y%';

-- NIO Vehicles
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/nio-es8.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/nio-es8.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%NIO%'
  AND model ILIKE '%ES%';

-- XPeng Vehicles
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/xpeng-p7i.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/xpeng-p7i.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%XPeng%'
  AND model ILIKE '%P7%';

-- GAC AION Vehicles
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/aion-y-plus.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/aion-y-plus.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND (manufacturer ILIKE '%GAC%' OR manufacturer ILIKE '%AION%' OR manufacturer ILIKE '%Aion%');

-- Hyundai Vehicles (use BYD Atto 3 as placeholder)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Hyundai%';

-- Kia Vehicles (use BYD Atto 3 as placeholder)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Kia%';

-- Porsche Vehicles (use Tesla Model 3 as placeholder for sports cars)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/tesla-model-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Porsche%';

-- Mercedes Vehicles (use BYD Han as placeholder for luxury sedans)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Mercedes%';

-- BMW Vehicles (use BYD Han as placeholder for luxury sedans)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%BMW%';

-- Audi Vehicles (use BYD Han as placeholder)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Audi%';

-- Volvo Vehicles (use BYD Atto 3 as placeholder)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Volvo%';

-- Genesis Vehicles (use BYD Han as placeholder)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-plus.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND manufacturer ILIKE '%Genesis%';

-- Chery/Jaecoo/Omoda Vehicles (use BYD Atto 3 as placeholder)
UPDATE vehicles
SET image_url = 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
    images = jsonb_build_array(
      jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-atto-3.jpg',
        'is_primary', true
      )
    )
WHERE image_url IS NULL
  AND (manufacturer ILIKE '%Chery%' OR manufacturer ILIKE '%Jaecoo%' OR manufacturer ILIKE '%Omoda%');

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✓ Stock images assigned to vehicles without images';
END
$$;
