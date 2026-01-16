#!/usr/bin/env python3
"""
Charging Station Availability Simulator
Updates charger availability based on realistic usage patterns
This is a temporary solution until real APIs become available
"""

import requests
import json
import random
from datetime import datetime, timedelta
from typing import Dict, List

# Supabase configuration
SUPABASE_URL = "https://wmumpqvvoydngcbffozu.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdW1wcXZ2b3lkbmdjYmZmb3p1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzE5Mzg4OSwiZXhwIjoyMDgyNzY5ODg5fQ.c8WcGF8BBRu1L6PjjW8rdQxmajGqg1FWzWx1jozFluc"

HEADERS = {
    'apikey': SUPABASE_KEY,
    'Authorization': f'Bearer {SUPABASE_KEY}',
    'Content-Type': 'application/json'
}

class AvailabilitySimulator:
    """Simulate realistic charger availability patterns"""

    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update(HEADERS)

    def get_all_chargers(self) -> List[Dict]:
        """Fetch all chargers from database"""
        url = f"{SUPABASE_URL}/rest/v1/chargers?select=*,station_id"
        response = self.session.get(url)
        if response.status_code == 200:
            return response.json()
        return []

    def calculate_availability(self, charger: Dict) -> str:
        """
        Calculate charger status based on realistic patterns:
        - Time of day (peak hours: 7-9 AM, 4-6 PM)
        - Location type (malls vs stadiums vs residential)
        - Power level (fast chargers more popular)
        """
        now = datetime.now()
        hour = now.hour
        minute = now.minute

        # Get station info
        station_name = charger.get('station_name', '')

        # Peak hours multiplier (less available during peak times)
        if (7 <= hour < 9) or (16 <= hour < 18):
            peak_multiplier = 0.4  # Only 40% of chargers available during peak
        elif (11 <= hour < 14) or (19 <= hour < 21):
            peak_multiplier = 0.6  # 60% available during mid-peak
        else:
            peak_multiplier = 0.9  # 90% available off-peak

        # Location-based adjustments
        if 'stadium' in station_name.lower():
            # Stadiums busy during events
            if hour >= 18 and hour <= 23:
                peak_multiplier *= 0.3
        elif 'mall' in station_name.lower():
            # Malls busy during shopping hours
            if 10 <= hour < 22:
                peak_multiplier *= 0.7

        # Power-based adjustments
        power = float(charger.get('power_kw', 0))
        if power >= 150:
            # Ultra-fast chargers more popular
            peak_multiplier *= 0.8

        # Add some randomness
        base_probability = peak_multiplier * random.uniform(0.8, 1.0)

        # Determine status
        rand_val = random.random()

        if rand_val < base_probability:
            return 'available'
        elif rand_val < base_probability + 0.15:
            return 'occupied'
        elif rand_val < base_probability + 0.20:
            return 'reserved'
        else:
            # Small chance of maintenance
            return 'maintenance' if random.random() < 0.05 else 'offline'

    def update_charger_status(self, charger_id: str, status: str):
        """Update individual charger status"""
        url = f"{SUPABASE_URL}/rest/v1/chargers?id=eq.{charger_id}"
        data = {
            'status': status,
            'last_synced_at': datetime.now().isoformat()
        }
        response = self.session.patch(url, json=data)
        return response.status_code in [200, 204]

    def update_station_availability(self, station_id: str):
        """Update station-level availability counts"""
        # Get all chargers for this station
        url = f"{SUPABASE_URL}/rest/v1/chargers?station_id=eq.{station_id}&select=status"
        response = self.session.get(url)

        if response.status_code != 200:
            return

        chargers = response.json()
        total = len(chargers)
        available = sum(1 for c in chargers if c.get('status') == 'available')

        # Update station
        station_url = f"{SUPABASE_URL}/rest/v1/charging_stations?id=eq.{station_id}"
        station_data = {
            'total_chargers': total,
            'available_chargers': available,
            'last_scraped_at': datetime.now().isoformat()
        }
        self.session.patch(station_url, json=station_data)

    def run(self):
        """Run the availability update"""
        print(f"=== Charger Availability Simulator ===")
        print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")

        chargers = self.get_all_chargers()
        print(f"Found {len(chargers)} chargers\n")

        status_counts = {
            'available': 0,
            'occupied': 0,
            'reserved': 0,
            'maintenance': 0,
            'offline': 0
        }

        stations_updated = set()

        for charger in chargers:
            charger_id = charger['id']
            station_id = charger['station_id']
            charger_name = charger.get('name', 'Unknown')
            station_name = charger.get('station_name', 'Unknown')

            # Calculate new status
            new_status = self.calculate_availability(charger)
            status_counts[new_status] += 1

            # Update charger
            if self.update_charger_status(charger_id, new_status):
                stations_updated.add(station_id)

        # Update station-level counts
        for station_id in stations_updated:
            self.update_station_availability(station_id)

        # Summary
        print("Status Distribution:")
        for status, count in status_counts.items():
            pct = (count / len(chargers)) * 100 if chargers else 0
            print(f"  {status}: {count} ({pct:.1f}%)")

        print(f"\n✓ Updated {len(stations_updated)} stations")
        print(f"✓ Updated {len(chargers)} chargers")
        print(f"\nNext update in 5 minutes")

def main():
    simulator = AvailabilitySimulator()
    simulator.run()

if __name__ == '__main__':
    main()
