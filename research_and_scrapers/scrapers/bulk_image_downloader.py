#!/usr/bin/env python3
"""
Download and upload missing vehicle images from manufacturer websites
Uses direct HTTP requests, not search APIs
"""

import json
import os
import requests
import hashlib
from pathlib import Path

# Supabase configuration
SUPABASE_URL = "https://wmumpqvvoydngcbffozu.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdW1wcXZ2b3lkbmdjYmZmb3p1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzE5Mzg4OSwiZXhwIjoyMDgyNzY5ODg5fQ.c8WcGF8BBRu1L6PjjW8rdQxmajGqg1FWzWx1jozFluc"
STORAGE_BUCKET = "vehicle-images"

# Known image URL patterns for manufacturers
MANUFACTURER_IMAGE_PATTERNS = {
    'BYD': {
        'base_url': 'https://www.bydqatar.com.qa',
        'models': {
            'ATTO 3': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/09/atto-3-hero.jpg',
            'DOLPHIN': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/10/dolphin-hero.jpg',
            'SEAL': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/09/seal-hero.jpg',
            'HAN EV': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/10/han-ev-hero.jpg',
            'SEALION 7': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/12/sealion-7-hero.jpg',
            'TANG': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/10/tang-hero.jpg',
            'E2': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/09/e2-hero.jpg',
            'SONG L': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/11/song-l-hero.jpg',
            'SHARK 6': 'https://www.bydqatar.com.qa/wp-content/uploads/2024/12/shark-6-hero.jpg',
        }
    },
    'GAC': {
        'base_url': 'https://www.gacmotor.com',
        'models': {
            'AION Y Plus': 'https://www.gacmotor.com/upload/image/20241028/aion-y-plus.jpg',
            'AION S Plus': 'https://www.gacmotor.com/upload/image/20241028/aion-s-plus.jpg',
            'AION LX Plus': 'https://www.gacmotor.com/upload/image/20241028/aion-lx-plus.jpg',
            'AION V': 'https://www.gacmotor.com/upload/image/20241028/aion-v.jpg',
            'AION ES': 'https://www.gacmotor.com/upload/image/20241028/aion-es.jpg',
        }
    },
    'MG': {
        'base_url': 'https://www.mgmotor.com',
        'models': {
            'MG 4 EV': 'https://www.mgmotor.com/content/dam/mg/motor/global/vehicles/mg4-ev/mg4-hero.jpg',
            'ZS EV': 'https://www.mgmotor.com/content/dam/mg/motor/global/vehicles/zs-ev/zs-ev-hero.jpg',
            'HS Hybrid+': 'https://www.mgmotor.com/content/dam/mg/motor/global/vehicles/hs/hs-hybrid-hero.jpg',
        }
    },
    'Chery': {
        'base_url': 'https://www.cheryinternational.com',
        'models': {
            'eQ7': 'https://www.cheryinternational.com/upload/image/eq7-hero.jpg',
            'QQ Ice Cream': 'https://www.cheryinternational.com/upload/image/qq-ice-cream-hero.jpg',
            'Tiggo 8 Pro e+': 'https://www.cheryinternational.com/upload/image/tiggo-8-pro-phev-hero.jpg',
        }
    },
    'Geely': {
        'base_url': 'https://www.geely.com',
        'models': {
            'Geometry C': 'https://www.geely.com/upload/image/geometry-c-hero.jpg',
            'Galaxy L6': 'https://www.geely.com/upload/image/galaxy-l6-hero.jpg',
            'Galaxy L7': 'https://www.geely.com/upload/image/galaxy-l7-hero.jpg',
        }
    },
    'Jaecoo': {
        'base_url': 'https://www.jaecoo.com',
        'models': {
            'J7': 'https://www.jaecoo.com/upload/image/j7-hero.jpg',
        }
    },
    'Omoda': {
        'base_url': 'https://www.omodacars.com',
        'models': {
            'C5': 'https://www.omodacars.com/upload/image/c5-hero.jpg',
        }
    },
    'Haval': {
        'base_url': 'https://www.haval.com',
        'models': {
            'H6': 'https://www.haval.com/upload/image/h6-hero.jpg',
        }
    },
    'Voyah': {
        'base_url': 'https://www.voyah.com',
        'models': {
            'FREE': 'https://www.voyah.com/upload/image/free-hero.jpg',
        }
    },
}

# Generic image patterns to try
GENERIC_PATTERNS = [
    'https://www.{make_lower}.com/assets/images/vehicles/{model_lower}-hero.jpg',
    'https://www.{make_lower}.com/vehicles/{model_lower}/images/hero.jpg',
    'https://cdn.{make_lower}.com/vehicles/{model_lower}/hero.jpg',
]

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

def get_image_filename(vehicle):
    """Generate storage filename for vehicle"""
    make = vehicle['make'].lower().replace(' ', '-')
    model = vehicle['model'].lower().replace(' ', '-')
    trim = vehicle.get('trim_level', '').lower().replace(' ', '-') if vehicle.get('trim_level') else ''
    year = vehicle.get('year', 2025)

    if trim:
        return f"{make}-{model}-{trim}-{year}.jpg"
    return f"{make}-{model}-{year}.jpg"

def try_known_patterns(vehicle):
    """Try known manufacturer image patterns"""
    make = vehicle.get('make', '')
    model = vehicle.get('model', '')

    if make in MANUFACTURER_IMAGE_PATTERNS:
        patterns = MANUFACTURER_IMAGE_PATTERNS[make]
        for model_name, url in patterns.get('models', {}).items():
            if model_name in model or model in model_name:
                return url

    return None

def try_generic_patterns(vehicle):
    """Try generic image URL patterns"""
    make = vehicle.get('make', '').lower()
    model = vehicle.get('model', '').lower().replace(' ', '-').replace('/', '-')

    for pattern in GENERIC_PATTERNS:
        url = pattern.format(make_lower=make, model_lower=model)
        if check_url_exists(url):
            return url

    return None

def check_url_exists(url):
    """Check if URL is accessible"""
    try:
        response = requests.head(url, headers=HEADERS, timeout=10)
        return response.status_code == 200
    except:
        return False

def download_image(url, dest_folder, filename):
    """Download image from URL"""
    try:
        response = requests.get(url, headers=HEADERS, timeout=30)
        response.raise_for_status()

        filepath = os.path.join(dest_folder, filename)
        with open(filepath, 'wb') as f:
            f.write(response.content)

        return filepath, len(response.content)
    except Exception as e:
        return None, 0

def upload_to_supabase(filepath, filename):
    """Upload image to Supabase Storage"""
    try:
        with open(filepath, 'rb') as f:
            file_data = f.read()

        url = f"{SUPABASE_URL}/storage/v1/object/{STORAGE_BUCKET}/{filename}"
        headers = {
            'apikey': SUPABASE_KEY,
            'Authorization': f'Bearer {SUPABASE_KEY}',
            'Content-Type': 'image/jpeg'
        }

        response = requests.post(url, headers=headers, data=file_data, timeout=30)
        response.raise_for_status()

        public_url = f"{SUPABASE_URL}/storage/v1/object/public/{STORAGE_BUCKET}/{filename}"
        return public_url
    except Exception as e:
        print(f"  ✗ Upload error: {e}")
        return None

def load_vehicles_missing_images():
    """Load vehicles from database that are missing images"""
    # This would query Supabase, but for now load from processed file
    with open('/home/pi/Desktop/QEV/all_vehicles_processed.json', 'r') as f:
        vehicles = json.load(f)

    # Filter vehicles without images
    missing = [v for v in vehicles if not v.get('images') or len(v.get('images', [])) == 0]
    return missing

def main():
    print("=== Bulk Vehicle Image Downloader ===\n")

    vehicles = load_vehicles_missing_images()
    print(f"Found {len(vehicles)} vehicles missing images\n")

    # Create output folder
    output_folder = '/home/pi/Desktop/QEV/scrapers/images/bulk'
    os.makedirs(output_folder, exist_ok=True)

    results = []

    for i, vehicle in enumerate(vehicles, 1):
        make = vehicle.get('make', '')
        model = vehicle.get('model', '')
        trim = vehicle.get('trim_level', '')

        print(f"[{i}/{len(vehicles)}] {make} {model} {trim}".strip())

        # Skip if already has images
        if vehicle.get('images') and len(vehicle.get('images', [])) > 0:
            print("  → Already has images, skipping\n")
            continue

        # Try known patterns first
        image_url = try_known_patterns(vehicle)

        # If no known pattern, try generic
        if not image_url:
            image_url = try_generic_patterns(vehicle)

        # Generate filename
        filename = get_image_filename(vehicle)

        # If we found a URL, download it
        if image_url:
            print(f"  Found: {image_url[:80]}...")
            filepath, size = download_image(image_url, output_folder, filename)

            if filepath:
                print(f"  ✓ Downloaded: {size:,} bytes")

                # Upload to Supabase
                public_url = upload_to_supabase(filepath, filename)
                if public_url:
                    print(f"  ✓ Uploaded: {public_url}")
                    results.append({
                        'vehicle': vehicle,
                        'filename': filename,
                        'public_url': public_url
                    })
                else:
                    print(f"  ✗ Upload failed")
            else:
                print(f"  ✗ Download failed")
        else:
            print(f"  ⚠ No image URL found")

        print()

    # Save results
    with open('/home/pi/Desktop/QEV/scrapers/bulk_upload_results.json', 'w') as f:
        json.dump(results, f, indent=2)

    print(f"=== Complete ===")
    print(f"Successfully processed: {len(results)}/{len(vehicles)} vehicles")
    print(f"\nResults saved to: scrapers/bulk_upload_results.json")
    print(f"\nTo update database, run:")
    print(f"  python3 scrapers/update_bulk_images.py")

if __name__ == '__main__':
    main()
