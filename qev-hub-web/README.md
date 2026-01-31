# QEV Hub Web Application

Qatar Electric Vehicle Hub - A comprehensive platform for EV marketplace, charging infrastructure, and regulatory compliance in Qatar.

## 🚀 Project Overview

QEV-Hub is a centralized digital platform designed to transform Qatar's EV ecosystem by:
- Eliminating third-party broker markups (15-25% cost savings)
- Connecting Qatari buyers directly with international EV manufacturers
- Streamlining regulatory compliance for vehicle imports
- Providing real-time charging infrastructure data
- Supporting Qatar National Vision 2030

## ✨ Features

### Module 1: Direct Marketplace
- 🚗 **EV Marketplace**: Browse and purchase vehicles from verified manufacturers
- 🏭 **Manufacturer Portal**: Direct integration with BYD, NIO, XPeng, and Zeekr
- 📊 **Real-time Inventory**: Dynamic pricing and stock availability
- 📦 **Order Tracking**: Complete order lifecycle management
- 🚢 **Shipping Details**: Track vehicle shipments from origin to Qatar

### Module 2: Regulatory Compliance Engine ✨ NEW
- 📋 **FAHES Inspection Flow**: Complete vehicle inspection scheduling and tracking
  - 4-step workflow: Documents → Schedule → Checklist → Results
  - Multiple inspection centers (Industrial Area, Dukhan, Al Khor, Wakra)
  - Real-time slot availability and booking
  - Comprehensive inspection checklist (40+ items)

- 📄 **Document Upload System**: Secure document management with progress tracking
  - Drag-and-drop file upload
  - Real-time upload progress
  - Document verification status
  - Support for PDF, JPG, PNG formats

- 🛃 **Customs Documentation Generator**: Automated Qatar customs documentation
  - Import Declaration (Customs 100)
  - Certificate of Origin
  - Commercial Invoice (Customs certified)
  - Packing List
  - Insurance Certificate
  - Excise Tax Declaration
  - Auto-calculated customs duties (5% for EVs)

- 📝 **Import Permit Automation**: Ministry of Commerce & Industry permit processing
  - Multi-step application flow
  - Individual & Company applications
  - Application reference tracking
  - Status notifications

### Module 3: Charging Infrastructure
- ⚡ **Charging Station Map**: Find stations across Qatar
- 🗺️ **Interactive Maps**: Filter by connector type, power level, availability
- 📍 **Real-time Status**: Live station availability updates
- 📱 **Mobile Responsive**: Optimized for all devices

### Additional Features
- 🎨 **New Landing Page**: Modern, animated landing page with dark mode support
- 🌙 **Dark Mode**: Full theme switching capability
- 🌍 **Multi-language**: English and Arabic support
- 🔔 **Notifications**: Real-time status updates
- 📊 **Admin Dashboard**: Vehicle management and analytics

## 🎨 Design System

### Color Palette
- **QEV Electric**: `#00D9C0` (Electric teal/cyan)
- **QEV Deep**: `#0A192F` (Deep navy)
- **QEV Gold**: `#D4AF37` (Qatar gold/sand)
- **QEV Maroon**: `#4a0d1d` (Qatar maroon - heritage)

### Typography
- **Display Font**: Space Grotesk (headings)
- **Body Font**: Inter (content)

## 📁 Project Structure

```
src/
├── app/
│   ├── (main)/
│   │   ├── charging/              # Charging stations page
│   │   ├── compliance/            # ✨ NEW: Module 2 compliance system
│   │   ├── marketplace/           # Vehicle marketplace
│   │   ├── orders/                # Order tracking
│   │   ├── dashboard/             # User dashboard
│   │   └── settings/              # User settings
│   ├── (manufacturer)/
│   │   └── manufacturer/          # Manufacturer portal
│   ├── (auth)/                   # Authentication pages
│   ├── api/                      # API routes
│   └── page.tsx                  # ✨ UPDATED: New landing page
├── components/
│   ├── landing/                  # ✨ NEW: Landing page components
│   │   ├── NewLandingNavbar.tsx
│   │   ├── NewHeroSection.tsx
│   │   ├── ChallengeSection.tsx
│   │   ├── SolutionSection.tsx
│   │   ├── MarketplacePreviewSection.tsx
│   │   ├── ChargingInfrastructureSection.tsx
│   │   ├── ResearchSection.tsx
│   │   ├── CTASection.tsx
│   │   └── NewLandingFooter.tsx
│   ├── compliance/               # ✨ NEW: Module 2 components
│   │   ├── ComplianceDashboard.tsx
│   │   ├── FAHESInspectionFlow.tsx
│   │   ├── DocumentUploadSystem.tsx
│   │   ├── CustomsDocumentationGenerator.tsx
│   │   └── ImportPermitAutomation.tsx
│   └── ui/                       # Reusable UI components
├── lib/
│   ├── supabase.ts               # Supabase client
│   └── utils.ts                  # Utility functions
└── services/
    └── charging-sync.ts          # Charging data sync service
```

## 🚀 Getting Started

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment Variables
Copy `.env.example` to `.env.local` and fill in your credentials:
```bash
cp .env.example .env.local
```

Required variables:
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

Optional variables:
```env
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_google_maps_key  # For maps integration
```

### 3. Run Database Migrations
```bash
# Using Supabase CLI
supabase db push

# Or apply migrations manually
supabase migration up
```

### 4. Start Development Server
```bash
npm run dev
```

Visit http://localhost:3000

## 📜 Available Scripts

| Script | Description |
|--------|-------------|
| `npm run dev` | Start development server (Next.js) |
| `npm run build` | Build for production |
| `npm run start` | Start production server |
| `npm run lint` | Run ESLint |

## 🔌 API Routes

### Compliance Module Routes
- `GET/POST /api/compliance` - Compliance document management
- `GET /api/logistics/[id]` - Order logistics/shipping information

### Existing Routes
- `GET/POST /api/orders` - Order management
- `POST /api/payments` - Payment processing
- `POST /api/scrape` - Data scraping trigger
- `GET /api/sync-stations` - Charging station sync

## 🗄️ Database Schema

### Core Tables
- `profiles` - User profiles
- `manufacturers` - Verified manufacturers
- `vehicles` - EV/PHEV inventory
- `orders` - Order management
- `order_status_history` - Order tracking
- `charging_stations` - Charging infrastructure
- `vehicle_inquiries` - Buyer inquiries

### Compliance Tables (Mock/Planning)
- `fahes_inspections` - Inspection records
- `import_permits` - Permit applications
- `customs_declarations` - Customs documentation
- `compliance_documents` - Document storage

## 🧪 Testing

The application includes comprehensive TypeScript type checking. Run:
```bash
npm run build  # Validates types and builds
```

## 📱 Pages Overview

| Page | Route | Description |
|------|-------|-------------|
| Landing | `/` | ✨ Updated landing page |
| Marketplace | `/marketplace` | Browse EV vehicles |
| Charging | `/charging` | Find charging stations |
| Compliance | `/compliance` | ✨ NEW: Module 2 compliance |
| Orders | `/orders` | Track orders |
| Dashboard | `/dashboard` | User dashboard |
| Admin | `/dashboard/admin` | Admin panel |

## 🔧 Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Next.js 14 (App Router) |
| Language | TypeScript |
| Database | Supabase (PostgreSQL) |
| Styling | Tailwind CSS |
| UI Components | Radix UI primitives |
| State | React Context, Custom Hooks |
| Maps | Leaflet (OpenStreetMap) |
| File Upload | react-dropzone |
| Auth | Supabase Auth |
| Forms | React Hook Form + Zod |

## 🌐 Deployment

### Production Build
```bash
npm run build
npm run start
```

### Environment Variables for Production
Ensure all environment variables are set in your production environment.

### Recommended Hosting
- Vercel (recommended for Next.js)
- AWS Amplify
- Google Cloud Run
- DigitalOcean App Platform

## 📋 Module 2 Status

| Feature | Status | Notes |
|---------|--------|-------|
| FAHES Inspection Flow | ✅ Complete | Frontend with mock data |
| Document Upload System | ✅ Complete | Full drag-and-drop support |
| Customs Documentation | ✅ Complete | Auto-generation with duty calc |
| Import Permit Automation | ✅ Complete | Multi-step application flow |
| Shipping Details Tracking | ✅ Complete | Real-time tracking UI |
| Compliance Dashboard | ✅ Complete | Overview with all features |

**Note**: All Module 2 features are frontend implementations with mock data. Real API integration with:
- FAHES/KAHRAMAA (requires official API access)
- Qatar Customs (requires government partnership)
- Ministry of Commerce (requires authentication)
- Hamad Port (requires port authority integration)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## 📄 License

ISC

## 👥 Team

- Mohammed Hassan - Project Lead
- Abid Farhan - System Architecture
- Khalid Al-Haj - Market Research
- Abdul Razaq - Regulations
- Mohammed Rehman - GCC Logistics

---

**QEV Hub** - Electrifying Qatar, One Connection at a Time ⚡
