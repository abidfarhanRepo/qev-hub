#!/usr/bin/env python3
"""
Create complete BYD vehicle dataset for QEV database
Combines data from all agents with complete specifications
"""

import json

# Complete BYD dataset for Qatar based on research from all agents
byd_complete_dataset = {
    "metadata": {
        "manufacturer": "BYD",
        "country": "Qatar",
        "official_distributor": "Mannai Trading Company WLL",
        "showroom": "Ground Floor Tornado Tower Dunes Plaza, Doha",
        "phone": "8001808",
        "email": "crm@mannai.com.qa",
        "website": "https://www.bydqatar.com.qa",
        "warranty": {
            "vehicle": "6 years or 150,000 km",
            "battery": "8 years or 200,000 km"
        },
        "scrape_date": "2025-01-16"
    },
    "vehicles": [
        # BYD SEAL - Electric Sedan
        {
            "manufacturer": "BYD",
            "model": "SEAL",
            "year": 2025,
            "trim_level": "Long Range FWD",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 570,
            "battery_kwh": 82.5,
            "acceleration_0_100": 5.9,
            "top_speed_kmh": 180,
            "power_kw": 230,
            "power_hp": 313,
            "charging_ac_kw": 11,
            "charging_dc_kw": 150,
            "manufacturer_direct_price": 142700,
            "grey_market_price": None,
            "grey_market_source": None,
            "price_qar": 142700,
            "body_style": "Sedan",
            "drivetrain": "RWD",
            "seats": 5,
            "specs": {
                "dimensions": {"length_mm": 4800, "width_mm": 1875, "height_mm": 1460, "wheelbase_mm": 2920},
                "battery": {"type": "BYD Blade Battery (LFP)", "technology": "Lithium Iron Phosphate"},
                "charging": {"dc_charging_kw": 150, "ac_charging_kw": 11, "charging_time_30_80_min": 26},
                "features": ["CTB Technology", "iTAC", "e-Platform 3.0", "Heat pump", "8-in-1 electric powertrain"]
            },
            "images": [{"url": "https://www.bydqatar.com.qa/wp-content/uploads/2024/09/section02-scaled.jpg", "type": "exterior", "is_primary": True}],
            "description": "BYD SEAL is an all-electric sedan with ocean-inspired aesthetics, featuring CTB technology and exceptional performance.",
            "status": "pending"
        },
        {
            "manufacturer": "BYD",
            "model": "SEAL",
            "year": 2025,
            "trim_level": "Flagship AWD",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 460,
            "battery_kwh": 82.5,
            "acceleration_0_100": 3.8,
            "top_speed_kmh": 180,
            "power_kw": 390,
            "power_hp": 530,
            "charging_ac_kw": 11,
            "charging_dc_kw": 150,
            "manufacturer_direct_price": 171698,
            "grey_market_price": None,
            "grey_market_source": None,
            "price_qar": 171698,
            "body_style": "Sedan",
            "drivetrain": "AWD",
            "seats": 5,
            "specs": {
                "dimensions": {"length_mm": 4800, "width_mm": 1875, "height_mm": 1460, "wheelbase_mm": 2920},
                "battery": {"type": "BYD Blade Battery (LFP)", "technology": "Lithium Iron Phosphate"},
                "charging": {"dc_charging_kw": 150, "ac_charging_kw": 11, "charging_time_30_80_min": 26}
            },
            "images": [{"url": "https://www.bydqatar.com.qa/wp-content/uploads/2024/09/section02-scaled.jpg", "type": "exterior", "is_primary": True}],
            "description": "BYD SEAL Flagship AWD with dual motors, 3.8s 0-100 km/h acceleration.",
            "status": "pending"
        },
        # BYD ATTO 3 - Electric Compact SUV
        {
            "manufacturer": "BYD",
            "model": "ATTO 3",
            "year": 2025,
            "trim_level": "Standard",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 420,
            "battery_kwh": 60.48,
            "acceleration_0_100": 7.3,
            "top_speed_kmh": 160,
            "power_kw": 150,
            "power_hp": 204,
            "charging_ac_kw": 7.4,
            "charging_dc_kw": 88,
            "manufacturer_direct_price": 108987,
            "grey_market_price": None,
            "grey_market_source": None,
            "price_qar": 108987,
            "body_style": "SUV",
            "drivetrain": "FWD",
            "seats": 5,
            "specs": {
                "dimensions": {"length_mm": 4455, "width_mm": 1875, "height_mm": 1615, "wheelbase_mm": 2720},
                "battery": {"type": "BYD Blade Battery (LFP)", "capacity_kwh": 60.48},
                "charging": {"dc_charging_kw": 88, "ac_charging_kw": 7.4},
                "features": ["12.8-inch rotating screen", "DiPilot", "VTOL mobile power supply"]
            },
            "images": [],
            "description": "BYD ATTO 3 is a compact electric SUV with 420km range, featuring the signature rotating display.",
            "status": "pending"
        },
        {
            "manufacturer": "BYD",
            "model": "ATTO 3",
            "year": 2025,
            "trim_level": "Plus",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 420,
            "battery_kwh": 60.48,
            "acceleration_0_100": 7.3,
            "top_speed_kmh": 160,
            "power_kw": 150,
            "power_hp": 204,
            "charging_ac_kw": 7.4,
            "charging_dc_kw": 88,
            "manufacturer_direct_price": 116062,
            "grey_market_price": None,
            "price_qar": 116062,
            "body_style": "SUV",
            "drivetrain": "FWD",
            "specs": {},
            "images": [],
            "description": "BYD ATTO 3 Plus trim with enhanced features.",
            "status": "pending"
        },
        # BYD HAN EV - Luxury Electric Sedan
        {
            "manufacturer": "BYD",
            "model": "HAN EV",
            "year": 2025,
            "trim_level": "AWD",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 521,
            "battery_kwh": 85.4,
            "acceleration_0_100": 3.9,
            "top_speed_kmh": 180,
            "power_kw": 380,
            "power_hp": 530,
            "charging_ac_kw": 11,
            "charging_dc_kw": 110,
            "manufacturer_direct_price": 197348,
            "price_qar": 197348,
            "body_style": "Sedan",
            "drivetrain": "AWD",
            "seats": 5,
            "specs": {
                "dimensions": {"length_mm": 4995, "width_mm": 1910, "height_mm": 1495, "wheelbase_mm": 2920},
                "battery": {"type": "BYD Blade Battery (LFP)", "capacity_kwh": 85.4}
            },
            "images": [{"url": "https://www.bydqatar.com.qa/wp-content/uploads/2024/10/21-scaled.jpg", "type": "exterior_front", "is_primary": True}],
            "description": "BYD HAN EV luxury sedan with dual motors, 521km range.",
            "status": "pending"
        },
        # BYD DOLPHIN - Electric Hatchback
        {
            "manufacturer": "BYD",
            "model": "DOLPHIN",
            "year": 2025,
            "trim_level": "Standard",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 340,
            "battery_kwh": 44.9,
            "acceleration_0_100": 12.3,
            "top_speed_kmh": 150,
            "power_kw": 95,
            "power_hp": 130,
            "charging_ac_kw": 7,
            "charging_dc_kw": 60,
            "manufacturer_direct_price": 52925,
            "price_qar": 52925,
            "body_style": "Hatchback",
            "drivetrain": "FWD",
            "seats": 5,
            "specs": {
                "dimensions": {"length_mm": 4290, "width_mm": 1770, "height_mm": 1570, "wheelbase_mm": 2700}
            },
            "images": [],
            "description": "BYD DOLPHIN - affordable electric hatchback with 340km range.",
            "status": "pending"
        },
        {
            "manufacturer": "BYD",
            "model": "DOLPHIN",
            "year": 2025,
            "trim_level": "Premium",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 427,
            "battery_kwh": 60.4,
            "acceleration_0_100": 7.0,
            "top_speed_kmh": 160,
            "power_kw": 150,
            "power_hp": 204,
            "charging_ac_kw": 11,
            "charging_dc_kw": 88,
            "manufacturer_direct_price": 67708,
            "price_qar": 67708,
            "body_style": "Hatchback",
            "drivetrain": "FWD",
            "specs": {},
            "images": [],
            "description": "BYD DOLPHIN Premium with 60.4kWh battery and 427km range.",
            "status": "pending"
        },
        # BYD SEALION 7 - Electric Performance SUV
        {
            "manufacturer": "BYD",
            "model": "SEALION 7",
            "year": 2025,
            "trim_level": "Excellence AWD",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 482,
            "battery_kwh": 80.64,
            "acceleration_0_100": 4.5,
            "top_speed_kmh": 180,
            "power_kw": 390,
            "power_hp": 523,
            "charging_ac_kw": 11,
            "charging_dc_kw": 150,
            "manufacturer_direct_price": 228490,
            "price_qar": 228490,
            "body_style": "SUV",
            "drivetrain": "AWD",
            "seats": 5,
            "specs": {
                "dimensions": {"length_mm": 4830, "width_mm": 1920, "height_mm": 1720, "wheelbase_mm": 2830}
            },
            "images": [
                {"url": "https://www.bydqatar.com.qa/wp-content/uploads/2024/12/byd-sealion-7-exterior-01-l-scaled.jpg", "type": "exterior_front", "is_primary": True},
                {"url": "https://www.bydqatar.com.qa/wp-content/uploads/2024/12/byd-sealion-7-exterior-02-l-scaled.jpg", "type": "exterior_side", "is_primary": False},
                {"url": "https://www.bydqatar.com.qa/wp-content/uploads/2024/12/byd-sealion-7-interior-01-l-scaled.jpg", "type": "interior", "is_primary": False}
            ],
            "description": "BYD SEALION 7 - premium electric SUV with Nappa leather, 523HP, 482km range.",
            "status": "pending"
        },
        # BYD SHARK 6 - Hybrid Pickup
        {
            "manufacturer": "BYD",
            "model": "SHARK 6",
            "year": 2025,
            "trim_level": "Premium",
            "vehicle_type": "Hybrid",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 520,
            "combined_range_km": 800,
            "battery_kwh": 29.58,
            "acceleration_0_100": 5.7,
            "top_speed_kmh": 160,
            "power_kw": 321,
            "power_hp": 430,
            "torque_nm": 650,
            "charging_ac_kw": 6.6,
            "manufacturer_direct_price": 157311,
            "price_qar": 157311,
            "body_style": "Pickup Truck",
            "drivetrain": "AWD",
            "specs": {
                "dimensions": {"length_mm": 5260, "width_mm": 1940, "height_mm": 1920, "wheelbase_mm": 3120},
                "technology": ["DMO Hybrid System", "V2L", "2500kg towing capacity"]
            },
            "images": [],
            "description": "BYD SHARK 6 - plug-in hybrid pickup with DMO off-road system, 2500kg towing.",
            "status": "pending"
        },
        # BYD SEAL 7 DM-i - Hybrid Sedan
        {
            "manufacturer": "BYD",
            "model": "SEAL 7 DM-i",
            "year": 2025,
            "trim_level": "Standard",
            "vehicle_type": "Hybrid",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 850,
            "battery_kwh": 17.6,
            "acceleration_0_100": 6.5,
            "top_speed_kmh": 180,
            "power_kw": 200,
            "power_hp": 270,
            "charging_ac_kw": 6.6,
            "manufacturer_direct_price": 104667,
            "price_qar": 104667,
            "body_style": "Sedan",
            "drivetrain": "FWD",
            "specs": {
                "dimensions": {"length_mm": 4830, "width_mm": 1890, "height_mm": 1495, "wheelbase_mm": 2900}
            },
            "images": [{"url": "https://www.bydqatar.com.qa/wp-content/uploads/2025/04/kv4pc-scaled.png", "type": "exterior", "is_primary": True}],
            "description": "BYD SEAL 7 DM-i - plug-in hybrid sedan with 850km combined range, DM-i Gen 4.0.",
            "status": "pending"
        },
        {
            "manufacturer": "BYD",
            "model": "SEAL 7 DM-i",
            "year": 2025,
            "trim_level": "AWD",
            "vehicle_type": "Hybrid",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 800,
            "battery_kwh": 17.6,
            "acceleration_0_100": 4.8,
            "top_speed_kmh": 190,
            "power_kw": 270,
            "power_hp": 366,
            "manufacturer_direct_price": 133714,
            "price_qar": 133714,
            "body_style": "Sedan",
            "drivetrain": "AWD",
            "specs": {},
            "images": [],
            "description": "BYD SEAL 7 DM-i AWD with 4.8s acceleration.",
            "status": "pending"
        },
        # BYD SONG PLUS DM-i - Plug-in Hybrid SUV
        {
            "manufacturer": "BYD",
            "model": "SONG PLUS DM-i",
            "year": 2025,
            "trim_level": "FWD",
            "vehicle_type": "Hybrid",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 110,
            "combined_range_km": 890,
            "battery_kwh": 18.3,
            "acceleration_0_100": 7.3,
            "top_speed_kmh": 170,
            "power_kw": 150,
            "power_hp": 204,
            "charging_ac_kw": 3.3,
            "manufacturer_direct_price": 110648,
            "price_qar": 110648,
            "body_style": "SUV",
            "drivetrain": "FWD",
            "specs": {
                "dimensions": {"length_mm": 4705, "width_mm": 1890, "height_mm": 1680, "wheelbase_mm": 2765}
            },
            "images": [],
            "description": "BYD SONG PLUS DM-i - plug-in hybrid SUV with 890km combined range.",
            "status": "pending"
        },
        # BYD SONG PLUS EV - Electric SUV
        {
            "manufacturer": "BYD",
            "model": "SONG PLUS EV",
            "year": 2025,
            "trim_level": "Standard",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 520,
            "battery_kwh": 71.8,
            "acceleration_0_100": 7.5,
            "top_speed_kmh": 160,
            "power_kw": 150,
            "power_hp": 204,
            "charging_ac_kw": 11,
            "charging_dc_kw": 100,
            "manufacturer_direct_price": 80000,
            "price_qar": 80000,
            "body_style": "SUV",
            "drivetrain": "FWD",
            "specs": {
                "dimensions": {"length_mm": 4785, "width_mm": 1890, "height_mm": 1665, "wheelbase_mm": 2765}
            },
            "images": [],
            "description": "BYD SONG PLUS EV - electric SUV with 520km range.",
            "status": "pending"
        },
        # BYD QIN PLUS DM-i - Plug-in Hybrid Sedan
        {
            "manufacturer": "BYD",
            "model": "QIN PLUS DM-i",
            "year": 2025,
            "trim_level": "Standard",
            "vehicle_type": "Hybrid",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 90,
            "combined_range_km": 795,
            "battery_kwh": 18.3,
            "acceleration_0_100": 7.3,
            "top_speed_kmh": 185,
            "power_kw": 197,
            "power_hp": 266,
            "charging_ac_kw": 3.3,
            "manufacturer_direct_price": 74278,
            "price_qar": 74278,
            "body_style": "Sedan",
            "drivetrain": "FWD",
            "specs": {
                "dimensions": {"length_mm": 4765, "width_mm": 1837, "height_mm": 1495, "wheelbase_mm": 2718}
            },
            "images": [],
            "description": "BYD QIN PLUS DM-i - efficient plug-in hybrid sedan with 795km range.",
            "status": "pending"
        },
        # BYD E2 - Electric Hatchback
        {
            "manufacturer": "BYD",
            "model": "E2",
            "year": 2025,
            "trim_level": "Luxury",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 405,
            "battery_kwh": 43.2,
            "acceleration_0_100": 9.3,
            "top_speed_kmh": 130,
            "power_kw": 70,
            "power_hp": 95,
            "charging_ac_kw": 6.6,
            "charging_dc_kw": 60,
            "manufacturer_direct_price": 58400,
            "price_qar": 58400,
            "body_style": "Hatchback",
            "drivetrain": "FWD",
            "specs": {
                "dimensions": {"length_mm": 4240, "width_mm": 1760, "height_mm": 1530, "wheelbase_mm": 2610}
            },
            "images": [],
            "description": "BYD E2 - affordable electric hatchback with 405km range.",
            "status": "pending"
        },
        # BYD YUAN PLUS - Electric SUV
        {
            "manufacturer": "BYD",
            "model": "YUAN PLUS",
            "year": 2025,
            "trim_level": "Standard",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 510,
            "battery_kwh": 60.48,
            "acceleration_0_100": 7.5,
            "top_speed_kmh": 160,
            "power_kw": 150,
            "power_hp": 204,
            "charging_ac_kw": 7.4,
            "charging_dc_kw": 88,
            "manufacturer_direct_price": 120450,
            "price_qar": 120450,
            "body_style": "SUV",
            "drivetrain": "FWD",
            "specs": {
                "dimensions": {"length_mm": 4455, "width_mm": 1875, "height_mm": 1615, "wheelbase_mm": 2720}
            },
            "images": [],
            "description": "BYD YUAN PLUS - electric SUV with 510km range.",
            "status": "pending"
        },
        # BYD SONG L - Electric SUV Coupe
        {
            "manufacturer": "BYD",
            "model": "SONG L",
            "year": 2025,
            "trim_level": "Standard",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 550,
            "battery_kwh": 71.8,
            "acceleration_0_100": 7.5,
            "top_speed_kmh": 170,
            "power_kw": 150,
            "power_hp": 204,
            "charging_ac_kw": 11,
            "charging_dc_kw": 100,
            "manufacturer_direct_price": 67615,
            "price_qar": 67615,
            "body_style": "SUV Coupe",
            "drivetrain": "FWD",
            "specs": {
                "dimensions": {"length_mm": 4840, "width_mm": 1950, "height_mm": 1560, "wheelbase_mm": 2930}
            },
            "images": [],
            "description": "BYD SONG L - electric SUV coupe with 550km range.",
            "status": "pending"
        },
        {
            "manufacturer": "BYD",
            "model": "SONG L",
            "year": 2025,
            "trim_level": "Performance",
            "vehicle_type": "EV",
            "gcc_spec": True,
            "chinese_spec": False,
            "range_km": 662,
            "battery_kwh": 87.04,
            "acceleration_0_100": 4.5,
            "top_speed_kmh": 200,
            "power_kw": 230,
            "power_hp": 313,
            "charging_ac_kw": 11,
            "charging_dc_kw": 120,
            "manufacturer_direct_price": 85000,
            "price_qar": 85000,
            "body_style": "SUV Coupe",
            "drivetrain": "AWD",
            "specs": {},
            "images": [],
            "description": "BYD SONG L Performance with 4.5s acceleration and 662km range.",
            "status": "pending"
        },
        # GREY MARKET VEHICLES (Chinese-spec via QatarSale)
        # BYD LEOPARD 5 (Fang Cheng Bao)
        {
            "manufacturer": "BYD",
            "model": "LEOPARD 5",
            "year": 2025,
            "trim_level": "Ultra 5",
            "vehicle_type": "Hybrid",
            "gcc_spec": False,
            "chinese_spec": True,
            "range_km": None,
            "battery_kwh": None,
            "manufacturer_direct_price": None,
            "grey_market_price": 165000,
            "grey_market_source": "QatarSale",
            "grey_market_url": "https://qatarsale.com/en/products/cars_for_sale/byd",
            "price_qar": 165000,
            "body_style": "SUV",
            "drivetrain": "4WD",
            "fuel_type": "Petrol",
            "seats": 5,
            "specs": {},
            "images": [],
            "description": "BYD Leopard 5 (Fang Cheng Bao) - Chinese-spec grey market import via QatarSale. Petrol hybrid SUV.",
            "status": "pending"
        },
        # BYD LEOPARD 7
        {
            "manufacturer": "BYD",
            "model": "LEOPARD 7",
            "year": 2025,
            "trim_level": "Titanium 7",
            "vehicle_type": "Hybrid",
            "gcc_spec": False,
            "chinese_spec": True,
            "manufacturer_direct_price": None,
            "grey_market_price": 143000,
            "grey_market_source": "QatarSale",
            "grey_market_url": "https://qatarsale.com/en/products/cars_for_sale/byd",
            "price_qar": 143000,
            "body_style": "SUV",
            "drivetrain": "4WD",
            "fuel_type": "Petrol",
            "specs": {},
            "images": [],
            "description": "BYD Leopard 7 - Chinese-spec grey market import via QatarSale. Petrol hybrid SUV.",
            "status": "pending"
        },
        # BYD LEOPARD 8
        {
            "manufacturer": "BYD",
            "model": "LEOPARD 8",
            "year": 2025,
            "trim_level": "Flagship",
            "vehicle_type": "Hybrid",
            "gcc_spec": False,
            "chinese_spec": True,
            "manufacturer_direct_price": None,
            "grey_market_price": 280000,
            "grey_market_source": "QatarSale",
            "grey_market_url": "https://qatarsale.com/en/products/cars_for_sale/byd",
            "price_qar": 280000,
            "body_style": "SUV",
            "drivetrain": "4WD",
            "fuel_type": "Petrol",
            "specs": {},
            "images": [],
            "description": "BYD Leopard 8 Flagship - Chinese-spec grey market import. Premium SUV with 6 seaters, 21 inch rims.",
            "status": "pending"
        },
        # BYD DENZA B5
        {
            "manufacturer": "BYD",
            "model": "DENZA B5",
            "year": 2026,
            "trim_level": "Flagship",
            "vehicle_type": "Hybrid",
            "gcc_spec": False,
            "chinese_spec": True,
            "range_km": 100,
            "combined_range_km": 1000,
            "battery_kwh": 31.8,
            "manufacturer_direct_price": 195000,
            "grey_market_price": 185000,
            "grey_market_source": "QatarSale",
            "price_qar": 185000,
            "body_style": "SUV",
            "drivetrain": "AWD",
            "specs": {
                "dimensions": {"length_mm": 5090, "width_mm": 1990, "height_mm": 1940, "wheelbase_mm": 2850},
                "powertrain": {"power_kw": 400, "power_hp": 570, "torque_nm": 760}
            },
            "images": [],
            "description": "BYD Denza B5 - plug-in hybrid off-road SUV with 1000km range, 790mm wading depth.",
            "status": "pending"
        },
        # BYD DENZA B8
        {
            "manufacturer": "BYD",
            "model": "DENZA B8",
            "year": 2026,
            "trim_level": "Luxury",
            "vehicle_type": "Hybrid",
            "gcc_spec": False,
            "chinese_spec": True,
            "range_km": 100,
            "combined_range_km": 905,
            "battery_kwh": 36.8,
            "manufacturer_direct_price": 242046,
            "grey_market_price": 243000,
            "grey_market_source": "QatarSale",
            "price_qar": 243000,
            "body_style": "SUV",
            "drivetrain": "AWD",
            "specs": {
                "dimensions": {"length_mm": 5140, "width_mm": 1995, "height_mm": 1805, "wheelbase_mm": 3050},
                "powertrain": {"power_kw": 450, "power_hp": 738, "torque_nm": 760}
            },
            "images": [],
            "description": "BYD Denza B8 - luxury plug-in hybrid SUV with 905km range, 890mm wading depth.",
            "status": "pending"
        },
        # BYD DENZA N9
        {
            "manufacturer": "BYD",
            "model": "DENZA N9",
            "year": 2025,
            "trim_level": "Flagship",
            "vehicle_type": "Hybrid",
            "gcc_spec": False,
            "chinese_spec": True,
            "manufacturer_direct_price": None,
            "grey_market_price": 229999,
            "grey_market_source": "QatarSale",
            "grey_market_url": "https://qatarsale.com/en/products/cars_for_sale/byd",
            "price_qar": 229999,
            "body_style": "SUV",
            "drivetrain": "AWD",
            "fuel_type": "Petrol",
            "specs": {},
            "images": [],
            "description": "BYD Denza N9 Flagship - Chinese-spec grey market import via QatarSale.",
            "status": "pending"
        }
    ]
}

def main():
    # Save complete dataset
    output_file = '/home/pi/Desktop/QEV/byd_complete_dataset.json'
    with open(output_file, 'w') as f:
        json.dump(byd_complete_dataset, f, indent=2)

    # Summary
    vehicles = byd_complete_dataset['vehicles']
    gcc_count = sum(1 for v in vehicles if v.get('gcc_spec'))
    chinese_count = sum(1 for v in vehicles if v.get('chinese_spec'))
    ev_count = sum(1 for v in vehicles if v.get('vehicle_type') == 'EV')
    hybrid_count = sum(1 for v in vehicles if v.get('vehicle_type') == 'Hybrid')

    print(f"\n✓ Complete BYD dataset created!")
    print(f"  Total vehicles: {len(vehicles)}")
    print(f"  GCC-spec (official): {gcc_count}")
    print(f"  Chinese-spec (grey market): {chinese_count}")
    print(f"  Electric (EV): {ev_count}")
    print(f"  Hybrid (PHEV): {hybrid_count}")
    print(f"  Price range: {min(v['price_qar'] for v in vehicles if v.get('price_qar')):,} - {max(v['price_qar'] for v in vehicles if v.get('price_qar')):,} QAR")
    print(f"\n✓ Saved to: {output_file}")

if __name__ == '__main__':
    main()
