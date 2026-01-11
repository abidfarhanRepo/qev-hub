# Real Android Device Tarsheed Data Capture - Quick Reference

## Purpose

This document provides quick reference instructions for capturing Tarsheed charging station data using a real Android device via USB connection and mitmproxy network interception.

## Project Information

- **Project**: QEV Hub - Electric Vehicle Marketplace for Qatar
- **Goal**: Extract official charging station data from Tarsheed app
- **Method**: One-time data capture via network interception
- **Target**: Replace existing seed data with 50+ Tarsheed stations
- **Database**: Supabase PostgreSQL
- **Environment**: Linux machine with real Android device

## Machine Information

- **Your Machine IP**: `192.168.10.234`
- **mitmproxy Port**: `8080`
- **mitmproxy Status**: Starting...
- **Capture Script**: `scripts/tarsheed-capture.py`
- **Output File**: `tarsheed-captured.jsonl`

## Prerequisites

### ✅ Verified Ready
- [x] mitmproxy 8.1.1 installed (`/usr/bin/mitmproxy`)
- [x] Python 3.12.3 installed
- [x] Node.js installed
- [x] Tarsheed capture script created
- [x] JSON parser script created
- [x] Database import script created
- [x] Android device connected via USB

### ⏳ Pending Steps
- [ ] Configure Android device WiFi proxy
- [ ] Install mitmproxy CA certificate on device
- [ ] Navigate Tarsheed app to capture data
- [ ] Parse captured JSON data
- [ ] Import to Supabase database

## Step-by-Step Instructions

### Phase 1: Configure Android Device for Network Interception

#### 1.1 Connect Android Device to Same WiFi Network

**Critical Requirement**: Your Android device and this machine (192.168.10.234) must be on the same WiFi network for proxy to work.

**Options:**
1. Connect Android device to same WiFi router
2. Create WiFi hotspot on this machine, connect Android to it

#### 1.2 Install mitmproxy CA Certificate on Android Device

**On your Android device:**

1. **Download Certificate**
   - Open Chrome browser or default browser
   - Navigate to: `http://192.168.10.234:8080/mitm.it`
   - Tap "Android" or "Android CA certificate"
   - Download the certificate file
   - Save to: `/sdcard/Download/`

2. **Install Certificate**
   - Go to: Settings → Security
   - Scroll to: "Install from storage"
   - Tap to open file manager
   - Navigate to: `Download` folder
   - Select: `mitmproxy-ca-cert.cer`
   - You'll see warning about network monitoring
   - Name it: `mitmproxy`
   - Choose usage: "VPN and apps"
   - Confirm installation

#### 1.3 Configure WiFi Proxy on Android Device

**On your Android device:**

1. Go to: Settings → WiFi
2. Long-press on your connected WiFi network
3. Choose: "Modify network"
4. Scroll down to: "Proxy"
5. Enable proxy and enter:
   - **Proxy hostname**: `192.168.10.234`
   - **Proxy port**: `8080`
6. Save network settings

#### 1.4 Verify Proxy is Working

**On your Android device:**
1. Open browser
2. Navigate to: `http://google.com`
3. If it loads, proxy is working correctly

---

### Phase 2: Start Network Capture on Machine

#### 2.1 Start mitmproxy

**On this machine (already started in background):**

```bash
cd /home/pi/Desktop/QEV/qev-hub-web
/usr/bin/mitmproxy --listen-host 0.0.0.0 --listen-port 8080 -s scripts/tarsheed-capture.py --set block_global=false --ssl-insecure
```

**mitmproxy is already running in background.**

**You should see:**
```
Mitmproxy starting...
HTTP server listening at 0.0.0.0:8080
```

#### 2.2 Open mitmproxy Web UI (Optional)

Open in browser on this machine: `http://127.0.0.1:8081`

This shows real-time flow of captured requests.

---

### Phase 3: Navigate Tarsheed App to Capture Data

#### 3.1 Open Tarsheed App

**On your Android device:**

1. Open Tarsheed app (from KAHRAMAA)
2. Login with your Qatar credentials
3. Wait for app to load

#### 3.2 Navigate Charging Stations Section

**Step-by-Step Navigation (do these slowly, 2-3 seconds between each):**

1. **Find Charging Section**
   - Look for: "EV Charging", "Electric Vehicles", "Chargers" in menu
   - Tap on it to open charging stations view
   - **Wait 2-3 seconds**

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
   - Wait 2-3 seconds between each pan
   - This triggers API calls to load stations for visible areas

3. **Switch to List View**
   - If available, switch from map to list
   - Scroll through entire list slowly
   - Wait 2-3 seconds at each scroll
   - This may trigger pagination or infinite scroll

4. **View Station Details**
   - Tap on 10-15 different stations from various regions
   - Wait 2-3 seconds for details to load
   - Check for: connector types, amenities, restrooms, availability
   - Tap "Back" after viewing each station

5. **Test Filters (if available)**
   - Filter by: charger type, availability, region
   - Wait 2-3 seconds after each filter change
   - This may trigger different API endpoints

6. **Refresh Data**
   - Use pull-to-refresh if available
   - This should reload station availability

**Navigation Duration:** 20-30 minutes total

#### 3.3 Watch for Capture Messages

**On this machine terminal running mitmproxy:**

You should see messages like:
```
✓ Captured [1]: GET /api/v1/charging/stations
✓ Captured [2]: GET /api/v1/charging/station/123/details
✓ Captured [3]: POST /api/v1/charging/locations
✓ Captured [4]: GET /api/v1/charging/stations?bounds=...
```

**Each station you tap on, map pan, or filter change should trigger a new capture.**

---

### Phase 4: Stop Capture and Parse Data

#### 4.1 Stop mitmproxy

**On this machine terminal running mitmproxy:**
- Press `Ctrl+C` to stop capture

**You should see:**
```
======================================================================
📊 CAPTURE SUMMARY
======================================================================
Total requests processed:      142
Charging requests captured:    47
Unique hosts filtered:        2
Capture duration:             00:24:32
Data saved to:              tarsheed-captured.jsonl
File size:                  42.57 KB
Capture timestamp:           2026-01-11T19:15:45.123456
======================================================================
```

#### 4.2 Backup Captured Data

```bash
cd /home/pi/Desktop/QEV/qev-hub-web

# Archive capture with timestamp
cp tarsheed-captured.jsonl archived-captures/tarsheed-captured-backup-$(date +%Y%m%d-%H%M%S).jsonl

# Verify backup
ls -lh archived-captures/
```

#### 4.3 Parse Captured JSON Data

```bash
# Run parser script to extract stations
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

---

### Phase 5: Import Data to Supabase

#### 5.1 Create Backup in Supabase

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

#### 5.2 Import Tarsheed Data to Database

```bash
cd /home/pi/Desktop/QEV/qev-hub-web

# Run import script (clears existing data, imports Tarsheed stations)
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

---

### Phase 6: Verify in QEV Hub Application

#### 6.1 Start QEV Hub Application

```bash
cd /home/pi/Desktop/QEV/qev-hub-web
npm run dev
```

#### 6.2 Open Charging Page

**In browser:**
1. Open: http://localhost:3000/charging
2. Verify:
   - Map displays markers for all 52+ stations
   - Markers show green (available) or red (full) correctly
   - Station list shows all stations
   - Clicking a station shows correct details

#### 6.3 Test Station Details

1. Click on several different stations
2. Verify details show:
   - Connector types
   - Power output
   - Available chargers
   - Amenities (restrooms, WiFi, parking, etc.)
   - Operating hours
   - Pricing info

---

### Phase 7: Cleanup

#### 7.1 Clean Up on Android Device

**On your Android device:**
1. Go to: Settings → WiFi
2. Long-press connected network → Modify network
3. Scroll to Proxy → Disable proxy
4. Reconnect to WiFi

**Remove mitmproxy CA certificate:**
1. Go to: Settings → Security → Credential storage → Trusted credentials
2. Find: `mitmproxy` certificate
3. Remove it

#### 7.2 Clean Up on Machine

```bash
# Stop mitmproxy (should already be stopped from Phase 4.1)
# Archive all capture files
cd /home/pi/Desktop/QEV/qev-hub-web
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

---

## Troubleshooting

### Issue: mitmproxy not capturing any requests

**Symptoms:** No `✓ Captured [N]:` messages in terminal

**Solutions:**
1. Verify Android device is connected to same WiFi network as machine
2. Verify WiFi proxy is configured correctly (192.168.10.234:8080)
3. Verify certificate is installed on Android device
4. Check mitmproxy is running: `ps aux | grep mitmproxy`
5. Try opening browser on Android to: `http://192.168.10.234:8080/mitm.it`

### Issue: Tarsheed app not loading

**Symptoms:** App shows errors or doesn't load

**Solutions:**
1. Check if WiFi is working (try loading other website)
2. Disable proxy temporarily on Android device
3. If app loads without proxy, re-check proxy configuration
4. Try different browser on Android device

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

---

## Verification Commands

### Verify Captured Data

```bash
# Count captured API calls
wc -l tarsheed-captured.jsonl

# Preview captured data
cat tarsheed-captured.jsonl | jq '.' | head -5
```

### Verify Parsed Data

```bash
# Count extracted stations
cat tarsheed-stations-extracted.json | jq '. | length'

# Sample extracted data
cat tarsheed-stations-extracted.json | jq '.[] | {name, latitude, longitude}' | head -10
```

### Verify Database Data

```sql
-- Run in Supabase SQL Editor

-- 1. Total station count
SELECT COUNT(*) as total_stations FROM charging_stations;

-- 2. Check for null coordinates
SELECT COUNT(*) as bad_coordinates 
FROM charging_stations 
WHERE latitude = 0 OR longitude = 0;

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

-- 5. Check stations with restrooms
SELECT COUNT(*) as with_restrooms
FROM charging_stations
WHERE 'Restroom' = ANY(amenities);

-- 6. Geographic coverage (check spread)
SELECT 
  MIN(latitude) as min_lat,
  MAX(latitude) as max_lat,
  MIN(longitude) as min_lng,
  MAX(longitude) as max_lng
FROM charging_stations;
```

---

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

---

## Completion Checklist

### Pre-Capture
- [ ] Android device connected to same WiFi network as machine (192.168.10.234)
- [ ] mitmproxy CA certificate downloaded on Android device
- [ ] Certificate installed on Android device
- [ ] WiFi proxy configured on Android device (192.168.10.234:8080)
- [ ] mitmproxy running on machine

### During Capture
- [ ] Tarsheed app opened and logged in
- [ ] Charging stations section navigated
- [ ] Map explored (zoomed out, panned around Qatar)
- [ ] List view scrolled through
- [ ] 10-15 station details viewed
- [ ] Filters tested (if available)
- [ ] Pull-to-refresh used
- [ ] mitmproxy showing capture messages
- [ ] Capture duration: 20-30 minutes

### Post-Capture
- [ ] mitmproxy stopped (Ctrl+C)
- [ ] Capture summary showing 40+ charging requests captured
- [ ] tarsheed-captured.jsonl created
- [ ] Capture backed up to archived-captures/
- [ ] Parser script run successfully
- [ ] 40+ unique stations extracted
- [ ] Backup table created in Supabase
- [ ] Existing seed data deleted from database
- [ ] 50+ Tarsheed stations imported
- [ ] Data validated (no nulls, all coordinates valid)
- [ ] Charging page verified to display stations
- [ ] Station details verified accurate
- [ ] WiFi proxy removed from Android device
- [ ] mitmproxy CA certificate removed from Android device
- [ ] Capture files archived
- [ ] Raw capture files deleted

---

## Expected Timeline

| Phase | Time | Notes |
|--------|------|-------|
| 1. Configure Android Device | 15-20 min | Certificate + proxy setup |
| 2. Start mitmproxy | 2 min | Already running in background |
| 3. Navigate Tarsheed App | 20-30 min | Capture all station data |
| 4. Stop & Parse | 5-10 min | Parse JSON, extract stations |
| 5. Import to Supabase | 5-10 min | Backup + delete + import |
| 6. Verify Application | 5 min | Test in browser |
| 7. Cleanup | 5 min | Remove proxy, archive data |
| **TOTAL** | **~60-90 min** | **1-1.5 hours** |

---

## Summary

### What We're Doing
- Capturing official charging station data from Tarsheed (KAHRAMAA)
- Using network interception via mitmproxy on real Android device
- Extracting 50+ unique charging stations
- Replacing existing seed data in QEV Hub database

### Why This Method
- **Simpler**: No Android SDK/emulator needed
- **Faster**: Save 30-60 minutes of setup time
- **More Reliable**: Real device, no emulator issues
- **One-Time**: Capture once, import, done

### What Happens Next
- QEV Hub will have accurate, official charging station data
- Users can see real Qatar charging locations
- All connector types, amenities, availability included
- Better user experience for EV owners in Qatar

---

## Files Reference

### Created Scripts
- `scripts/tarsheed-capture.py` - mitmproxy capture script
- `scripts/parse-tarsheed-capture.js` - JSON parser
- `scripts/clear-and-import-tarsheed.js` - Database import

### Generated Files (During Process)
- `tarsheed-captured.jsonl` - Raw API responses (Phase 4)
- `tarsheed-stations-extracted.json` - Parsed stations (Phase 4)
- `archived-captures/tarsheed-complete-YYYYMMDD-HHMMSS.tar.gz` - Archive (Phase 7)

---

**Document Version:** 1.0
**Created:** January 11, 2026
**For:** QEV Hub - Tarsheed Charging Stations Data Capture (Real Android Device)
**Machine IP:** 192.168.10.234
**mitmproxy Port:** 8080
