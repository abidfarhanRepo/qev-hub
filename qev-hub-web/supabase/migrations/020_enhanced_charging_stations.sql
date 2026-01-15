-- Enhanced charging stations table with Tarsheed-style connector information
-- This migration adds support for connector types, operator information, and enhanced amenities

-- Drop existing table if it exists (for clean migration)
DROP TABLE IF EXISTS charging_stations_enhanced CASCADE;

-- Create enhanced charging stations table
CREATE TABLE charging_stations_enhanced (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    operator TEXT,
    area TEXT,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    charger_types TEXT[] DEFAULT '{}',
    total_chargers INTEGER DEFAULT 0,
    available_chargers INTEGER DEFAULT 0,
    power_output_kw DECIMAL(8, 2),
    amenities TEXT[] DEFAULT '{}',
    operating_hours TEXT DEFAULT '24/7',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    pricing_info TEXT,
    phone_number TEXT,
    website_url TEXT,
    image_url TEXT,
    distance_km DECIMAL(8, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_charging_stations_enhanced_location ON charging_stations_enhanced USING GIST (
    ll_to_earth(latitude, longitude)
);

CREATE INDEX idx_charging_stations_enhanced_operator ON charging_stations_enhanced(operator);
CREATE INDEX idx_charging_stations_enhanced_status ON charging_stations_enhanced(status);
CREATE INDEX idx_charging_stations_enhanced_power ON charging_stations_enhanced(power_output_kw);
CREATE INDEX idx_charging_stations_enhanced_available ON charging_stations_enhanced(available_chargers);
CREATE INDEX idx_charging_stations_enhanced_types ON charging_stations_enhanced USING GIN(charger_types);

-- Add PostGIS extension for spatial queries
CREATE EXTENSION IF NOT EXISTS postgis;

-- Add Earth distance functions for location-based queries
CREATE OR REPLACE FUNCTION ll_to_earth(latitude float8, longitude float8)
RETURNS earth
AS '$libdir/earthdistance', 'll_to_earth'
LANGUAGE C IMMUTABLE STRICT;

-- Function to get nearby stations with distance
CREATE OR REPLACE FUNCTION get_stations_nearby(
    lat float8,
    lng float8,
    radius_km float8 DEFAULT 10.0
)
RETURNS TABLE (
    id text,
    name text,
    address text,
    operator text,
    area text,
    latitude decimal,
    longitude decimal,
    charger_types text[],
    total_chargers int,
    available_chargers int,
    power_output_kw decimal,
    amenities text[],
    operating_hours text,
    status text,
    pricing_info text,
    phone_number text,
    website_url text,
    image_url text,
    distance_km float8
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cs.id,
        cs.name,
        cs.address,
        cs.operator,
        cs.area,
        cs.latitude,
        cs.longitude,
        cs.charger_types,
        cs.total_chargers,
        cs.available_chargers,
        cs.power_output_kw,
        cs.amenities,
        cs.operating_hours,
        cs.status,
        cs.pricing_info,
        cs.phone_number,
        cs.website_url,
        cs.image_url,
        (earth_distance(ll_to_earth(lat, lng), ll_to_earth(cs.latitude, cs.longitude)) / 1000.0) as distance_km
    FROM charging_stations_enhanced cs
    WHERE earth_box(ll_to_earth(lat, lng), ll_to_earth(lat, lng), radius_km * 1000.0) @> ll_to_earth(cs.latitude, cs.longitude)
    ORDER BY distance_km;
END;
$$ LANGUAGE plpgsql;

-- Insert Tarsheed station data
INSERT INTO charging_stations_enhanced (id, name, address, operator, area, latitude, longitude, charger_types, total_chargers, available_chargers, power_output_kw, amenities, operating_hours, status, created_at, updated_at) VALUES
-- KAHRAMAA Stations
('tarsheed-1', '60 Al Dafna Street 200 Al Corniche', '60 Al Dafna Street 200 Al Corniche', 'KAHRAMAA', 'Qatar', 25.298590852334748, 51.514394019204715, ARRAY['Type 2', 'CCS'], 5, 3, 22, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),
('tarsheed-3', 'AL BAYT STADIUM', 'Al Bayt Stadium', 'KAHRAMAA', 'Al Khor', 25.652, 51.4875, ARRAY['Type 2', 'CCS'], 2, 1, 150, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),
('tarsheed-4', 'AL CORNICHE ROAD ABB', 'Al Corniche Road', 'ABB', 'Corniche', 25.295, 51.535, ARRAY['Type 2', 'CCS'], 4, 1, 22, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),
('tarsheed-7', 'AL JANOUB STADIUM', 'Al Janoub Stadium', 'KAHRAMAA', 'Al Wakra', 25.158, 51.58, ARRAY['Type 2', 'CCS'], 4, 2, 150, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),
('tarsheed-36', 'KHALIFA STADIUM', 'Khalifa Stadium', 'KAHRAMAA', 'Aspire Zone', 25.2634, 51.4482, ARRAY['Type 2', 'CCS'], 2, 3, 150, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),
('tarsheed-35', 'Katara', 'Katara Cultural Village', 'KAHRAMAA', 'Katara', 25.3594, 51.5265, ARRAY['Type 2', 'CCS'], 2, 2, 22, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),

-- WOQOD Stations (with all 3 connector types)
('tarsheed-2', 'ABU NAKHLA - WOQOD', 'Abu Nakhla', 'WOQOD', 'Abu Nakhla', 25.185, 51.495, ARRAY['Type 2', 'CCS', 'CHAdeMO'], 2, 1, 50, ARRAY['Restroom', 'Parking', 'Convenience Store'], '24/7', 'active', NOW(), NOW()),
('tarsheed-5', 'AL EGLA - WOQOD', 'Al Egla', 'WOQOD', 'Al Egla', 25.295, 51.505, ARRAY['Type 2', 'CCS', 'CHAdeMO'], 4, 3, 50, ARRAY['Restroom', 'Parking', 'Convenience Store'], '24/7', 'active', NOW(), NOW()),
('tarsheed-6', 'AL HILAL - WOQOD', 'Al Hilal', 'WOQOD', 'Al Hilal', 25.2854, 51.531, ARRAY['Type 2', 'CCS', 'CHAdeMO'], 5, 3, 50, ARRAY['Restroom', 'Parking', 'Convenience Store'], '24/7', 'active', NOW(), NOW()),
('tarsheed-18', 'AL WAAB - WOQOD', 'Al Waab', 'WOQOD', 'Al Waab', 25.265, 51.445, ARRAY['Type 2', 'CCS', 'CHAdeMO'], 4, 2, 50, ARRAY['Restroom', 'Parking', 'Convenience Store'], '24/7', 'active', NOW(), NOW()),

-- Premium Locations
('tarsheed-31', 'Grand Hyatt Hotel', 'Grand Hyatt Doha', 'KAHRAMAA', 'West Bay Lagoon', 25.32, 51.532, ARRAY['Type 2', 'CCS'], 3, 1, 22, ARRAY['Restroom', 'WiFi', 'Parking', 'Food'], '24/7', 'active', NOW(), NOW()),
('tarsheed-58', 'W Hotel', 'W Hotel Doha', 'KAHRAMAA', 'West Bay', 25.328, 51.531, ARRAY['Type 2', 'CCS'], 3, 3, 22, ARRAY['Restroom', 'WiFi', 'Parking', 'Food'], '24/7', 'active', NOW(), NOW()),

-- Shopping Malls
('tarsheed-26', 'Doha Festival City - Lower Ground Parking - North', 'Doha Festival City', 'KAHRAMAA', 'Doha Festival City', 25.315, 51.505, ARRAY['Type 2', 'CCS'], 3, 2, 22, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),
('tarsheed-40', 'Mall of Qatar', 'Mall of Qatar', 'KAHRAMAA', 'Al Rayyan', 25.3282, 51.4869, ARRAY['Type 2', 'CCS'], 4, 1, 22, ARRAY['Restroom', 'WiFi', 'Parking', 'Food'], '24/7', 'active', NOW(), NOW()),

-- Education & Government
('tarsheed-10', 'Al Mujabilah Center, Qatar Foundation', 'Education City', 'KAHRAMAA', 'Education City', 25.312, 51.438, ARRAY['Type 2', 'CCS'], 3, 3, 22, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),
('tarsheed-47', 'Qatar University EVC#1', 'Qatar University', 'KAHRAMAA', 'Qatar University', 25.3755, 51.491, ARRAY['Type 2', 'CCS'], 3, 2, 22, ARRAY['Parking'], '24/7', 'active', NOW(), NOW()),

-- Transportation
('tarsheed-34', 'HIA - WOQOD', 'Hamad International Airport', 'WOQOD', 'Airport', 25.2731, 51.608, ARRAY['Type 2', 'CCS', 'CHAdeMO'], 5, 2, 50, ARRAY['Restroom', 'Parking', 'Convenience Store'], '24/7', 'active', NOW(), NOW());

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_charging_stations_enhanced_updated_at 
    BEFORE UPDATE ON charging_stations_enhanced 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE charging_stations_enhanced ENABLE ROW LEVEL SECURITY;

-- Allow public read access to charging stations
CREATE POLICY "Public read access to charging stations" ON charging_stations_enhanced
    FOR SELECT USING (true);

-- Allow authenticated users to update station availability
CREATE POLICY "Authenticated users can update availability" ON charging_stations_enhanced
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Grant permissions
GRANT SELECT ON charging_stations_enhanced TO anon;
GRANT SELECT ON charging_stations_enhanced TO authenticated;
GRANT UPDATE ON charging_stations_enhanced TO authenticated;

-- Create view for public API with sensitive fields hidden
CREATE VIEW public_charging_stations AS
SELECT 
    id,
    name,
    address,
    operator,
    area,
    latitude,
    longitude,
    charger_types,
    total_chargers,
    available_chargers,
    power_output_kw,
    amenities,
    operating_hours,
    status
FROM charging_stations_enhanced
WHERE status = 'active';

-- Grant access to view
GRANT SELECT ON public_charging_stations TO anon;
GRANT SELECT ON public_charging_stations TO authenticated;