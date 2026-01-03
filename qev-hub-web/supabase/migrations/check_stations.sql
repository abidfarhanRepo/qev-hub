-- Quick check for existing charging stations
-- Run this first to see if you have any stations already

SELECT 
  COUNT(*) as total_stations,
  STRING_AGG(name, ', ' ORDER BY name) as station_names
FROM charging_stations;
