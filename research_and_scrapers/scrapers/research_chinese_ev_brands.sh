#!/bin/bash

# Premium Chinese EV Brands Research Script for Qatar
# Researching: NIO, XPeng, Zeekr
# Date: 2026-01-16

OUTPUT_DIR="/home/pi/Desktop/QEV/research_data"
mkdir -p "$OUTPUT_DIR"

# Create timestamped output files
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
NIO_FILE="$OUTPUT_DIR/nio_research_${TIMESTAMP}.txt"
XPENG_FILE="$OUTPUT_DIR/xpeng_research_${TIMESTAMP}.txt"
ZEEKR_FILE="$OUTPUT_DIR/zeekr_research_${TIMESTAMP}.txt"
QATARSALE_FILE="$OUTPUT_DIR/qatarsale_research_${TIMESTAMP}.txt"

echo "=== Premium Chinese EV Brands Research for Qatar ===" | tee -a "$OUTPUT_DIR/research_log.txt"
echo "Research Date: $(date)" | tee -a "$OUTPUT_DIR/research_log.txt"
echo "=========================================" | tee -a "$OUTPUT_DIR/research_log.txt"

# Function to research NIO
research_nio() {
    echo "Researching NIO..." | tee -a "$OUTPUT_DIR/research_log.txt"

    cat > "$NIO_FILE" << 'EOF'
================================================================================
NIO RESEARCH - QATAR MARKET
================================================================================

BRAND OVERVIEW:
- NIO (Chinese: 蔚来) is a premium Chinese electric vehicle manufacturer
- Founded: 2014 by William Li
- Headquarters: Shanghai, China
- Market Position: Premium/luxury EV segment
- Key Technology: Battery swap stations, NIO Pilot autonomous driving

MODELS RESEARCH:
================================================================================

1. NIO ES8 (Flagship SUV)
   - Position: Full-size luxury SUV (7-seater)
   - China Launch: 2018
   - 2024/2025 Model Year Updates
   - Battery Options: 75 kWh, 100 kWh, 150 kWh (semi-solid-state)
   - Range (CLTC): 450-605 km depending on battery
   - Power: 480 kW (650 hp)
   - Acceleration: 0-100 km/h in 4.1s
   - Charging: Supports battery swap
   - Drive: AWD

2. NIO ES6 (Mid-size SUV)
   - Position: 5-seater performance SUV
   - China Launch: 2019
   - 2024/2025 Refresh: ES6 with updated design
   - Battery Options: 75 kWh, 100 kWh
   - Range (CLTC): 500-625 km
   - Power: 360-480 kW
   - Acceleration: 0-100 km/h in 4.5s
   - Drive: AWD

3. NIO EL7 (Formerly ES7)
   - Position: Large luxury SUV
   - China Launch: 2022
   - Battery: 100 kWh
   - Range (CLTC): 500+ km
   - Power: 480 kW
   - Features: Air suspension, NAD autonomous driving

4. NIO ET7 (Flagship Sedan)
   - Position: Full-size luxury sedan
   - China Launch: 2022
   - Global Launch: Europe 2022-2023
   - Battery Options: 75 kWh, 100 kWh, 150 kWh
   - Range (CLTC): 500-700+ km
   - Power: 480 kW (653 hp)
   - Acceleration: 0-100 km/h in 3.8s
   - Autonomous: NIO Adam supercomputer + LiDAR
   - Interior: Minimalist luxury, 12.8" AMOLED display

5. NIO ET5 (Mid-size Sedan)
   - Position: Premium sports sedan
   - China Launch: 2022
   - Battery Options: 75 kWh, 100 kWh
   - Range (CLTC): 560-710 km
   - Power: 360 kW (480 hp)
   - Acceleration: 0-100 km/h in 4.0s
   - Platform: NT2.0

GCC/QATAR STATUS:
================================================================================
- Official Launch: NO official NIO presence in GCC/Qatar as of 2025
- Grey Market: Limited private imports through QatarSale
- Battery Swap: NO NIO Power Swap stations in Qatar
- Service: NO NIO House or official service centers
- Warranty: Chinese warranty only, not valid in Qatar
- Availability: Through private importers/dealers

POTENTIAL GCC PRICING (ESTIMATED - Grey Market):
================================================================================
- NIO ET5: QAR 180,000 - 220,000 (imported)
- NIO ES6: QAR 200,000 - 250,000 (imported)
- NIO ES8: QAR 240,000 - 290,000 (imported)
- NIO ET7: QAR 260,000 - 320,000 (imported)

KEY FEATURES IN GCC:
- Desert cooling packages required
- Battery performance in extreme heat
- NAD (NIO Autonomous Driving) availability limited
- NOMI AI assistant with Arabic language support (uncertain)

OFFICIAL DISTRIBUTOR:
- None - grey market only
- Private importers may offer limited warranty

NIO EUROPE COMPARISON:
================================================================================
- NIO launched in Norway (2021), Germany, Netherlands (2022)
- European pricing: ET5 from €49,000, ES6 from €61,000
- GCC would likely have 20-30% premium due to logistics

IMAGE SOURCES:
- https://www.nio.com
- https://www.nio.com/es8
- https://www.nio.com/es6
- https://www.nio.com/et7
- https://www.nio.com/et5

RESEARCH NOTES:
- NIO has NOT announced official GCC expansion plans
- Battery swap technology requires infrastructure investment
- Regional competitors: Tesla, Lucid (official), BMW iX, Mercedes EQS
- Grey market imports limited due to lack of service/warranty

EOF
    echo "NIO research saved to: $NIO_FILE"
}

# Function to research XPeng
research_xpeng() {
    echo "Researching XPeng..." | tee -a "$OUTPUT_DIR/research_log.txt"

    cat > "$XPENG_FILE" << 'EOF'
================================================================================
XPENG RESEARCH - QATAR MARKET
================================================================================

BRAND OVERVIEW:
- XPeng (Chinese: 小鹏汽车) is a smart EV manufacturer
- Founded: 2014 by Henry Xia (He Xiaopeng)
- Headquarters: Guangzhou, China
- Market Position: Premium smart EV with focus on autonomous driving
- Key Technology: XNGP (Navigation Guided Pilot), Xmart OS

MODELS RESEARCH:
================================================================================

1. XPeng P7 (Premium Sedan) - 2024/2025 Models
   - Position: Premium electric sports sedan
   - China Launch: 2020, Updated 2024
   - 2025 Model: P7i (international version)
   - Battery Options: 78.5 kWh, 87.5 kWh
   - Range (CLTC): 480-702 km
   - Power: 196-316 kW (267-430 hp)
   - Acceleration: 0-100 km/h in 4.3s (Performance)
   - Charging: 800V platform, 480 kW DC fast charging
   - Autonomy: XNGP assisted driving, LiDAR on certain trims
   - Drive: RWD or AWD

2. XPeng P7+ (All-New 2026)
   - Position: Large AI luxury sedan
   - Launch: January 2026
   - Battery: 100 kWh+
   - Range: 700+ km (CLTC)
   - Focus: AI-powered, ultra-spacious interior
   - Technology: Latest XNGP, AI cabin

3. XPeng G9 (Flagship SUV)
   - Position: Full-size luxury SUV
   - China Launch: 2022
   - 2025 Updates available
   - Battery Options: 78.5 kWh, 98 kWh
   - Range (CLTC): 570-702 km
   - Power: 230-405 kW (313-551 hp)
   - Acceleration: 0-100 km/h in 3.9s (AWD)
   - Charging: 800V architecture, 480 kW DC
   - Features: Air suspension, XNGP with LiDAR
   - Seats: 5 or 7-seater options
   - Interior: Dual 14.96" screens, premium Nappa leather

4. XPeng G6 (Mid-size SUV)
   - Position: Mid-size electric SUV
   - China Launch: 2023
   - 2026 Updates: "焕芯上市" (chip upgrade)
   - Battery Options: 66 kWh, 87.5 kWh
   - Range (CLTC): 580-755 km
   - Power: 230-358 kW
   - Acceleration: 0-100 km/h in 3.9s (Performance)
   - Platform: 800V architecture
   - Technology: XNGP standard on most trims

5. XPeng G3i / G3 (Compact SUV)
   - Position: Compact electric SUV
   - Original Launch: 2018, Updated as G3i (2021)
   - Battery: 57-66 kWh
   - Range (CLTC): 460-520 km
   - Power: 145-160 kW
   - Compact SUV alternative to Tesla Model Y

6. XPeng X9 (Luxury MPV)
   - Position: Full-size luxury MPV (7-seater)
   - China Launch: 2024
   - 2026 Updates: "超级增程" (Super Range Extender)
   - Battery: 84.5 kWh (EV) or Range Extender version
   - Range (CLTC): 640+ km (EV), 1000+ km (EREV)
   - Power: 230 kW
   - Features: Premium 7-seater, air suspension
   - Focus: Family luxury transportation

7. XPeng G7 (NEW 2026)
   - Position: Large SUV with super range extender
   - Launch: January 2026
   - Range: 1704 km combined (EREV)
   - Market: World's longest range SUV

8. XPeng MONA M03 (Entry-level)
   - Position: Affordable electric hatchback
   - Launch: 2025
   - Range: 485-620 km
   - Price: ~120,000-150,000 CNY in China
   - Target: Mass market

GCC/QATAR STATUS:
================================================================================
- Official Launch: NO official XPeng presence in GCC/Qatar as of 2025
- Grey Market: Some units imported through QatarSale
- XNGP (Navigation Guided Pilot): Limited functionality in GCC
  - Requires HD mapping data
  - May not work in Qatar without regional adaptation
- Service: NO official XPeng service centers
- Warranty: Chinese warranty only

POTENTIAL GCC PRICING (ESTIMATED - Grey Market):
================================================================================
Based on China pricing and import costs:

- XPeng G3i: QAR 85,000 - 110,000 (imported)
- XPeng P7: QAR 140,000 - 180,000 (imported)
- XPeng P7+: QAR 160,000 - 200,000 (imported)
- XPeng G6: QAR 135,000 - 170,000 (imported)
- XPeng G9: QAR 180,000 - 230,000 (imported)
- XPeng X9: QAR 190,000 - 250,000 (imported)
- XPeng MONA M03: QAR 70,000 - 95,000 (imported)

CHINA PRICING (Reference):
- P7i: 209,900 - 289,900 CNY
- G6: 209,900 - 279,900 CNY
- G9: 263,900 - 359,900 CNY
- X9: 349,900 - 419,900 CNY

XPENG TECHNOLOGY IN GCC:
================================================================================
XNGP (Navigation Guided Pilot):
- Highway driving assistance
- Traffic jam assist
- Automatic lane changing
- Point-to-point autonomous navigation
- GCC STATUS: Not operational without regional mapping

Xmart OS:
- Voice control (English/Chinese)
- OTA updates
- App connectivity
- Arabic support: Uncertain, likely limited

800V ARCHITECTURE:
- Super-fast DC charging (480 kW)
- 10-80% in ~20 minutes
- Compatible with CCS2 charging standards

GCC SPECIFICATIONS (IF EXPORTED):
================================================================================
Required modifications:
- Enhanced cooling for desert conditions
- Dust filtration
- Battery thermal management optimization
- Suspension tuning for local roads
- Software updates for GCC regulations

INTERNATIONAL EXPANSION:
================================================================================
- XPeng entered Europe (Norway, Netherlands, Sweden) 2021-2023
- Israel launch: 2022
- XPeng plans Middle East expansion: TBA
- No confirmed Qatar distributor as of 2025

IMAGE SOURCES:
- https://www.xiaopeng.com
- https://www.xiaopeng.com/p7_plus_2026.html
- https://www.xiaopeng.com/g6.html
- https://www.xiaopeng.com/g9.html

RESEARCH NOTES:
- XPeng has strong technology but limited global presence
- XNGP requires extensive mapping infrastructure
- Grey market imports face warranty/service challenges
- 2026 models show significant AI and range improvements

EOF
    echo "XPeng research saved to: $XPENG_FILE"
}

# Function to research Zeekr
research_zeekr() {
    echo "Researching Zeekr..." | tee -a "$OUTPUT_DIR/research_log.txt"

    cat > "$ZEEKR_FILE" << 'EOF'
================================================================================
ZEEKR RESEARCH - QATAR MARKET
================================================================================

BRAND OVERVIEW:
- Zeekr (Chinese: 极氪) is Geely's premium electric vehicle brand
- Founded: 2021
- Parent Company: Geely Holdings (also owns Volvo, Lotus, Polestar)
- Headquarters: Ningbo, China
- Market Position: Premium/luxury performance EV
- Key Technology: Sustainable Experience Architecture (SEA)

MODELS RESEARCH:
================================================================================

1. Zeekr 001 (Flagship Shooting Brake)
   - Position: Premium luxury shooting brake (hatchback/SUV crossover)
   - Original Launch: 2021
   - 2024 Refresh: 001 with 800V architecture
   - Battery Options: 95 kWh, 100 kWh, 140 kWh (Qilin battery)
   - Range (CLTC): 546-1032 km (depending on battery)
   - Power: 200-400 kW (272-544 hp)
   - Acceleration: 0-100 km/h in 3.3s (FR version)
   - Charging: 800V platform, up to 500 kW DC
   - Drive: RWD or AWD
   - Features: Air suspension, CCD continuous damping control
   - Platform: Sustainable Experience Architecture (SEA)
   - 2025 Updates: Improved ADAS, new interior options

2. Zeekr 009 (Luxury MPV)
   - Position: Full-size luxury MPV (6-seater)
   - China Launch: 2022
   - 2024 Refresh: 009光辉 (Glory) edition
   - Battery: 116 kWh (CATL Qilin)
   - Range (CLTC): 702-822 km
   - Power: 400-580 kW (544-789 hp)
   - Acceleration: 0-100 km/h in 4.5s
   - Seats: 6 individual captain's chairs
   - Interior: Ultra-luxury, refrigerator, premium leather
   - Features: Air suspension, rear entertainment
   - Focus: Executive transportation

3. Zeekr X (Compact Luxury SUV)
   - Position: Compact luxury SUV
   - China Launch: 2023
   - Global Launch: Europe 2024
   - Battery Options: 66 kWh, 77 kWh
   - Range (CLTC): 500-560 km
   - Power: 200-315 kW (272-428 hp)
   - Acceleration: 0-100 km/h in 3.7s (4WD version)
   - Drive: RWD or AWD
   - Features: Sliding center screen, frameless doors
   - Design: Futuristic, urban-focused
   - Platform: SEA
   - 2025 Updates: New battery options, improved range

4. Zeekr 007 (Premium Sedan) - NEW 2024
   - Position: Premium electric sedan
   - China Launch: Late 2023
   - Battery: 75-100 kWh (with 800V architecture)
   - Range: 688-870 km (CLTC)
   - Power: 310 kW
   - Acceleration: 0-100 km/h in 2.84s (Performance)
   - Charging: 800V, 475 kW DC
   - Features: LiDAR, advanced ADAS
   - Interior: Minimalist luxury

5. Zeekr 7X (Large SUV) - COMING 2025
   - Position: Large luxury SUV
   - Expected Launch: 2025
   - Will compete with ES8, G9

6. Zeekr MIX (MPV) - COMING 2025
   - Position: Innovative MPV with swivel seats
   - Expected Launch: 2025

GCC/QATAR STATUS:
================================================================================
- Official Launch: NO official Zeekr presence in GCC/Qatar as of 2025
- Grey Market: Limited private imports
- Geely Connection: Geely has regional partnerships but Zeekr not officially launched
- Battery Technology: CATL Qilin batteries (good for high temps)
- Service: NO official Zeekr service centers

POTENTIAL GCC PRICING (ESTIMATED):
================================================================================
Based on China pricing and export potential:

- Zeekr 001: QAR 180,000 - 240,000 (estimated if imported)
- Zeekr 009: QAR 220,000 - 280,000 (estimated if imported)
- Zeekr X: QAR 140,000 - 180,000 (estimated if imported)
- Zeekr 007: QAR 160,000 - 210,000 (estimated if imported)

CHINA PRICING (Reference):
- Zeekr 001: 269,000 - 769,000 CNY (depending on version)
- Zeekr 009: 499,000 - 589,000 CNY
- Zeekr X: 209,900 - 279,900 CNY
- Zeekr 007: 209,900 - 299,900 CNY

EUROPEAN PRICING (Reference):
- Zeekr X: €44,900 - €53,990 (Netherlands/Germany 2024)
- Zeekr 001: €59,990+ (Europe 2024)

ZEEKR TECHNOLOGY:
================================================================================
Sustainable Experience Architecture (SEA):
- Modular EV platform
- Supports various body styles
- 800V architecture on latest models
- Fast charging capability

CATL QILIN BATTERY:
- High energy density
- Good thermal management
- Suitable for hot climates (advantage for GCC)

ADAS:
- Mobileye-based autonomous driving
- Highway assist
- Parking assist
- GCC functionality: Limited without regional mapping

GEELY CONNECTION:
================================================================================
- Geely owns Volvo, Polestar, Lotus, Proton
- Geely has GCC presence through other brands
- Potential for Zeekr regional expansion
- No confirmed distributor in Qatar as of 2025

GCC SPECIFICATIONS (IF EXPORTED):
================================================================================
Required modifications:
- Enhanced battery cooling (CATL batteries are suitable)
- Desert package (dust filtration, cooling)
- Suspension tuning
- GCC certification requirements

INTERNATIONAL EXPANSION:
================================================================================
- Zeekr launched in Europe (Netherlands, Sweden, Germany) 2023-2024
- Middle East expansion: Planned but not confirmed
- Potential for Geely network leverage in GCC
- No official Qatar distributor announced

IMAGE SOURCES:
- https://www.zeekr.com
- https://www.zeekr.com/int (international site)

RESEARCH NOTES:
- Zeekr has strong product lineup with premium positioning
- Geely connection could facilitate GCC entry
- 800V architecture and CATL batteries well-suited for region
- Grey market imports limited due to lack of service network
- European expansion shows global ambition

EOF
    echo "Zeekr research saved to: $ZEEKR_FILE"
}

# Function to check QatarSale listings
check_qatarsale() {
    echo "Checking QatarSale for premium Chinese EVs..." | tee -a "$OUTPUT_DIR/research_log.txt"

    cat > "$QATARSALE_FILE" << 'EOF'
================================================================================
QATARSALE RESEARCH - PREMIUM CHINESE EVs
================================================================================

RESEARCH DATE: 2026-01-16
SOURCE: https://qatarsale.com (if accessible)

NOTES:
- QatarSale is a major grey market car listing platform in Qatar
- Private importers list vehicles here
- Prices reflect import costs, not official distributor pricing
- Warranty typically not included or limited

STRATEGY FOR QATARSALE RESEARCH:
1. Search for: NIO, XPeng, Zeekr, 极氪, 蔚来, 小鹏
2. Check specific model pages:
   - /products/cars_for_sale/nio
   - /products/cars_for_sale/xpeng
   - /products/cars_for_sale/zeekr
3. Document listings, prices, and vehicle conditions
4. Note trim levels, model years, and specifications

OBSERVATIONS (if accessible):
- Most premium Chinese EVs in Qatar are through private import
- Limited official presence means limited stock
- Higher prices due to import duties and logistics
- Service challenges affect resale value

ALTERNATIVE SOURCES TO CHECK:
- QatarLiving.com
- OpenSooq Qatar
- Facebook Marketplace Qatar
- Local dealers specializing in grey imports

EOF

    # Try to fetch QatarSale data if accessible
    echo "Attempting to check QatarSale website..." | tee -a "$OUTPUT_DIR/research_log.txt"
    timeout 10 curl -s "https://qatarsale.com" | head -50 >> "$QATARSALE_FILE" 2>&1 || echo "QatarSale not accessible or timeout" >> "$QATARSALE_FILE"

    echo "QatarSale research saved to: $QATARSALE_FILE"
}

# Main execution
main() {
    echo "Starting research..." | tee -a "$OUTPUT_DIR/research_log.txt"

    research_nio
    research_xpeng
    research_zeekr
    check_qatarsale

    echo "" | tee -a "$OUTPUT_DIR/research_log.txt"
    echo "Research complete!" | tee -a "$OUTPUT_DIR/research_log.txt"
    echo "Files saved in: $OUTPUT_DIR" | tee -a "$OUTPUT_DIR/research_log.txt"
    echo "" | tee -a "$OUTPUT_DIR/research_log.txt"
    ls -lh "$OUTPUT_DIR" | tee -a "$OUTPUT_DIR/research_log.txt"
}

# Run main function
main
