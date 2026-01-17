#!/usr/bin/env python3
"""
KAHRAMAA Charging Station Scraper
Scrapes real-time availability data from KAHRAMAA's electric vehicle charging infrastructure
"""

import requests
from bs4 import BeautifulSoup
import json
import os
from datetime import datetime
from typing import Dict, List, Optional
import time

# Supabase configuration
SUPABASE_URL = "https://wmumpqvvoydngcbffozu.supabase.co"
SUPABASE_KEY = os.environ.get('SUPABASE_SERVICE_KEY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdW1wcXZ2b3lkbmdjYmZmb3p1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzE5Mzg4OSwiZXhwIjoyMDgyNzY5ODg5fQ.c8WcGF8BBRu1L6PjjW8rdQxmajGqg1FWzWx1jozFluc')

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

class KahramaaScraper:
    """Scraper for KAHRAMAA EV charging stations"""

    def __init__(self):
        self.base_url = "https://www.kahramaa.com"
        self.stations_url = f"{self.base_url}/ev-charging-stations"
        self.session = requests.Session()
        self.session.headers.update(HEADERS)

    def fetch_stations_page(self) -> str:
        """Fetch the main charging stations page"""
        try:
            response = self.session.get(self.stations_url, timeout=30)
            response.raise_for_status()
            return response.text
        except Exception as e:
            print(f"  ✗ Error fetching stations page: {e}")
            return None

    def parse_stations(self, html: str) -> List[Dict]:
        """Parse station data from HTML"""
        if not html:
            return []

        soup = BeautifulSoup(html, 'html.parser')
        stations = []

        # Look for station cards or list items
        # This will need to be adapted based on actual HTML structure
        station_elements = soup.find_all(['div', 'article', 'section'],
                                         class_=lambda x: x and any(term in x.lower() for term in ['station', 'charger', 'location']))

        for element in station_elements:
            try:
                station_data = self._parse_station_element(element)
                if station_data:
                    stations.append(station_data)
            except Exception as e:
                print(f"  ✗ Error parsing station element: {e}")
                continue

        return stations

    def _parse_station_element(self, element) -> Optional[Dict]:
        """Parse individual station element"""
        # Extract station name
        name_elem = element.find(['h2', 'h3', 'h4', 'span'],
                               class_=lambda x: x and 'name' in x.lower())
        name = name_elem.get_text(strip=True) if name_elem else None

        if not name:
            return None

        # Extract location/address
        address_elem = element.find(['p', 'span', 'div'],
                                   class_=lambda x: x and any(term in x.lower() for term in ['address', 'location', 'area']))
        address = address_elem.get_text(strip=True) if address_elem else None

        # Extract charger count
        count_text = element.get_text()
        chargers = self._extract_charger_count(count_text)

        # Extract connector types
        connector_types = self._extract_connector_types(count_text)

        return {
            'name': f"KAHRAMAA - {name}",
            'address': address,
            'operator': 'KAHRAMAA',
            'total_chargers': chargers,
            'available_chargers': None,  # Will be updated by availability checker
            'connector_types': connector_types,
            'last_scraped_at': datetime.now().isoformat()
        }

    def _extract_charger_count(self, text: str) -> Optional[int]:
        """Extract number of chargers from text"""
        import re
        patterns = [
            r'(\d+)\s*charger',
            r'(\d+)\s*point',
            r'(\d+)\s*port',
        ]
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return int(match.group(1))
        return None

    def _extract_connector_types(self, text: str) -> List[str]:
        """Extract connector types from text"""
        types = []
        if 'CCS' in text or 'CCS2' in text:
            types.append('CCS')
        if 'CHAdeMO' in text or 'Chademo' in text:
            types.append('CHAdeMO')
        if 'Type 2' in text:
            types.append('Type 2')
        if 'Tesla' in text:
            types.append('Tesla')
        return types

    def check_realtime_availability(self, station_id: str) -> Dict:
        """
        Check real-time availability for a station
        Note: This is a placeholder - actual implementation depends on KAHRAMAA's API
        """
        # KAHRAMAA may not have a public API, so this would need to:
        # 1. Check if they have an API endpoint
        # 2. Or scrape status indicators from their page
        # 3. Or use mock data based on time of day

        import random
        hour = datetime.now().hour

        # Simulate availability based on time (more available early morning/late night)
        base_availability = 0.7 if 6 <= hour <= 22 else 0.9

        return {
            'available_chargers': max(0, int(4 * base_availability + random.randint(-1, 1))),
            'last_synced_at': datetime.now().isoformat()
        }

    def update_supabase(self, station_data: Dict):
        """Update Supabase with station data"""
        url = f"{SUPABASE_URL}/rest/v1/charging_stations"
        headers = {
            'apikey': SUPABASE_KEY,
            'Authorization': f'Bearer {SUPABASE_KEY}',
            'Content-Type': 'application/json'
        }

        try:
            # Check if station exists
            check_url = f"{url}?name=eq.{station_data['name']}&select=id"
            response = self.session.get(check_url, headers=headers)
            existing = response.json() if response.status_code == 200 else []

            if existing and len(existing) > 0:
                # Update existing station
                station_id = existing[0]['id']
                update_url = f"{url}?id=eq.{station_id}"
                response = self.session.patch(update_url, headers=headers, json=station_data)
            else:
                # Insert new station
                response = self.session.post(url, headers=headers, json=station_data)

            if response.status_code in [200, 201, 204]:
                return True
            else:
                print(f"  ✗ Supabase update failed: {response.status_code}")
                return False
        except Exception as e:
            print(f"  ✗ Error updating Supabase: {e}")
            return False

    def run(self):
        """Run the scraper"""
        print("=== KAHRAMAA Charging Station Scraper ===\n")

        print("Fetching stations page...")
        html = self.fetch_stations_page()

        if not html:
            print("Failed to fetch page. Exiting.")
            return

        print("Parsing station data...")
        stations = self.parse_stations(html)
        print(f"Found {len(stations)} stations\n")

        for i, station in enumerate(stations, 1):
            print(f"[{i}/{len(stations)}] {station['name']}")
            print(f"  Address: {station.get('address', 'N/A')}")
            print(f"  Chargers: {station.get('total_chargers', 'N/A')}")
            print(f"  Connectors: {', '.join(station.get('connector_types', []))}")

            if self.update_supabase(station):
                print("  ✓ Updated in database")
            else:
                print("  ✗ Failed to update")
            print()

        print(f"=== Complete ===")
        print(f"Processed {len(stations)} stations")

def main():
    scraper = KahramaaScraper()
    scraper.run()

if __name__ == '__main__':
    main()
