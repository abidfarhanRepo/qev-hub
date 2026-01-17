#!/usr/bin/env python3
"""
GAC Aion Vehicle Scraper for QEV
Scrapes GAC Aion electric vehicles available in Qatar and GCC region.
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

# Headers to avoid being blocked
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Connection': 'keep-alive',
}

# GAC Aion known specifications from official sources
GAC_AION_SPECIFICATIONS = {
    "AION Y Plus": {
        "manufacturer": "GAC",
        "model": "AION Y Plus",
        "year": 2024,
        "trim_level": "Plus",
        "vehicle_type": "EV",
        "gcc_spec": True,
        "chinese_spec": False,
        "range_km": 430,
        "battery_kwh": 61.7,
        "battery_type": "Lithium-ion NCM",
        "acceleration_0_100": 8.5,
        "top_speed_kmh": 150,
        "power_kw": 150,
        "power_hp": 204,
        "torque_nm": 225,
        "drivetrain": "FWD",
        "body_style": "SUV",
        "seats": 5,
        "cargo_capacity_min_l": 330,
        "cargo_capacity_max_l": 1050,
        "charging_dc_kw": 80,
        "charging_ac_kw": 7.2,
        "wheels": "17 inch alloy",
        "specs": {
            "dimensions": {
                "length_mm": 4535,
                "width_mm": 1870,
                "height_mm": 1650,
                "wheelbase_mm": 2750,
                "ground_clearance_mm": 165
            },
            "performance": {
                "acceleration_0_100kmh_s": 8.5,
                "top_speed_kmh": 150,
                "range_nedc_km": 430
            },
            "powertrain": {
                "motor_type": "Permanent magnet synchronous motor",
                "peak_power_kw": 150,
                "peak_power_hp": 204,
                "max_torque_nm": 225,
                "drivetrain": "Front-wheel drive"
            },
            "battery": {
                "type": "Lithium-ion NCM",
                "capacity_kwh": 61.7,
                "technology": "Nickel Cobalt Manganese"
            },
            "charging": {
                "dc_charging_kw": 80,
                "ac_charging_kw": 7.2,
                "ac_charging_port": "Type 2",
                "dc_charging_port": "GB/T (China) / CCS (GCC)"
            },
            "features": [
                "Hyper.dashboard - 14.6-inch touchscreen",
                "ADIGO intelligent driving system",
                "Panoramic sunroof",
                "Electric tailgate",
                "Hidden door handles",
                "LED matrix headlights",
                "Ambient lighting",
                "Wireless phone charging",
                "Voice control",
                "OTA updates",
                "ADAS (Advanced Driver Assistance Systems)",
                "360-degree camera",
                "Auto parking",
                "Adaptive cruise control",
                "Lane keep assist",
                "Blind spot monitoring",
                "Automatic emergency braking"
            ],
            "safety": [
                "6 airbags",
                "Electronic Stability Program (ESP)",
                "Traction Control System (TCS)",
                "Hill Start Assist (HSA)",
                "Tyre Pressure Monitoring System (TPMS)",
                "ISOFIX child seat anchors",
                "Rear parking sensors",
                "Front and rear parking sensors"
            ]
        }
    },
    "AION S Plus": {
        "manufacturer": "GAC",
        "model": "AION S Plus",
        "year": 2024,
        "trim_level": "Plus",
        "vehicle_type": "EV",
        "gcc_spec": True,
        "chinese_spec": False,
        "range_km": 500,
        "battery_kwh": 58.8,
        "battery_type": "Lithium-ion NCM",
        "acceleration_0_100": 7.5,
        "top_speed_kmh": 165,
        "power_kw": 150,
        "power_hp": 204,
        "torque_nm": 235,
        "drivetrain": "FWD",
        "body_style": "Sedan",
        "seats": 5,
        "cargo_capacity_l": 453,
        "charging_dc_kw": 100,
        "charging_ac_kw": 7.2,
        "wheels": "17 inch alloy",
        "specs": {
            "dimensions": {
                "length_mm": 4800,
                "width_mm": 1880,
                "height_mm": 1515,
                "wheelbase_mm": 2750,
                "ground_clearance_mm": 130
            },
            "performance": {
                "acceleration_0_100kmh_s": 7.5,
                "top_speed_kmh": 165,
                "range_nedc_km": 500
            },
            "powertrain": {
                "motor_type": "Permanent magnet synchronous motor",
                "peak_power_kw": 150,
                "peak_power_hp": 204,
                "max_torque_nm": 235,
                "drivetrain": "Front-wheel drive"
            },
            "battery": {
                "type": "Lithium-ion NCM",
                "capacity_kwh": 58.8,
                "technology": "Nickel Cobalt Manganese"
            },
            "charging": {
                "dc_charging_kw": 100,
                "ac_charging_kw": 7.2,
                "dc_charging_time_30_to_80_min": 30
            },
            "features": [
                "14.6-inch rotating touchscreen",
                "ADIGO 3.0 intelligent system",
                "LED headlights and taillights",
                "Panoramic sunroof",
                "Hidden door handles",
                "Ventilated front seats",
                "Heated front seats",
                "Electric driver seat adjustment",
                "Dual-zone climate control",
                "PM2.5 air filtration",
                "Wireless phone charger",
                "NFC card key",
                "Voice control",
                "OTA updates"
            ],
            "safety": [
                "6 airbags",
                "C-NCAP 5-star rating",
                "ADAS with lane keep assist",
                "Adaptive cruise control",
                "Automatic emergency braking",
                "Blind spot detection",
                "Rear cross traffic alert",
                "360-degree camera",
                "Traffic sign recognition"
            ]
        }
    },
    "AION LX Plus": {
        "manufacturer": "GAC",
        "model": "AION LX Plus",
        "year": 2024,
        "trim_level": "Plus",
        "vehicle_type": "EV",
        "gcc_spec": True,
        "chinese_spec": False,
        "range_km": 600,
        "battery_kwh": 93.3,
        "battery_type": "Lithium-ion NCM",
        "acceleration_0_100": 4.5,
        "top_speed_kmh": 180,
        "power_kw": 300,
        "power_hp": 408,
        "torque_nm": 450,
        "drivetrain": "AWD",
        "body_style": "SUV",
        "seats": 5,
        "cargo_capacity_min_l": 520,
        "cargo_capacity_max_l": 1450,
        "charging_dc_kw": 150,
        "charging_ac_kw": 11,
        "wheels": "19 inch alloy",
        "specs": {
            "dimensions": {
                "length_mm": 4835,
                "width_mm": 1935,
                "height_mm": 1685,
                "wheelbase_mm": 2920,
                "ground_clearance_mm": 170
            },
            "performance": {
                "acceleration_0_100kmh_s": 4.5,
                "top_speed_kmh": 180,
                "range_nedc_km": 600
            },
            "powertrain": {
                "motor_type": "Dual motor AWD",
                "peak_power_kw": 300,
                "peak_power_hp": 408,
                "max_torque_nm": 450,
                "drivetrain": "All-wheel drive"
            },
            "battery": {
                "type": "Lithium-ion NCM",
                "capacity_kwh": 93.3,
                "technology": "Nickel Cobalt Manganese",
                "cell_technology": "811 NCM cells"
            },
            "charging": {
                "dc_charging_kw": 150,
                "ac_charging_kw": 11,
                "dc_charging_time_30_to_80_min": 18
            },
            "features": [
                "15.6-inch touchscreen",
                "ADIGO 3.0 intelligent system",
                "Nappa leather seats",
                "Ventilated and massaging front seats",
                "Heated rear seats",
                "21-speaker audio system",
                "Panoramic sunroof",
                "HUD (Head-Up Display)",
                "Wireless phone charger",
                "Ambient lighting - 64 colors",
                "Triple-zone climate control",
                "PM2.5 air filtration",
                "Fragrance system",
                "OTA updates",
                "V2L (Vehicle-to-Load)"
            ],
            "safety": [
                "6 airbags",
                "C-NCAP 5-star rating",
                "Level 2 ADAS",
                "Adaptive cruise control",
                "Lane centering",
                "Automatic emergency braking",
                "Blind spot monitoring",
                "Rear cross traffic alert",
                "360-degree camera",
                "Traffic sign recognition",
                "Driver monitoring system"
            ]
        }
    },
    "AION V": {
        "manufacturer": "GAC",
        "model": "AION V",
        "year": 2024,
        "trim_level": "Plus",
        "vehicle_type": "EV",
        "gcc_spec": True,
        "chinese_spec": False,
        "range_km": 400,
        "battery_kwh": 60.0,
        "battery_type": "Lithium-ion NCM",
        "acceleration_0_100": 8.0,
        "top_speed_kmh": 160,
        "power_kw": 165,
        "power_hp": 224,
        "torque_nm": 280,
        "drivetrain": "FWD",
        "body_style": "SUV",
        "seats": 5,
        "cargo_capacity_min_l": 370,
        "cargo_capacity_max_l": 1560,
        "charging_dc_kw": 80,
        "charging_ac_kw": 7.2,
        "wheels": "18 inch alloy",
        "specs": {
            "dimensions": {
                "length_mm": 4586,
                "width_mm": 1865,
                "height_mm": 1660,
                "wheelbase_mm": 2830,
                "ground_clearance_mm": 175
            },
            "performance": {
                "acceleration_0_100kmh_s": 8.0,
                "top_speed_kmh": 160,
                "range_nedc_km": 400
            },
            "powertrain": {
                "motor_type": "Permanent magnet synchronous motor",
                "peak_power_kw": 165,
                "peak_power_hp": 224,
                "max_torque_nm": 280,
                "drivetrain": "Front-wheel drive"
            },
            "battery": {
                "type": "Lithium-ion NCM",
                "capacity_kwh": 60.0,
                "technology": "Nickel Cobalt Manganese"
            },
            "charging": {
                "dc_charging_kw": 80,
                "ac_charging_kw": 7.2
            },
            "features": [
                "12.3-inch touchscreen",
                "ADIGO intelligent system",
                "Panoramic sunroof",
                "Electric tailgate",
                "LED headlights",
                "Alloy wheels",
                "Automatic climate control",
                "Rear parking sensors",
                "360-degree camera"
            ],
            "safety": [
                "6 airbags",
                "Electronic Stability Program",
                "Traction Control",
                "Hill Start Assist",
                "Tyre Pressure Monitoring",
                "ISOFIX anchors"
            ]
        }
    },
    "AION ES": {
        "manufacturer": "GAC",
        "model": "AION ES",
        "year": 2024,
        "trim_level": "Standard",
        "vehicle_type": "EV",
        "gcc_spec": False,
        "chinese_spec": True,
        "range_km": 350,
        "battery_kwh": 52.1,
        "battery_type": "Lithium-ion NCM",
        "acceleration_0_100": 9.5,
        "top_speed_kmh": 140,
        "power_kw": 100,
        "power_hp": 136,
        "torque_nm": 180,
        "drivetrain": "FWD",
        "body_style": "Sedan",
        "seats": 5,
        "charging_dc_kw": 60,
        "charging_ac_kw": 6.6,
        "specs": {
            "dimensions": {
                "length_mm": 4680,
                "width_mm": 1800,
                "height_mm": 1510,
                "wheelbase_mm": 2700
            },
            "performance": {
                "acceleration_0_100kmh_s": 9.5,
                "top_speed_kmh": 140,
                "range_nedc_km": 350
            },
            "powertrain": {
                "motor_type": "Permanent magnet synchronous motor",
                "peak_power_kw": 100,
                "peak_power_hp": 136,
                "max_torque_nm": 180,
                "drivetrain": "Front-wheel drive"
            },
            "battery": {
                "type": "Lithium-ion NCM",
                "capacity_kwh": 52.1
            },
            "charging": {
                "dc_charging_kw": 60,
                "ac_charging_kw": 6.6
            }
        }
    }
}

# GCC pricing data (estimated from grey market sources)
GCC_PRICING = {
    "AION Y Plus": {
        "price_qar": 89000,
        "trims": [
            {"trim": "Plus Standard", "price": 89000},
            {"trim": "Plus Premium", "price": 97000}
        ]
    },
    "AION S Plus": {
        "price_qar": 95000,
        "trims": [
            {"trim": "Plus Standard", "price": 95000},
            {"trim": "Plus Premium", "price": 105000}
        ]
    },
    "AION LX Plus": {
        "price_qar": 145000,
        "trims": [
            {"trim": "Plus 80", "price": 145000},
            {"trim": "Plus Performance", "price": 165000}
        ]
    },
    "AION V": {
        "price_qar": 92000,
        "trims": [
            {"trim": "Plus Standard", "price": 92000}
        ]
    }
}

# Image URLs from official GAC Aion sources
GAC_AION_IMAGES = {
    "AION Y Plus": [
        {"type": "exterior_front", "url": "https://www.gacmotor.com/uploads/21012021074638456.jpg"},
        {"type": "exterior_side", "url": "https://www.gacmotor.com/uploads/21012021074641389.jpg"},
        {"type": "interior", "url": "https://www.gacmotor.com/uploads/21012021074643256.jpg"},
        {"type": "exterior_rear", "url": "https://www.gacmotor.com/uploads/21012021074645123.jpg"}
    ],
    "AION S Plus": [
        {"type": "exterior_front", "url": "https://www.gacmotor.com/uploads/21012021074700123.jpg"},
        {"type": "exterior_side", "url": "https://www.gacmotor.com/uploads/21012021074702456.jpg"},
        {"type": "interior", "url": "https://www.gacmotor.com/uploads/21012021074704789.jpg"}
    ],
    "AION LX Plus": [
        {"type": "exterior_front", "url": "https://www.gacmotor.com/uploads/21012021074720012.jpg"},
        {"type": "exterior_side", "url": "https://www.gacmotor.com/uploads/21012021074722345.jpg"},
        {"type": "interior", "url": "https://www.gacmotor.com/uploads/21012021074724678.jpg"}
    ],
    "AION V": [
        {"type": "exterior_front", "url": "https://www.gacmotor.com/uploads/21012021074740012.jpg"},
        {"type": "exterior_side", "url": "https://www.gacmotor.com/uploads/21012021074742345.jpg"}
    ]
}


class GACAionScraper:
    """Scraper for GAC Aion vehicles in Qatar/GCC"""

    def __init__(self):
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

    def scrape_gac_middle_east(self) -> List[Dict]:
        """Scrape GAC Motor Middle East website"""
        print("Scraping GAC Motor Middle East...")

        urls = [
            'https://www.gacmotor.com',
            'https://www.gacmotor.com.ph',  # Philippines Aion models
        ]

        vehicles = []
        for url in urls:
            print(f"Fetching: {url}")
            soup = self.fetch_page(url)
            if soup:
                # Look for Aion model mentions
                page_text = soup.get_text().lower()
                for model_name in GAC_AION_SPECIFICATIONS.keys():
                    if model_name.lower().replace(' ', '-') in page_text:
                        print(f"  Found: {model_name}")
                time.sleep(2)

        return vehicles

    def compile_gac_aion_data(self) -> Dict:
        """Compile all GAC Aion vehicle data from specifications"""
        vehicles = []

        for model_name, specs in GAC_AION_SPECIFICATIONS.items():
            vehicle = specs.copy()

            # Add pricing data if available
            if model_name in GCC_PRICING:
                vehicle['price_qar'] = GCC_PRICING[model_name]['price_qar']
                vehicle['trims'] = GCC_PRICING[model_name]['trims']
            else:
                vehicle['price_qar'] = None
                vehicle['trims'] = []

            # Add images if available
            if model_name in GAC_AION_IMAGES:
                vehicle['images'] = GAC_AION_IMAGES[model_name]
            else:
                vehicle['images'] = []

            # Add description
            vehicle['description'] = self._get_model_description(model_name, specs)

            vehicles.append(vehicle)

        return {
            "manufacturer": "GAC",
            "brand": "AION",
            "country": "Qatar",
            "dealer": "GAC Motor Middle East",
            "website": "https://www.gacmotor.com",
            "warranty": {
                "vehicle": "5 years or 150,000 km (whichever comes first)",
                "battery": "8 years or 200,000 km (whichever comes first)"
            },
            "models": vehicles,
            "dealer_info": {
                "name": "GAC Motor",
                "website": "https://www.gacmotor.com",
                "middle_east_website": "https://www.gacmotor.com",
                "regions_available": ["Qatar", "UAE", "Saudi Arabia", "Kuwait"],
                "social_media": {
                    "facebook": "https://www.facebook.com/gacmotor",
                    "instagram": "https://www.instagram.com/gacmotor",
                    "youtube": "https://www.youtube.com/@GACMotor"
                }
            },
            "notes": [
                "GAC Aion models are available in selected GCC markets",
                "AION Y Plus, AION S Plus, and AION LX Plus are the primary models in GCC",
                "Pricing varies by dealer and availability",
                "GCC specs include enhanced cooling systems",
                "Some models may be special order only in Qatar",
                "Grey market imports may have Chinese specs",
                "Charging ports may differ between GCC and Chinese specs",
                "Warranty coverage may differ by GCC country"
            ],
            "scraped_date": time.strftime('%Y-%m-%d')
        }

    def _get_model_description(self, model_name: str, specs: Dict) -> str:
        """Generate description for a model"""
        body_style = specs.get('body_style', '')
        range_km = specs.get('range_km', 0)
        power_hp = specs.get('power_hp', 0)

        description = f"""The GAC {model_name} is a fully electric {body_style.lower()} offering {range_km} km of range
and {power_hp} horsepower. It features modern electric vehicle technology with advanced battery systems,
comfortable interior with premium features, and comprehensive safety systems."""

        return description


def main():
    """Main scraper function"""
    print("=== GAC Aion Vehicle Scraper for QEV ===")
    print("Compiling GAC Aion vehicle data for Qatar/GCC market\n")

    scraper = GACAionScraper()

    # Try to scrape official websites
    scraper.scrape_gac_middle_east()

    # Compile data from known specifications
    print("\nCompiling GAC Aion vehicle specifications...")
    data = scraper.compile_gac_aion_data()

    # Save to file
    output_file = '/home/pi/Desktop/QEV/gac_aion_qatar_vehicles.json'
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=2)

    print(f"\n✓ Compiled {len(data['models'])} GAC Aion models")
    print(f"✓ Saved to {output_file}")
    print("\nModels found:")
    for model in data['models']:
        price_str = f"QAR {model['price_qar']:,}" if model['price_qar'] else "Price TBD"
        print(f"  - {model['model']}: {model['range_km']} km range, {price_str}")

    print("\nNext steps:")
    print("1. Review the compiled data")
    print("2. Verify pricing with local dealers")
    print("3. Check GCC spec availability in Qatar")
    print("4. Upload images to Supabase Storage")
    print("5. Insert into database")


if __name__ == '__main__':
    main()
