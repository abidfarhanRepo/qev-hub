# QEV Hub Mobile App

React Native mobile application for QEV Hub - Qatar's Premier EV Marketplace.

## Features

- **Marketplace**: Browse and purchase electric vehicles directly from manufacturers
- **Order Tracking**: Track your vehicle shipment with real-time updates
- **Charging Stations**: Find nearby EV charging stations on an interactive map
- **Payments**: Secure payment processing for deposits and balances
- **User Dashboard**: View order statistics and quick actions

## Tech Stack

- React Native 0.72
- React Navigation 6
- React Native Paper (Material Design 3)
- React Native Maps
- Supabase (Auth & Database)
- TypeScript

## Project Structure

```
src/
├── config/         # Configuration files (Supabase client)
├── contexts/       # React contexts (Auth)
├── navigation/     # Navigation structure
├── screens/        # All app screens
├── services/       # API service layer
├── theme/          # Theme configuration
├── types/          # TypeScript type definitions
└── utils/          # Utility functions
```

## Setup

### Prerequisites

- Node.js 16+
- React Native CLI
- Android Studio (for Android)
- Xcode (for iOS, macOS only)

### Installation

1. Clone the repository and navigate to the mobile app:
   ```bash
   cd qev-hub-mobile
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Copy environment variables:
   ```bash
   cp .env.example .env
   ```

4. Fill in your Supabase credentials in `.env`

5. Install iOS pods (macOS only):
   ```bash
   cd ios && pod install && cd ..
   ```

### Running the App

**Android:**
```bash
npm run android
```

**iOS:**
```bash
npm run ios
```

**Start Metro bundler:**
```bash
npm start
```

## Screens

| Screen | Description |
|--------|-------------|
| Login | User authentication |
| Signup | New user registration |
| Dashboard | Home screen with stats and quick actions |
| Marketplace | Browse available EVs with filters |
| Vehicle Details | Full vehicle specifications and purchase |
| Orders | List of user's orders |
| Order Details | Order summary and payment options |
| Order Tracking | 5-stage shipment timeline |
| Payment | Card/bank payment processing |
| Charging | Map of charging stations |
| Settings | Profile and app preferences |

## API Integration

The app connects to the QEV Hub web API endpoints:

- `POST /api/orders` - Create new order
- `GET /api/orders` - Fetch user orders
- `POST /api/payments` - Process payment
- `GET /api/charging-stations` - Fetch charging stations

## Environment Variables

| Variable | Description |
|----------|-------------|
| `EXPO_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `EXPO_PUBLIC_SUPABASE_ANON_KEY` | Supabase anonymous key |
| `EXPO_PUBLIC_API_URL` | Web API base URL |
| `GOOGLE_MAPS_API_KEY` | Google Maps API key (Android) |

## Theme

The app uses QEV Hub brand colors:
- Primary: `#8A1538` (Qatar Maroon)
- Secondary: `#00FFFF` (Electric Cyan)

## Contributing

1. Create a feature branch
2. Make your changes
3. Test on both iOS and Android
4. Submit a pull request

## License

Proprietary - QEV Hub
