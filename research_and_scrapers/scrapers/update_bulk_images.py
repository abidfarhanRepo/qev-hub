#!/usr/bin/env python3
"""
Update vehicle records in database with new Supabase Storage image URLs
"""

import json
import requests
import os

SUPABASE_URL = "https://wmumpqvvoydngcbffozu.supabase.co"
SUPABASE_KEY = os.environ.get('SUPABASE_SERVICE_KEY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdW1wcXZ2b3lkbmdjYmZmb3p1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzE5Mzg4OSwiZXhwIjoyMDgyNzY5ODg5fQ.c8WcGF8BBRu1L6PjjW8rdQxmajGqg1FWzWx1jozFluc')

def get_vehicle_id(make, model, trim=None):
    """Find vehicle ID by make, model, trim"""
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json'
    }

    # Build query
    query = f"?make=eq.{make}&model=eq.{model}"
    if trim:
        query += f"&trim_level=eq.{trim}"

    url = f"{SUPABASE_URL}/rest/v1/vehicles{query}&select=id"

    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        data = response.json()
        if data and len(data) > 0:
            return data[0]['id']
    except Exception as e:
        print(f"  ✗ Error finding vehicle: {e}")

    return None

def update_vehicle_images(vehicle_id, image_url):
    """Update vehicle with new image"""
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json'
    }

    # Build images array
    images_data = [{
        'url': image_url,
        'type': 'exterior',
        'is_primary': True
    }]

    url = f"{SUPABASE_URL}/rest/v1/vehicles?id=eq.{vehicle_id}"
    payload = {
        'images': images_data
    }

    try:
        response = requests.patch(url, headers=headers, json=payload)
        response.raise_for_status()
        return True
    except Exception as e:
        print(f"  ✗ Error updating: {e}")
        return False

def main():
    print("=== Updating Vehicle Records with Bulk Images ===\n")

    # Load results
    results_file = '/home/pi/Desktop/QEV/scrapers/bulk_upload_results.json'

    if not os.path.exists(results_file):
        print("No bulk upload results found. Run bulk_image_downloader.py first.")
        return

    with open(results_file, 'r') as f:
        results = json.load(f)

    print(f"Found {len(results)} vehicles to update\n")

    updated = 0
    failed = 0

    for result in results:
        vehicle = result['vehicle']
        make = vehicle.get('make')
        model = vehicle.get('model')
        trim = vehicle.get('trim_level')
        public_url = result['public_url']

        print(f"Updating: {make} {model} {trim}".strip())

        # Find vehicle ID
        vehicle_id = get_vehicle_id(make, model, trim)

        if vehicle_id:
            # Update images
            if update_vehicle_images(vehicle_id, public_url):
                print(f"  ✓ Updated successfully")
                updated += 1
            else:
                print(f"  ✗ Update failed")
                failed += 1
        else:
            print(f"  ✗ Vehicle not found in database")
            failed += 1

        print()

    print(f"=== Update Complete ===")
    print(f"Updated: {updated}")
    print(f"Failed: {failed}")

if __name__ == '__main__':
    main()
