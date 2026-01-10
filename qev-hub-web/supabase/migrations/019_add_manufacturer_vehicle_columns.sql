-- Add missing columns to vehicles table for manufacturer features
-- This migration adds all columns needed by the manufacturer vehicle management system

-- Add missing columns if they don't exist
ALTER TABLE vehicles 
  ADD COLUMN IF NOT EXISTS make TEXT,
  ADD COLUMN IF NOT EXISTS model TEXT,
  ADD COLUMN IF NOT EXISTS price NUMERIC(12, 2),
  ADD COLUMN IF NOT EXISTS availability TEXT DEFAULT 'available',
  ADD COLUMN IF NOT EXISTS battery_capacity NUMERIC(6, 2),
  ADD COLUMN IF NOT EXISTS range INTEGER,
  ADD COLUMN IF NOT EXISTS charging_time TEXT,
  ADD COLUMN IF NOT EXISTS top_speed INTEGER,
  ADD COLUMN IF NOT EXISTS acceleration TEXT,
  ADD COLUMN IF NOT EXISTS seating_capacity INTEGER DEFAULT 5,
  ADD COLUMN IF NOT EXISTS cargo_space INTEGER;

-- Migrate data from old columns to new ones
UPDATE vehicles SET make = manufacturer WHERE make IS NULL AND manufacturer IS NOT NULL;
UPDATE vehicles SET price = price_qar WHERE price IS NULL AND price_qar IS NOT NULL;

-- Make required columns NOT NULL after populating them
ALTER TABLE vehicles ALTER COLUMN make SET NOT NULL;
ALTER TABLE vehicles ALTER COLUMN model SET NOT NULL;
ALTER TABLE vehicles ALTER COLUMN price SET NOT NULL;

-- Create index on commonly queried columns
CREATE INDEX IF NOT EXISTS idx_vehicles_make ON vehicles(make);
CREATE INDEX IF NOT EXISTS idx_vehicles_model ON vehicles(model);
CREATE INDEX IF NOT EXISTS idx_vehicles_availability ON vehicles(availability);
