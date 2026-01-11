# Tarsheed Charging Stations Data Import - Complete Guide

## Overview

This guide documents the complete process to extract charging station data from the Tarsheed app using an Android emulator and import it into the QEV Hub database.

**Important Notes:**
- This is a ONE-TIME data capture only
- No ongoing scraping or automation
- Purpose: Initialize QEV Hub database with official Tarsheed data
- All existing seed data will be replaced

## Prerequisites

### System Requirements
- OS: Linux (Ubuntu/Debian recommended)
- RAM: 8GB+ minimum (you have 15GB ✅)
- Disk Space: 15GB+ available (you have 126GB ✅)
- Python 3.8+ (you have 3.12.3 ✅)
- Node.js 16+ (installed with project ✅)

### Software to Install
- Java Development Kit (JDK) 17
- Android SDK Command Line Tools
- Android System Image (API 33 with Google APIs)
- Android Emulator
- mitmproxy (Python package)
- jq (JSON processor)
- apktool (optional, for APK analysis)

### Account Requirements
- Valid Qatar ID
- Active Tarsheed account (personal or business)
- Tarsheed app will be downloaded from Play Store

## Phase 1: Install Required Tools (30-45 minutes)

### 1.1 Install Java JDK

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk

# Verify installation
java -version
```

### 1.2 Install Android SDK

```bash
# Create Android SDK directory
mkdir -p ~/Android/sdk
cd ~/Android/sdk

# Download command line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-*.zip

# Create local.properties to accept licenses
mkdir -p ~/Android/sdk/cmdline-tools/latest/bin
echo "sdk.dir=$HOME/Android/sdk" > ~/Android/sdk/cmdline-tools/latest/local.properties

# Accept licenses non-interactively
yes | ~/Android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses

# Install required SDK packages
~/Android/sdk/cmdline-tools/latest/bin/sdkmanager \
  "platform-tools" \
  "platforms;android-33" \
  "system-images;android-33;google_apis;x86_64" \
  "emulator" \
  "build-tools;33.0.2"

# Set environment variables
echo 'export ANDROID_HOME=$HOME/Android/sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

# Verify installation
adb --version
```

### 1.3 Install mitmproxy

```bash
# Install mitmproxy via pip
pip3 install --user mitmproxy

# Add to PATH
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
~/.local/bin/mitmproxy --version
```

### 1.4 Install Additional Tools

```bash
# Install JSON processor
sudo apt install -y jq

# Install APK analysis tool (optional)
sudo apt install -y apktool
```

## Phase 2: Create Android Emulator (10-15 minutes)

### 2.1 Create Android Virtual Device (AVD)

```bash
# Create AVD with minimal specs
~/.local/bin/avdmanager create avd \
  -n qev-tarsheed \
  -k "system-images;android-33;google_apis;x86_64" \
  --device "pixel_6" \
  --force

# This will ask you to select system image features
# Choose defaults (press Enter for each prompt)
```

### 2.2 Edit AVD Configuration

```bash
# Edit AVD config to reduce RAM usage
nano ~/.android/avd/qev-tarsheed.avd/config.ini
```

Update these settings:

```ini
# Reduce RAM to 4GB (safe for your 15GB system)
hw.ramSize=4096

# Enable hardware acceleration
hw.gpu.enabled=yes
hw.gpu.mode=auto

# Screen resolution
hw.lcd.density=420
hw.lcd.height=2400
hw.lcd.width=1080
```

Save with `Ctrl+X`, then `Y`, then `Enter`

### 2.3 Start Emulator

```bash
# Start emulator in background
cd /home/pi/Desktop/QEV/qev-hub-web
emulator -avd qev-tarsheed \
  -no-snapshot-load \
  -no-snapshot-save \
  -no-audio \
  -no-boot-anim \
  -wipe-data &

# Wait for emulator to boot
echo "Waiting for emulator to boot..."
adb wait-for-device
sleep 30

# Verify boot complete
adb shell getprop sys.boot_completed
# Should return: 1
```

## Phase 3: Configure Network Interception (30 minutes)

### 3.1 Get Machine IP Address

```bash
# Find your local IP
YOUR_IP=$(hostname -I | awk '{print $1}')
echo "Your machine IP: $YOUR_IP"
# Note this IP (e.g., 192.168.1.100)
```

### 3.2 Configure Emulator Proxy

```bash
# Set proxy on emulator
adb shell settings put global http_proxy $YOUR_IP:8080
adb shell settings put global https_proxy $YOUR_IP:8080

# Allow user certificates
adb shell settings put global user_certificate_allowed 1

# Verify proxy settings
adb shell settings get global http_proxy
adb shell settings get global https_proxy
```

### 3.3 Install SSL Certificate on Emulator

**Method A: Via Emulator Browser**

1. Start mitmproxy briefly (to generate certificate):
   ```bash
   ~/.local/bin/mitmproxy --listen-host 0.0.0.0 --listen-port 8080 &
   MITMPID=$!
   sleep 2
   kill $MITMPID
   ```

2. On emulator, open Chrome browser
3. Navigate to: `http://mitm.it`
4. Download Android certificate (CA certificate)
5. Open Settings → Security → Install certificates
6. Choose: VPN and apps
7. Select downloaded certificate
8. Name it: `mitmproxy`
9. Set usage: VPN and apps
10. Confirm installation

**Method B: Via ADB Command Line**

```bash
# Copy certificate to emulator
adb push ~/.mitmproxy/mitmproxy-ca-cert.cer /sdcard/Download/

# Install certificate via intent
adb shell am start -a android.intent.action.VIEW \
  -d "file:///sdcard/Download/mitmproxy-ca-cert.cer" \
  -t "application/x-x509-ca-cert"

# Follow prompts on emulator to install
```

**Verify Certificate:**

```bash
# Check if certificate is installed
adb shell "ls /data/misc/user/0/cacerts-added/ | grep mitmproxy"
# Should show certificate file
```

## Phase 4: Capture Tarsheed Data (20-30 minutes)

### 4.1 Start Network Capture

```bash
# Navigate to project directory
cd /home/pi/Desktop/QEV/qev-hub-web

# Start mitmproxy with capture script
~/.local/bin/mitmproxy \
  --listen-host 0.0.0.0 \
  --listen-port 8080 \
  -s scripts/tarsheed-capture.py \
  --set block_global=false \
  --ssl-insecure

# Leave this running throughout the capture process
# Terminal will show captured requests in real-time
```

**Keep this terminal open and running!**

### 4.2 Install Tarsheed APK

**On Emulator:**

1. Open Play Store app
2. Search for "Tarsheed"
3. Find the official Tarsheed app (likely by KAHRAMAA)
4. Install the app
5. Wait for installation to complete

### 4.3 Login to Tarsheed

**On Emulator:**

1. Open Tarsheed app
2. Enter your Qatar ID credentials
3. Complete any MFA if required
4. Wait for app to load

### 4.4 Navigate Tarsheed App to Capture All Data

**Step-by-Step Navigation (do these slowly, 2-3 seconds between each):**

1. **Find Charging Section**
   - Look for: "EV Charging", "Electric Vehicles", "Chargers" in menu
   - Tap on it to open charging stations view

2. **Explore Map View**
   - In map view, zoom out to see entire Qatar
   - Pan around slowly to load all regions:
     - Doha/West Bay area
     - The Pearl
     - Lusail
     - Katara
     - Airport
     - Al Wakrah
     - Al Khor
   - This should trigger API calls to load stations for visible areas

3. **Switch to List View**
   - If available, switch from map to list
   - Scroll through entire list slowly
   - This may trigger pagination or infinite scroll

4. **View Station Details**
   - Tap on ~10-15 different stations from various regions
   - Wait 2-3 seconds for details to load
   - Check for: connector types, amenities, restrooms, availability

5. **Test Filters (if available)**
   - Filter by: charger type, availability, region
   - This may trigger different API endpoints

6. **Refresh Data**
   - Use pull-to-refresh if available
   - This should reload station availability

**Navigation Duration:** 20-30 minutes total

### 4.5 Verify Capture

While still in mitmproxy terminal, check:

```bash
# In another terminal, check captured data
cd /home/pi/Desktop/QEV/qev-hub-web
wc -l tarsheed-captured.jsonl

# Should show 50+ lines (one per API call)
```

### 4.6 Stop Capture

**In mitmproxy terminal:**
- Press `Ctrl+C` to stop capture

**You should see:**

```
======================================================================
📊 CAPTURE SUMMARY
======================================================================
Total requests processed:      127
Charging requests captured:    47
Unique hosts filtered:        2
Data saved to:              tarsheed-captured.jsonl
File size:                  42.57 KB
Capture timestamp:           2026-01-11T18:45:32.123456
======================================================================
```

### 4.7 Backup Capture

```bash
# Archive capture with timestamp
mkdir -p archived-captures
cp tarsheed-captured.jsonl archived-captures/tarsheed-captured-backup-$(date +%Y%m%d-%H%M%S).jsonl

# Verify backup
ls -lh archived-captures/
```

## Phase 5: Parse Captured Data (5-10 minutes)

### 5.1 Run Parser Script

```bash
cd /home/pi/Desktop/QEV/qev-hub-web

# Parse captured JSON and extract stations
node scripts/parse-tarsheed-capture.js
```

**Expected Output:**

```
🔍 Parsing captured Tarsheed data...
📁 Reading from: tarsheed-captured.jsonl

✓ Extracted station 1: KAHRAMAA - Katara Cultural Village
✓ Extracted station 2: KAHRAMAA - The Pearl
✓ Extracted station 3: KAHRAMAA - Lusail Boulevard
...
✓ Extracted station 52: KAHRAMAA - Al Khor Mall

======================================================================
📊 PARSING SUMMARY
======================================================================
Total lines processed:     127
API calls captured:        89
Valid JSON responses:      67
Unique stations found:     52
======================================================================

✅ Stations saved to: tarsheed-stations-extracted.json
   File size: 18.42 KB
   Station count: 52

📋 Sample extracted stations (first 5):

   1. KAHRAMAA - Katara Cultural Village
      Location: 25.3548, 51.5326
      Chargers: 2/4
      Connector: Type 2 / CCS

   2. KAHRAMAA - The Pearl - Porto Arabia
      Location: 25.3714, 51.5504
      Chargers: 1/2
      Connector: Type 2 / CHAdeMO

   ... and 47 more stations

🎉 Parsing complete! Extracted 52 unique stations.
```

### 5.2 Verify Extracted Data

```bash
# Check JSON structure
cat tarsheed-stations-extracted.json | jq '.[] | {name, latitude, longitude, available_chargers}' | head -20

# Count stations
cat tarsheed-stations-extracted.json | jq '. | length'
# Should show: 52 (or similar)
```

## Phase 6: Backup Existing Data (5 minutes)

### 6.1 Create Backup in Supabase

**Open Supabase SQL Editor:** https://app.supabase.com

**Run this SQL:**

```sql
-- Create backup table with all existing data
CREATE TABLE charging_stations_backup AS 
SELECT * FROM charging_stations;

-- Verify backup
SELECT COUNT(*) as backup_count FROM charging_stations_backup;

-- Sample of backed up data
SELECT name, latitude, longitude, available_chargers
FROM charging_stations_backup
LIMIT 5;
```

**Expected Result:**
- `backup_count`: 13 (current seed data)

### 6.2 Verify Backup Exists

```bash
# This will be checked by the import script
# No manual verification needed if SQL ran successfully
```

## Phase 7: Import Tarsheed Data (5-10 minutes)

### 7.1 Run Import Script

```bash
cd /home/pi/Desktop/QEV/qev-hub-web

# Clear existing data and import Tarsheed stations
node scripts/clear-and-import-tarsheed.js
```

**Expected Output:**

```
🚀 Tarsheed Charging Stations Import

======================================================================

📥 Reading Tarsheed station data...
   Found 52 stations

🗋 Step 1: Verifying backup table exists...
   ✓ Backup table verified with 13 records

🗑 Step 2: Deleting ALL existing charging stations...
   ✓ Deleted 13 existing stations

📥 Step 3: Importing 52 Tarsheed stations...
   ✓ Imported: KAHRAMAA - Katara Cultural Village
   ✓ Imported: KAHRAMAA - The Pearl - Porto Arabia
   ✓ Imported: KAHRAMAA - Lusail Boulevard
   ...
   ✓ Imported: KAHRAMAA - Al Khor Mall

✓ Step 4: Validating imported data...

======================================================================
📊 IMPORT SUMMARY
======================================================================
Stations deleted:       13
Stations imported:      52
Stations failed:        0
Import success rate:    100.0%

🔍 VALIDATION RESULTS:
   Total stations in DB:  52
   Valid coordinates:     52
   Stations with nulls:  0
   Stations with amenities: 52

======================================================================

🎉 All stations imported successfully!
🗺️  View at: http://localhost:3000/charging

📝 Next steps:
   1. Verify charging page displays stations correctly
   2. Check station details for accuracy
   3. Test map markers display properly
   4. Delete backup table after validation period
```

## Phase 8: Verify in Application (5 minutes)

### 8.1 Start QEV Hub Application

```bash
cd /home/pi/Desktop/QEV/qev-hub-web
npm run dev
```

### 8.2 Open Charging Page

1. Open browser: http://localhost:3000/charging
2. Verify:
   - Map displays markers for all 52 stations
   - Markers show green (available) or red (full) correctly
   - Station list shows all stations
   - Clicking a station shows correct details

### 8.3 Test Station Details

1. Click on several different stations
2. Verify details show:
   - Connector types
   - Power output
   - Available chargers
   - Amenities (restrooms, WiFi, parking, etc.)
   - Operating hours
   - Pricing info

## Phase 9: Complete Cleanup (5-10 minutes)

### 9.1 Stop Emulator

```bash
# Stop emulator
adb emu kill

# Verify emulator stopped
adb devices
# Should show no devices
```

### 9.2 Remove Android SDK

```bash
# Delete AVD
~/.local/bin/avdmanager delete avd -n qev-tarsheed

# Remove Android SDK directory
rm -rf ~/Android/sdk

# Remove emulator configuration
rm -rf ~/.android/avd/qev-tarsheed.avd
```

### 9.3 Remove Proxy Tools

```bash
# Uninstall mitmproxy
pip3 uninstall -y mitmproxy

# Remove certificate
rm -f ~/.mitmproxy/mitmproxy-ca-cert.cer
rm -f ~/.mitmproxy/mitmproxy-ca-cert.pem
```

### 9.4 Archive All Capture Data

```bash
cd /home/pi/Desktop/QEV/qev-hub-web

# Create final archive with timestamp
tar -czf archived-captures/tarsheed-complete-$(date +%Y%m%d-%H%M%S).tar.gz \
  tarsheed-captured.jsonl \
  tarsheed-captured-backup-*.jsonl \
  tarsheed-stations-extracted.json \
  scripts/tarsheed-capture.py

# Delete raw capture files (after archiving)
rm -f tarsheed-captured.jsonl
rm -f tarsheed-captured-backup-*.jsonl
rm -f tarsheed-stations-extracted.json

# Verify archive
ls -lh archived-captures/
```

### 9.5 Remove Java (Optional)

```bash
# If you don't need Java for other projects:
sudo apt remove -y openjdk-17-jdk
```

## Troubleshooting

### Issue: Emulator won't boot

**Symptoms:** Emulator hangs at Android logo or black screen

**Solutions:**
```bash
# Check if hardware acceleration is available
emulator -accel-check

# Try without hardware acceleration
emulator -avd qev-tarsheed -no-accel

# Increase RAM in AVD config (if you have enough RAM)
nano ~/.android/avd/qev-tarsheed.avd/config.ini
# Change hw.ramSize to 6144
```

### Issue: mitmproxy not capturing any requests

**Symptoms:** No requests captured in terminal

**Solutions:**
```bash
# Verify proxy is set on emulator
adb shell settings get global http_proxy
adb shell settings get global https_proxy

# Verify certificate is installed
adb shell "ls /data/misc/user/0/cacerts-added/"

# Check mitmproxy is listening
netstat -tulpn | grep :8080

# Try restarting proxy on emulator
adb shell settings put global http_proxy ""
adb shell settings put global http_proxy $YOUR_IP:8080
```

### Issue: No stations extracted from capture

**Symptoms:** Parser shows 0 stations extracted

**Possible Causes:**
1. Tarsheed app was not opened during capture
2. Charging section was not navigated
3. API response structure is different than expected

**Solutions:**
1. Repeat capture process
2. Ensure you navigate to charging stations section in app
3. Check capture file: `cat tarsheed-captured.jsonl | jq '.' | head -20`
4. Look for station-related endpoints in captured URLs

### Issue: Import script fails - backup table not found

**Symptoms:** Import script exits with error about missing backup table

**Solution:**
```sql
-- Run this in Supabase SQL Editor
CREATE TABLE charging_stations_backup AS 
SELECT * FROM charging_stations;
```

### Issue: Stations imported but not showing on map

**Symptoms:** Database shows 52 stations, but map is empty

**Solutions:**
```sql
-- Check if data was actually imported
SELECT COUNT(*) FROM charging_stations;

-- Check for invalid coordinates
SELECT * FROM charging_stations WHERE latitude = 0 OR longitude = 0;

-- Restart Next.js dev server
npm run dev
```

## Post-Import Verification

### SQL Queries to Verify Data Quality

Run these in Supabase SQL Editor:

```sql
-- 1. Total station count
SELECT COUNT(*) as total_stations FROM charging_stations;
-- Expected: 50+ (or however many were extracted)

-- 2. Check for null coordinates
SELECT COUNT(*) as bad_coordinates 
FROM charging_stations 
WHERE latitude = 0 OR longitude = 0;
-- Expected: 0

-- 3. Sample stations
SELECT name, latitude, longitude, available_chargers, charger_type, 
       power_output_kw, amenities, last_scraped_at
FROM charging_stations
ORDER BY last_scraped_at DESC
LIMIT 10;

-- 4. Check all amenities populated
SELECT COUNT(*) as with_amenities
FROM charging_stations
WHERE array_length(amenities, 1) > 0;
-- Expected: Total stations count

-- 5. Check unique providers
SELECT provider, COUNT(*) as count
FROM charging_stations
GROUP BY provider;

-- 6. Check stations with restrooms
SELECT COUNT(*) as with_restrooms
FROM charging_stations
WHERE 'Restroom' = ANY(amenities);

-- 7. Geographic coverage (check spread)
SELECT 
  MIN(latitude) as min_lat,
  MAX(latitude) as max_lat,
  MIN(longitude) as min_lng,
  MAX(longitude) as max_lng
FROM charging_stations;
```

## Data Retention Policy

### Backup Table

- Keep `charging_stations_backup` for **7 days**
- After 7 days, delete:
  ```sql
  DROP TABLE charging_stations_backup;
  ```

### Archived Captures

- Keep `archived-captures/` directory for **30 days**
- After 30 days, delete all archives:
  ```bash
  rm -rf archived-captures/
  ```

### Script Files

- Keep `scripts/clear-and-import-tarsheed.js` for future reference
- Archive `tarsheed-capture.py` and `parse-tarsheed-capture.js` to `archived-captures/`

## Legal & Compliance Notes

### Purpose Documentation

- This was a one-time data extraction for internal database initialization
- No ongoing scraping or automated data collection
- Data is used solely for QEV Hub charging station display
- No user account data was captured
- No payment/transaction data was extracted

### Attribution

If displaying Tarsheed data, consider adding:
> "Charging station data provided by Tarsheed (KAHRAMAA)"

### Future Partnership

Consider reaching out to KAHRAMAA for official API access:
- Benefits: Real-time data, official support, legal compliance
- Contact: +974 4440 0066
- Website: kahramaa.com.qa

## Completion Checklist

- [ ] Android SDK and tools installed
- [ ] Emulator created and running
- [ ] mitmproxy configured and SSL certificate installed
- [ ] Tarsheed app installed from Play Store
- [ ] Logged in with Qatar credentials
- [ ] Navigated charging stations (map + list + details)
- [ ] Network capture completed with 50+ API calls
- [ ] Captured data parsed and 50+ stations extracted
- [ ] Backup table created in Supabase
- [ ] Existing seed data deleted
- [ ] Tarsheed data imported successfully
- [ ] Data validated (no nulls, all coordinates valid)
- [ ] Charging page verified to display stations
- [ ] Emulator and tools removed
- [ ] Capture data archived and raw files deleted

## Estimated Time Summary

| Phase | Estimated Time |
|--------|----------------|
| Phase 1: Install Tools | 30-45 min |
| Phase 2: Create Emulator | 10-15 min |
| Phase 3: Configure Proxy | 30 min |
| Phase 4: Capture Data | 20-30 min |
| Phase 5: Parse Data | 5-10 min |
| Phase 6: Backup Data | 5 min |
| Phase 7: Import Data | 5-10 min |
| Phase 8: Verify App | 5 min |
| Phase 9: Cleanup | 5-10 min |
| **TOTAL** | **~2-3 hours** |

## Support

If issues occur during execution:
1. Check troubleshooting section above
2. Review captured JSON: `cat tarsheed-captured.jsonl | jq '.'`
3. Check Supabase logs: https://app.supabase.com/logs
4. Verify emulator status: `adb devices`

---

**Document Version:** 1.0  
**Created:** January 11, 2026  
**For:** QEV Hub - Tarsheed Charging Stations Data Import
