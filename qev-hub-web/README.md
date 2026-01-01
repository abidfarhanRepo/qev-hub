# QEV Hub Web Application

Qatar Electric Vehicle Hub - Web application for EV marketplace and charging station network.

## Features

- 🚗 **EV Marketplace**: Direct purchasing from manufacturers
- ⚡ **Charging Network**: Find and navigate to charging stations with Google Maps
- 📱 **Real-time Tracking**: Order and charging session tracking
- 🗺️ **Interactive Maps**: Google Maps integration with real-time availability
- 🔄 **Data Sync**: Automated scraping from Tarsheed app

## Setup

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
- `NEXT_PUBLIC_SUPABASE_URL`: Your Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Your Supabase anonymous key
- `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY`: Your Google Maps API key

### 3. Run Database Migrations
Apply the charging stations migration:
```bash
# Using Supabase CLI
supabase db push

# Or manually
psql $DATABASE_URL -f supabase/migrations/011_charging_stations.sql
```

### 4. Initial Data Sync
Populate charging stations from Tarsheed:
```bash
npm run sync-stations
```

### 5. Start Development Server
```bash
npm run dev
```

Visit http://localhost:3000

## Project Structure

```
src/
├── app/
│   ├── (main)/
│   │   ├── charging/         # Charging stations page
│   │   ├── marketplace/      # Vehicle marketplace
│   │   └── orders/           # Order tracking
│   ├── api/
│   │   └── sync-stations/    # Station sync API
│   ├── layout.tsx            # Root layout
│   ├── page.tsx              # Homepage
│   └── globals.css           # Global styles
├── lib/
│   ├── supabase.ts           # Supabase client
│   └── tarsheed-scraper.ts   # Tarsheed data scraper
└── services/
    └── charging-sync.ts      # Sync service
```

## Charging Stations Integration

See [CHARGING_INTEGRATION.md](./CHARGING_INTEGRATION.md) for detailed documentation on:
- Tarsheed data scraping
- Google Maps integration
- Database schema
- API endpoints
- Production deployment

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run sync-stations` - Sync charging station data

## Tech Stack

- **Framework**: Next.js 14 with App Router
- **Language**: TypeScript
- **Database**: Supabase (PostgreSQL)
- **Styling**: Tailwind CSS
- **Maps**: Google Maps JavaScript API
- **Data Scraping**: Cheerio, Axios

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

ISC
