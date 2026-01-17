#!/usr/bin/env python3
"""
Upload BYD vehicle images to Supabase Storage via REST API
"""

import os
import json
import requests
import base64
from pathlib import Path

# Supabase configuration
SUPABASE_URL = "https://wmumpqvvoydngcbffozu.supabase.co"
SUPABASE_KEY = os.environ.get('SUPABASE_SERVICE_KEY', '')
STORAGE_BUCKET = "vehicle-images"

def upload_image_to_supabase(filepath, filename):
    """Upload image to Supabase Storage via REST API"""
    if not SUPABASE_KEY:
        print("  ✗ SUPABASE_SERVICE_KEY not set - skipping upload")
        return None

    # Read image file
    with open(filepath, 'rb') as f:
        file_data = f.read()

    # Upload to Supabase Storage
    url = f"{SUPABASE_URL}/storage/v1/object/{STORAGE_BUCKET}/{filename}"
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'image/jpeg'
    }

    try:
        response = requests.post(url, headers=headers, data=file_data)
        response.raise_for_status()

        # Return public URL
        public_url = f"{SUPABASE_URL}/storage/v1/object/public/{STORAGE_BUCKET}/{filename}"
        return public_url
    except Exception as e:
        print(f"  ✗ Upload error: {e}")
        return None

def get_image_mapping():
    """Map local images to vehicle models"""
    return {
        'section02-scaled.jpg': {'model': 'SEAL', 'trim': 'Long Range FWD', 'type': 'exterior'},
        '21-scaled.jpg': {'model': 'HAN EV', 'trim': 'AWD', 'type': 'exterior_front'},
        'byd-sealion-7-exterior-01-l-scaled.jpg': {'model': 'SEALION 7', 'trim': 'Excellence AWD', 'type': 'exterior_front'},
        'byd-sealion-7-exterior-02-l-scaled.jpg': {'model': 'SEALION 7', 'trim': 'Excellence AWD', 'type': 'exterior_side'},
        'byd-sealion-7-interior-01-l-scaled.jpg': {'model': 'SEALION 7', 'trim': 'Excellence AWD', 'type': 'interior'},
        'kv4pc-scaled.png': {'model': 'SEAL 7 DM-i', 'trim': 'Standard', 'type': 'exterior'}
    }

def main():
    print("=== BYD Image Uploader to Supabase Storage ===\n")

    if not SUPABASE_KEY:
        print("Error: SUPABASE_SERVICE_KEY environment variable not set!")
        print("\nPlease set it using:")
        print("  export SUPABASE_SERVICE_KEY='your-service-role-key-here'")
        print("\nYou can find the service role key in Supabase Dashboard > Settings > API")
        return

    # Get image folder
    image_folder = '/home/pi/Desktop/QEV/scrapers/images'
    mapping = get_image_mapping()

    # Upload each image
    uploaded = 0
    results = []

    for filename, info in mapping.items():
        filepath = os.path.join(image_folder, filename)
        if not os.path.exists(filepath):
            print(f"✗ File not found: {filename}")
            continue

        # Generate storage filename (more organized)
        storage_filename = f"byd-{info['model'].lower().replace(' ', '-')}-{info['type']}.jpg"
        if info.get('trim'):
            storage_filename = f"byd-{info['model'].lower().replace(' ', '-')}-{info['trim'].lower().replace(' ', '-')}-{info['type']}.jpg"

        print(f"Uploading: {filename} -> {storage_filename}")
        print(f"  Model: {info['model']} {info.get('trim', '')}")
        print(f"  Type: {info['type']}")

        public_url = upload_image_to_supabase(filepath, storage_filename)
        if public_url:
            uploaded += 1
            print(f"  ✓ Uploaded: {public_url}")
            results.append({
                'original_filename': filename,
                'storage_filename': storage_filename,
                'public_url': public_url,
                'model': info['model'],
                'trim': info.get('trim'),
                'type': info['type']
            })
        else:
            print(f"  ✗ Upload failed")
        print()

    # Summary
    print(f"=== Upload Complete ===")
    print(f"Uploaded: {uploaded}/{len(mapping)} images")
    print(f"\nTo update vehicle records with new URLs, run:")
    print(f"  python3 scrapers/update_vehicle_images.py")

    # Save results for next step
    with open('/home/pi/Desktop/QEV/scrapers/upload_results.json', 'w') as f:
        json.dump(results, f, indent=2)
    print(f"\n✓ Saved upload results to: scrapers/upload_results.json")

if __name__ == '__main__':
    main()
