# 🔧 Manual Migration Required

## The SQL migration needs to be run manually in Supabase Dashboard

### Steps:

1. **Go to Supabase Dashboard**: https://supabase.com/dashboard
2. **Select your QEV Hub project**
3. **Navigate to**: SQL Editor (left sidebar)
4. **Click**: "New query"
5. **Paste this SQL**:

```sql
-- Add missing columns to vehicles table for manufacturer features
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
```

6. **Click**: "Run" (or press Ctrl+Enter)
7. **Verify**: You should see "Success. No rows returned"

### Then test again:
```bash
cd /home/pi/Desktop/QEV/qev-hub-web
node scripts/test-manufacturer.js
```

---

## Step 2: Fix RLS Policies (Run this next!)

After running the first migration, run this second one to fix permissions:

```sql
-- Fix RLS policies for manufacturer vehicle management
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
```

### Then test again:
```bash
node scripts/test-manufacturer.js
```

This will add all the missing columns needed for the manufacturer vehicle management system.
