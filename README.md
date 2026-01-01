# QEV-Hub

Electrifying Qatar: Optimizing Infrastructure & Supply Chain

A centralized digital ecosystem connecting Qatari consumers directly with international EV manufacturers.

---

## 🤖 For AI Agents & LLMs

If you're an AI coding assistant (Claude, GPT-4, GLM-4, DeepSeek, etc.) working on this codebase:

1. **Start Here**: Read [AI_CONTEXT.md](AI_CONTEXT.md) - Comprehensive guide for AI agents
2. **Navigate**: Use [CODEBASE_MAP.md](CODEBASE_MAP.md) - Detailed file structure and locations
3. **Reference**: Check [DOCUMENTATION.md](DOCUMENTATION.md) - Full technical documentation

These files provide structured context about:
- Database schema and RLS patterns
- Common code patterns and conventions
- How to implement features safely
- Where to find specific functionality
- Testing and debugging approaches

---

## Project Structure

```
qev-hub/
├── qev-hub-web/          # Next.js 14 web application
├── qev-hub-mobile/       # React Native mobile application
└── qev-hub-shared/       # Shared TypeScript types package
```

## Tech Stack

### Web (qev-hub-web)
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS + shadcn/ui
- **Backend**: Supabase (PostgreSQL, Auth, Storage)

### Mobile (qev-hub-mobile)
- **Framework**: React Native CLI
- **Language**: TypeScript
- **UI Library**: React Native Paper
- **Navigation**: React Navigation
- **Backend**: Supabase

### Shared (qev-hub-shared)
- **Package**: NPM package for shared types
- **Language**: TypeScript

## Getting Started

### Prerequisites

- Node.js v18 or later
- npm or yarn
- Supabase account (https://supabase.com)

### 1. Clone & Install

```bash
# Install web dependencies
cd qev-hub-web
npm install

# Install mobile dependencies
cd ../qev-hub-mobile
npm install

# Install shared package dependencies
cd ../qev-hub-shared
npm install
npm run build
```

### 2. Supabase Setup

#### Create Supabase Project

1. Go to https://supabase.com and create a new project
2. Navigate to SQL Editor
3. Run the migration scripts:
   - `qev-hub-web/supabase/migrations/001_initial_schema.sql`
   - `qev-hub-web/supabase/migrations/002_seed_data.sql`

#### Get Credentials

1. Go to Project Settings → API
2. Copy:
   - Project URL
   - anon public key

#### Configure Environment Variables

**Web (qev-hub-web/.env.local):**
```env
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

**Mobile (qev-hub-mobile/.env):**
```env
EXPO_PUBLIC_SUPABASE_URL=your-project-url
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

#### Create Storage Buckets

Go to Storage → Create buckets:
- `vehicle-images` (public)
- `user-documents` (authenticated)
- `generated-pdfs` (authenticated)

### 3. Run Applications

**Web:**
```bash
cd qev-hub-web
npm run dev
# Open http://localhost:3000
```

**Mobile:**
```bash
cd qev-hub-mobile
npm start
# Run on Android: npm run android
# Run on iOS: npm run ios
```

**Shared Types:**
```bash
cd qev-hub-shared
npm run watch  # Watch for changes
```

## Design System

### Colors

- **Qatar Maroon**: `#8A1538` (Primary)
- **Electric Cyan**: `#00FFFF` (Secondary)

### Components

- **Web**: shadcn/ui components (https://ui.shadcn.com)
- **Mobile**: React Native Paper components

## Database Schema

### Tables
- `profiles` - User profiles
- `vehicles` - EV inventory
- `orders` - Vehicle orders
- `order_status_history` - Logistics timeline
- `documents` - User documents
- `gcc_export_rules` - GCC export regulations
- `sustainability_metrics` - Environmental impact metrics

## Seed Data

The application includes seed data for:
- 18 electric vehicles (Tesla, BYD, Hyundai, Kia, BMW, Mercedes, etc.)
- GCC export rules for all 5 countries
- Realistic QAR pricing (150,000-370,000 QAR)

## Authentication

Current implementation uses mock authentication with localStorage. To enable real Supabase auth:

1. Enable Google Auth in Supabase Dashboard
2. Configure Google OAuth credentials
3. Update auth pages to use Supabase client

## Roadmap

- [x] Phase 1: Foundation Setup
- [x] Phase 2: Database & Authentication (mock)
- [ ] Phase 3: Module A - Marketplace
- [ ] Phase 4: Module B - Logistics Tracking
- [ ] Phase 5: Module C - Compliance Hub
- [ ] Phase 6: Module D - Regional Gateway
- [ ] Phase 7: Testing & Polish
- [ ] Phase 8: Beta Launch

## Project Status

**Current Phase**: Foundation Setup Complete
- ✅ Three repositories initialized
- ✅ Design system configured (Qatar Maroon + Electric Cyan)
- ✅ Shared types package created
- ✅ Database schema with seed data
- ✅ Authentication UI with mock auth

## Next Steps

1. Set up Supabase project with provided migration scripts
2. Configure environment variables
3. Test authentication flow (login/signup)
4. Begin Module A - Marketplace implementation

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

ISC
