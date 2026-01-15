# QEV Hub - Comprehensive Project Summary

## 📱 Project Overview

**QEV Hub** is a comprehensive Electric Vehicle (EV) platform for Qatar consisting of:
- **Mobile App**: Flutter-based mobile application (qev-hub-mobile)
- **Web App**: Next.js 14 web application (qev-hub-web)
- **Database**: Supabase (PostgreSQL) backend

---

## 🎯 Core Features

### 1. EV Marketplace
- Direct vehicle purchasing from manufacturers
- Vehicle browsing with detailed specs and images
- Shopping cart and checkout flow
- Order tracking and management
- Stock management system

### 2. Charging Station Network
- Real-time charging station finder with Google Maps
- Station details with connector types, power ratings, amenities
- Charging session booking system
- Availability tracking (real-time)
- 26+ Qatar charging stations with 118+ chargers

### 3. Order Management
- 11-stage order lifecycle tracking
- Order history and search
- Order cancellation with stock restoration
- Spending analytics and statistics
- GCC export handling with customs/insurance

---

## 🏗️ Architecture

### Technology Stack

**Mobile App (Flutter):**
- Flutter 3.x
- Dart 3.x
- Riverpod (State Management)
- Supabase (Backend)
- GoRouter (Navigation)
- Freezed (Immutable models)

**Web App (Next.js):**
- Next.js 14 (App Router)
- TypeScript
- Supabase Client
- Google Maps JavaScript API
- Tailwind CSS

**Database:**
- PostgreSQL via Supabase
- Row Level Security (RLS)
- Real-time subscriptions
- Geospatial queries

---

## 📊 Database Schema

### Key Tables

#### `vehicles` - EV Inventory
```sql
- id: UUID
- manufacturer, model, year
- range_km, battery_kwh
- price_qar, grey_market_price
- images (JSON array)
- specs (JSON)
- stock_count, status
```

#### `charging_stations` - Charging Locations
```sql
- id: UUID
- name, address, area
- latitude, longitude
- operator (QEV, WOQOD)
- charger_types (TEXT[]): Type 2, CCS, CHAdeMO
- power_output_kw
- total_chargers, available_chargers
- amenities (TEXT[]): Parking, WiFi, Restroom, etc.
- operating_hours, pricing_info
- phone_number, website_url
```

#### `chargers` - Individual Charging Units
```sql
- id: UUID
- station_id: UUID
- name: Charger 1, Charger 2, etc.
- charger_type: AC Level 2, Fast DC, Ultra Fast DC
- power_kw: 22, 50, 150
- connector_types (TEXT[]): Type 2, CCS, CHAdeMO
- status: available, occupied, maintenance
- is_enabled: boolean
```

#### `bookings` - Charging Reservations
```sql
- id: UUID
- user_id, charger_id, station_id
- start_time, end_time
- status: pending, confirmed, in_progress, completed, cancelled
- estimated_cost, actual_cost
- energy_delivered (kWh)
- EXCLUDE constraint prevents double-booking
```

#### `orders` - Vehicle Orders
```sql
- id: UUID
- user_id, vehicle_id
- order_number
- status: pending → confirmed → processing → shipped → in_transit
         → in_customs → fahes_inspection → insurance_pending
         → delivery → delivered → completed
- total_price_qar
- shipping_address, city, country
- payment_status, payment_method
- tracking_number
- estimated/actual delivery dates
```

#### `order_status_history` - Order Tracking
```sql
- id: UUID
- order_id: UUID
- status, location, notes
- document_url
- created_at, updated_at
```

---

## 🔄 Key Workflows

### Vehicle Purchase Flow
1. User browses marketplace
2. Selects vehicle → views details
3. Clicks "Buy Now" or "Add to Cart"
4. Fills shipping information
5. Confirms order
6. Order created with status "pending"
7. Stock automatically decremented
8. Order progress tracked through 11 stages
9. Final delivery and completion

### Charging Station Booking Flow
1. User navigates to Charging screen
2. Views map with station markers
3. Taps station → views details
4. Sees available chargers with status
5. Taps "Book" on charger
6. Selects time slot
7. Confirms booking
8. Real-time availability updates
9. Arrives at station → scans QR
10. Charging session starts
11. Session completes → booking marked complete

### Order Tracking Flow
1. Order created
2. Each status update creates history record
3. User can view timeline
4. Real-time status updates via subscription
5. Document uploads at each stage
6. Final delivery confirmation

---

## 🎨 Design System

### Colors
- **Primary**: #8A1538 (Deep Red)
- **Secondary**: #00FFFF (Cyan)
- **Background**: Dark theme (#121212)
- **Surface**: #1E1E1E
- **Success**: #00D084 (Green)
- **Warning**: #FFA500 (Orange)
- **Error**: #FF4444 (Red)

### Typography
- **Headings**: Bold, 18-24px
- **Body**: Regular, 14-16px
- **Captions**: Light, 12px

### Components
- Material Design 3
- Custom cards with elevation
- Rounded corners (12-16px)
- Gradient backgrounds
- Status indicators with color coding

---

## 📁 Project Structure

### Mobile App
```
qev-hub-mobile/
├── lib/
│   ├── core/
│   │   ├── theme/        # App colors, themes
│   │   └── router/       # Navigation
│   ├── features/
│   │   ├── auth/         # Login, signup
│   │   ├── dashboard/    # Home screen
│   │   ├── marketplace/  # Vehicle shopping
│   │   ├── booking/      # Charging reservations
│   │   ├── orders/       # Order management
│   │   └── charging/     # Station finder
│   ├── data/
│   │   ├── models/       # Data models
│   │   └── repositories/ # Data access
│   └── shared/
│       └── widgets/      # Reusable components
```

### Web App
```
qev-hub-web/
├── src/
│   ├── app/
│   │   ├── (main)/
│   │   │   ├── charging/
│   │   │   ├── marketplace/
│   │   │   └── orders/
│   │   └── api/
│   ├── lib/
│   │   ├── supabase.ts
│   │   └── tarsheed-scraper.ts
│   └── services/
│       └── charging-sync.ts
```

---

## 🔐 Security Features

### Row Level Security (RLS)
- Users can only see their own orders/bookings
- Service role for admin operations
- Authentication required for all mutations

### Validation
- Form validation for all inputs
- Stock checking before purchase
- Double-booking prevention via database constraints
- Phone number format validation

### Data Protection
- SQL injection prevention (parameterized queries)
- XSS protection (Sanitized HTML)
- Secure API key handling
- CSRF protection

---

## 🚀 Deployment

### Environment Variables Required

**Mobile (.env):**
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```

**Web (.env.local):**
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_maps_key
```

### Build Commands

**Mobile:**
```bash
flutter pub get
flutter run --release
flutter build apk --release
flutter build ios --release
```

**Web:**
```bash
npm install
npm run build
npm start
```

---

## 📝 Recent Updates (January 2026)

### Latest Commits
1. **Qatar Charging Stations Implementation**
   - Added 26 mock charging stations across Qatar
   - Locations: Doha, Lusail, Al Wakrah, Al Khor, etc.
   - 118 individual chargers with full specs
   - Enhanced station detail page with improved UI
   - Multi-connector type badges
   - Soft slate blue header for better readability

2. **Enhanced Data Models**
   - Added `connectorTypes` array to Charger model
   - Updated repository to fetch all connector types
   - Improved charger unit cards with proper display

3. **UI/UX Improvements**
   - Fixed header overlapping glitch
   - Improved station detail page layout
   - Better color scheme for readability
   - Enhanced connector type visibility

---

## 🎯 Current Status

### Completed Features
✅ User Authentication
✅ Vehicle Marketplace
✅ Shopping Cart & Checkout
✅ Order Management & Tracking
✅ Charging Station Finder
✅ Station Detail Pages
✅ Charger Booking System
✅ Real-time Availability
✅ Order History & Search
✅ GCC Export Integration

### In Progress
🔄 Enhanced Analytics
🔄 Push Notifications
🔄 Payment Gateway Integration

### Planned Features
📋 Route Planning for EV Trips
📋 Charging Reservations
📋 Payment Processing
📋 Reviews & Ratings
📋 Favorites & Saved Locations
📋 Advanced Analytics Dashboard

---

## 📞 Support & Maintenance

### Database Queries

**Find nearby stations:**
```sql
SELECT *, earth_distance(
  ll_to_earth(latitude, longitude),
  ll_to_earth(25.3548, 51.1839)
) / 1000 as distance_km
FROM charging_stations
WHERE status = 'active'
ORDER BY distance_km
LIMIT 10;
```

**Get user's active bookings:**
```sql
SELECT b.*, c.name as charger_name, s.name as station_name
FROM bookings b
JOIN chargers c ON b.charger_id = c.id
JOIN charging_stations s ON b.station_id = s.id
WHERE b.user_id = $1
  AND b.status IN ('pending', 'confirmed', 'in_progress')
ORDER BY b.start_time;
```

**Check charger availability:**
```sql
SELECT COUNT(*) as conflicting_bookings
FROM bookings
WHERE charger_id = $1
  AND status IN ('confirmed', 'in_progress')
  AND tsrange(start_time, end_time) && tsrange($2, $3);
```

---

## 📄 License

ISC License - See LICENSE file for details

---

## 👥 Team

QEV Development Team
- Project: Qatar Electric Vehicle Hub
- Location: Doha, Qatar
- Year: 2025-2026

---

*Last Updated: January 16, 2026*
