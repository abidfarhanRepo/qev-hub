#!/usr/bin/env python3
"""
Insert BYD vehicle data into Supabase database
Uses direct REST API calls (no web search, no external APIs)
"""

import json
import os
import requests
from typing import List, Dict

# Supabase configuration
SUPABASE_URL = "https://wmumpqvvoydngcbffozu.supabase.co"
# Use the service role key for admin operations
SUPABASE_KEY = os.environ.get('SUPABASE_SERVICE_KEY', '')

def load_dataset() -> Dict:
    """Load the complete BYD dataset"""
    with open('/home/pi/Desktop/QEV/byd_complete_dataset.json', 'r') as f:
        return json.load(f)

def insert_vehicle(vehicle: Dict) -> bool:
    """Insert a single vehicle into the database"""
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
    }

    # Prepare the vehicle record
    record = {
        'manufacturer': vehicle.get('manufacturer'),
        'model': vehicle.get('model'),
        'year': vehicle.get('year'),
        'trim_level': vehicle.get('trim_level'),
        'vehicle_type': vehicle.get('vehicle_type', 'EV'),
        'gcc_spec': vehicle.get('gcc_spec'),
        'chinese_spec': vehicle.get('chinese_spec'),
        'range_km': vehicle.get('range_km'),
        'battery_kwh': vehicle.get('battery_kwh'),
        'price_qar': vehicle.get('price_qar'),
        'manufacturer_direct_price': vehicle.get('manufacturer_direct_price'),
        'grey_market_price': vehicle.get('grey_market_price'),
        'grey_market_source': vehicle.get('grey_market_source'),
        'grey_market_url': vehicle.get('grey_market_url'),
        'description': vehicle.get('description'),
        'specs': json.dumps(vehicle.get('specs', {})),
        'images': json.dumps(vehicle.get('images', [])),
        'stock_count': 1,
        'status': vehicle.get('status', 'pending')
    }

    # Optional fields
    if vehicle.get('acceleration_0_100'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'acceleration_0_100': vehicle['acceleration_0_100']})
    if vehicle.get('top_speed_kmh'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'top_speed_kmh': vehicle['top_speed_kmh']})
    if vehicle.get('power_kw'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'power_kw': vehicle['power_kw']})
    if vehicle.get('power_hp'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'power_hp': vehicle['power_hp']})
    if vehicle.get('charging_ac_kw'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'charging_ac_kw': vehicle['charging_ac_kw']})
    if vehicle.get('charging_dc_kw'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'charging_dc_kw': vehicle['charging_dc_kw']})
    if vehicle.get('drivetrain'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'drivetrain': vehicle['drivetrain']})
    if vehicle.get('body_style'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'body_style': vehicle['body_style']})
    if vehicle.get('seats'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'seats': vehicle['seats']})
    if vehicle.get('combined_range_km'):
        record['specs'] = json.dumps({**json.loads(record.get('specs', '{}')), 'combined_range_km': vehicle['combined_range_km']})

    try:
        response = requests.post(
            f'{SUPABASE_URL}/rest/v1/vehicles',
            headers=headers,
            json=record
        )

        if response.status_code in [200, 201]:
            print(f"  ✓ Inserted: {vehicle['manufacturer']} {vehicle['model']} {vehicle.get('trim_level', '')}")
            return True
        else:
            print(f"  ✗ Error inserting {vehicle['model']}: {response.status_code} - {response.text}")
            return False

    except Exception as e:
        print(f"  ✗ Exception inserting {vehicle['model']}: {e}")
        return False

def create_scrape_job(vehicles_count: int, status: str = 'completed') -> str:
    """Create a scrape job record"""
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
    }

    job_record = {
        'source': 'byd_multi_agent_scraper',
        'status': status,
        'full_scrape': True,
        'vehicles_processed': vehicles_count,
        'vehicles_updated': 0,
        'vehicles_created': vehicles_count,
        'result': f'Successfully scraped and inserted {vehicles_count} BYD vehicles from multiple sources'
    }

    try:
        response = requests.post(
            f'{SUPABASE_URL}/rest/v1/scrape_jobs',
            headers=headers,
            json=job_record
        )

        if response.status_code in [200, 201]:
            data = response.json()
            return data[0]['id'] if data else None
        else:
            print(f"Warning: Could not create scrape job: {response.status_code}")
            return None

    except Exception as e:
        print(f"Warning: Exception creating scrape job: {e}")
        return None

def main():
    """Main insertion function"""
    print("=== BYD Vehicle Data Insertion ===\n")

    # Check for Supabase key
    if not SUPABASE_KEY:
        print("Error: SUPABASE_SERVICE_KEY environment variable not set!")
        print("Please set it using: export SUPABASE_SERVICE_KEY='your-key-here'")
        return

    # Load dataset
    print("Loading BYD dataset...")
    dataset = load_dataset()
    vehicles = dataset['vehicles']

    print(f"Found {len(vehicles)} vehicles to insert\n")

    # Insert vehicles
    print("Inserting vehicles into database...")
    success_count = 0
    failed_count = 0

    for i, vehicle in enumerate(vehicles, 1):
        print(f"[{i}/{len(vehicles)}] ", end='')
        if insert_vehicle(vehicle):
            success_count += 1
        else:
            failed_count += 1

    # Create scrape job record
    print(f"\nCreating scrape job record...")
    job_id = create_scrape_job(success_count)

    # Summary
    print(f"\n=== Insertion Complete ===")
    print(f"✓ Successfully inserted: {success_count}")
    print(f"✗ Failed: {failed_count}")
    print(f"Total: {len(vehicles)}")

    if job_id:
        print(f"Scrape Job ID: {job_id}")

    # Breakdown
    gcc_count = sum(1 for v in vehicles if v.get('gcc_spec'))
    chinese_count = sum(1 for v in vehicles if v.get('chinese_spec'))
    ev_count = sum(1 for v in vehicles if v.get('vehicle_type') == 'EV')
    hybrid_count = sum(1 for v in vehicles if v.get('vehicle_type') == 'Hybrid')

    print(f"\nBreakdown:")
    print(f"  GCC-spec (official): {gcc_count}")
    print(f"  Chinese-spec (grey market): {chinese_count}")
    print(f"  Electric (EV): {ev_count}")
    print(f"  Hybrid (PHEV): {hybrid_count}")

    print(f"\nAll vehicles inserted with status='pending' for manual review.")

if __name__ == '__main__':
    main()
