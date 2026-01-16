#!/usr/bin/env python3
"""
BYD Vehicle Scraper for QEV
Scrapes BYD Qatar website and other sources without using web search APIs.
Uses requests + BeautifulSoup for direct HTTP scraping.
"""

import json
import requests
from bs4 import BeautifulSoup
from typing import List, Dict, Optional
import re
import time
from urllib.parse import urljoin, urlparse
import os

# Database connection will use Supabase REST API
import hashlib

# Headers to avoid being blocked
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Connection': 'keep-alive',
}

class BYDScraper:
    """Scraper for BYD vehicles in Qatar"""

    def __init__(self):
        self.base_url = "https://www.bydqatar.com.qa"
        self.session = requests.Session()
        self.session.headers.update(HEADERS)
        self.scraped_data = []

    def fetch_page(self, url: str) -> Optional[BeautifulSoup]:
        """Fetch a page and return BeautifulSoup object"""
        try:
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            return BeautifulSoup(response.content, 'html.parser')
        except Exception as e:
            print(f"Error fetching {url}: {e}")
            return None

    def extract_vehicle_data(self, soup: BeautifulSoup, url: str) -> Dict:
        """Extract vehicle data from a product page"""
        vehicle = {
            'manufacturer': 'BYD',
            'source_url': url,
            'scraped_at': time.strftime('%Y-%m-%d %H:%M:%S')
        }

        # Extract model name from title or h1
        title = soup.find('h1') or soup.find('title')
        if title:
            title_text = title.get_text().strip()
            vehicle['model'] = self._extract_model_name(title_text)

        # Extract specifications from common selectors
        specs = self._extract_specs(soup)
        vehicle.update(specs)

        # Extract images
        images = self._extract_images(soup, url)
        vehicle['images'] = images

        # Extract description
        description = self._extract_description(soup)
        vehicle['description'] = description

        return vehicle

    def _extract_model_name(self, text: str) -> str:
        """Extract model name from title text"""
        # Common BYD models
        models = ['SEAL', 'ATTO 3', 'HAN', 'DOLPHIN', 'SEALION 7', 'SHARK', 'SONG', 'QIN', 'YUAN', 'E2', 'TANG', 'YANGWANG']
        text_upper = text.upper()

        for model in models:
            if model in text_upper:
                # Return clean model name
                if 'SEALION' in text_upper:
                    return 'SEALION 7'
                return model

        # Try to extract from title
        match = re.search(r'BYD\s+([A-Z][A-Z0-9\s]+)', text_upper)
        if match:
            return match.group(1).strip()

        return 'Unknown'

    def _extract_specs(self, soup: BeautifulSoup) -> Dict:
        """Extract vehicle specifications"""
        specs = {}

        # Common spec patterns
        spec_patterns = {
            'range_km': [r'(\d+)\s*km\s*range', r'range[^\d]*(\d+)'],
            'battery_kwh': [r'([\d.]+)\s*kWh', r'battery[^\d]*([\d.]+)'],
            'acceleration_0_100': [r'[\d.]+\s*s\s*0-100', r'0-100[^\d]*([\d.]+)'],
            'power_kw': [r'(\d+)\s*kW'],
            'power_hp': [r'(\d+)\s*HP'],
            'charging_dc_kw': [r'DC[^\d]*(\d+)\s*kW', r'(\d+)\s*kW\s*DC'],
        }

        # Search in page text
        page_text = soup.get_text()

        for field, patterns in spec_patterns.items():
            for pattern in patterns:
                match = re.search(pattern, page_text, re.IGNORECASE)
                if match:
                    value = match.group(1)
                    try:
                        specs[field] = float(value)
                    except ValueError:
                        specs[field] = value
                    break

        # Set defaults for BYD
        if 'vehicle_type' not in specs:
            specs['vehicle_type'] = 'EV'
        if 'gcc_spec' not in specs:
            specs['gcc_spec'] = True
        if 'chinese_spec' not in specs:
            specs['chinese_spec'] = False

        return specs

    def _extract_images(self, soup: BeautifulSoup, base_url: str) -> List[Dict]:
        """Extract vehicle images"""
        images = []

        # Find all img tags
        for img in soup.find_all('img'):
            src = img.get('src') or img.get('data-src')
            if src:
                # Convert relative URLs to absolute
                full_url = urljoin(base_url, src)

                # Skip small images and icons
                if any(x in src.lower() for x in ['icon', 'logo', 'avatar', 'thumb']):
                    continue

                # Determine image type
                img_type = 'other'
                alt_text = img.get('alt', '').lower()
                if 'exterior' in alt_text or 'front' in alt_text:
                    img_type = 'exterior_front'
                elif 'interior' in alt_text:
                    img_type = 'interior'

                images.append({
                    'url': full_url,
                    'type': img_type,
                    'alt': img.get('alt', '')
                })

        return images[:10]  # Limit to first 10 images

    def _extract_description(self, soup: BeautifulSoup) -> str:
        """Extract vehicle description"""
        # Try to find description in meta tags or paragraphs
        meta_desc = soup.find('meta', {'name': 'description'})
        if meta_desc:
            return meta_desc.get('content', '')

        # Try first substantial paragraph
        for p in soup.find_all('p'):
            text = p.get_text().strip()
            if len(text) > 50:
                return text[:500]  # Limit length

        return ''

    def scrape_byd_qatar(self) -> List[Dict]:
        """Scrape BYD Qatar website for vehicle data"""
        print("Scraping BYD Qatar...")

        # Known BYD Qatar model pages
        model_pages = [
            'https://www.bydqatar.com.qa/vehicles/seal/',
            'https://www.bydqatar.com.qa/vehicles/atto-3/',
            'https://www.bydqatar.com.qa/vehicles/han/',
            'https://www.bydqatar.com.qa/vehicles/dolphin/',
            'https://www.bydqatar.com.qa/vehicles/sealion-7/',
            'https://www.bydqatar.com.qa/vehicles/shark/',
        ]

        vehicles = []
        for url in model_pages:
            print(f"Fetching: {url}")
            soup = self.fetch_page(url)
            if soup:
                vehicle = self.extract_vehicle_data(soup, url)
                vehicles.append(vehicle)
                time.sleep(2)  # Rate limiting

        return vehicles


def load_existing_data() -> Dict:
    """Load existing scraped BYD data"""
    try:
        with open('/home/pi/Desktop/QEV/byd_qatar_vehicles.json', 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading existing data: {e}")
        return {}


def merge_vehicle_data(scraped: List[Dict], existing: Dict) -> List[Dict]:
    """Merge scraped data with existing data"""
    # Start with existing data
    vehicles = existing.get('models', [])

    # Add pricing data from Google research agent
    pricing_data = {
        'SEAL': {'price_qar': 142700, 'trims': [{'trim': 'Long Range FWD', 'price': 142700}, {'trim': 'Flagship AWD', 'price': 171698}]},
        'ATTO 3': {'price_qar': 108987, 'trims': [{'trim': 'Standard', 'price': 108987}, {'trim': 'Plus', 'price': 116062}]},
        'HAN': {'price_qar': 197348, 'trims': [{'trim': 'AWD', 'price': 197348}]},
        'DOLPHIN': {'price_qar': 52925, 'trims': [{'trim': 'Standard', 'price': 52925}, {'trim': 'Premium', 'price': 67708}]},
        'SEALION 7': {'price_qar': 228490, 'trims': [{'trim': 'Excellence AWD', 'price': 228490}]},
        'SHARK 6': {'price_qar': 157311, 'trims': [{'trim': 'Premium', 'price': 157311}]},
        'SEAL 7 DM-i': {'price_qar': 104667, 'trims': [{'trim': 'Standard', 'price': 104667}]},
        'SONG PLUS EV': {'price_qar': 80000, 'trims': [{'trim': 'Standard', 'price': 80000}, {'trim': 'Flagship', 'price': 234000}]},
        'QIN PLUS DM-i': {'price_qar': 74278, 'trims': [{'trim': 'Standard', 'price': 74278}]},
        'E2': {'price_qar': 58400, 'trims': [{'trim': 'Luxury', 'price': 58400}]},
        'YUAN PLUS': {'price_qar': 120450, 'trims': [{'trim': 'Standard', 'price': 120450}]},
        'SONG L': {'price_qar': 67615, 'trims': [{'trim': 'Standard', 'price': 67615}, {'trim': 'Performance', 'price': 85000}]},
    }

    # Add pricing to existing vehicles
    for vehicle in vehicles:
        model = vehicle.get('model', '').upper()
        if model in pricing_data:
            vehicle['manufacturer_direct_price'] = pricing_data[model]['price_qar']
            vehicle['trims'] = pricing_data[model].get('trims', [])

    return vehicles


def prepare_for_database(vehicles: List[Dict]) -> List[Dict]:
    """Prepare vehicle data for database insertion"""
    prepared = []

    for v in vehicles:
        record = {
            'manufacturer': v.get('manufacturer', 'BYD'),
            'model': v.get('model', ''),
            'year': v.get('year', 2025),
            'trim_level': v.get('trim_level'),
            'vehicle_type': v.get('vehicle_type', 'EV'),
            'gcc_spec': v.get('gcc_spec', True),
            'chinese_spec': v.get('chinese_spec', False),
            'range_km': v.get('range_km'),
            'battery_kwh': v.get('battery_kwh'),
            'manufacturer_direct_price': v.get('manufacturer_direct_price'),
            'grey_market_price': v.get('grey_market_price'),
            'grey_market_source': v.get('grey_market_source'),
            'price_qar': v.get('manufacturer_direct_price') or v.get('price_qar'),
            'specs': json.dumps(v.get('specs', {})),
            'images': json.dumps(v.get('images', [])),
            'description': v.get('description', ''),
            'stock_count': 1,
            'status': 'pending',  # Requires manual review
        }
        prepared.append(record)

    return prepared


def main():
    """Main scraper function"""
    print("=== BYD Vehicle Scraper for QEV ===")
    print("Using direct HTTP requests (no web search API)\n")

    # Load existing data
    print("Loading existing scraped data...")
    existing = load_existing_data()

    # Merge with pricing data
    print("Merging vehicle data with pricing...")
    vehicles = merge_vehicle_data([], existing)

    # Prepare for database
    print(f"Preparing {len(vehicles)} vehicles for database...")
    prepared = prepare_for_database(vehicles)

    # Save to file for review
    output_file = '/home/pi/Desktop/QEV/byd_vehicles_prepared.json'
    with open(output_file, 'w') as f:
        json.dump(prepared, f, indent=2)

    print(f"\n✓ Prepared {len(prepared)} vehicles")
    print(f"✓ Saved to {output_file}")
    print("\nNext steps:")
    print("1. Review the prepared data")
    print("2. Upload images to Supabase Storage")
    print("3. Insert into database with status='pending'")


if __name__ == '__main__':
    main()
