#!/usr/bin/env python3
"""
Scrape manufacturer websites for actual vehicle images
Uses requests + BeautifulSoup, no search API
"""

import json
import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import time
import re

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

# Manufacturer websites to scrape
MANUFACTURER_SITES = {
    'BYD': {
        'url': 'https://www.bydqatar.com.qa/vehicles',
        'image_selectors': [
            'img[src*="wp-content/uploads"]',
            '.vehicle-image img',
            '.model-image img',
            'img[class*="vehicle"]'
        ]
    },
    'MG': {
        'url': 'https://www.mg-motor.com',
        'image_selectors': [
            'img[src*="vehicle"]',
            'img[src*="model"]',
            '.vehicle-card img',
            '.model-card img'
        ]
    },
    'Chery': {
        'url': 'https://www.chery.com.cn',
        'image_selectors': [
            'img[src*="vehicle"]',
            'img[src*="model"]',
            '.model img'
        ]
    }
}

def extract_image_urls(url, model_name):
    """Extract image URLs from a webpage"""
    try:
        response = requests.get(url, headers=HEADERS, timeout=30)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        urls = []

        # Find all image tags
        for img in soup.find_all('img'):
            src = img.get('src') or img.get('data-src')
            if src:
                full_url = urljoin(url, src)
                # Check if URL seems relevant
                if any(term.lower() in full_url.lower() for term in [model_name.lower(), 'vehicle', 'model', 'car']):
                    urls.append(full_url)

        return list(set(urls))[:10]  # Return up to 10 unique URLs
    except Exception as e:
        print(f"  ✗ Scrape error: {e}")
        return []

def try_common_patterns(make, model):
    """Try common image URL patterns"""
    patterns = []

    # BYD patterns
    if make.upper() == 'BYD':
        model_slug = model.lower().replace(' ', '-').replace('+', 'plus')
        patterns = [
            f'https://www.bydauto.com.cn/upload/image/{model_slug}.jpg',
            f'https://www.byd.com/global/assets/images/vehicles/{model_slug}.jpg',
            f'https://www.byd.com/media/vehicles/{model_slug}.jpg',
        ]

    # MG patterns
    elif make.upper() == 'MG':
        model_slug = model.lower().replace(' ', '-').replace('+', 'plus')
        patterns = [
            f'https://mgmotor.wpenginepowered.com/wp-content/uploads/{model_slug}.jpg',
            f'https://www.mg.co.uk/wp-content/uploads/{model_slug}.webp',
        ]

    # Check each pattern
    for pattern in patterns:
        if check_url_exists(pattern):
            return pattern

    return None

def check_url_exists(url):
    """Check if URL returns 200"""
    try:
        response = requests.head(url, headers=HEADERS, timeout=10, allow_redirects=True)
        if response.status_code == 200:
            return True
        # Some servers don't support HEAD, try GET
        response = requests.get(url, headers=HEADERS, timeout=10, stream=True)
        if response.status_code == 200:
            return True
    except:
        pass
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

def get_storage_filename(make, model, trim):
    """Generate storage filename"""
    make_slug = make.lower().replace(' ', '-')
    model_slug = model.lower().replace(' ', '-').replace('/', '-')
    trim_slug = trim.lower().replace(' ', '-') if trim else ''
    year = 2025

    if trim_slug:
        return f"{make_slug}-{model_slug}-{trim_slug}-{year}.jpg"
    return f"{make_slug}-{model_slug}-{year}.jpg"

def load_vehicles_needing_images():
    """Load vehicles that need images"""
    with open('/home/pi/Desktop/QEV/all_vehicles_processed.json', 'r') as f:
        vehicles = json.load(f)

    return [v for v in vehicles if not v.get('images') or len(v.get('images', [])) == 0]

def main():
    print("=== Smart Vehicle Image Scraper ===\n")

    vehicles = load_vehicles_needing_images()
    print(f"Processing {len(vehicles)} vehicles\n")

    output_folder = '/home/pi/Desktop/QEV/scrapers/images/smart'
    os.makedirs(output_folder, exist_ok=True)

    results = []

    for i, vehicle in enumerate(vehicles[:20], 1):  # Process first 20 for testing
        make = vehicle.get('make', '')
        model = vehicle.get('model', '')
        trim = vehicle.get('trim_level', '')

        print(f"[{i}/{min(20, len(vehicles))}] {make} {model} {trim}".strip())

        image_url = None

        # Try common patterns first
        image_url = try_common_patterns(make, model)

        # If no pattern match, try scraping manufacturer site
        if not image_url and make in MANUFACTURER_SITES:
            site_info = MANUFACTURER_SITES[make]
            print(f"  Scraping {site_info['url']}...")
            urls = extract_image_urls(site_info['url'], model)
            if urls:
                image_url = urls[0]

        # If we found an image, download it
        if image_url:
            print(f"  Found: {image_url[:60]}...")
            filename = get_storage_filename(make, model, trim)
            filepath, size = download_image(image_url, output_folder, filename)

            if filepath:
                print(f"  ✓ Downloaded: {size:,} bytes")
                results.append({
                    'vehicle': vehicle,
                    'filename': filename,
                    'local_path': filepath,
                    'source_url': image_url
                    # Will upload to Supabase later
                })
            else:
                print(f"  ✗ Download failed")
        else:
            print(f"  ⚠ No image found")

        print()
        time.sleep(2)  # Rate limiting

    # Save results
    with open('/home/pi/Desktop/QEV/scrapers/smart_scrape_results.json', 'w') as f:
        json.dump(results, f, indent=2)

    print(f"=== Complete ===")
    print(f"Downloaded: {len(results)} images")
    print(f"Results saved to: scrapers/smart_scrape_results.json")

if __name__ == '__main__':
    main()
