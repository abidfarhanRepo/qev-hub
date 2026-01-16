#!/usr/bin/env python3
"""
Process all scraped vehicle data and prepare for database insertion
"""

import json
import os

def load_all_vehicle_data():
    """Load all scraped vehicle data files"""
    vehicles = []

    # List of all data files
    data_files = [
        '/home/pi/Desktop/QEV/byd_complete_dataset.json',
        '/home/pi/Desktop/QEV/gac_aion_qatar_vehicles.json',
        '/home/pi/Desktop/QEV/chery_jaecoo_omoda_qatar_vehicles.json',
        '/home/pi/Desktop/QEV/chinese_premium_ev_qatar_dataset.json',
        '/home/pi/Desktop/QEV/chinese_ev_qatar_research.json'
    ]

    for filepath in data_files:
        if not os.path.exists(filepath):
            print(f"  ⊗ File not found: {filepath}")
            continue

        try:
            with open(filepath, 'r') as f:
                data = json.load(f)

            # Extract vehicles array
            if 'vehicles' in data:
                vehicles.extend(data['vehicles'])
                print(f"  ✓ Loaded {len(data['vehicles'])} vehicles from {os.path.basename(filepath)}")
            elif 'models' in data:
                vehicles.extend(data['models'])
                print(f"  ✓ Loaded {len(data['models'])} vehicles from {os.path.basename(filepath)}")
            elif isinstance(data, list):
                vehicles.extend(data)
                print(f"  ✓ Loaded {len(data)} vehicles from {os.path.basename(filepath)}")
        except Exception as e:
            print(f"  ✗ Error loading {filepath}: {e}")

    return vehicles

def normalize_vehicle(vehicle):
    """Normalize vehicle data to common format"""
    # Handle different field names
    make = vehicle.get('make') or vehicle.get('manufacturer') or vehicle.get('brand')
    if not make:
        return None

    # Extract model name (handle different formats)
    model = vehicle.get('model', '')
    if not model:
        return None

    # Normalize vehicle type
    vehicle_type = vehicle.get('vehicle_type') or vehicle.get('type') or vehicle.get('fuel_type')
    if vehicle_type:
        vehicle_type = vehicle_type.upper()
        if 'PETROL' in vehicle_type or 'GASOLINE' in vehicle_type:
            vehicle_type = 'ICE'
        elif 'HYBRID' in vehicle_type or 'PHEV' in vehicle_type or 'PLUGIN' in vehicle_type.upper():
            vehicle_type = 'Hybrid'
        elif 'EV' in vehicle_type or 'ELECTRIC' in vehicle_type.upper():
            vehicle_type = 'EV'
    else:
        vehicle_type = 'EV'  # Default

    # Extract pricing
    price = vehicle.get('price') or vehicle.get('price_qar') or vehicle.get('price_qar')
    if isinstance(price, str):
        price = price.replace(',', '').replace(' QAR', '').strip()
        try:
            price = float(price)
        except:
            price = None

    manufacturer_direct_price = vehicle.get('manufacturer_direct_price') or vehicle.get('official_price')
    grey_market_price = vehicle.get('grey_market_price') or vehicle.get('import_price')

    # Build specs object
    specs = vehicle.get('specs', {})
    if isinstance(specs, str):
        try:
            specs = json.loads(specs)
        except:
            specs = {}

    # Add common fields to specs if not present
    if vehicle.get('range_km'):
        specs['range_km'] = vehicle['range_km']
    if vehicle.get('battery_kwh'):
        specs['battery_kwh'] = vehicle['battery_kwh']
    if vehicle.get('acceleration_0_100'):
        specs['acceleration_0_100'] = vehicle['acceleration_0_100']
    if vehicle.get('top_speed_kmh'):
        specs['top_speed_kmh'] = vehicle['top_speed_kmh']
    if vehicle.get('power_kw'):
        specs['power_kw'] = vehicle['power_kw']
    if vehicle.get('power_hp'):
        specs['power_hp'] = vehicle['power_hp']
    if vehicle.get('drivetrain'):
        specs['drivetrain'] = vehicle['drivetrain']
    if vehicle.get('body_style'):
        specs['body_style'] = vehicle['body_style']
    if vehicle.get('seats'):
        specs['seats'] = vehicle['seats']

    # Determine GCC/Chinese spec
    gcc_spec = vehicle.get('gcc_spec')
    chinese_spec = vehicle.get('chinese_spec')

    # If not explicitly set, infer from other fields
    if gcc_spec is None and chinese_spec is None:
        if vehicle.get('grey_market_price') and not vehicle.get('manufacturer_direct_price'):
            chinese_spec = True
            gcc_spec = False
        elif vehicle.get('official_distributor') or vehicle.get('warranty'):
            gcc_spec = True
            chinese_spec = False

    # Extract images
    images = vehicle.get('images', [])
    if isinstance(images, str):
        try:
            images = json.loads(images)
        except:
            images = []
    if vehicle.get('image_url'):
        images.insert(0, {'url': vehicle['image_url'], 'is_primary': True, 'type': 'exterior'})

    # Create normalized record
    normalized = {
        'make': make,
        'model': model,
        'year': vehicle.get('year', 2025),
        'trim_level': vehicle.get('trim_level'),
        'vehicle_type': vehicle_type,
        'gcc_spec': gcc_spec,
        'chinese_spec': chinese_spec,
        'range_km': vehicle.get('range_km'),
        'battery_kwh': vehicle.get('battery_kwh'),
        'price': price,
        'manufacturer_direct_price': manufacturer_direct_price,
        'grey_market_price': grey_market_price,
        'grey_market_source': vehicle.get('grey_market_source') or vehicle.get('source'),
        'grey_market_url': vehicle.get('grey_market_url'),
        'description': vehicle.get('description', '')[:500] if vehicle.get('description') else '',
        'specs': specs,
        'images': images,
        'stock_count': 1,
        'status': 'pending'  # All new vehicles require manual review
    }

    return normalized

def main():
    print("=== Processing All Scraped Vehicle Data ===\n")

    # Load all data
    print("Loading scraped data files...")
    all_vehicles = load_all_vehicle_data()
    print(f"\nTotal vehicles loaded: {len(all_vehicles)}")

    # Normalize data
    print("\nNormalizing vehicle data...")
    normalized = []
    skipped = 0

    for v in all_vehicles:
        norm = normalize_vehicle(v)
        if norm:
            normalized.append(norm)
        else:
            skipped += 1

    print(f"Normalized: {len(normalized)} vehicles")
    if skipped > 0:
        print(f"Skipped: {skipped} vehicles (missing required fields)")

    # Count by make
    makes = {}
    for v in normalized:
        make = v['make']
        makes[make] = makes.get(make, 0) + 1

    print("\nVehicles by make:")
    for make, count in sorted(makes.items()):
        print(f"  {make}: {count}")

    # Save processed data
    output_file = '/home/pi/Desktop/QEV/all_vehicles_processed.json'
    with open(output_file, 'w') as f:
        json.dump(normalized, f, indent=2)

    print(f"\n✓ Saved processed data to: {output_file}")
    print(f"Total vehicles ready for database: {len(normalized)}")

if __name__ == '__main__':
    main()
