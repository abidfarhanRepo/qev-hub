-- Module A: The Direct Marketplace (B2C)
-- B2C marketplace for international EVs and PHEVs from China
-- Features: Factory direct pricing, manufacturer verification, price transparency

-- Manufacturers/Factories table
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
  verification_status TEXT DEFAULT 'pending', -- pending, verified, rejected, suspended
  verified_at TIMESTAMPTZ,
  verified_by UUID REFERENCES auth.users(id),
  verified_documents JSONB DEFAULT '[]'::jsonb, -- Array of document URLs
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Update vehicles table to support manufacturer relationship
ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS manufacturer_id UUID REFERENCES manufacturers(id) ON DELETE SET NULL;

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS vehicle_type TEXT DEFAULT 'EV', -- EV, PHEV, FCEV

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS origin_country TEXT DEFAULT 'China';

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS manufacturer_direct_price DECIMAL(12, 2);

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS broker_market_price DECIMAL(12, 2);

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS price_transparency_enabled BOOLEAN DEFAULT true;

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS images JSONB DEFAULT '[]'::jsonb;

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS video_url TEXT;

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS brochure_url TEXT;

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS warranty_years INTEGER DEFAULT 5;

ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS warranty_km INTEGER DEFAULT 100000;

-- Manufacturer dashboard stats
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

-- Vehicle inquiries from buyers
CREATE TABLE IF NOT EXISTS vehicle_inquiries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  message TEXT,
  status TEXT DEFAULT 'pending', -- pending, responded, closed
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_manufacturers_user_id ON manufacturers(user_id);
CREATE INDEX IF NOT EXISTS idx_manufacturers_country ON manufacturers(country);
CREATE INDEX IF NOT EXISTS idx_manufacturers_verification_status ON manufacturers(verification_status);
CREATE INDEX IF NOT EXISTS idx_vehicles_manufacturer_id ON vehicles(manufacturer_id);
CREATE INDEX IF NOT EXISTS idx_vehicles_vehicle_type ON vehicles(vehicle_type);
CREATE INDEX IF NOT EXISTS idx_vehicles_origin_country ON vehicles(origin_country);
CREATE INDEX IF NOT EXISTS idx_vehicles_price_transparency ON vehicles(price_transparency_enabled);
CREATE INDEX IF NOT EXISTS idx_vehicle_inquiries_vehicle_id ON vehicle_inquiries(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_vehicle_inquiries_user_id ON vehicle_inquiries(user_id);
CREATE INDEX IF NOT EXISTS idx_manufacturer_stats_manufacturer_id ON manufacturer_stats(manufacturer_id);

-- Enable RLS
ALTER TABLE manufacturers ENABLE ROW LEVEL SECURITY;
ALTER TABLE manufacturer_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicle_inquiries ENABLE ROW LEVEL SECURITY;

-- Manufacturers RLS Policies
CREATE POLICY "Manufacturers can view own profile"
  ON manufacturers FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Manufacturers can insert own profile"
  ON manufacturers FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Manufacturers can update own profile"
  ON manufacturers FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Public can view verified manufacturers"
  ON manufacturers FOR SELECT
  USING (verification_status = 'verified');

-- Manufacturer stats RLS Policies
CREATE POLICY "Manufacturers can view own stats"
  ON manufacturer_stats FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM manufacturers
    WHERE manufacturers.id = manufacturer_stats.manufacturer_id
    AND manufacturers.user_id = auth.uid()
  ));

CREATE POLICY "Manufacturers can update own stats"
  ON manufacturer_stats FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM manufacturers
    WHERE manufacturers.id = manufacturer_stats.manufacturer_id
    AND manufacturers.user_id = auth.uid()
  ));

-- Vehicle inquiries RLS Policies
CREATE POLICY "Users can view own inquiries"
  ON vehicle_inquiries FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create inquiries"
  ON vehicle_inquiries FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Manufacturers can view inquiries for their vehicles"
  ON vehicle_inquiries FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM vehicles
    INNER JOIN manufacturers ON vehicles.manufacturer_id = manufacturers.id
    WHERE vehicles.id = vehicle_inquiries.vehicle_id
    AND manufacturers.user_id = auth.uid()
  ));

-- Create triggers for updated_at
CREATE TRIGGER update_manufacturers_updated_at
  BEFORE UPDATE ON manufacturers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_manufacturer_stats_updated_at
  BEFORE UPDATE ON manufacturer_stats
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vehicle_inquiries_updated_at
  BEFORE UPDATE ON vehicle_inquiries
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert sample China manufacturers
INSERT INTO manufacturers (
  user_id,
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
    (SELECT id FROM auth.users LIMIT 1),
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
    (SELECT id FROM auth.users LIMIT 1),
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
    (SELECT id FROM auth.users LIMIT 1),
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
    (SELECT id FROM auth.users LIMIT 1),
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

-- Insert sample EV and PHEV vehicles from China
UPDATE vehicles
SET 
  manufacturer_id = (SELECT id FROM manufacturers WHERE company_name = 'BYD Auto Co Ltd' LIMIT 1),
  vehicle_type = 'EV',
  origin_country = 'China',
  manufacturer_direct_price = price_qar,
  broker_market_price = price_qar * 1.3,
  price_transparency_enabled = true,
  images = jsonb_build_array(jsonb_build_object('url', COALESCE(image_url, ''))),
  warranty_years = 5,
  warranty_km = 100000
WHERE model = 'Atto 3';

-- Add new China EV/PHEV samples
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
  images,
  description,
  specs,
  stock_count,
  status,
  warranty_years,
  warranty_km
)
SELECT
  m.id as manufacturer_id,
  'GAC AION' as manufacturer,
  'AION Y Plus' as model,
  2024 as year,
  'PHEV' as vehicle_type,
  'China' as origin_country,
  450 as range_km,
  25.5 as battery_kwh,
  135000 as price_qar,
  135000 as manufacturer_direct_price,
  175500 as broker_market_price,
  true as price_transparency_enabled,
  'https://example.com/aion-y-plus.jpg' as image_url,
  jsonb_build_array(jsonb_build_object('url', 'https://example.com/aion-y-plus.jpg')) as images,
  'GAC AION Y Plus is a plug-in hybrid SUV offering excellent efficiency and practical daily driving range with flexible charging options.' as description,
  '{"0-100kmh": "6.8s", "top_speed": "180km/h", "seats": 5, "fuel_tank": "50L"}'::jsonb as specs,
  12 as stock_count,
  'available' as status,
  5 as warranty_years,
  100000 as warranty_km
FROM manufacturers m
WHERE m.company_name = 'GAC AION'
LIMIT 1;

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
  images,
  description,
  specs,
  stock_count,
  status,
  warranty_years,
  warranty_km
)
SELECT
  m.id as manufacturer_id,
  'NIO' as manufacturer,
  'ES8' as model,
  2024 as year,
  'EV' as vehicle_type,
  'China' as origin_country,
  500 as range_km,
  75.0 as battery_kwh,
  210000 as price_qar,
  210000 as manufacturer_direct_price,
  273000 as broker_market_price,
  true as price_transparency_enabled,
  'https://example.com/nio-es8.jpg' as image_url,
  jsonb_build_array(jsonb_build_object('url', 'https://example.com/nio-es8.jpg')) as images,
  'NIO ES8 is a premium electric SUV featuring battery swapping technology, NOMI AI assistant, and up to 500km range on a single charge.' as description,
  '{"0-100kmh": "4.1s", "top_speed": "200km/h", "seats": 7, "autonomous_level": "Level 2+"}'::jsonb as specs,
  8 as stock_count,
  'available' as status,
  5 as warranty_years,
  100000 as warranty_km
FROM manufacturers m
WHERE m.company_name = 'NIO'
LIMIT 1;

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
  images,
  description,
  specs,
  stock_count,
  status,
  warranty_years,
  warranty_km
)
SELECT
  m.id as manufacturer_id,
  'XPeng' as manufacturer,
  'P7i' as model,
  2024 as year,
  'EV' as vehicle_type,
  'China' as origin_country,
  450 as range_km,
  78.2 as battery_kwh,
  165000 as price_qar,
  165000 as manufacturer_direct_price,
  214500 as broker_market_price,
  true as price_transparency_enabled,
  'https://example.com/xpeng-p7i.jpg' as image_url,
  jsonb_build_array(jsonb_build_object('url', 'https://example.com/xpeng-p7i.jpg')) as images,
  'XPeng P7i is a mid-size electric sedan featuring XNGP intelligent assistance and dual-motor all-wheel drive for excellent performance.' as description,
  '{"0-100kmh": "4.6s", "top_speed": "200km/h", "seats": 5, "xngp_level": "XNGP 3.0"}'::jsonb as specs,
  15 as stock_count,
  'available' as status,
  5 as warranty_years,
  100000 as warranty_km
FROM manufacturers m
WHERE m.company_name = 'XPeng'
LIMIT 1;

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
  images,
  description,
  specs,
  stock_count,
  status,
  warranty_years,
  warranty_km
)
SELECT
  m.id as manufacturer_id,
  'BYD Auto Co Ltd' as manufacturer,
  'Han Plus' as model,
  2024 as year,
  'PHEV' as vehicle_type,
  'China' as origin_country,
  1200 as range_km,
  18.3 as battery_kwh,
  115000 as price_qar,
  115000 as manufacturer_direct_price,
  149500 as broker_market_price,
  true as price_transparency_enabled,
  'https://example.com/byd-han-plus.jpg' as image_url,
  jsonb_build_array(jsonb_build_object('url', 'https://example.com/byd-han-plus.jpg')) as images,
  'BYD Han Plus is a plug-in hybrid sedan offering exceptional 1200km total range with flexible fuel and electric power options.' as description,
  '{"electric_range": "200km", "fuel_range": "1000km", "fuel_tank": "48L", "0-100kmh": "7.9s"}'::jsonb as specs,
  20 as stock_count,
  'available' as status,
  5 as warranty_years,
  100000 as warranty_km
FROM manufacturers m
WHERE m.company_name = 'BYD Auto Co Ltd'
LIMIT 1;
