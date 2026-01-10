-- Fix RLS policies for manufacturer vehicle management
-- This allows manufacturers to manage their own vehicles

-- Drop existing vehicle policies if they exist
DROP POLICY IF EXISTS "public_vehicles_select" ON vehicles;
DROP POLICY IF EXISTS "Manufacturers can insert own vehicles" ON vehicles;
DROP POLICY IF EXISTS "Manufacturers can update own vehicles" ON vehicles;
DROP POLICY IF EXISTS "Manufacturers can delete own vehicles" ON vehicles;

-- Public can view all vehicles
CREATE POLICY "public_vehicles_select" ON vehicles
  FOR SELECT USING (true);

-- Manufacturers can insert their own vehicles
CREATE POLICY "Manufacturers can insert own vehicles" ON vehicles
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM manufacturers
      WHERE manufacturers.id = vehicles.manufacturer_id
      AND manufacturers.user_id = auth.uid()
    )
  );

-- Manufacturers can update their own vehicles
CREATE POLICY "Manufacturers can update own vehicles" ON vehicles
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM manufacturers
      WHERE manufacturers.id = vehicles.manufacturer_id
      AND manufacturers.user_id = auth.uid()
    )
  );

-- Manufacturers can delete their own vehicles
CREATE POLICY "Manufacturers can delete own vehicles" ON vehicles
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM manufacturers
      WHERE manufacturers.id = vehicles.manufacturer_id
      AND manufacturers.user_id = auth.uid()
    )
  );
