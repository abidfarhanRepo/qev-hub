-- Create charging_stations table
CREATE TABLE IF NOT EXISTS charging_stations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  latitude NUMERIC(10, 8) NOT NULL,
  longitude NUMERIC(11, 8) NOT NULL,
  provider TEXT DEFAULT 'Tarsheed',
  charger_type TEXT,
  power_output_kw NUMERIC(5, 2),
  total_chargers INTEGER DEFAULT 1,
  available_chargers INTEGER,
  status TEXT DEFAULT 'active',
  operating_hours TEXT,
  pricing_info TEXT,
  amenities TEXT[],
  last_scraped_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create charging_sessions table
CREATE TABLE IF NOT EXISTS charging_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  station_id UUID REFERENCES charging_stations(id) ON DELETE SET NULL,
  vehicle_id UUID REFERENCES vehicles(id) ON DELETE SET NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ,
  energy_delivered_kwh NUMERIC(6, 2),
  cost_qar NUMERIC(8, 2),
  payment_method TEXT,
  status TEXT DEFAULT 'in_progress',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE charging_stations ENABLE ROW LEVEL SECURITY;
ALTER TABLE charging_sessions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for charging_stations
CREATE POLICY "charging_stations_select_all" ON charging_stations
  FOR SELECT USING (true);

CREATE POLICY "charging_stations_admin_all" ON charging_stations
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- RLS Policies for charging_sessions
CREATE POLICY "charging_sessions_select_own" ON charging_sessions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "charging_sessions_insert_own" ON charging_sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "charging_sessions_update_own" ON charging_sessions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "charging_sessions_admin_all" ON charging_sessions
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_charging_stations_updated_at
  BEFORE UPDATE ON charging_stations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
