-- Complete Database Setup for QEV Hub
-- Run this in Supabase SQL Editor: https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new

-- Step 1: Create base tables if they don't exist

-- Profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'customer',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Vehicles table (base)
CREATE TABLE IF NOT EXISTS vehicles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  manufacturer TEXT NOT NULL,
  model TEXT NOT NULL,
  year INTEGER NOT NULL,
  range_km INTEGER DEFAULT 0,
  battery_kwh DECIMAL(6, 2) DEFAULT 0,
  price_qar DECIMAL(12, 2) NOT NULL,
  image_url TEXT,
  description TEXT,
  specs JSONB DEFAULT '{}'::jsonb,
  stock_count INTEGER DEFAULT 0,
  status TEXT DEFAULT 'available',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 2: Add new columns for B2C marketplace
DO $$ 
BEGIN
  -- Add manufacturer_id
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='manufacturer_id') THEN
    ALTER TABLE vehicles ADD COLUMN manufacturer_id UUID;
  END IF;
  
  -- Add vehicle_type
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='vehicle_type') THEN
    ALTER TABLE vehicles ADD COLUMN vehicle_type TEXT DEFAULT 'EV';
  END IF;
  
  -- Add origin_country
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='origin_country') THEN
    ALTER TABLE vehicles ADD COLUMN origin_country TEXT DEFAULT 'China';
  END IF;
  
  -- Add manufacturer_direct_price
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='manufacturer_direct_price') THEN
    ALTER TABLE vehicles ADD COLUMN manufacturer_direct_price DECIMAL(12, 2);
  END IF;
  
  -- Add broker_market_price
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='broker_market_price') THEN
    ALTER TABLE vehicles ADD COLUMN broker_market_price DECIMAL(12, 2);
  END IF;
  
  -- Add price_transparency_enabled
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='price_transparency_enabled') THEN
    ALTER TABLE vehicles ADD COLUMN price_transparency_enabled BOOLEAN DEFAULT true;
  END IF;
  
  -- Add images
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='images') THEN
    ALTER TABLE vehicles ADD COLUMN images JSONB DEFAULT '[]'::jsonb;
  END IF;
  
  -- Add video_url
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='video_url') THEN
    ALTER TABLE vehicles ADD COLUMN video_url TEXT;
  END IF;
  
  -- Add brochure_url
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='brochure_url') THEN
    ALTER TABLE vehicles ADD COLUMN brochure_url TEXT;
  END IF;
  
  -- Add warranty_years
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='warranty_years') THEN
    ALTER TABLE vehicles ADD COLUMN warranty_years INTEGER DEFAULT 5;
  END IF;
  
  -- Add warranty_km
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name='vehicles' AND column_name='warranty_km') THEN
    ALTER TABLE vehicles ADD COLUMN warranty_km INTEGER DEFAULT 100000;
  END IF;
END $$;

-- Step 3: Create manufacturers table
CREATE TABLE IF NOT EXISTS manufacturers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  company_name TEXT NOT NULL,
  company_name_ar TEXT,
  logo_url TEXT,
  country TEXT NOT NULL DEFAULT 'China',
  city TEXT,
  region TEXT,
  contact_email TEXT NOT NULL,
  contact_phone TEXT,
  website_url TEXT,
  description TEXT,
  description_ar TEXT,
  business_license TEXT,
  business_license_expiry DATE,
  verification_status TEXT DEFAULT 'pending',
  verified_at TIMESTAMPTZ,
  verified_by UUID REFERENCES auth.users(id),
  verified_documents JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 4: Add foreign key constraint if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'vehicles_manufacturer_id_fkey'
  ) THEN
    ALTER TABLE vehicles 
      ADD CONSTRAINT vehicles_manufacturer_id_fkey 
      FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Step 5: Create supporting tables
CREATE TABLE IF NOT EXISTS manufacturer_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  manufacturer_id UUID NOT NULL REFERENCES manufacturers(id) ON DELETE CASCADE,
  stat_date DATE NOT NULL,
  views_count INTEGER DEFAULT 0,
  inquiries_count INTEGER DEFAULT 0,
  orders_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS vehicle_inquiries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  message TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 6: Create indexes
CREATE INDEX IF NOT EXISTS idx_manufacturers_user_id ON manufacturers(user_id);
CREATE INDEX IF NOT EXISTS idx_manufacturers_country ON manufacturers(country);
CREATE INDEX IF NOT EXISTS idx_manufacturers_verification_status ON manufacturers(verification_status);
CREATE INDEX IF NOT EXISTS idx_vehicles_manufacturer_id ON vehicles(manufacturer_id);
CREATE INDEX IF NOT EXISTS idx_vehicles_vehicle_type ON vehicles(vehicle_type);
CREATE INDEX IF NOT EXISTS idx_vehicles_origin_country ON vehicles(origin_country);
CREATE INDEX IF NOT EXISTS idx_vehicles_status ON vehicles(status);
CREATE INDEX IF NOT EXISTS idx_vehicle_inquiries_vehicle_id ON vehicle_inquiries(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_vehicle_inquiries_user_id ON vehicle_inquiries(user_id);

-- Step 7: Enable RLS
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE manufacturers ENABLE ROW LEVEL SECURITY;
ALTER TABLE manufacturer_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicle_inquiries ENABLE ROW LEVEL SECURITY;

-- Step 8: Create RLS Policies
DROP POLICY IF EXISTS "vehicles_public_read" ON vehicles;
CREATE POLICY "vehicles_public_read" ON vehicles FOR SELECT USING (true);

DROP POLICY IF EXISTS "manufacturers_verified_read" ON manufacturers;
CREATE POLICY "manufacturers_verified_read" ON manufacturers FOR SELECT 
  USING (verification_status = 'verified');

DROP POLICY IF EXISTS "manufacturers_own_read" ON manufacturers;
CREATE POLICY "manufacturers_own_read" ON manufacturers FOR SELECT 
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "manufacturers_own_update" ON manufacturers;
CREATE POLICY "manufacturers_own_update" ON manufacturers FOR UPDATE 
  USING (user_id = auth.uid());

-- Step 9: Insert sample manufacturers
INSERT INTO manufacturers (
  company_name,
  company_name_ar,
  country,
  city,
  region,
  contact_email,
  description,
  verification_status
) VALUES
  (
    'BYD Auto Co Ltd',
    'شركة بي واي دي للسيارات',
    'China',
    'Shenzhen',
    'Guangdong Province',
    'contact@byd.com',
    'BYD is a leading Chinese manufacturer of battery electric vehicles and plug-in hybrids, offering models from compact cars to premium SUVs.',
    'verified'
  ),
  (
    'GAC AION',
    'غاك أيون',
    'China',
    'Guangzhou',
    'Guangdong Province',
    'contact@gac.com.cn',
    'GAC AION specializes in advanced electric vehicles and intelligent mobility solutions.',
    'verified'
  ),
  (
    'NIO',
    'نيو',
    'China',
    'Shanghai',
    'Jiading District',
    'contact@nio.com',
    'NIO is a premium Chinese EV manufacturer known for battery swapping technology and autonomous driving features.',
    'verified'
  ),
  (
    'XPeng',
    'إكس بي إي إن جي',
    'China',
    'Guangzhou',
    'Guangdong Province',
    'contact@xpeng.com',
    'XPeng designs and produces smart EVs with advanced autonomous driving capabilities.',
    'verified'
  )
ON CONFLICT DO NOTHING;

-- Step 10: Insert sample vehicles
INSERT INTO vehicles (
  manufacturer_id,
  manufacturer,
  model,
  year,
  vehicle_type,
  origin_country,
  range_km,
  battery_kwh,
  price_qar,
  manufacturer_direct_price,
  broker_market_price,
  price_transparency_enabled,
  image_url,
  description,
  specs,
  stock_count,
  status,
  warranty_years,
  warranty_km
) VALUES
  -- BYD Atto 3
  (
    (SELECT id FROM manufacturers WHERE company_name = 'BYD Auto Co Ltd' LIMIT 1),
    'BYD',
    'Atto 3',
    2024,
    'EV',
    'China',
    420,
    60.5,
    145000,
    145000,
    188500,
    true,
    'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800',
    'BYD Atto 3 is a compact electric SUV with 420km range, advanced safety features, and modern design.',
    '{"0-100kmh": "7.3s", "top_speed": "160km/h", "seats": 5, "drive": "FWD"}'::jsonb,
    15,
    'available',
    5,
    100000
  ),
  -- BYD Han Plus PHEV
  (
    (SELECT id FROM manufacturers WHERE company_name = 'BYD Auto Co Ltd' LIMIT 1),
    'BYD',
    'Han Plus',
    2024,
    'PHEV',
    'China',
    1200,
    18.3,
    115000,
    115000,
    149500,
    true,
    'https://images.unsplash.com/photo-1617469767053-d3b523a0b982?w=800',
    'BYD Han Plus is a plug-in hybrid sedan offering exceptional 1200km total range with flexible fuel and electric power options.',
    '{"electric_range": "200km", "fuel_range": "1000km", "0-100kmh": "7.9s"}'::jsonb,
    20,
    'available',
    5,
    100000
  ),
  -- GAC AION Y Plus
  (
    (SELECT id FROM manufacturers WHERE company_name = 'GAC AION' LIMIT 1),
    'GAC AION',
    'AION Y Plus',
    2024,
    'PHEV',
    'China',
    450,
    25.5,
    135000,
    135000,
    175500,
    true,
    'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800',
    'GAC AION Y Plus is a plug-in hybrid SUV offering excellent efficiency and practical daily driving range.',
    '{"0-100kmh": "6.8s", "top_speed": "180km/h", "seats": 5}'::jsonb,
    12,
    'available',
    5,
    100000
  ),
  -- NIO ES8
  (
    (SELECT id FROM manufacturers WHERE company_name = 'NIO' LIMIT 1),
    'NIO',
    'ES8',
    2024,
    'EV',
    'China',
    500,
    75.0,
    210000,
    210000,
    273000,
    true,
    'https://images.unsplash.com/photo-1617469767053-d3b523a0b982?w=800',
    'NIO ES8 is a premium electric SUV featuring battery swapping technology, NOMI AI assistant, and up to 500km range.',
    '{"0-100kmh": "4.1s", "top_speed": "200km/h", "seats": 7}'::jsonb,
    8,
    'available',
    5,
    100000
  ),
  -- XPeng P7i
  (
    (SELECT id FROM manufacturers WHERE company_name = 'XPeng' LIMIT 1),
    'XPeng',
    'P7i',
    2024,
    'EV',
    'China',
    450,
    78.2,
    165000,
    165000,
    214500,
    true,
    'https://images.unsplash.com/photo-1617469767053-d3b523a0b982?w=800',
    'XPeng P7i is a mid-size electric sedan featuring XNGP intelligent assistance and dual-motor all-wheel drive.',
    '{"0-100kmh": "4.6s", "top_speed": "200km/h", "seats": 5}'::jsonb,
    15,
    'available',
    5,
    100000
  ),
  -- XPeng G9
  (
    (SELECT id FROM manufacturers WHERE company_name = 'XPeng' LIMIT 1),
    'XPeng',
    'G9',
    2024,
    'EV',
    'China',
    520,
    98.0,
    195000,
    195000,
    253500,
    true,
    'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800',
    'XPeng G9 is a flagship electric SUV with 800V ultra-fast charging and advanced autonomous driving.',
    '{"0-100kmh": "3.9s", "top_speed": "200km/h", "seats": 5}'::jsonb,
    10,
    'available',
    5,
    100000
  )
ON CONFLICT DO NOTHING;

-- Success message
SELECT 'Database setup complete! You now have:' as message,
       (SELECT COUNT(*) FROM manufacturers WHERE verification_status = 'verified') as verified_manufacturers,
       (SELECT COUNT(*) FROM vehicles WHERE status = 'available') as available_vehicles;
