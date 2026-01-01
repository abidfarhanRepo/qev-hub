/**
 * Charging Station Data Provider
 * 
 * Uses Google Places API to find EV charging stations in Qatar
 */

export interface ChargingStation {
  id?: string
  name: string
  address: string
  latitude: number
  longitude: number
  provider: string
  charger_type?: string
  power_output_kw?: number
  total_chargers?: number
  available_chargers?: number
  status?: string
  operating_hours?: string
  pricing_info?: string
  amenities?: string[]
}

/**
 * Fetch charging stations using Google Places API
 * 
 * Note: This requires a Google Maps API key with Places API enabled
 * Set NEXT_PUBLIC_GOOGLE_MAPS_API_KEY in your .env.local
 */
export async function fetchChargingStations(): Promise<ChargingStation[]> {
  try {
    // For now, using mock data until Google Places API is fully integrated
    // TODO: Implement Google Places API integration
    // See: https://developers.google.com/maps/documentation/places/web-service/search-nearby
    
    const mockData: ChargingStation[] = [
      {
        name: 'KAHRAMAA EV Charging Station - Katara',
        address: 'Katara Cultural Village, Doha',
        latitude: 25.3548,
        longitude: 51.5326,
        provider: 'KAHRAMAA',
        charger_type: 'Type 2 / CCS',
        power_output_kw: 50,
        total_chargers: 4,
        available_chargers: 2,
        status: 'active',
        operating_hours: '24/7',
        pricing_info: 'Free (KAHRAMAA initiative)',
        amenities: ['Restaurant', 'WiFi', 'Restroom']
      },
      {
        name: 'KAHRAMAA EV Charging - The Pearl',
        address: 'Porto Arabia, The Pearl, Doha',
        latitude: 25.3714,
        longitude: 51.5504,
        provider: 'KAHRAMAA',
        charger_type: 'Type 2 / CHAdeMO',
        power_output_kw: 50,
        total_chargers: 2,
        available_chargers: 1,
        status: 'active',
        operating_hours: '24/7',
        pricing_info: 'Free (KAHRAMAA initiative)',
        amenities: ['Shopping', 'Dining', 'Parking']
      },
      {
        name: 'KAHRAMAA Charging Hub - Lusail',
        address: 'Lusail Boulevard, Lusail City',
        latitude: 25.4192,
        longitude: 51.4966,
        provider: 'KAHRAMAA',
        charger_type: 'Type 2 / CCS / CHAdeMO',
        power_output_kw: 150,
        total_chargers: 6,
        available_chargers: 4,
        status: 'active',
        operating_hours: '24/7',
        pricing_info: 'Free (KAHRAMAA initiative)',
        amenities: ['Mall', 'Entertainment', 'Parking', 'WiFi']
      }
    ]

    return mockData
  } catch (error) {
    console.error('Error fetching charging stations:', error)
    throw error
  }
}

/**
 * Search for EV charging stations using Google Places API
 * 
 * @param latitude - Center point latitude
 * @param longitude - Center point longitude
 * @param radius - Search radius in meters (max 50000)
 */
export async function searchNearbyChargingStations(
  latitude: number,
  longitude: number,
  radius: number = 50000
): Promise<ChargingStation[]> {
  // TODO: Implement Google Places API Nearby Search
  // https://developers.google.com/maps/documentation/places/web-service/search-nearby
  
  /*
  const apiKey = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY
  const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json`
  
  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      locationRestriction: {
        circle: {
          center: { latitude, longitude },
          radius
        }
      },
      includedTypes: ['electric_vehicle_charging_station'],
      maxResultCount: 20,
      languageCode: 'en'
    })
  })
  
  const data = await response.json()
  return transformGooglePlacesToStations(data.places)
  */
  
  return fetchChargingStations()
}

/**
 * Calculate distance between two coordinates (Haversine formula)
 */
export function calculateDistance(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const R = 6371 // Earth's radius in km
  const dLat = toRad(lat2 - lat1)
  const dLon = toRad(lon2 - lon1)
  
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2)
  
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  return R * c
}

function toRad(degrees: number): number {
  return degrees * (Math.PI / 180)
}
