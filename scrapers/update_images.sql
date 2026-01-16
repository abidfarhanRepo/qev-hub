-- Update BYD vehicle images with Supabase Storage URLs

-- Update SEAL Long Range FWD - exterior
UPDATE vehicles
SET images = COALESCE(images, '[]'::jsonb) || jsonb_build_array(
    jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-seal-long-range-fwd-exterior.jpg',
        'type', 'exterior',
        'is_primary', True
    )
)
WHERE make = 'BYD' AND model = 'SEAL' AND trim_level = 'Long Range FWD';

-- Update HAN EV AWD - exterior_front
UPDATE vehicles
SET images = COALESCE(images, '[]'::jsonb) || jsonb_build_array(
    jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-han-ev-awd-exterior_front.jpg',
        'type', 'exterior_front',
        'is_primary', True
    )
)
WHERE make = 'BYD' AND model = 'HAN EV' AND trim_level = 'AWD';

-- Update SEALION 7 Excellence AWD - exterior_front
UPDATE vehicles
SET images = COALESCE(images, '[]'::jsonb) || jsonb_build_array(
    jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-sealion-7-excellence-awd-exterior_front.jpg',
        'type', 'exterior_front',
        'is_primary', True
    )
)
WHERE make = 'BYD' AND model = 'SEALION 7' AND trim_level = 'Excellence AWD';

-- Update SEALION 7 Excellence AWD - exterior_side
UPDATE vehicles
SET images = COALESCE(images, '[]'::jsonb) || jsonb_build_array(
    jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-sealion-7-excellence-awd-exterior_side.jpg',
        'type', 'exterior_side',
        'is_primary', False
    )
)
WHERE make = 'BYD' AND model = 'SEALION 7' AND trim_level = 'Excellence AWD';

-- Update SEALION 7 Excellence AWD - interior
UPDATE vehicles
SET images = COALESCE(images, '[]'::jsonb) || jsonb_build_array(
    jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-sealion-7-excellence-awd-interior.jpg',
        'type', 'interior',
        'is_primary', False
    )
)
WHERE make = 'BYD' AND model = 'SEALION 7' AND trim_level = 'Excellence AWD';

-- Update SEAL 7 DM-i Standard - exterior
UPDATE vehicles
SET images = COALESCE(images, '[]'::jsonb) || jsonb_build_array(
    jsonb_build_object(
        'url', 'https://wmumpqvvoydngcbffozu.supabase.co/storage/v1/object/public/vehicle-images/byd-seal-7-dm-i-standard-exterior.jpg',
        'type', 'exterior',
        'is_primary', True
    )
)
WHERE make = 'BYD' AND model = 'SEAL 7 DM-i' AND trim_level = 'Standard';

