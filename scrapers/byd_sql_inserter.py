#!/usr/bin/env python3
"""
Generate SQL INSERT statements for BYD vehicles
"""

import json

def escape_string(s):
    """Escape string for SQL"""
    if s is None:
        return 'NULL'
    s = str(s).replace("'", "''")
    return f"'{s}'"

def generate_sql_insert(vehicle):
    """Generate SQL INSERT statement for a single vehicle"""
    specs_json = json.dumps(vehicle.get('specs', {}))
    images_json = json.dumps(vehicle.get('images', []))

    # Build specs with additional fields
    specs = vehicle.get('specs', {})
    if vehicle.get('acceleration_0_100'):
        specs['acceleration_0_100'] = vehicle['acceleration_0_100']
    if vehicle.get('top_speed_kmh'):
        specs['top_speed_kmh'] = vehicle['top_speed_kmh']
    if vehicle.get('power_kw'):
        specs['power_kw'] = vehicle['power_kw']
    if vehicle.get('power_hp'):
        specs['power_hp'] = vehicle['power_hp']
    if vehicle.get('charging_ac_kw'):
        specs['charging_ac_kw'] = vehicle['charging_ac_kw']
    if vehicle.get('charging_dc_kw'):
        specs['charging_dc_kw'] = vehicle['charging_dc_kw']
    if vehicle.get('drivetrain'):
        specs['drivetrain'] = vehicle['drivetrain']
    if vehicle.get('body_style'):
        specs['body_style'] = vehicle['body_style']
    if vehicle.get('seats'):
        specs['seats'] = vehicle['seats']
    if vehicle.get('combined_range_km'):
        specs['combined_range_km'] = vehicle['combined_range_km']

    specs_json = json.dumps(specs)
    images_json = json.dumps(vehicle.get('images', []))

    sql = f"""INSERT INTO vehicles (
        make, model, year, trim_level, vehicle_type, gcc_spec, chinese_spec,
        range_km, battery_kwh, price, manufacturer_direct_price, grey_market_price,
        grey_market_source, grey_market_url, description, specs, images, stock_count, status
    ) VALUES (
        {escape_string(vehicle.get('manufacturer'))},
        {escape_string(vehicle.get('model'))},
        {vehicle.get('year', 2025)},
        {escape_string(vehicle.get('trim_level'))},
        {escape_string(vehicle.get('vehicle_type', 'EV'))},
        {vehicle.get('gcc_spec', 'true') if vehicle.get('gcc_spec') is not None else 'NULL'},
        {vehicle.get('chinese_spec', 'false') if vehicle.get('chinese_spec') is not None else 'NULL'},
        {vehicle.get('range_km') if vehicle.get('range_km') is not None else 'NULL'},
        {vehicle.get('battery_kwh') if vehicle.get('battery_kwh') is not None else 'NULL'},
        {vehicle.get('price_qar') if vehicle.get('price_qar') is not None else 'NULL'},
        {vehicle.get('manufacturer_direct_price') if vehicle.get('manufacturer_direct_price') is not None else 'NULL'},
        {vehicle.get('grey_market_price') if vehicle.get('grey_market_price') is not None else 'NULL'},
        {escape_string(vehicle.get('grey_market_source'))},
        {escape_string(vehicle.get('grey_market_url'))},
        {escape_string(vehicle.get('description', '')[:500])},
        {escape_string(specs_json)}::jsonb,
        {escape_string(images_json)}::jsonb,
        1,
        'pending'
    );"""
    return sql

def main():
    # Load dataset
    with open('/home/pi/Desktop/QEV/byd_complete_dataset.json', 'r') as f:
        dataset = json.load(f)

    vehicles = dataset['vehicles']

    # Generate SQL file
    output_file = '/home/pi/Desktop/QEV/scrapers/byd_insert.sql'
    with open(output_file, 'w') as f:
        for vehicle in vehicles:
            f.write(generate_sql_insert(vehicle) + '\n\n')

        # Add scrape job record
        f.write(f"""INSERT INTO scrape_jobs (source, status, full_scrape, vehicles_processed, vehicles_updated, vehicles_created, result)
VALUES ('byd_multi_agent_scraper', 'completed', true, {len(vehicles)}, 0, {len(vehicles)}, 'Successfully scraped and inserted {len(vehicles)} BYD vehicles from multiple sources');
""")

    print(f"✓ Generated SQL for {len(vehicles)} vehicles")
    print(f"✓ Saved to: {output_file}")

    # Summary
    gcc_count = sum(1 for v in vehicles if v.get('gcc_spec'))
    chinese_count = sum(1 for v in vehicles if v.get('chinese_spec'))
    ev_count = sum(1 for v in vehicles if v.get('vehicle_type') == 'EV')
    hybrid_count = sum(1 for v in vehicles if v.get('vehicle_type') == 'Hybrid')

    print(f"\nBreakdown:")
    print(f"  GCC-spec (official): {gcc_count}")
    print(f"  Chinese-spec (grey market): {chinese_count}")
    print(f"  Electric (EV): {ev_count}")
    print(f"  Hybrid (PHEV): {hybrid_count}")

if __name__ == '__main__':
    main()
