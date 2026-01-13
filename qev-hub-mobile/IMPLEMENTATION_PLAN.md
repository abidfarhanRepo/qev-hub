# QEV-HUB-MOBILE Implementation Plan
## Flutter App Replicating QEV-HUB-WEB Features

---

## Overview
This plan breaks down the QEV-HUB-WEB application into sequential phases for Flutter implementation. Each phase builds upon the previous one and will be deployed to ADB device for testing before proceeding.

**Current State**: Blank Flutter template with counter app
**Target State**: Full-featured EV marketplace mobile app matching web functionality

---

## Phase 1: Foundation & Infrastructure Setup
**Agent Assignment**: Architecture & Setup Agent
**Dependencies**: None
**Estimated Scope**: Core infrastructure only

### Objectives
- Set up project architecture and folder structure
- Configure dependencies for networking, state management, and navigation
- Set up Supabase integration
- Create base theme and design system
- Implement base screen wrapper components

### Tasks
1. **Project Structure Setup**
   - Create organized folder structure:
     ```
     lib/
     ├── core/
     │   ├── constants/
     │   ├── theme/
     │   ├── router/
     │   └── utils/
     ├── data/
     │   ├── models/
     │   ├── repositories/
     │   └── services/
     ├── features/
     │   └── [feature_name]/
     │       ├── data/
     │       ├── domain/
     │       ├── presentation/
     │       └── bindings/
     └── main.dart
     ```

2. **Dependencies Configuration**
   - Add to `pubspec.yaml`:
     - `flutter_riverpod: ^2.4.9` - State management
     - `go_router: ^13.0.0` - Declarative routing
     - `supabase_flutter: ^2.3.4` - Supabase integration
     - `dio: ^5.4.0` - HTTP client
     - `freezed: ^2.4.6` + `freezed_annotation` - Code generation
     - `json_serializable: ^6.7.1` + `json_annotation` - JSON serialization
     - `flutter_secure_storage: ^9.0.0` - Secure storage
     - `cached_network_image: ^3.3.1` - Image caching
     - `flutter_svg: ^2.0.9` - SVG support
     - `intl: ^0.19.0` - Internationalization
     - `connectivity_plus: ^5.0.2` - Network connectivity

3. **Supabase Configuration**
   - Create `.env` management
   - Set up Supabase client initialization
   - Configure auth state listener

4. **Design System**
   - Create color palette matching web app:
     ```dart
     // Primary: Electric Green (#00D084)
     // Secondary: Deep Blue (#0F172A)
     // Accent: Electric Purple (#7C3AED)
     // Background: Dark (#0A0A0A)
     // Surface: Card Dark (#121212)
     ```
   - Define typography scale
   - Create border radius constants
   - Define spacing system

5. **Base Components**
   - `AppButton` - Primary, secondary, outline variants
   - `AppTextField` - Text input with validation
   - `AppCard` - Reusable card component
   - `AppLoader` - Loading indicator
   - `AppError` - Error display widget
   - `ScaffoldWrapper` - Base scaffold with consistent app bar

6. **Router Setup**
   - Configure GoRouter with initial routes:
     - `/` - Splash/Landing
     - `/auth` - Authentication wrapper
     - `/home` - Main app wrapper

### Verification Steps (ADB Device)
1. Run `flutter run` on connected device
2. Verify app opens without errors
3. Navigate to `/` route
4. Verify theme colors are applied
5. Test base button and card components
6. Check console for Supabase initialization

### Deliverables
- Properly structured project
- Working theme system
- Configured router with navigation
- Base UI components library
- Supabase client ready for use
- Green check: App runs on device with splash screen

---

## Phase 2: Authentication System
**Agent Assignment**: Auth Implementation Agent
**Dependencies**: Phase 1 complete
**Estimated Scope**: Complete auth flow

### Objectives
- Implement full authentication system
- Create signup, login, and forgot password screens
- Set up auth state management with Riverpod
- Implement role-based route protection

### Tasks
1. **Data Models**
   - `User` model (freezed)
   - `UserProfile` model with roles
   - `AuthState` enum

2. **Repository Layer**
   - `AuthRepository` interface
   - `SupabaseAuthRepository` implementation
   - Methods:
     - `signUp(email, password, metadata)`
     - `signIn(email, password)`
     - `signOut()`
     - `sendPasswordResetEmail(email)`
     - `getCurrentUser()`
     - `updateProfile()`

3. **State Management**
   - `AuthNotifier` with Riverpod
   - `AuthProvider` for global auth state
   - `isLoggedIn`, `isAuthenticated`, `currentUser` providers

4. **Screens**
   - `SplashScreen` - Initial loading with auth check
   - `LoginScreen` - Email/password login form
     - Email input with validation
     - Password input with visibility toggle
     - "Forgot Password?" link
     - Login button
     - Sign up link
   - `SignUpScreen` - Registration form
     - Full name input
     - Email input with validation
     - Password input with strength indicator
     - Confirm password input
     - Role selection (Consumer/Manufacturer - default Consumer)
     - Sign up button
     - Login link
   - `ForgotPasswordScreen` - Password reset request
     - Email input
     - Send reset link button
     - Back to login link

5. **Route Guards**
   - Implement redirect logic in GoRouter:
     - Unauthenticated users → `/auth/login`
     - Authenticated users → `/home`
   - Protected route wrapper for authenticated screens

6. **Form Validation**
   - Email validation regex
   - Password strength requirements (min 8 chars, 1 uppercase, 1 number)
   - Matching password confirmation

7. **Error Handling**
   - Display auth-specific error messages
   - Toast notifications for success/error
   - Loading states during auth operations

### Verification Steps (ADB Device)
1. Launch app, verify splash screen redirects appropriately
2. Test sign up with new account:
   - Fill form, submit
   - Verify account creation
   - Verify redirect to home/dashboard
3. Test logout and login with same credentials
4. Test password reset flow
5. Test form validation (invalid email, weak password, mismatched passwords)
6. Verify auth persists across app restart
7. Test unauthenticated redirect (logout, try to access protected route)

### Deliverables
- Complete authentication flow
- Persistent auth sessions
- Form validation working
- Route protection active
- Green check: User can sign up, log in, and access protected screens

---

## Phase 3: Dashboard & Navigation
**Agent Assignment**: Navigation & Dashboard Agent
**Dependencies**: Phase 2 complete
**Estimated Scope**: Main app shell and dashboard

### Objectives
- Create main navigation structure
- Build user dashboard
- Implement bottom navigation
- Create reusable app shell

### Tasks
1. **Main Navigation Shell**
   - `MainScreen` with bottom navigation
   - Bottom nav items:
     - Home
     - Marketplace
     - Charging
     - Orders
     - Profile/Settings

2. **Dashboard Screen**
   - User greeting with name
   - Quick stats cards:
     - Active Orders
     - Saved Vehicles
     - Total Savings (QAR)
   - Quick actions grid:
     - Browse Marketplace
     - Find Charging
     - Track Order
     - Settings
   - Recent activity section (placeholder)

3. **App Bar Components**
   - Dynamic app bar titles
   - Notification bell icon (placeholder)
   - User avatar display

4. **Dashboard Data Providers**
   - `DashboardController` for data fetching
   - `orderCountProvider` - Number of active orders
   - `savedVehiclesProvider` - Number of saved vehicles
   - `savingsProvider` - Total savings from purchases

5. **Navigation Logic**
   - Tab switching with state preservation
   - Active tab highlighting
   - Proper back stack management

6. **Placeholder Screens**
   - Create empty states for:
     - Marketplace (coming soon)
     - Charging (coming soon)
     - Orders (coming soon)
     - Settings (coming soon)

### Verification Steps (ADB Device)
1. After login, verify dashboard loads
2. Test all bottom nav items
3. Verify active tab highlighting
4. Check back button behavior
5. Verify user stats display (even if zero)
6. Test quick action buttons navigate correctly
7. Rotate device, verify layout adapts

### Deliverables
- Working bottom navigation
- Dashboard with user stats
- Placeholder screens for all tabs
- Green check: User can navigate between all main sections

---

## Phase 4: Vehicle Marketplace - Browse & Discovery
**Agent Assignment**: Marketplace Agent
**Dependencies**: Phase 3 complete
**Estimated Scope**: Vehicle browsing and filtering

### Objectives
- Implement vehicle marketplace browsing
- Create filtering and search
- Display vehicle cards and lists
- Build vehicle detail screen

### Tasks
1. **Data Models**
   - `Vehicle` model (freezed) matching web schema:
     ```dart
     - id, manufacturer, model, year
     - range_km, battery_kwh, power_kw
     - price_qar, manufacturer_direct_price, broker_market_price
     - price_transparency_enabled
     - vehicle_type (EV/PHEV/FCEV)
     - stock_count, status
     - image_url, specs
     ```

2. **Repository Layer**
   - `VehicleRepository` interface
   - `SupabaseVehicleRepository` implementation
   - Methods:
     - `getVehicles(filters)` - Fetch with filters
     - `getVehicleById(id)` - Single vehicle
     - `searchVehicles(query)` - Search functionality
     - `getManufacturers()` - List of manufacturers
     - `getVehicleTypes()` - List of vehicle types

3. **State Management**
   - `VehicleListNotifier` - Paginated vehicle list
   - `vehicleListProvider` - Exposes vehicles
   - `vehicleFilterProvider` - Current filter state
   - `selectedVehicleProvider` - Selected vehicle details

4. **Marketplace Screen**
   - Search bar at top
   - Filter button opening filter modal
   - Vehicle grid/list toggle
   - Vehicle cards showing:
     - Vehicle image
     - Manufacturer & model name
     - Year
     - Price in QAR
     - Savings badge (if applicable)
     - Range indicator
   - Infinite scroll pagination
   - Empty state when no vehicles
   - Loading skeleton

5. **Vehicle Filter Modal**
   - Filter by:
     - Manufacturer (multi-select)
     - Vehicle type (EV/PHEV/FCEV)
     - Price range (slider)
     - Minimum range (slider)
     - Year range
     - In stock only (toggle)
   - Clear filters button
   - Apply filters button
   - Active filter chips display

6. **Vehicle Detail Screen**
   - Large vehicle image gallery
   - Price display:
     - Manufacturer direct price
     - Grey market price
     - Savings amount and percentage
   - Vehicle specifications:
     - Range (km)
     - Battery (kWh)
     - Power (kW)
     - Acceleration (0-100)
     - Charging time
   - Description
   - "Purchase from Manufacturer" button
   - "Save for Later" button
   - Manufacturer info card
   - Stock availability indicator

7. **Components**
   - `VehicleCard` - Reusable vehicle card
   - `SavingsBadge` - Price savings display
   - `SpecItem` - Specification display item
   - `PriceDisplay` - Formatted price with QAR
   - `FilterChip` - Active filter display
   - `ImageGallery` - Swipeable image viewer

### Verification Steps (ADB Device)
1. Navigate to Marketplace tab
2. Verify vehicles load in grid
3. Test search functionality
4. Open filter modal, apply filters, verify results update
5. Tap a vehicle card, verify detail screen opens
6. Verify all vehicle specs display correctly
7. Test savings badge calculation
8. Test gallery swipe on detail screen
9. Verify empty state when filtering yields no results
10. Test pull-to-refresh on marketplace

### Deliverables
- Browseable vehicle marketplace
- Working filters and search
- Detailed vehicle information
- Green check: User can browse, filter, and view vehicle details

---

## Phase 5: Charging Station Locator
**Agent Assignment**: Maps & Charging Agent
**Dependencies**: Phase 3 complete
**Estimated Scope**: Charging station map and listing

### Objectives
- Implement charging station map
- Create station list view
- Show station details and availability

### Tasks
1. **Data Models**
   - `ChargingStation` model:
     ```dart
     - id, name, address
     - latitude, longitude
     - provider, charger_type
     - power_output_kw
     - total_chargers, available_chargers
     - pricing_info
     - amenities
     ```

2. **Repository Layer**
   - `ChargingRepository` interface
   - `SupabaseChargingRepository` implementation
   - Methods:
     - `getAllStations()` - Fetch all stations
     - `getNearbyStations(lat, lng, radius)` - Location-based
     - `getStationById(id)` - Single station details

3. **State Management**
   - `ChargingStationNotifier` - Station list state
   - `chargingStationProvider` - Exposes stations
   - `selectedStationProvider` - Selected station
   - `userLocationProvider` - User's current location

4. **Charging Screen**
   - Two tabs: Map and List
   - Map view:
     - Interactive map with station markers
     - Current location indicator
     - Marker color by availability (green/red)
     - Tap marker to show preview
     - Cluster markers for zoomed out view
   - List view:
     - Station cards with:
       - Station name
       - Distance from user
       - Available/total chargers
       - Power output
       - Provider badge
     - Sort by distance or availability
   - Filter by charger type
   - Refresh button

5. **Station Detail Screen**
   - Station name and provider
   - Address with "Get Directions" button
   - Availability indicator
     - X of Y chargers available
     - Visual availability bar
   - Charger details:
     - Type (CCS2, CHAdeMO, etc.)
     - Power output
     - Pricing info
   - Amenities list (WiFi, coffee, restrooms, etc.)
   - Operating hours
   - Photos (if available)

6. **Map Integration**
   - Add `flutter_map` package
   - Configure OpenStreetMap tiles
   - Custom markers for stations
   - Location permission handling
   - Current location tracking

7. **Location Services**
   - `LocationService` for GPS
   - Permission request handling
   - Distance calculations
   - "Get Directions" opens external maps app

8. **Components**
   - `StationCard` - Station list item
   - `AvailabilityIndicator` - Visual availability
   - `ChargerTypeBadge` - Charger type indicator
   - `AmenityChip` - Amenity display

### Verification Steps (ADB Device)
1. Navigate to Charging tab
2. Grant location permission when prompted
3. Verify map loads with station markers
4. Verify current location appears on map
5. Tap a marker, verify preview shows
6. Switch to list view, verify stations display
7. Tap a station, verify detail screen opens
8. Test "Get Directions" button
9. Test filter by charger type
10. Verify availability indicators update
11. Test without location permission (should show all stations)

### Deliverables
- Interactive charging station map
- Station list with details
- Location-based features
- Green check: User can find and navigate to charging stations

---

## Phase 6: Order Placement & Flow
**Agent Assignment**: Checkout & Orders Agent
**Dependencies**: Phase 4 complete
**Estimated Scope**: Purchase flow

### Objectives
- Implement order placement flow
- Create multi-step checkout process
- Handle order confirmation

### Tasks
1. **Data Models**
   - `Order` model:
     ```dart
     - id, user_id, vehicle_id
     - tracking_id, status
     - total_price, deposit_amount
     - payment_status
     - created_at, updated_at
     ```
   - `OrderItem` for line items
   - `OrderStatus` enum (pending, confirmed, processing, shipped, delivered)
   - `PaymentStatus` enum (pending, paid, failed, refunded)

2. **Repository Layer**
   - `OrderRepository` interface
   - `SupabaseOrderRepository` implementation
   - Methods:
     - `createOrder(orderData)` - Create new order
     - `getOrders(userId)` - User's orders
     - `getOrderById(id)` - Single order
     - `updateOrderStatus(id, status)` - Status update

3. **State Management**
   - `OrderNotifier` - Order operations
   - `orderListProvider` - User's orders
   - `activeOrderProvider` - Current order in progress
   - `orderProvider(id)` - Specific order

4. **Order Flow Screens**
   - **Order Details Screen** (Step 1):
     - Vehicle summary (image, name, specs)
     - Price breakdown:
       - Vehicle price
       - Deposit amount
       - Total due
     - "Proceed to Payment" button
     - Back to vehicle detail

   - **Payment Screen** (Step 2):
     - Order summary
     - Payment method selection (placeholder for integration)
     - Deposit amount display
     - Terms and conditions checkbox
     - Card details form (placeholder UI)
     - "Pay Deposit" button
     - Loading state during payment

   - **Order Confirmation Screen** (Step 3):
     - Success animation
     - Order tracking ID (prominent display)
     - Order summary
     - "View Order Status" button
     - "Continue Shopping" button
     - Share tracking ID option

5. **Order Services**
   - `OrderService` for business logic
   - Generate tracking ID
   - Calculate totals
   - Validate order before submission

6. **Components**
   - `OrderSummaryCard` - Summary display
   - `PriceBreakdown` - Itemized pricing
   - `PaymentMethodSelector` - Payment options
   - `StepIndicator` - Progress through flow
   - `SuccessAnimation` - Confirmation celebration

7. **Form Validation**
   - Required fields check
   - Terms acceptance
   - Payment method selection

8. **Error Handling**
   - Payment failure handling
   - Order creation errors
   - Retry mechanism

### Verification Steps (ADB Device)
1. From vehicle detail, tap "Purchase from Manufacturer"
2. Verify order details screen shows correct vehicle and pricing
3. Proceed to payment screen
4. Verify payment form displays
5. Fill payment form (can be placeholder)
6. Accept terms, submit payment
7. Verify confirmation screen appears with tracking ID
8. Note the tracking ID for later testing
9. Verify order appears in orders list (will implement in Phase 7)
10. Test going back through the flow
11. Test validation (try to submit without accepting terms)

### Deliverables
- Complete order placement flow
- Multi-step checkout process
- Order confirmation with tracking
- Green check: User can complete a purchase flow

---

## Phase 7: Order Management & Tracking
**Agent Assignment**: Order Tracking Agent
**Dependencies**: Phase 6 complete
**Estimated Scope**: Order list and tracking

### Objectives
- Implement order listing
- Create detailed order tracking
- Show logistics stages

### Tasks
1. **Additional Models**
   - `OrderLogistics` model:
     ```dart
     - id, order_id
     - current_stage
     - stages: [
         - factory (completed, date, notes)
         - ocean_freight (completed, date, notes)
         - hamad_port (completed, date, notes)
         - qatar_customs (completed, date, notes)
         - fahes_inspection (completed, date, notes)
         - insurance (completed, date, notes)
         - delivery (completed, date, notes)
       ]
     - estimated_delivery
     - actual_delivery
     ```

2. **Repository Extensions**
   - `getOrderLogistics(orderId)` - Fetch tracking info
   - `updateLogisticsStage(orderId, stage, data)` - Update stage

3. **State Management**
   - `orderLogisticsProvider(orderId)` - Logistics for order

4. **Orders List Screen**
   - Tabbed view: Active / Completed
   - Order cards showing:
     - Tracking ID (prominent)
     - Vehicle image and name
     - Order date
     - Current status badge
     - Progress bar (logistics stages)
     - "Track Order" button
   - Pull to refresh
   - Empty states for each tab
   - Filtering by status

5. **Order Tracking Screen**
   - Order header with tracking ID
   - Vehicle summary
   - Timeline view of logistics stages:
     - Vertical timeline with connected nodes
     - Completed stages: Green with checkmark
     - Current stage: Highlighted with animation
     - Upcoming stages: Grayed out
     - Date and notes for each stage
   - Progress percentage
   - Estimated delivery date (if available)
   - Share tracking button
   - Contact support button

6. **Order Detail Screen**
   - Full order information
   - Tabs: Overview / Timeline / Documents
   - Overview:
     - Order details
     - Vehicle details
     - Payment summary
   - Timeline:
     - Full logistics timeline
   - Documents:
     - Compliance documents (Phase 8)
     - Invoices
     - Certificates

7. **Components**
   - `OrderCard` - Order list item
   - `LogisticsTimeline` - Timeline visualization
   - `TimelineNode` - Individual stage node
   - `StatusBadge` - Order status indicator
   - `ProgressBar` - Visual progress

8. **Pull to Refresh**
   - Refresh order data
   - Refresh logistics data

### Verification Steps (ADB Device)
1. Navigate to Orders tab
2. Verify order from Phase 6 appears in Active tab
3. Tap order card, verify tracking screen opens
4. Verify timeline shows current stage
5. Check that completed stages are marked
6. Verify progress percentage displays
7. Test share tracking functionality
8. Pull to refresh, verify data updates
9. Navigate to detail screen, verify all tabs work
10. Test moving between active and completed tabs

### Deliverables
- Order list with filtering
- Detailed order tracking
- Visual logistics timeline
- Green check: User can track their orders through all stages

---

## Phase 8: Manufacturer Portal
**Agent Assignment**: Manufacturer Features Agent
**Dependencies**: Phase 7 complete, User role = Manufacturer
**Estimated Scope**: Manufacturer-specific features

### Objectives
- Implement manufacturer dashboard
- Vehicle inventory management
- Order management for manufacturers

### Tasks
1. **Data Models**
   - `Manufacturer` model:
     ```dart
     - id, user_id, company_name
     - verification_status (pending, verified, rejected)
     - business_license, contact_info
     - verified_at, rejection_reason
     ```

2. **Repository Extensions**
   - `ManufacturerRepository` interface
   - Methods:
     - `getManufacturerProfile(userId)` - Get profile
     - `getManufacturerVehicles(manufacturerId)` - Their vehicles
     - `getManufacturerOrders(manufacturerId)` - Orders for their vehicles
     - `addVehicle(vehicleData)` - Add listing
     - `updateVehicle(id, data)` - Update listing
     - `deleteVehicle(id)` - Remove listing
     - `updateOrderStage(orderId, stage, data)` - Update logistics

3. **State Management**
   - `manufacturerProvider` - Current manufacturer profile
   - `manufacturerVehiclesProvider` - Their vehicles
   - `manufacturerOrdersProvider` - Orders to fulfill

4. **Manufacturer Dashboard**
   - Verification status banner
   - Stats cards:
     - Active listings
     - Total orders
     - Pending fulfillment
     - Revenue (placeholder)
   - Quick actions:
     - Add Vehicle
     - View Orders
     - Manage Inventory
   - Recent orders list

5. **Vehicle Management Screen**
   - List of manufacturer's vehicles
   - Each vehicle card shows:
     - Image, name, price
     - Stock count
     - Status badge
     - Orders count
   - "Add Vehicle" floating action button
   - Edit/Delete actions on each card
   - Filter by status
   - Search by model

6. **Add/Edit Vehicle Screen**
   - Vehicle information form:
     - Manufacturer (read-only)
     - Model name
     - Year
     - Vehicle type selector
   - Specifications:
     - Range (km)
     - Battery (kWh)
     - Power (kW)
     - Acceleration
     - Charging time
   - Pricing:
     - Manufacturer direct price (QAR)
     - Broker market price (QAR)
     - Enable price transparency toggle
   - Inventory:
     - Stock count
     - Status (active/inactive)
   - Images:
     - Image upload
     - Multiple images support
     - Image preview and delete
   - Additional specs (key-value pairs)
   - Save/Cancel buttons

7. **Manufacturer Orders Screen**
   - List of orders for manufacturer's vehicles
   - Filter by status
   - Each order shows:
     - Tracking ID
     - Vehicle ordered
     - Customer info (name, email)
     - Current stage
     - "Update Status" button
   - Pull to refresh

8. **Order Fulfillment Screen**
   - Order details
   - Logistics stage selector
   - Date picker for stage completion
   - Notes input field
   - "Update Stage" button
   - Stage history view

9. **Verification Status Screen**
   - Current verification status
   - Pending: Application in progress message
   - Verified: Badge and congratulations
   - Rejected: Reason and reapply option
   - View submitted documents
   - Edit business information

10. **Components**
    - `VerificationBanner` - Status display
    - `VehicleForm` - Add/edit form
    - `ImageUploader` - Multi-image upload
    - `StageSelector` - Logistics update UI

11. **Image Upload**
    - `image_picker` integration
    - Upload to Supabase Storage
    - Progress indicators
    - Preview and delete

### Verification Steps (ADB Device)
1. Log in as manufacturer user (or create manufacturer account)
2. Verify manufacturer dashboard loads
3. Check verification status displays correctly
4. Navigate to vehicle management
5. Tap "Add Vehicle", fill form, submit
6. Verify vehicle appears in list
7. Edit the vehicle, make changes, save
8. Navigate to manufacturer orders
9. Select an order, update logistics stage
10. Verify stage updates in order tracking

### Deliverables
- Manufacturer dashboard
- Vehicle inventory management
- Order fulfillment tools
- Green check: Manufacturer can manage vehicles and orders

---

## Phase 9: Settings & Profile
**Agent Assignment**: Settings Agent
**Dependencies**: Phase 2 complete
**Estimated Scope**: User settings and profile management

### Objectives
- Implement profile management
- Create settings screen
- Handle app preferences

### Tasks
1. **Settings Screen**
   - Profile section:
     - User avatar
     - Name
     - Email
     - "Edit Profile" button
   - Account section:
     - Change password
     - Delete account (with confirmation)
   - Preferences section:
     - Notifications (toggle)
     - Language (English/Arabic selector)
     - Theme (Light/Dark/Auto - if implemented)
   - Support section:
     - Help Center
     - Contact Support
     - Terms of Service
     - Privacy Policy
   - App info:
     - App version
     - Build number
   - Logout button

2. **Edit Profile Screen**
   - Profile photo upload
   - Full name input
   - Email (read-only, managed separately)
   - Phone number input
   - Save/Cancel buttons

3. **Change Password Screen**
   - Current password input
   - New password input
   - Confirm new password input
   - Show/hide password toggles
   - Update button
   - Validation (current password required, strength check)

4. **Delete Account Screen**
   - Warning message about data loss
   - Confirmation checkbox
   - "Confirm Deletion" button
   - Cancel button

5. **Language Selector**
   - English / Arabic options
   - Updates app language
   - Persists selection

6. **Support Screens**
   - Help Center:
     - FAQ list
     - Search FAQs
     - Contact support button
   - Contact Support:
     - Subject input
     - Message input
     - Send button
   - Terms & Privacy:
     - Static content display
     - Link to web version

7. **State Management**
   - `settingsProvider` - User preferences
   - `profileProvider` - User profile data
   - `languageProvider` - Selected language
   - `notificationProvider` - Notification preferences

8. **Services**
   - `ProfileService` - Profile updates
   - `SettingsService` - Preferences persistence
   - `SupportService` - Contact form submission

9. **Components**
   - `SettingsTile` - Reusable settings item
   - `SettingsSection` - Grouped settings
   - `ProfilePhotoPicker` - Avatar selection
   - `LanguageSelector` - Language picker

10. **Storage**
    - SharedPreferences for settings
    - Secure storage for sensitive data

### Verification Steps (ADB Device)
1. Navigate to Profile/Settings tab
2. Verify all settings sections display
3. Tap "Edit Profile", change name, save
4. Verify name updates across app
5. Navigate to change password, flow through screen
6. Test language selector (if content supports)
7. Open Help Center, browse FAQs
8. Fill out contact support form
9. Test delete account flow (don't confirm!)
10. Verify logout button works and redirects to login

### Deliverables
- Complete settings screen
- Profile editing
- Account management
- Green check: User can manage their profile and settings

---

## Phase 10: Admin Portal
**Agent Assignment**: Admin Features Agent
**Dependencies**: Phase 9 complete, User role = Admin
**Estimated Scope**: Admin-specific features

### Objectives
- Implement admin dashboard
- User and content moderation
- System overview

### Tasks
1. **Data Models**
   - `AdminStats` model:
     ```dart
     - total_users, total_manufacturers
     - total_orders, total_vehicles
     - pending_verifications
     - revenue_summary
     ```

2. **Repository Extensions**
   - `AdminRepository` interface
   - Methods:
     - `getSystemStats()` - Dashboard statistics
     - `getAllUsers(pagination)` - User list
     - `getAllManufacturers(pagination)` - Manufacturer list
     - `getAllOrders(pagination)` - All orders
     - `getPendingVerifications()` - Manufacturer applications
     - `verifyManufacturer(id, approve)` - Approve/reject
     - `updateVehicle(id, data)` - Edit any vehicle
     - `deleteVehicle(id)` - Remove any vehicle

3. **State Management**
   - `adminStatsProvider` - Dashboard stats
   - `usersProvider` - User list
   - `verificationsProvider` - Pending applications

4. **Admin Dashboard**
   - Stats overview cards
   - Pending verifications section
   - Recent orders
   - Quick actions

5. **User Management Screen**
   - List of all users
   - Search and filter
   - User detail view with:
     - Profile info
     - Order history
     - Account status
     - Suspend/Ban actions

6. **Manufacturer Verification Screen**
   - List of pending applications
   - Each application shows:
     - Company name
     - Contact info
     - Business license preview
     - Applied date
     - Approve/Reject buttons
   - Detail view with full documents
   - Reason input for rejection

7. **Vehicle Management Screen**
   - List of all vehicles
   - Filter by manufacturer, status
   - Edit any vehicle
   - Delete vehicle with confirmation

8. **Order Management Screen**
   - List of all orders
   - Filter by status, date range
   - View order details
   - Manual status override (admin action)

### Verification Steps (ADB Device)
1. Log in as admin user
2. Verify dashboard loads with stats
3. Navigate to pending verifications
4. Approve/reject a manufacturer application
5. Navigate to user management
6. Search for a specific user
7. Navigate to vehicle management
8. Edit a vehicle listing

### Deliverables
- Admin dashboard
- User management
- Verification system
- Green check: Admin can manage users and content

---

## Phase 11: Polish & Production Readiness
**Agent Assignment**: QA & Polish Agent
**Dependencies**: All phases complete
**Estimated Scope**: Bug fixes, optimizations, production prep

### Objectives
- Fix bugs and issues found during testing
- Optimize performance
- Add error boundaries
- Implement analytics
- Prepare for production

### Tasks
1. **Error Handling**
   - Global error handler
   - Error screens for each feature
   - Offline mode handling
   - Network timeout handling

2. **Loading States**
   - Skeleton loaders for all lists
   - Full-screen loaders for actions
   - Progressive image loading

3. **Performance Optimization**
   - Image caching optimization
   - List performance (lazy loading)
   - API response caching
   - Memory leak detection and fixes

4. **Accessibility**
   - Screen reader support
   - Proper contrast ratios
   - Touch target sizes
   - Semantic labels

5. **Animations**
   - Page transitions
   - Button press feedback
   - Loading animations
   - Success/failure feedback

6. **Analytics Integration**
   - Screen tracking
   - Event tracking (button taps, purchases)
   - Crash reporting

7. **Notification System**
   - Local notifications for order updates
   - Push notification setup
   - Notification preferences

8. **Testing**
   - Unit tests for critical logic
   - Widget tests for key components
   - Integration tests for flows

9. **Security**
   - Certificate pinning (if needed)
   - Sensitive data protection
   - API key security

10. **Documentation**
    - Code documentation
    - API documentation
    - Deployment guide

11. **Build Configuration**
    - Production build setup
    - Environment-specific configs
    - Proguard/R8 configuration (Android)
    - App signing setup

12. **Store Preparation**
    - App store screenshots
    - Description text
    - Privacy policy URL
    - App icons for all sizes

### Verification Steps (ADB Device)
1. Test all major flows end-to-end
2. Test on poor network connection
3. Test in airplane mode (offline handling)
4. Rotate device, verify orientations
5. Test on different screen sizes
6. Monitor memory usage
7. Test with accessibility features enabled
8. Verify no crashes during navigation
9. Test deep links (if implemented)
10. Verify push notifications work

### Deliverables
- Production-ready app
- All bugs fixed
- Optimized performance
- Store listings prepared
- Green check: App ready for submission

---

## How to Use This Plan

### For Each Phase:
1. **Review the phase objectives and tasks**
2. **Authorize Claude to proceed** with the specific agent
3. **Agent will implement** all tasks in the phase
4. **Deploy to ADB device** for testing
5. **Test all verification steps**
6. **Confirm completion** before moving to next phase

### Phase Activation Commands:
```
"Proceed with Phase 1: Foundation & Infrastructure Setup"
"Proceed with Phase 2: Authentication System"
"Proceed with Phase 3: Dashboard & Navigation"
... and so on
```

### Testing Between Phases:
After each phase completion:
1. Review the implemented features
2. Run through all verification steps on ADB device
3. Report any issues to be addressed
4. Confirm satisfaction before proceeding

### Notes:
- Each phase is designed to be testable on device
- Later phases depend on earlier phases being complete
- You can pause after any phase
- Report issues and they will be addressed before proceeding
- The plan can be adjusted based on priorities

---

## Environment Setup Reference

### ADB Testing:
```bash
# Check connected devices
adb devices

# Install and run on device
flutter install
flutter run

# Release build for testing
flutter build apk --release
adb install app-release.apk
```

### Supabase Environment Variables:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

---

*Document Version: 1.0*
*Last Updated: 2026-01-13*
*Generated for QEV-HUB-MOBILE Flutter Implementation*
