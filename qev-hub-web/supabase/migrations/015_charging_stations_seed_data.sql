-- Add charging stations sample data to QEV Hub
-- This migration adds 15 charging stations across Qatar
-- Run this in Supabase SQL Editor: https://app.supabase.com

INSERT INTO charging_stations (name, address, latitude, longitude, provider, charger_type, power_output_kw, total_chargers, available_chargers, status, operating_hours, pricing_info, amenities)
VALUES
(
  'KAHRAMAA EV Charging Station - Katara',
  'Katara Cultural Village, Doha, Qatar',
  25.3548,
  51.5326,
  'KAHRAMAA',
  'Type 2 / CCS',
  50.00,
  4,
  2,
  'active',
  '24/7',
  'Free (KAHRAMAA initiative)',
  ARRAY['Restaurant', 'WiFi', 'Restroom', 'Parking']
),
(
  'KAHRAMAA EV Charging - The Pearl',
  'Porto Arabia, The Pearl, Doha, Qatar',
  25.3714,
  51.5504,
  'KAHRAMAA',
  'Type 2 / CHAdeMO',
  50.00,
  2,
  1,
  'active',
  '24/7',
  'Free (KAHRAMAA initiative)',
  ARRAY['Shopping', 'Dining', 'Parking', 'WiFi']
),
(
  'KAHRAMAA Charging Hub - Lusail',
  'Lusail Boulevard, Lusail City, Qatar',
  25.4192,
  51.4966,
  'KAHRAMAA',
  'Type 2 / CCS / CHAdeMO',
  150.00,
  6,
  4,
  'active',
  '24/7',
  'Free (KAHRAMAA initiative)',
  ARRAY['Mall', 'Entertainment', 'Parking', 'WiFi', 'Cafe']
),
(
  'EV Charging Station - Villaggio Mall',
  'Villaggio Mall, Al Waab Street, Doha, Qatar',
  25.2854,
  51.4421,
  'Private',
  'Type 2',
  22.00,
  4,
  3,
  'active',
  '10:00 - 23:00',
  '15 QAR/hour',
  ARRAY['Shopping', 'Dining', 'Restroom', 'Parking']
),
(
  'Charging Station - City Center Mall',
  'City Center Doha, West Bay, Qatar',
  25.2867,
  51.5335,
  'Private',
  'Type 2 / CCS',
  50.00,
  3,
  2,
  'active',
  '09:00 - 00:00',
  '20 QAR/hour',
  ARRAY['Shopping', 'Dining', 'Restroom', 'Parking', 'Cinema']
),
(
  'EV Charger - Doha Festival City',
  'Doha Festival City, Al Rayyan, Qatar',
  25.2585,
  51.5405,
  'Private',
  'Type 2',
  11.00,
  2,
  1,
  'active',
  '10:00 - 23:00',
  '12 QAR/hour',
  ARRAY['Shopping', 'Entertainment', 'Restroom', 'Parking']
),
(
  'KAHRAMAA Charging - Qatar University',
  'Qatar University, Al Tarafa, Doha, Qatar',
  25.3775,
  51.4978,
  'KAHRAMAA',
  'Type 2 / CHAdeMO',
  50.00,
  2,
  2,
  'active',
  '07:00 - 22:00',
  'Free for students',
  ARRAY['Cafe', 'WiFi', 'Restroom', 'Library']
),
(
  'EV Charging - Education City',
  'Education City, Al Rayyan, Qatar',
  25.3199,
  51.4375,
  'KAHRAMAA',
  'Type 2 / CCS',
  22.00,
  4,
  0,
  'active',
  '07:00 - 23:00',
  'Free (QF initiative)',
  ARRAY['Library', 'Cafe', 'WiFi', 'Restroom', 'Parking']
),
(
  'Charging Station - Airport',
  'Hamad International Airport, Doha, Qatar',
  25.2609,
  51.6138,
  'KAHRAMAA',
  'Type 2 / CCS / CHAdeMO',
  150.00,
  8,
  5,
  'active',
  '24/7',
  '30 QAR/hour',
  ARRAY['Restroom', 'Dining', 'Shopping', 'WiFi', 'Parking']
),
(
  'EV Charger - Msheireb Downtown',
  'Msheireb Downtown Doha, Qatar',
  25.2889,
  51.5318,
  'Private',
  'Type 2',
  22.00,
  2,
  1,
  'active',
  '08:00 - 22:00',
  '18 QAR/hour',
  ARRAY['Dining', 'Shopping', 'Restroom', 'Parking']
),
(
  'Charging Station - Al Wakrah',
  'Al Wakrah Mall, Al Wakrah, Qatar',
  25.1725,
  51.6035,
  'KAHRAMAA',
  'Type 2',
  22.00,
  2,
  2,
  'active',
  '10:00 - 23:00',
  'Free (KAHRAMAA initiative)',
  ARRAY['Shopping', 'Dining', 'Restroom', 'Parking']
),
(
  'EV Charging - Al Khor',
  'Al Khor Mall, Al Khor, Qatar',
  25.6848,
  51.4959,
  'KAHRAMAA',
  'Type 2',
  22.00,
  1,
  1,
  'active',
  '10:00 - 22:00',
  'Free (KAHRAMAA initiative)',
  ARRAY['Shopping', 'Dining', 'Restroom', 'Parking']
),
(
  'Fast Charger - Doha Port',
  'Doha Port, Old Doha Port, Qatar',
  25.2855,
  51.5350,
  'KAHRAMAA',
  'CCS / CHAdeMO',
  150.00,
  4,
  3,
  'active',
  '24/7',
  '25 QAR/hour',
  ARRAY['Dining', 'Restroom', 'Parking', 'WiFi']
),
(
  'Charging Station - The Gate Mall',
  'The Gate Mall, West Bay, Doha, Qatar',
  25.2899,
  51.5353,
  'Private',
  'Type 2',
  22.00,
  2,
  2,
  'active',
  '09:00 - 23:00',
  '20 QAR/hour',
  ARRAY['Shopping', 'Dining', 'Restroom', 'Parking']
),
(
  'EV Charger - Landmark Mall',
  'Landmark Mall, Al Markhiya, Doha, Qatar',
  25.3265,
  51.4642,
  'Private',
  'Type 2 / CCS',
  50.00,
  3,
  1,
  'active',
  '10:00 - 23:00',
  '22 QAR/hour',
  ARRAY['Shopping', 'Dining', 'Restroom', 'Parking']
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_charging_stations_latitude ON charging_stations(latitude);
CREATE INDEX IF NOT EXISTS idx_charging_stations_longitude ON charging_stations(longitude);
CREATE INDEX IF NOT EXISTS idx_charging_stations_status ON charging_stations(status);
CREATE INDEX IF NOT EXISTS idx_charging_stations_name_lat_long ON charging_stations(name, latitude, longitude);

-- Verify data was inserted
SELECT 
  COUNT(*) as total_stations,
  SUM(CASE WHEN available_chargers > 0 THEN 1 ELSE 0 END) as available_stations,
  SUM(CASE WHEN available_chargers = 0 THEN 1 ELSE 0 END) as full_stations
FROM charging_stations
WHERE status = 'active';
