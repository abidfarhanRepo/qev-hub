#!/usr/bin/env python3
"""
Generate SQL for all processed vehicles and insert into database
"""

import json
import subprocess
import os

def load_processed_vehicles():
    """Load processed vehicle data"""
    with open('/home/pi/Desktop/QEV/all_vehicles_processed.json', 'r') as f:
        return json.load(f)

def escape_string(s):
    """Escape string for SQL"""
    if s is None:
        return 'NULL'
    s = str(s).replace("'", "''")
    return f"'{s}'"

def generate_sql_insert(vehicle):
    """Generate SQL INSERT statement for a single vehicle"""
    specs = vehicle.get('specs', {})
    images = vehicle.get('images', [])

    # Build specs JSON
    specs_json = json.dumps(specs)

    # Build images JSON
    images_json = json.dumps(images)

    # Get values with defaults
    make = escape_string(vehicle.get('make', ''))
    model = escape_string(vehicle.get('model', ''))
    year = vehicle.get('year', 2025)
    trim = escape_string(vehicle.get('trim_level'))
    v_type = escape_string(vehicle.get('vehicle_type', 'EV'))
    gcc = 'true' if vehicle.get('gcc_spec') else ('false' if vehicle.get('gcc_spec') is not None else 'NULL')
    chinese = 'true' if vehicle.get('chinese_spec') else ('false' if vehicle.get('chinese_spec') is not None else 'NULL')
    range_km = vehicle.get('range_km') or 'NULL'
    battery = vehicle.get('battery_kwh') or 'NULL'
    price = vehicle.get('price') or 'NULL'
    mfg_price = vehicle.get('manufacturer_direct_price') or 'NULL'
    grey_price = vehicle.get('grey_market_price') or 'NULL'
    grey_source = escape_string(vehicle.get('grey_market_source'))
    grey_url = escape_string(vehicle.get('grey_market_url'))
    desc = escape_string(vehicle.get('description', '')[:500])

    sql = f"""INSERT INTO vehicles (make, model, year, trim_level, vehicle_type, gcc_spec, chinese_spec, range_km, battery_kwh, price, manufacturer_direct_price, grey_market_price, grey_market_source, grey_market_url, description, specs, images, stock_count, status)
VALUES ({make}, {model}, {year}, {trim}, {v_type}, {gcc}, {chinese}, {range_km}, {battery}, {price}, {mfg_price}, {grey_price}, {grey_source}, {grey_url}, {desc}, '{escape_string(specs_json)}'::jsonb, '{escape_string(images_json)}'::jsonb, 1, 'pending');"""
    return sql

def execute_sql_via_supabase(sql):
    """Execute SQL via Supabase MCP tool (simulated via echo for now)"""
    print(f"Would execute: {sql[:100]}...")
    return True

def main():
    print("=== Inserting All Vehicles into Database ===\n")

    vehicles = load_processed_vehicles()
    print(f"Loaded {len(vehicles)} vehicles for insertion\n")

    # Check what's already in database
    print("Checking existing vehicles...")
    # This would query Supabase but for now we'll just insert

    # Create batch files
    batch_size = 10
    batch_num = 1

    for i in range(0, len(vehicles), batch_size):
        batch = vehicles[i:i+batch_size]
        batch_file = f'/home/pi/Desktop/QEV/scrapers/batches/batch_{batch_num:03d}.sql'

        os.makedirs('/home/pi/Desktop/QEV/scrapers/batches', exist_ok=True)

        with open(batch_file, 'w') as f:
            for vehicle in batch:
                sql = generate_sql_insert(vehicle)
                f.write(sql + '\n')

        print(f"  Created batch {batch_num}: {len(batch)} vehicles")
        batch_num += 1

    print(f"\n✓ Created {batch_num - 1} batch files")
    print(f"Location: /home/pi/Desktop/QEV/scrapers/batches/")
    print(f"\nTo execute batches via Supabase MCP tool, run:")
    print(f"  cat /home/pi/Desktop/QEV/scrapers/batches/batch_001.sql")
    print(f"\nFirst batch preview:")
    with open('/home/pi/Desktop/QEV/scrapers/batches/batch_001.sql', 'r') as f:
        lines = f.readlines()
        for line in lines[:5]:
            print(f"  {line.strip()}")

if __name__ == '__main__':
    main()
