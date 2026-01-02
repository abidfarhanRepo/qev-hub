# Quick Start Guide - QEV Dashboard

## Prerequisites

✅ All components are built and ready
✅ Theme compliance verified
✅ No external API dependencies
✅ Full light/dark mode support

---

## Step 1: Start Development Server

```bash
cd /home/pi/Desktop/QEV/qev-hub-web
npm run dev
```

Wait for: `Ready in 2.1s` message

---

## Step 2: Access Application

1. Open browser to: http://localhost:3000
2. Click "Sign Up" in top-right
3. Create an account (email: test@example.com, password: 123456)
4. **You'll be automatically redirected to Dashboard**

**Important:** Dashboard is now the main hub after login. From Dashboard, you can navigate to:
- Marketplace (browse vehicles)
- Charging Stations (find chargers)
- Orders (track shipments)
- Settings (manage account)

---

## Step 3: Test Dashboard Features

### Test Smart Search Bar (Marketplace Tab)

1. Click "Marketplace" in sidebar
2. In the search bar, type "Tesla"
3. Click "Advanced Filters" button
4. Adjust these sliders:
   - Range: Move to 500 km
   - Charging Time: Move to 45 min
   - Price: Move to 200k
   - Arrival Time: Move to 8 weeks
5. Click "Search"
6. Click on "Tesla Model 3" from results

**Expected:** Comparison card appears with price savings

### Test Vehicle Comparison Card

1. After selecting a vehicle, review the comparison:
   - QEV-Hub Price (green)
   - Market Price (strikethrough gray)
   - Instant Savings badge
   - 5-Year TCO breakdown
2. Click "View Detailed Calculator"

**Expected:** Savings calculator modal opens

### Test Savings Calculator Modal

1. In the modal, adjust sliders:
   - Annual KM: Move to 20,000
   - Years: Click "3"
   - Electricity Price: Move to 0.07
2. Watch the real-time calculations update
3. Review the Environmental Impact section
4. Click "Proceed with Purchase" or "X" to close

**Expected:** All calculations update instantly, modal closes cleanly

### Test Logistics Timeline (Orders Tab)

1. Click "Orders" in sidebar
2. Click on "FAHES Inspection" checkpoint (animated)
3. In the modal, review:
   - Status: In Progress
   - Requirements list (5 items)
   - Document Vault with 2 documents
4. Click "Download" on "FAHES Inspection Report"
5. Close modal

**Expected:** Details modal opens, download simulated, modal closes

### Test Sustainability Dashboard

1. Click "Sustainability" in sidebar
2. Watch the live CO2 counter (updates every 5s)
3. Review Qatar Vision 2030 goals:
   - Carbon Neutrality: 68%
   - Renewable Energy: 72%
   - Electric Vehicles: 55%
4. Click "Calculate Detailed Savings"

**Expected:** Calculator modal opens with sustainability data

---

## Step 4: Test Theme Toggle

1. Click the moon/sun icon in sidebar
2. Verify all components switch properly:
   - Backgrounds change (white → dark)
   - Text adapts (dark → light)
   - Glass effects work in both modes
   - All colors remain readable

---

## Step 5: Test Mobile Responsiveness

1. Resize browser to mobile width (375px)
2. Test all features:
   - Sidebar collapses (or adapts)
   - Search bar is accessible
   - Sliders are touch-friendly
   - Modals fit screen
   - All text is readable

---

## Troubleshooting

### Issue: Dashboard doesn't load
**Fix:** Check browser console for errors, ensure Supabase env variables are set

### Issue: Icons not displaying
**Fix:** Clear browser cache, hard refresh (Ctrl+Shift+R)

### Issue: Build errors
**Fix:** Run `npm install` to ensure dependencies are installed

### Issue: Theme not switching
**Fix:** Ensure ThemeProvider is wrapping the app (check layout.tsx)

---

## File Locations

All new files are in:
```
qev-hub-web/src/
├── app/dashboard/page.tsx          # Main dashboard
├── components/dashboard/
│   ├── SmartSearchBar.tsx         # Search component
│   ├── VehicleComparisonCard.tsx   # Comparison card
│   ├── LogisticsTimeline.tsx       # Timeline
│   ├── SustainabilityDashboard.tsx # Sustainability
│   └── SavingsCalculator.tsx      # Calculator modal
├── components/icons.tsx            # Updated icons
└── components/Navbar.tsx           # Updated nav
```

---

## Next Steps

After testing is complete:

1. **Connect to Real Data:**
   - Replace mock vehicle data with Supabase queries
   - Connect to actual orders table
   - Fetch real charging session data

2. **Implement Real Documents:**
   - Use PDF generation library (jsPDF, react-pdf)
   - Store files in Supabase Storage
   - Serve actual downloads

3. **Deploy to Production:**
   - Run `npm run build`
   - Deploy to Vercel/Netlify
   - Set environment variables

---

## Support Documentation

- **Full Implementation:** `DASHBOARD_IMPLEMENTATION_SUMMARY.md`
- **Theme Compliance:** `THEME_COMPLIANCE_TESTING.md`
- **Development Guide:** `AGENTS.md` (project-specific rules)
- **Architecture:** `ARCHITECTURE.md`

---

**Questions?** Check the documentation files or review the code comments in each component.

**Ready to test!** 🚀
