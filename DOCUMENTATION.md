# QEV Hub - Complete Documentation

> **Electrifying Qatar: Optimizing Infrastructure & Supply Chain**
> A centralized digital ecosystem connecting Qatari consumers directly with international EV manufacturers.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Key Features](#key-features)
4. [Technology Stack](#technology-stack)
5. [Project Structure](#project-structure)
6. [Database Schema](#database-schema)
7. [Authentication & Authorization](#authentication--authorization)
8. [Core Modules](#core-modules)
9. [API & Integration](#api--integration)
10. [Setup & Installation](#setup--installation)
11. [Deployment](#deployment)
12. [Development Workflow](#development-workflow)

---

## 1. Project Overview

### Purpose
QEV Hub is a comprehensive platform designed to revolutionize electric vehicle adoption in Qatar by:
- **Eliminating middlemen** between consumers and EV manufacturers
- **Reducing costs** by up to 30-40% compared to traditional broker pricing
- **Streamlining logistics** from international sourcing to local delivery
- **Ensuring compliance** with Qatari regulations (FAHES inspection, customs, insurance)
- **Promoting sustainability** through data-driven insights

### Target Users
- **Consumers**: Browse EVs, place orders, track deliveries
- **Manufacturers**: List vehicles, manage inventory
- **Administrators**: Manage orders, update shipping status, handle logistics
- **Government/Regulators**: Compliance tracking and reporting

---

## 2. System Architecture

### Three-Tier Architecture

```
┌─────────────────────────────────────────────────────┐
│              QEV Hub Ecosystem                      │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────────┐      ┌──────────────────┐    │
│  │   Web App       │      │   Mobile App     │    │
│  │  (Next.js 14)   │      │ (React Native)   │    │
│  └────────┬────────┘      └────────┬─────────┘    │
│           │                         │              │
│           └─────────┬───────────────┘              │
│                     │                              │
│           ┌─────────▼─────────┐                    │
│           │   Shared Types    │                    │
│           │  (TypeScript)     │                    │
│           └─────────┬─────────┘                    │
│                     │                              │
│           ┌─────────▼─────────┐                    │
│           │    Supabase       │                    │
│           │   (Backend)       │                    │
│           │ - PostgreSQL      │                    │
│           │ - Auth            │                    │
│           │ - Storage         │                    │
│           │ - Realtime        │                    │
│           └───────────────────┘                    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Components

#### **qev-hub-web** (Next.js 14)
- Server-side rendered web application
- App Router for modern routing
- Responsive UI with Tailwind CSS
- Admin dashboard and consumer portal

#### **qev-hub-mobile** (React Native)
- Native iOS and Android applications
- Cross-platform codebase
- React Navigation for routing
- React Native Paper for UI components

#### **qev-hub-shared**
- Shared TypeScript types and interfaces
- Ensures type safety across web and mobile
- Published as local NPM package

#### **qev-hub-mcp**
- Model Context Protocol (MCP) server
- Enables AI assistants to interact with the system
- Provides tools for querying and managing data
- Connects directly to Supabase backend

#### **Supabase Backend**
- PostgreSQL database with RLS (Row Level Security)
- User authentication and authorization
- File storage for documents and images
- Real-time subscriptions for live updates

---

## 3. Key Features

### 🛒 **Marketplace**
- Browse available electric vehicles
- View manufacturer pricing vs broker pricing
- See cost savings (30-40% discount)
- Filter by manufacturer, model, range, price
- Detailed vehicle specifications

### 📦 **Order Management**
- Place orders directly with manufacturers
- Track order status in real-time
- 8-stage tracking timeline:
  1. Order Placed
  2. Confirmed
  3. Shipped
  4. In Customs (Qatar)
  5. FAHES Inspection
  6. Insurance Processing
  7. Out for Delivery
  8. Completed

### 🚚 **Logistics Tracking**
- Real-time order status updates
- Visual timeline with progress indicators
- Location tracking for each stage
- Document management (customs forms, certificates, etc.)
- Push notifications for status changes

### 👥 **User Management**
- Role-based access control (Consumer, Manufacturer, Admin)
- User profiles with personal information
- Authentication via Supabase Auth
- Secure session management

### 🛡️ **Admin Dashboard**
- View all orders across all users
- Update order status with notes
- Attach documents at each shipping stage
- Real-time updates broadcast to customers
- Comprehensive order analytics

### 📄 **Document Management**
- Upload and store shipping documents
- Customs forms and declarations
- FAHES inspection certificates
- Insurance papers
- Delivery receipts
- Download documents from tracking page

### 📊 **Sustainability Metrics**
- Track CO2 emissions saved
- Energy consumption data
- Environmental impact reports
- Compare with traditional vehicles

### 🔄 **Real-time Updates**
- Supabase Realtime subscriptions
- Instant status updates without refresh
- Toast notifications for changes
- Live order tracking

### 🤖 **AI Integration (MCP Server)**
- Natural language queries to database
- Search vehicles through AI conversation
- Track orders via AI assistant
- Update order status through AI commands
- Get analytics and reports via conversation
- Works with Claude Desktop, VS Code (Cline), and other MCP-compatible tools

---

## 4. Technology Stack

### Frontend

#### Web (qev-hub-web)
| Technology | Purpose | Version |
|------------|---------|---------|
| **Next.js** | React framework with SSR | 14.2.0 |
| **React** | UI library | 18.x |
| **TypeScript** | Type-safe JavaScript | 5.x |
| **Tailwind CSS** | Utility-first CSS | 3.4.1 |
| **shadcn/ui** | Component library | Latest |
| **Radix UI** | Headless UI components | Latest |
| **React Hook Form** | Form management | 7.69.0 |
| **Zod** | Schema validation | 4.3.2 |

#### Mobile (qev-hub-mobile)
| Technology | Purpose | Version |
|------------|---------|---------|
| **React Native** | Mobile framework | 0.72.10 |
| **React Navigation** | Navigation library | 6.1.9 |
| **React Native Paper** | Material Design UI | 5.11.0 |
| **TypeScript** | Type-safe JavaScript | 4.8.4 |

### Backend

| Technology | Purpose |
|------------|---------|
| **Supabase** | Backend-as-a-Service |
| **PostgreSQL** | Relational database |
| **PostgREST** | Auto-generated REST API |
| **GoTrue** | User authentication |
| **Realtime** | WebSocket subscriptions |
| **Storage** | File storage (S3-compatible) |

### Development Tools

| Tool | Purpose |
|------|---------|
| **Git** | Version control |
| **npm** | Package management |
| **ESLint** | Code linting |
| **Prettier** | Code formatting |
| **Metro** | React Native bundler |

### AI Integration

| Technology | Purpose |
|------------|---------|
| **MCP (Model Context Protocol)** | AI assistant integration protocol |
| **@modelcontextprotocol/sdk** | MCP SDK for TypeScript |
| **Claude Desktop** | Desktop AI assistant (supports MCP) |
| **VS Code (Cline)** | Code editor with AI (supports MCP) |

---

## 5. Project Structure

```
QEV/
├── README.md                           # Project overview and setup
├── DATABASE_REBUILD_COMPLETE.md        # Database migration documentation
├── DOCUMENTATION.md                    # This file
│
├── qev-hub-mcp/                        # MCP Server for AI integration
│   ├── src/
│   │   └── index.ts                   # MCP server implementation
│   ├── package.json                   # Dependencies
│   ├── tsconfig.json                  # TypeScript config
│   ├── README.md                      # MCP server documentation
│   ├── SETUP.md                       # Setup instructions
│   └── .env.example                   # Environment template
│
├── qev-hub-web/                        # Next.js web application
│   ├── public/                         # Static assets
│   ├── src/
│   │   ├── app/                        # Next.js App Router
│   │   │   ├── globals.css            # Global styles
│   │   │   ├── layout.tsx             # Root layout
│   │   │   ├── page.tsx               # Homepage
│   │   │   │
│   │   │   ├── (auth)/                # Auth routes (login/signup)
│   │   │   │   ├── login/
│   │   │   │   │   └── page.tsx       # Login page
│   │   │   │   └── signup/
│   │   │   │       └── page.tsx       # Signup page
│   │   │   │
│   │   │   ├── (main)/                # Protected routes
│   │   │   │   ├── marketplace/
│   │   │   │   │   ├── page.tsx       # Vehicle listing
│   │   │   │   │   └── [id]/
│   │   │   │   │       └── page.tsx   # Vehicle details
│   │   │   │   ├── orders/
│   │   │   │   │   ├── page.tsx       # Orders list
│   │   │   │   │   └── [id]/
│   │   │   │   │       └── page.tsx   # Order tracking
│   │   │   │   └── admin/
│   │   │   │       └── page.tsx       # Admin dashboard
│   │   │   │
│   │   │   ├── auth/
│   │   │   │   └── callback/
│   │   │   │       └── page.tsx       # OAuth callback
│   │   │   │
│   │   │   └── db-status/
│   │   │       └── page.tsx           # Database status check
│   │   │
│   │   ├── components/                # React components
│   │   │   ├── auth/                  # Auth-related components
│   │   │   └── ui/                    # shadcn/ui components
│   │   │       ├── badge.tsx
│   │   │       ├── button.tsx
│   │   │       ├── card.tsx
│   │   │       ├── dialog.tsx
│   │   │       ├── form.tsx
│   │   │       ├── input.tsx
│   │   │       ├── label.tsx
│   │   │       ├── progress.tsx
│   │   │       ├── select.tsx
│   │   │       ├── tabs.tsx
│   │   │       ├── toast.tsx
│   │   │       └── toaster.tsx
│   │   │
│   │   ├── hooks/                     # Custom React hooks
│   │   │   └── use-toast.ts
│   │   │
│   │   └── lib/                       # Utility libraries
│   │       ├── supabase.ts            # Supabase client
│   │       └── utils.ts               # Helper functions
│   │
│   ├── supabase/                      # Database migrations
│   │   └── migrations/
│   │       ├── 001_initial_schema.sql              # Database schema
│   │       ├── 002_seed_data.sql                   # Sample data
│   │       ├── 003_fix_rls_policies.sql            # RLS fixes
│   │       ├── 004_fix_auth_rls.sql                # Auth fixes
│   │       ├── 005_add_read_policy.sql             # Read policies
│   │       ├── 006_remove_trigger.sql              # Cleanup
│   │       ├── 007_fix_profile_insert_policy.sql   # Profile creation fix
│   │       ├── 008_rebuild_rls_policies.sql        # Complete RLS rebuild
│   │       ├── 009_fix_insert_only.sql             # Insert policy fix
│   │       └── 010_enable_realtime.sql             # Enable realtime
│   │
│   ├── scripts/                       # Utility scripts
│   │   ├── apply-migration-007.sh
│   │   ├── apply-migration-008.sh
│   │   ├── check-database.js
│   │   ├── create-test-account.js
│   │   ├── create-test-account.ts
│   │   ├── database-scan.js
│   │   ├── enable-realtime.sh
│   │   ├── migrate.ts
│   │   ├── show-fix.sh
│   │   ├── test-actual-signup.js
│   │   ├── test-auth.js
│   │   ├── test-complete-flow.js
│   │   ├── test-profile-creation.js
│   │   ├── test-tracking.sh
│   │   └── test-with-auth.js
│   │
│   ├── package.json                   # Dependencies
│   ├── tsconfig.json                  # TypeScript config
│   ├── tailwind.config.ts             # Tailwind config
│   ├── postcss.config.mjs             # PostCSS config
│   ├── next.config.mjs                # Next.js config
│   ├── components.json                # shadcn/ui config
│   ├── LOGISTICS_TRACKING.md          # Logistics feature docs
│   └── SIMPLE_FIX.sql                 # Quick SQL fixes
│
├── qev-hub-mobile/                    # React Native mobile app
│   ├── android/                       # Android native code
│   ├── ios/                           # iOS native code
│   ├── src/
│   │   ├── App.tsx                    # Root component
│   │   ├── components/                # React components
│   │   ├── navigation/                # Navigation setup
│   │   ├── screens/
│   │   │   └── LoginScreen.tsx        # Login screen
│   │   ├── theme/
│   │   │   └── colors.ts              # Color palette
│   │   └── utils/                     # Utilities
│   │
│   ├── app.json                       # React Native config
│   ├── babel.config.js                # Babel config
│   ├── metro.config.js                # Metro bundler config
│   ├── index.js                       # App entry point
│   ├── package.json                   # Dependencies
│   └── tsconfig.json                  # TypeScript config
│
└── qev-hub-shared/                    # Shared TypeScript types
    ├── src/
    │   ├── index.ts                   # Main export
    │   └── types/
    │       └── index.ts               # Type definitions
    ├── package.json                   # Package config
    └── tsconfig.json                  # TypeScript config
```

---

## 6. Database Schema

### Tables Overview

| Table | Purpose | Records |
|-------|---------|---------|
| **profiles** | User profiles and role information | Users |
| **vehicles** | EV inventory with pricing | ~10-15 models |
| **orders** | Customer orders | Transactions |
| **order_status_history** | Order tracking timeline | Status changes |
| **documents** | Shipping documents and certificates | Files |
| **gcc_export_rules** | Regional export compliance rules | Regulations |
| **sustainability_metrics** | Environmental impact data | Analytics |

### Detailed Schema

#### **profiles**
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT,
  role TEXT DEFAULT 'consumer' CHECK (role IN ('consumer', 'manufacturer', 'admin')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Purpose**: Store user information and roles
**RLS Policies**:
- Users can read their own profile
- Users can insert their own profile during signup
- Users can update their own profile
- Admins have full access

#### **vehicles**
```sql
CREATE TABLE vehicles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  manufacturer TEXT NOT NULL,
  model TEXT NOT NULL,
  year INTEGER NOT NULL,
  range_km INTEGER NOT NULL,
  battery_capacity_kwh NUMERIC NOT NULL,
  charging_time_hours NUMERIC NOT NULL,
  manufacturer_price_qar NUMERIC NOT NULL,
  broker_price_qar NUMERIC NOT NULL,
  available BOOLEAN DEFAULT true,
  image_url TEXT,
  specs JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Purpose**: Store EV inventory with pricing
**Key Fields**:
- `manufacturer_price_qar`: Direct from manufacturer (lower price)
- `broker_price_qar`: Traditional broker price (30-40% higher)
- `available`: Whether vehicle can be ordered
- `specs`: Additional specifications as JSON

**RLS Policies**:
- Public can view available vehicles
- Admins can manage all vehicles

#### **orders**
```sql
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id),
  vehicle_id UUID NOT NULL REFERENCES vehicles(id),
  tracking_id TEXT UNIQUE NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN (
    'pending', 'confirmed', 'shipped', 'in_customs',
    'fahes_inspection', 'insurance_processing',
    'out_for_delivery', 'completed', 'cancelled'
  )),
  total_price_qar NUMERIC NOT NULL,
  shipping_address TEXT NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);
```

**Purpose**: Track customer orders
**Status Flow**:
1. `pending` → Order placed, awaiting confirmation
2. `confirmed` → Manufacturer confirmed order
3. `shipped` → Vehicle shipped from origin
4. `in_customs` → Clearing Qatar customs
5. `fahes_inspection` → FAHES safety inspection
6. `insurance_processing` → Processing Qatar insurance
7. `out_for_delivery` → On the way to customer
8. `completed` → Delivered to customer

**RLS Policies**:
- Users can view their own orders
- Users can create orders
- Admins can view and update all orders

#### **order_status_history**
```sql
CREATE TABLE order_status_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  status TEXT NOT NULL,
  location TEXT,
  notes TEXT,
  document_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Purpose**: Track status change timeline
**Realtime**: Enabled for live updates
**RLS Policies**:
- Users can view history for their orders
- Admins can insert new status updates

#### **documents**
```sql
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN (
    'customs_form', 'fahes_certificate', 'insurance_policy',
    'shipping_manifest', 'delivery_receipt', 'other'
  )),
  url TEXT NOT NULL,
  uploaded_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Purpose**: Store order-related documents
**Document Types**:
- `customs_form`: Customs declaration
- `fahes_certificate`: FAHES inspection certificate
- `insurance_policy`: Qatar insurance policy
- `shipping_manifest`: Shipping documents
- `delivery_receipt`: Proof of delivery

#### **gcc_export_rules**
```sql
CREATE TABLE gcc_export_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  country TEXT NOT NULL,
  rule_description TEXT NOT NULL,
  compliance_required BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Purpose**: Track GCC export compliance requirements

#### **sustainability_metrics**
```sql
CREATE TABLE sustainability_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id UUID REFERENCES vehicles(id),
  co2_savings_kg_per_year NUMERIC NOT NULL,
  energy_consumption_kwh_per_100km NUMERIC NOT NULL,
  estimated_lifecycle_years INTEGER DEFAULT 10,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Purpose**: Track environmental impact and sustainability

---

## 7. Authentication & Authorization

### Authentication Flow

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Signup  │────▶│  Supabase │────▶│  Create  │
│  /signup │     │   Auth    │     │  Profile │
└──────────┘     └──────────┘     └──────────┘
                       │
                       ▼
                 ┌──────────┐
                 │  Session │
                 │  Cookie  │
                 └──────────┘
                       │
                       ▼
              ┌─────────────────┐
              │  Protected Pages │
              │  - Marketplace   │
              │  - Orders        │
              │  - Admin         │
              └─────────────────┘
```

### User Roles

#### **Consumer** (Default)
- Browse marketplace
- Place orders
- Track own orders
- View own profile
- Download documents

#### **Manufacturer**
- List vehicles
- View orders for their vehicles
- Update vehicle information
- Manage inventory

#### **Admin**
- Full system access
- View all orders
- Update order status
- Upload documents
- Manage users
- View analytics

### Row Level Security (RLS)

Every table has RLS enabled to ensure data security:

**Example: Profiles Table**
```sql
-- Users can read their own profile
CREATE POLICY "profiles_select_own"
ON profiles FOR SELECT
USING (auth.uid() = id);

-- Users can insert their own profile during signup
CREATE POLICY "profiles_insert_own"
ON profiles FOR INSERT
WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "profiles_update_own"
ON profiles FOR UPDATE
USING (auth.uid() = id);
```

**Example: Orders Table**
```sql
-- Users can view their own orders
CREATE POLICY "orders_select_own"
ON orders FOR SELECT
USING (auth.uid() = user_id);

-- Admins can view all orders
CREATE POLICY "orders_admin_select_all"
ON orders FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
);
```

---

## 8. Core Modules

### Module 1: Marketplace

**Location**: [src/app/(main)/marketplace/page.tsx](qev-hub-web/src/app/(main)/marketplace/page.tsx)

**Features**:
- Display all available vehicles
- Show manufacturer vs broker pricing
- Calculate savings (30-40%)
- Filter and sort options
- Responsive grid layout
- Direct links to vehicle details

**Key Code**:
```typescript
// Fetch vehicles from Supabase
const { data, error } = await supabase
  .from('vehicles')
  .select('*')
  .eq('available', true)
  .order('manufacturer_price_qar', { ascending: true })

// Calculate savings
const savings = brokerPrice - manufacturerPrice
const percentage = ((savings / brokerPrice) * 100)
```

### Module 2: Vehicle Details & Ordering

**Location**: [src/app/(main)/marketplace/[id]/page.tsx](qev-hub-web/src/app/(main)/marketplace/[id]/page.tsx)

**Features**:
- Detailed vehicle specifications
- Pricing comparison
- Order form with validation
- Shipping address input
- Order confirmation

### Module 3: Order Tracking

**Location**: [src/app/(main)/orders/[id]/page.tsx](qev-hub-web/src/app/(main)/orders/[id]/page.tsx)

**Features**:
- 8-stage horizontal timeline
- Visual progress indicators
- Real-time status updates
- Document downloads
- Status history with timestamps
- Location tracking

**Timeline Stages**:
1. 📝 Order Placed
2. ✅ Confirmed
3. 🚢 Shipped
4. 🛃 In Customs
5. 🔍 FAHES Inspection
6. 🛡️ Insurance Processing
7. 🚚 Out for Delivery
8. ✨ Completed

**Real-time Updates**:
```typescript
// Subscribe to order changes
const subscription = supabase
  .channel('order-updates')
  .on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'orders',
    filter: `id=eq.${orderId}`
  }, (payload) => {
    // Update UI with new status
    setOrder(payload.new)
    toast({
      title: "Order Updated",
      description: `Status changed to ${payload.new.status}`
    })
  })
  .subscribe()
```

### Module 4: Admin Dashboard

**Location**: [src/app/(main)/admin/page.tsx](qev-hub-web/src/app/(main)/admin/page.tsx)

**Features**:
- View all orders (all users)
- Update order status
- Add location tracking
- Attach documents
- Add notes to status updates
- Real-time updates broadcast

**Access Control**:
```typescript
// Check if user is admin
const { data: profile } = await supabase
  .from('profiles')
  .select('role')
  .eq('id', session.user.id)
  .single()

if (profile?.role !== 'admin') {
  router.push('/marketplace')
}
```

### Module 5: Authentication

**Signup**: [src/app/(auth)/signup/page.tsx](qev-hub-web/src/app/(auth)/signup/page.tsx)
**Login**: [src/app/(auth)/login/page.tsx](qev-hub-web/src/app/(auth)/login/page.tsx)

**Features**:
- Email/password authentication
- Form validation with React Hook Form + Zod
- Automatic profile creation
- Session management
- Protected route middleware

**Signup Flow**:
```typescript
// 1. Create auth user
const { data: authData, error: authError } = await supabase.auth.signUp({
  email,
  password,
})

// 2. Create profile record
const { error: profileError } = await supabase
  .from('profiles')
  .insert({
    id: authData.user.id,
    email,
    full_name,
    phone,
    role
  })

// 3. Redirect to marketplace
router.push('/marketplace')
```

---

## 9. API & Integration

### MCP Server (AI Integration)

The QEV Hub MCP server enables AI assistants to interact with the system through natural language.

**Location**: [qev-hub-mcp/](qev-hub-mcp/)

#### Available Tools

1. **search_vehicles** - Search and filter EVs in marketplace
2. **get_vehicle** - Get detailed vehicle information
3. **get_orders** - Retrieve orders with filtering
4. **get_order_tracking** - Get detailed order tracking
5. **update_order_status** - Update order status (admin)
6. **get_user_profile** - Get user information
7. **get_order_analytics** - Get statistics and analytics
8. **get_sustainability_metrics** - Get environmental impact data

#### Setup

See [qev-hub-mcp/SETUP.md](qev-hub-mcp/SETUP.md) for detailed setup instructions.

**Quick start**:
```bash
cd qev-hub-mcp
npm install
npm run build

# Create .env file with Supabase credentials
cp .env.example .env
# Edit .env with your credentials

# Test the server
npm start
```

#### Example Usage

Once configured with Claude Desktop or VS Code:

```
User: "Show me all Tesla vehicles under 200,000 QAR"
AI: [Uses search_vehicles tool to query database]

User: "What's the status of order #QEV-12345?"
AI: [Uses get_order_tracking tool to fetch tracking info]

User: "Update order XYZ to 'shipped' status"
AI: [Uses update_order_status tool to update the order]
```

### Supabase Client

**Location**: [src/lib/supabase.ts](qev-hub-web/src/lib/supabase.ts)

```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseKey)
```

### Common Operations

#### **Fetch Data**
```typescript
const { data, error } = await supabase
  .from('table_name')
  .select('*')
  .eq('column', value)
```

#### **Insert Data**
```typescript
const { data, error } = await supabase
  .from('table_name')
  .insert({ column: value })
```

#### **Update Data**
```typescript
const { data, error } = await supabase
  .from('table_name')
  .update({ column: newValue })
  .eq('id', recordId)
```

#### **Real-time Subscription**
```typescript
const subscription = supabase
  .channel('channel-name')
  .on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'table_name'
  }, (payload) => {
    // Handle update
  })
  .subscribe()
```

#### **File Upload**
```typescript
const { data, error } = await supabase.storage
  .from('bucket-name')
  .upload('file-path', file)
```

---

## 10. Setup & Installation

### Prerequisites

- **Node.js**: v18 or later
- **npm**: v9 or later
- **Git**: For version control
- **Supabase Account**: https://supabase.com

### Step 1: Clone Repository

```bash
git clone <repository-url>
cd QEV
```

### Step 2: Install Dependencies

```bash
# Web application
cd qev-hub-web
npm install

# Mobile application
cd ../qev-hub-mobile
npm install

# Shared types package
cd ../qev-hub-shared
npm install
npm run build
```

### Step 3: Supabase Setup

#### Create Project
1. Go to https://supabase.com
2. Create new project
3. Note down:
   - Project URL
   - Anon public key
   - Service role key (keep secret)

#### Run Migrations
1. Open Supabase SQL Editor
2. Run migrations in order:
   - `001_initial_schema.sql` - Database schema
   - `002_seed_data.sql` - Sample data
   - `008_rebuild_rls_policies.sql` - RLS policies
   - `010_enable_realtime.sql` - Enable realtime

#### Create Storage Buckets
Navigate to Storage → Create buckets:
- `vehicle-images` (public)
- `user-documents` (authenticated)
- `generated-pdfs` (authenticated)

### Step 4: Environment Variables

**Web** (`qev-hub-web/.env.local`):
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

**Mobile** (`qev-hub-mobile/.env`):
```env
EXPO_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

### Step 5: Run Applications

**Web Development Server**:
```bash
cd qev-hub-web
npm run dev
# Opens at http://localhost:3000
```

**Mobile Development**:
```bash
cd qev-hub-mobile

# iOS
npm run ios

# Android
npm run android
```

### Step 6: Create Test Account

```bash
cd qev-hub-web
node scripts/create-test-account.js
```

Creates test accounts:
- Consumer: consumer@test.com / password123
- Admin: admin@test.com / password123

### Step 7: Setup MCP Server (Optional - For AI Integration)

```bash
cd qev-hub-mcp
npm install
npm run build

# Create environment file
cp .env.example .env
# Edit .env with Supabase service role key

# Test the server
npm start
```

See [qev-hub-mcp/SETUP.md](qev-hub-mcp/SETUP.md) for detailed configuration with Claude Desktop or VS Code.

---

## 11. Deployment

### Web Application (Vercel)

1. **Install Vercel CLI**:
```bash
npm install -g vercel
```

2. **Deploy**:
```bash
cd qev-hub-web
vercel
```

3. **Set Environment Variables** in Vercel dashboard:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`

4. **Production Deploy**:
```bash
vercel --prod
```

### Mobile Application

#### iOS (App Store)

1. **Build**:
```bash
cd qev-hub-mobile/ios
xcodebuild -workspace QEVHub.xcworkspace -scheme QEVHub archive
```

2. **Upload** to App Store Connect

#### Android (Google Play)

1. **Build**:
```bash
cd qev-hub-mobile/android
./gradlew assembleRelease
```

2. **Upload** to Google Play Console

---

## 12. Development Workflow

### Code Organization

- **Components**: Reusable UI components
- **Screens/Pages**: Full page views
- **Hooks**: Custom React hooks
- **Utils**: Helper functions
- **Types**: TypeScript interfaces

### Best Practices

1. **Type Safety**: Always use TypeScript types
2. **RLS First**: Design database with RLS in mind
3. **Error Handling**: Catch and display errors gracefully
4. **Loading States**: Show loading indicators
5. **Responsive Design**: Mobile-first approach
6. **Accessibility**: ARIA labels and keyboard navigation
7. **Performance**: Lazy load components, optimize images
8. **Security**: Never expose service role key
9. **Testing**: Test auth flows and RLS policies

### Common Commands

```bash
# Development
npm run dev              # Start dev server
npm run build            # Build for production
npm run start            # Start production server
npm run lint             # Run ESLint

# Database
node scripts/check-database.js        # Check DB connection
node scripts/test-complete-flow.js    # Test full auth flow
bash scripts/enable-realtime.sh       # Enable realtime on tables

# Testing
node scripts/test-auth.js             # Test authentication
node scripts/test-tracking.sh         # Test order tracking
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes
git add .
git commit -m "Add new feature"

# Push to GitHub
git push origin feature/new-feature

# Create Pull Request on GitHub
```

---

## Key Files Reference

### Configuration Files

| File | Purpose |
|------|---------|
| `package.json` | Dependencies and scripts |
| `tsconfig.json` | TypeScript configuration |
| `next.config.mjs` | Next.js configuration |
| `tailwind.config.ts` | Tailwind CSS configuration |
| `components.json` | shadcn/ui configuration |
| `.env.local` | Environment variables (not in git) |

### Important Scripts

| Script | Location | Purpose |
|--------|----------|---------|
| `create-test-account.js` | qev-hub-web/scripts/ | Create test users |
| `check-database.js` | qev-hub-web/scripts/ | Verify DB connection |
| `test-complete-flow.js` | qev-hub-web/scripts/ | Test auth + profile flow |
| `enable-realtime.sh` | qev-hub-web/scripts/ | Enable realtime on tables |

---

## Troubleshooting

### Common Issues

**Issue**: "Profile creation failed"
**Solution**: Run migration `008_rebuild_rls_policies.sql` to fix RLS policies

**Issue**: "Real-time updates not working"
**Solution**: Run migration `010_enable_realtime.sql` and check subscription code

**Issue**: "Authentication not working"
**Solution**: Verify environment variables in `.env.local`

**Issue**: "Cannot find module '@qev-hub/shared'"
**Solution**: Build shared package: `cd qev-hub-shared && npm run build`

**Issue**: "Storage bucket not accessible"
**Solution**: Check bucket policies in Supabase dashboard

---

## MCP Server Capabilities

The QEV Hub MCP server provides these AI-powered features:

### Natural Language Queries
```
"Show me all available EVs from Tesla"
"What's the cheapest vehicle under 150,000 QAR?"
"List all orders that are currently in customs"
"How many orders were placed last month?"
```

### Order Management
```
"Update order ABC123 to shipped status"
"Add a note to order XYZ: Vehicle cleared customs"
"What's the current location of order ABC123?"
"Show me all pending orders"
```

### Analytics & Reporting
```
"What's the total revenue this month?"
"How many vehicles have we sold?"
"Show me sustainability metrics for all EVs"
"What's the average order value?"
```

### User Management
```
"Get profile information for user XYZ"
"How many admin users are there?"
```

For detailed setup instructions, see [qev-hub-mcp/SETUP.md](qev-hub-mcp/SETUP.md).

---

## Future Enhancements

### Planned Features
- [x] **MCP Server for AI integration** ✅ **Completed!**
- [ ] Multi-language support (Arabic + English)
- [ ] Payment gateway integration (Qatar Payment Gateway)
- [ ] Vehicle comparison tool
- [ ] Test drive booking system
- [ ] Financing calculator
- [ ] Trade-in evaluation
- [ ] Referral program
- [ ] Advanced analytics dashboard
- [ ] Mobile app push notifications
- [ ] Enhanced AI chatbot with voice support
- [ ] Virtual showroom (3D vehicle viewer)
- [ ] Integration with Qatar customs API
- [ ] Blockchain-based vehicle history

### Technical Improvements
- [ ] Unit and integration tests
- [ ] E2E testing with Cypress/Playwright
- [ ] Performance monitoring
- [ ] Error tracking (Sentry)
- [ ] Analytics (Google Analytics)
- [ ] SEO optimization
- [ ] PWA support
- [ ] Offline mode
- [ ] GraphQL API layer
- [ ] Microservices architecture

---

## Contributing

### How to Contribute
1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Submit pull request
5. Code review
6. Merge to main

### Code Style
- Follow TypeScript best practices
- Use ESLint and Prettier
- Write meaningful commit messages
- Add comments for complex logic
- Update documentation

---

## License

Proprietary - All rights reserved

---

## Contact & Support

For questions or support:
- **Email**: support@qevhub.qa
- **Documentation**: This file
- **Issue Tracker**: GitHub Issues

---

## Appendix

### Database ER Diagram

```
┌─────────────┐
│   auth.users │
└──────┬──────┘
       │
       │ 1:1
       ▼
┌─────────────┐
│  profiles   │◄────────────────────────┐
└──────┬──────┘                         │
       │                                │
       │ 1:N                            │ References
       ▼                                │
┌─────────────┐         ┌──────────────┴────┐
│   orders    │────────▶│     vehicles      │
└──────┬──────┘         └───────────────────┘
       │
       │ 1:N
       ├────────────────┬────────────────┐
       ▼                ▼                ▼
┌──────────────┐  ┌──────────┐  ┌───────────┐
│order_status  │  │documents │  │gcc_export │
│   _history   │  │          │  │  _rules   │
└──────────────┘  └──────────┘  └───────────┘
```

### Technology Versions

Last updated: January 1, 2026

| Technology | Version | Status |
|------------|---------|--------|
| Node.js | 18.x | ✅ Active |
| Next.js | 14.2.0 | ✅ Active |
| React | 18.x | ✅ Active |
| React Native | 0.72.10 | ✅ Active |
| TypeScript | 5.x | ✅ Active |
| Supabase | Latest | ✅ Active |
| Tailwind CSS | 3.4.1 | ✅ Active |

---

**End of Documentation**

For the latest updates, check the GitHub repository and README.md file.
