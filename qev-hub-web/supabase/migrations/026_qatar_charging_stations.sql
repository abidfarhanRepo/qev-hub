-- Migration: Update charging_stations schema and add Qatar mock data
-- This migration updates the schema to use charger_types (array) and adds comprehensive Qatar charging stations

-- First, let's update the charging_stations table schema
-- Add new columns if they don't exist
DO $$
BEGIN
    -- Add charger_types column as array if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'charging_stations' AND column_name = 'charger_types'
    ) THEN
        ALTER TABLE charging_stations ADD COLUMN charger_types TEXT[];
    END IF;

    -- Add other missing columns if not exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'charging_stations' AND column_name = 'area'
    ) THEN
        ALTER TABLE charging_stations ADD COLUMN area TEXT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'charging_stations' AND column_name = 'operator'
    ) THEN
        ALTER TABLE charging_stations ADD COLUMN operator TEXT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'charging_stations' AND column_name = 'phone_number'
    ) THEN
        ALTER TABLE charging_stations ADD COLUMN phone_number TEXT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'charging_stations' AND column_name = 'website_url'
    ) THEN
        ALTER TABLE charging_stations ADD COLUMN website_url TEXT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'charging_stations' AND column_name = 'image_url'
    ) THEN
        ALTER TABLE charging_stations ADD COLUMN image_url TEXT;
    END IF;

    -- Migrate existing charger_type data to charger_types array
    UPDATE charging_stations
    SET charger_types = ARRAY[charger_type]
    WHERE charger_type IS NOT NULL AND charger_types IS NULL;

END $$;

-- Insert Qatar mock charging stations with comprehensive details
INSERT INTO charging_stations (
    id,
    name,
    address,
    area,
    latitude,
    longitude,
    operator,
    charger_types,
    power_output_kw,
    total_chargers,
    available_chargers,
    status,
    operating_hours,
    pricing_info,
    amenities,
    phone_number,
    website_url
) VALUES
-- Doha City Center Area
(
    gen_random_uuid(),
    'Doha Festival City - EV Hub',
    'Doha Festival City, Al Daayen',
    'Al Daayen',
    25.3435,
    51.4994,
    'QEV',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    150.0,
    6,
    4,
    'active',
    '07:00 - 23:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food Court', 'Shopping', 'Accessibility', 'Climate Control', 'Security'],
    '+974 4455 1234',
    'https://www.dohafestivalcity.com'
),
(
    gen_random_uuid(),
    'Villaggio Mall Charging Station',
    'Villaggio Mall, Al Waab Street',
    'Al Rayyan',
    25.2854,
    51.4428,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    4,
    3,
    'active',
    '08:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Shopping', 'Accessibility', 'Security', 'Climate Control'],
    '+974 4413 5555',
    'https://www.villaggioqatar.com'
),
(
    gen_random_uuid(),
    'The Pearl-Qatar Marina',
    'Pearl Qatar, Porto Arabia',
    'The Pearl',
    25.3984,
    51.5184,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    22.0,
    3,
    2,
    'active',
    '24/7',
    '0.50 QAR/kWh',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food', 'Shaded', 'Security', 'Scenic View'],
    '+974 4459 8888',
    'https://www.pearlqatar.com'
),

-- West Bay Area
(
    gen_random_uuid(),
    'City Center Doha',
    'City Center Doha, West Bay',
    'West Bay',
    25.3152,
    51.5103,
    'QEV',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    150.0,
    8,
    5,
    'active',
    '07:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food Court', 'Shopping', 'Accessibility', 'Security', 'Climate Control'],
    '+974 4433 3333',
    'https://www.citycenterdoha.com'
),
(
    gen_random_uuid(),
    'Doha Tower Charging Hub',
    'Doha Tower, West Bay',
    'West Bay',
    25.3177,
    51.5206,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    4,
    2,
    'active',
    '06:00 - 22:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Accessibility', 'Security'],
    '+974 4400 1111',
    NULL
),

-- Education City Area
(
    gen_random_uuid(),
    'Education City - Qatar Foundation',
    'Education City, Al Luqta Street',
    'Al Rayyan',
    25.3119,
    51.4378,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    22.0,
    5,
    3,
    'active',
    '06:00 - 23:00',
    '0.50 QAR/kWh',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food', 'Accessibility', 'Security'],
    '+974 4454 0000',
    'https://www.qf.org.qa'
),

-- Lusail City
(
    gen_random_uuid(),
    'Lusail Marina District',
    'Lusail Marina, Qetaifan Island',
    'Lusail',
    25.4511,
    51.5033,
    'QEV',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    150.0,
    6,
    4,
    'active',
    '24/7',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food', 'Shaded', 'Accessibility', 'Security', 'Scenic View'],
    '+974 4499 7777',
    'https://www.lusail.com'
),
(
    gen_random_uuid(),
    'Lusail Place Vendome',
    'Place Vendome, Lusail',
    'Lusail',
    25.4389,
    51.5206,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    4,
    3,
    'active',
    '08:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Shopping', 'Accessibility', 'Security', 'Climate Control'],
    '+974 4488 6666',
    'https://www.placevendomeqatar.com'
),

-- Airport Area
(
    gen_random_uuid(),
    'Hamad International Airport',
    'Hamad International Airport, Terminal 1',
    'Old Airport',
    25.2609,
    51.6138,
    'QEV',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    150.0,
    10,
    7,
    'active',
    '24/7',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food', 'Shaded', 'Accessibility', 'Security', 'Lounge'],
    '+974 4401 4444',
    'https://www.dohahamadairport.com'
),

-- Al Wakrah Area
(
    gen_random_uuid(),
    'Al Wakrah Stadium',
    'Al Wakrah Stadium',
    'Al Wakrah',
    25.1794,
    51.6047,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    150.0,
    4,
    3,
    'active',
    '08:00 - 22:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Accessibility', 'Security'],
    '+974 4445 2222',
    'https://www.alwakrahstadium.qa'
),

-- Al Khor Area
(
    gen_random_uuid(),
    'Al Khor Coastal Road',
    'Al Khor Coastal Highway',
    'Al Khor',
    25.6847,
    51.4978,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    3,
    2,
    'active',
    '06:00 - 22:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Shaded', 'Accessibility'],
    '+974 4472 3333',
    NULL
),

-- Industrial Area
(
    gen_random_uuid(),
    'Qatar Science & Technology Park',
    'QSTP, Education City',
    'Doha',
    25.3206,
    51.4386,
    'QEV',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    150.0,
    5,
    3,
    'active',
    '07:00 - 21:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food', 'Accessibility', 'Security'],
    '+974 4454 1111',
    'https://www.qstp.org.qa'
),

-- The Mall Area
(
    gen_random_uuid(),
    'Mall of Qatar',
    'Mall of Qatar, Al Rayyan',
    'Al Rayyan',
    25.3036,
    51.4431,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    4,
    2,
    'active',
    '08:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food Court', 'Shopping', 'Accessibility', 'Security', 'Climate Control'],
    '+974 4444 9999',
    'https://www.mallofqatar.com'
),

-- Souq Waqif Area
(
    gen_random_uuid(),
    'Souq Waqif Parking',
    'Souq Waqif Car Park',
    'Doha',
    25.2854,
    51.5311,
    'QEV',
    ARRAY['Type 2'],
    22.0,
    2,
    1,
    'active',
    '24/7',
    '0.50 QAR/kWh',
    ARRAY['Parking', 'Restroom', 'Accessibility', 'Security'],
    '+974 4433 2222',
    'https://www.souqwaqif.qa'
),

-- Msheireb Downtown Doha
(
    gen_random_uuid(),
    'Msheireb Downtown Doha',
    'Msheireb Properties, Downtown Doha',
    'Doha',
    25.2883,
    51.5286,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    3,
    2,
    'active',
    '08:00 - 22:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food', 'Accessibility', 'Security'],
    '+974 4444 5555',
    'https://www.msheireb.com'
),

-- Qatar University Area
(
    gen_random_uuid(),
    'Qatar University',
    'Qatar University Campus',
    'Doha',
    25.3697,
    51.4983,
    'QEV',
    ARRAY['Type 2'],
    22.0,
    4,
    3,
    'active',
    '06:00 - 22:00',
    '0.50 QAR/kWh',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Accessibility', 'Security'],
    '+974 4403 3333',
    'https://www.qu.edu.qa'
),

-- WOQOD Stations (Popular fuel stations with EV charging)
(
    gen_random_uuid(),
    'WOQOD - Abu Hamour',
    'WOQOD Station, Abu Hamour',
    'Abu Hamour',
    25.2603,
    51.5222,
    'WOQOD',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    50.0,
    4,
    3,
    'active',
    '05:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'Convenience Store', 'Shaded', 'Accessibility'],
    '+974 4466 0000',
    'https://www.woqod.qa'
),
(
    gen_random_uuid(),
    'WOQOD - Al Egla',
    'WOQOD Station, Al Egla',
    'Al Egla',
    25.2948,
    51.5047,
    'WOQOD',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    50.0,
    4,
    2,
    'active',
    '05:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'Convenience Store', 'Shaded', 'Accessibility'],
    '+974 4466 1111',
    'https://www.woqod.qa'
),
(
    gen_random_uuid(),
    'WOQOD - Al Hilal',
    'WOQOD Station, Al Hilal',
    'Al Hilal',
    25.2854,
    51.5310,
    'WOQOD',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    50.0,
    5,
    3,
    'active',
    '05:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'Convenience Store', 'Shaded', 'Accessibility'],
    '+974 4466 2222',
    'https://www.woqod.qa'
),
(
    gen_random_uuid(),
    'WOQOD - Abu Nakla',
    'WOQOD Station, Abu Nakla',
    'Abu Nakla',
    25.1849,
    51.4948,
    'WOQOD',
    ARRAY['Type 2', 'CCS', 'CHAdeMO'],
    50.0,
    2,
    1,
    'active',
    '05:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'Convenience Store', 'Shaded', 'Accessibility'],
    '+974 4466 3333',
    'https://www.woqod.qa'
),

-- Stadium Stations (World Cup legacy)
(
    gen_random_uuid(),
    'Al Bayt Stadium',
    'Al Bayt Stadium, Al Khor',
    'Al Khor',
    25.6517,
    51.4872,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    150.0,
    4,
    2,
    'active',
    '08:00 - 20:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Accessibility', 'Security'],
    '+974 4470 0000',
    'https://www.albaytstadium.qa'
),
(
    gen_random_uuid(),
    'Al Janoub Stadium',
    'Al Janoub Stadium, Al Wakrah',
    'Al Wakrah',
    25.1581,
    51.5799,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    150.0,
    4,
    3,
    'active',
    '08:00 - 20:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Accessibility', 'Security'],
    '+974 4440 0000',
    'https://www.aljanoubstadium.qa'
),

-- Additional key locations
(
    gen_random_uuid(),
    'Tornado Tower',
    'Tornado Tower, West Bay',
    'West Bay',
    25.3169,
    51.5169,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    3,
    2,
    'active',
    '07:00 - 22:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Accessibility', 'Security'],
    '+974 4402 0000',
    'https://www.tornadotower.com'
),
(
    gen_random_uuid(),
    'Doha Exhibition and Convention Center',
    'DECC, West Bay',
    'West Bay',
    25.3281,
    51.5164,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    5,
    3,
    'active',
    '08:00 - 23:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Food', 'Accessibility', 'Security'],
    '+974 4404 4444',
    'https://www.decc.qa'
),
(
    gen_random_uuid(),
    'Hyatt Plaza',
    'Hyatt Plaza, Al Rayyan',
    'Al Rayyan',
    25.3189,
    51.4419,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    22.0,
    2,
    1,
    'active',
    '08:00 - 22:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Shopping', 'Accessibility'],
    '+974 4443 0000',
    'https://www.hyattplaza.com'
),

-- More locations for better coverage
(
    gen_random_uuid(),
    'Landmark Mall',
    'Landmark Mall, Al Dafna',
    'Al Dafna',
    25.2952,
    51.5349,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    4,
    2,
    'active',
    '08:00 - 00:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Shopping', 'Accessibility', 'Security', 'Climate Control'],
    '+974 4445 0000',
    'https://www.landmarkmall.com'
),
(
    gen_random_uuid(),
    'Alhazm Mall',
    'Alhazm Mall, Al Markhiya',
    'Al Markhiya',
    25.3336,
    51.5028,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    22.0,
    3,
    2,
    'active',
    '10:00 - 22:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Fine Dining', 'Accessibility', 'Security'],
    '+974 4440 5555',
    'https://www.alhazm.com'
),
(
    gen_random_uuid(),
    'Gate Mall',
    'Gate Mall, West Bay',
    'West Bay',
    25.3208,
    51.5128,
    'QEV',
    ARRAY['Type 2', 'CCS'],
    50.0,
    3,
    2,
    'active',
    '08:00 - 22:00',
    '0.50 QAR/kWh (AC), 0.75 QAR/kWh (DC)',
    ARRAY['Parking', 'Restroom', 'WiFi', 'Shopping', 'Accessibility', 'Security'],
    '+974 4401 0000',
    'https://www.gatemall.com'
);

-- Insert mock chargers for each station
-- We'll add individual chargers with detailed specifications
DO $$
DECLARE
    station_record RECORD;
    charger_count INTEGER;
    i INTEGER;
    charger_id UUID;
    v_station_id UUID;
    v_charger_types TEXT[];
    v_power_kw NUMERIC;
BEGIN
    FOR station_record IN
        SELECT id, charger_types, power_output_kw FROM charging_stations
    LOOP
        v_station_id := station_record.id;
        v_charger_types := station_record.charger_types;
        v_power_kw := station_record.power_output_kw;

        -- Determine number of chargers based on station
        charger_count := (SELECT total_chargers FROM charging_stations WHERE id = v_station_id);

        -- Insert chargers
        FOR i IN 1..charger_count LOOP
            charger_id := gen_random_uuid();

            INSERT INTO chargers (
                id,
                station_id,
                name,
                charger_type,
                power_kw,
                status,
                connector_types,
                is_enabled
            )
            VALUES (
                charger_id,
                v_station_id,
                'Charger ' || i,
                CASE
                    WHEN v_power_kw >= 150 THEN 'Ultra Fast DC'
                    WHEN v_power_kw >= 50 THEN 'Fast DC'
                    ELSE 'AC Level 2'
                END,
                v_power_kw,
                CASE
                    WHEN (i % 3 = 0) THEN 'occupied'
                    WHEN (i % 5 = 0) THEN 'maintenance'
                    ELSE 'available'
                END,
                v_charger_types,
                CASE
                    WHEN (i % 5 = 0) THEN FALSE
                    ELSE TRUE
                END
            );

            -- Update station available count
            UPDATE charging_stations
            SET available_chargers = available_chargers - 1
            WHERE id = v_station_id AND (i % 3 = 0 OR i % 5 = 0);
        END LOOP;
    END LOOP;
END $$;

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_charging_stations_location ON charging_stations USING GIST (point(longitude, latitude));
CREATE INDEX IF NOT EXISTS idx_charging_stations_charger_types ON charging_stations USING GIN (charger_types);
CREATE INDEX IF NOT EXISTS idx_chargers_station_id ON chargers(station_id);

-- Add comments for documentation
COMMENT ON TABLE charging_stations IS 'EV charging stations in Qatar with comprehensive details';
COMMENT ON COLUMN charging_stations.charger_types IS 'Array of connector types available (Type 2, CCS, CHAdeMO, Tesla)';
COMMENT ON COLUMN charging_stations.operator IS 'Station operator (QEV, WOQOD, etc.)';
COMMENT ON COLUMN charging_stations.area IS 'Geographic area in Qatar';
COMMENT ON COLUMN charging_stations.amenities IS 'Available amenities at the station';

COMMENT ON TABLE chargers IS 'Individual charging units at stations';
COMMENT ON COLUMN chargers.connector_types IS 'Array of connector types for this charger';
COMMENT ON COLUMN chargers.is_enabled IS 'Whether the charger is enabled for use';
COMMENT ON COLUMN chargers.status IS 'Current status (available, occupied, maintenance)';
