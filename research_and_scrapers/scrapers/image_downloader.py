#!/usr/bin/env python3
"""
Download BYD vehicle images and upload to Supabase Storage
"""

import json
import requests
import os
from urllib.parse import urlparse
import hashlib
import time

def load_byd_vehicles():
    """Load BYD vehicle data from our dataset"""
    with open('/home/pi/Desktop/QEV/byd_complete_dataset.json', 'r') as f:
        data = json.load(f)
    return data['vehicles']

def extract_image_urls(vehicles):
    """Extract all unique image URLs from vehicles"""
    urls = []
    for vehicle in vehicles:
        for img in vehicle.get('images', []):
            url = img.get('url')
            if url and url.startswith('http'):
                urls.append({
                    'url': url,
                    'model': vehicle.get('model'),
                    'trim': vehicle.get('trim_level'),
                    'type': img.get('type', 'other')
                })
    return urls

def download_image(url, dest_folder):
    """Download image from URL"""
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()

        # Generate filename from URL
        parsed = urlparse(url)
        filename = os.path.basename(parsed.path)
        if not filename or len(filename) < 5:
            filename = hashlib.md5(url.encode()).hexdigest() + '.jpg'

        filepath = os.path.join(dest_folder, filename)
        with open(filepath, 'wb') as f:
            f.write(response.content)

        return filepath, len(response.content)
    except Exception as e:
        print(f"  ✗ Error downloading {url}: {e}")
        return None, 0

def main():
    print("=== BYD Vehicle Image Downloader ===\n")

    # Load vehicles
    vehicles = load_byd_vehicles()
    print(f"Loaded {len(vehicles)} vehicles from dataset")

    # Extract image URLs
    images = extract_image_urls(vehicles)
    print(f"Found {len(images)} unique image URLs\n")

    # Create output folder
    output_folder = '/home/pi/Desktop/QEV/scrapers/images'
    os.makedirs(output_folder, exist_ok=True)

    # Download images
    print("Downloading images...")
    downloaded = 0
    total_size = 0

    for i, img in enumerate(images, 1):
        url = img['url']
        print(f"[{i}/{len(images)}] {img['model']} {img.get('trim', '')} - {img['type']}")

        filepath, size = download_image(url, output_folder)
        if filepath:
            downloaded += 1
            total_size += size
            print(f"  ✓ Downloaded: {filepath} ({size:,} bytes)")
        else:
            print(f"  ✗ Failed: {url}")

        time.sleep(1)  # Rate limiting

    # Summary
    print(f"\n=== Download Complete ===")
    print(f"Downloaded: {downloaded}/{len(images)} images")
    print(f"Total size: {total_size:,} bytes ({total_size/1024/1024:.2f} MB)")
    print(f"Saved to: {output_folder}")
    print("\nNext steps:")
    print("1. Review downloaded images")
    print("2. Upload to Supabase Storage bucket 'vehicle-images'")
    print("3. Update vehicle records with Supabase Storage URLs")

if __name__ == '__main__':
    main()
