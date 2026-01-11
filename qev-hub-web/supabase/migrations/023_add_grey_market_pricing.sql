-- Add Grey Market Price Tracking
-- Track pricing from local Qatar grey markets for comparison

-- Add price source tracking to vehicles
ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS grey_market_price DECIMAL(12, 2),
  ADD COLUMN IF NOT EXISTS grey_market_source TEXT,
  ADD COLUMN IF NOT EXISTS grey_market_updated_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS grey_market_url TEXT,
  ADD COLUMN IF NOT EXISTS savings_percentage DECIMAL(5, 2),
  ADD COLUMN IF NOT EXISTS savings_amount DECIMAL(12, 2);

-- Create price_sources table to track where pricing data comes from
CREATE TABLE IF NOT EXISTS price_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  name_ar TEXT,
  type TEXT NOT NULL, -- 'grey_market', 'dealership', 'auction', 'importer'
  url TEXT,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Track price history for analytics
CREATE TABLE IF NOT EXISTS price_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  price_type TEXT NOT NULL, -- 'manufacturer_direct', 'grey_market'
  price DECIMAL(12, 2) NOT NULL,
  source_id UUID REFERENCES price_sources(id),
  recorded_at TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_vehicles_grey_market_price ON vehicles(grey_market_price);
CREATE INDEX IF NOT EXISTS idx_vehicles_savings_percentage ON vehicles(savings_percentage);
CREATE INDEX IF NOT EXISTS idx_price_history_vehicle_id ON price_history(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_price_history_price_type ON price_history(price_type);
CREATE INDEX IF NOT EXISTS idx_price_history_recorded_at ON price_history(recorded_at);

-- Enable RLS
ALTER TABLE price_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE price_history ENABLE ROW LEVEL SECURITY;

-- RLS Policies for price_sources
CREATE POLICY "Public can view active price sources"
  ON price_sources FOR SELECT
  USING (is_active = true);

CREATE POLICY "Admin can manage price sources"
  ON price_sources FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
    )
  );

-- RLS Policies for price_history
CREATE POLICY "Users can view price history"
  ON price_history FOR SELECT
  USING (true);

CREATE POLICY "System can record price history"
  ON price_history FOR INSERT
  WITH CHECK (true);

-- Create triggers
CREATE TRIGGER update_price_sources_updated_at
  BEFORE UPDATE ON price_sources
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert common Qatar grey market price sources
INSERT INTO price_sources (name, name_ar, type, url, description, is_active) VALUES
  (
    'Doha Grey Market',
    'سوق الدوخة الرمادي',
    'grey_market',
    'https://example.com/doha-grey',
    'Major grey market automotive dealer in Doha Industrial Area',
    true
  ),
  (
    'Al Wakra Auto Traders',
    'تجار السيارات الوكرة',
    'grey_market',
    'https://example.com/al-wakra-auto',
    'Grey market vehicle importers in Al Wakra',
    true
  ),
  (
    'Al Rayyan Car Market',
    'سوق سيارات الريان',
    'grey_market',
    'https://example.com/al-rayyan-cars',
    'Vehicle market in Al Rayyan specializing in imported cars',
    true
  ),
  (
    'Lusail Importers',
    'مستوردو لوسيل',
    'grey_market',
    'https://example.com/lusail-import',
    'Vehicle importers in Lusail',
    true
  ),
  (
    'Qatar Dealership Average',
    'متوسط وكالات قطر',
    'dealership',
    NULL,
    'Average pricing from authorized dealerships across Qatar',
    true
  )
ON CONFLICT (name) DO NOTHING;

-- Create function to calculate savings
CREATE OR REPLACE FUNCTION calculate_vehicle_savings()
RETURNS TRIGGER AS $$
BEGIN
  -- Calculate savings if both prices exist
  IF NEW.manufacturer_direct_price IS NOT NULL AND NEW.grey_market_price IS NOT NULL THEN
    NEW.savings_amount := NEW.grey_market_price - NEW.manufacturer_direct_price;
    NEW.savings_percentage := (NEW.savings_amount / NEW.grey_market_price) * 100;
  END IF;

  -- Update timestamp when grey market price changes
  IF (TG_OP = 'UPDATE' AND NEW.grey_market_price IS DISTINCT FROM OLD.grey_market_price) OR TG_OP = 'INSERT' THEN
    NEW.grey_market_updated_at := NOW();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add trigger to automatically calculate savings
DROP TRIGGER IF EXISTS calculate_savings_trigger ON vehicles;
CREATE TRIGGER calculate_savings_trigger
  BEFORE INSERT OR UPDATE OF manufacturer_direct_price, grey_market_price
  ON vehicles
  FOR EACH ROW
  EXECUTE FUNCTION calculate_vehicle_savings();

-- Function to record price history
CREATE OR REPLACE FUNCTION record_price_history()
RETURNS TRIGGER AS $$
BEGIN
  -- Record manufacturer direct price change
  IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.manufacturer_direct_price IS DISTINCT FROM OLD.manufacturer_direct_price) THEN
    IF NEW.manufacturer_direct_price IS NOT NULL THEN
      INSERT INTO price_history (vehicle_id, price_type, price, source_id, notes)
      VALUES (NEW.id, 'manufacturer_direct', NEW.manufacturer_direct_price, NULL, 'Manufacturer direct pricing');
    END IF;
  END IF;

  -- Record grey market price change
  IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.grey_market_price IS DISTINCT FROM OLD.grey_market_price) THEN
    IF NEW.grey_market_price IS NOT NULL THEN
      -- Find source by name if grey_market_source is set
      DECLARE source_record_id UUID;
      BEGIN
        SELECT id INTO source_record_id
        FROM price_sources
        WHERE name = NEW.grey_market_source
        LIMIT 1;
      END;

      INSERT INTO price_history (vehicle_id, price_type, price, source_id, notes)
      VALUES (
        NEW.id,
        'grey_market',
        NEW.grey_market_price,
        source_record_id,
        'Grey market price from: ' || COALESCE(NEW.grey_market_source, 'Unknown')
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add trigger to record price history
DROP TRIGGER IF EXISTS record_price_history_trigger ON vehicles;
CREATE TRIGGER record_price_history_trigger
  AFTER INSERT OR UPDATE OF manufacturer_direct_price, grey_market_price
  ON vehicles
  FOR EACH ROW
  EXECUTE FUNCTION record_price_history();

-- Update existing vehicles with calculated savings
UPDATE vehicles
SET
  savings_amount = COALESCE(grey_market_price, broker_market_price) - manufacturer_direct_price,
  savings_percentage = CASE
    WHEN COALESCE(grey_market_price, broker_market_price) > 0
    THEN ((COALESCE(grey_market_price, broker_market_price) - manufacturer_direct_price) / COALESCE(grey_market_price, broker_market_price)) * 100
    ELSE NULL
  END
WHERE manufacturer_direct_price IS NOT NULL
  AND (grey_market_price IS NOT NULL OR broker_market_price IS NOT NULL);

-- Migrate existing broker_market_price to grey_market_price if grey_market_price is null
UPDATE vehicles
SET
  grey_market_price = broker_market_price,
  grey_market_source = 'Qatar Dealership Average',
  grey_market_updated_at = NOW()
WHERE grey_market_price IS NULL AND broker_market_price IS NOT NULL;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✓ Grey market price tracking added successfully!';
  RAISE NOTICE '✓ Price sources table created with 5 Qatar market sources';
  RAISE NOTICE '✓ Price history tracking enabled';
  RAISE NOTICE '✓ Automatic savings calculation trigger added';
  RAISE NOTICE '✓ Price history recording trigger added';
  RAISE NOTICE '✓ Existing vehicles updated with savings data';
END
$$;
