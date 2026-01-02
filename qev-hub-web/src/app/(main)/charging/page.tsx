'use client'

import { useEffect, useState } from 'react'
import { GoogleMap, LoadScript, Marker, InfoWindow } from '@react-google-maps/api'
import { supabase } from '@/lib/supabase'
import { ChargingStation } from '@/lib/charging-data-provider'

const mapContainerStyle = {
  width: '100%',
  height: '600px',
}

const center = {
  lat: 25.3548, // Doha, Qatar
  lng: 51.1839,
}

export default function ChargingPage() {
  const [stations, setStations] = useState<ChargingStation[]>([])
  const [selectedStation, setSelectedStation] = useState<ChargingStation | null>(null)
  const [loading, setLoading] = useState(true)
  const [userLocation, setUserLocation] = useState<{ lat: number; lng: number } | null>(null)
  const [filter, setFilter] = useState<'all' | 'available' | 'nearby'>('all')

  useEffect(() => {
    fetchChargingStations()
    getUserLocation()
  }, [])

  const fetchChargingStations = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('charging_stations')
        .select('*')
        .eq('status', 'active')
        .order('name')

      if (error) throw error
      setStations(data || [])
    } catch (error) {
      console.error('Error fetching charging stations:', error)
    } finally {
      setLoading(false)
    }
  }

  const getUserLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setUserLocation({
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          })
        },
        (error) => {
          console.error('Error getting user location:', error)
        }
      )
    }
  }

  const calculateDistance = (lat1: number, lon1: number, lat2: number, lon2: number) => {
    const R = 6371
    const dLat = toRad(lat2 - lat1)
    const dLon = toRad(lon2 - lon1)
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2)
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    return R * c
  }

  const toRad = (degrees: number) => degrees * (Math.PI / 180)

  const filteredStations = stations.filter((station) => {
    if (filter === 'available') {
      return (station.available_chargers || 0) > 0
    }
    if (filter === 'nearby' && userLocation) {
      const distance = calculateDistance(
        userLocation.lat,
        userLocation.lng,
        Number(station.latitude),
        Number(station.longitude)
      )
      return distance <= 10 // Within 10km
    }
    return true
  })

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
          <p className="mt-4 text-muted-foreground">Loading charging stations...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 relative z-10">
        <div className="mb-8">
          <h1 className="text-4xl font-black uppercase tracking-widest text-foreground mb-2">EV Charging <span className="text-primary">Stations</span></h1>
          <p className="text-muted-foreground">Find and navigate to charging stations across Qatar</p>
        </div>

        <div className="mb-6 flex gap-3 flex-wrap">
          <button
            onClick={() => setFilter('all')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'all'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">All Stations ({stations.length})</span>
          </button>
          <button
            onClick={() => setFilter('available')}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'available'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">Available Now</span>
          </button>
          <button
            onClick={() => setFilter('nearby')}
            disabled={!userLocation}
            className={`px-6 py-2.5 rounded-none skew-x-[-10deg] font-bold uppercase tracking-wider transition-all ${
              filter === 'nearby'
                ? 'bg-primary text-primary-foreground shadow-lg'
                : 'bg-muted/20 text-muted-foreground hover:bg-muted/40 border border-border hover:border-primary/50 disabled:opacity-50 disabled:cursor-not-allowed'
            }`}
          >
            <span className="skew-x-[10deg] inline-block">Nearby (10km)</span>
          </button>
        </div>

        <div className="bg-card/50 border border-border backdrop-blur-sm rounded-xl shadow-lg overflow-hidden mb-8">
          <LoadScript googleMapsApiKey={process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || ''}>
            <GoogleMap
              mapContainerStyle={mapContainerStyle}
              center={userLocation || center}
              zoom={12}
              options={{
                styles: [
                  { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
                  { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
                  { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
                  {
                    featureType: "administrative.locality",
                    elementType: "labels.text.fill",
                    stylers: [{ color: "#d59563" }],
                  },
                  {
                    featureType: "poi",
                    elementType: "labels.text.fill",
                    stylers: [{ color: "#d59563" }],
                  },
                  {
                    featureType: "poi.park",
                    elementType: "geometry",
                    stylers: [{ color: "#263c3f" }],
                  },
                  {
                    featureType: "poi.park",
                    elementType: "labels.text.fill",
                    stylers: [{ color: "#6b9a76" }],
                  },
                  {
                    featureType: "road",
                    elementType: "geometry",
                    stylers: [{ color: "#38414e" }],
                  },
                  {
                    featureType: "road",
                    elementType: "geometry.stroke",
                    stylers: [{ color: "#212a37" }],
                  },
                  {
                    featureType: "road",
                    elementType: "labels.text.fill",
                    stylers: [{ color: "#9ca5b3" }],
                  },
                  {
                    featureType: "road.highway",
                    elementType: "geometry",
                    stylers: [{ color: "#746855" }],
                  },
                  {
                    featureType: "road.highway",
                    elementType: "geometry.stroke",
                    stylers: [{ color: "#1f2835" }],
                  },
                  {
                    featureType: "road.highway",
                    elementType: "labels.text.fill",
                    stylers: [{ color: "#f3d19c" }],
                  },
                  {
                    featureType: "transit",
                    elementType: "geometry",
                    stylers: [{ color: "#2f3948" }],
                  },
                  {
                    featureType: "transit.station",
                    elementType: "labels.text.fill",
                    stylers: [{ color: "#d59563" }],
                  },
                  {
                    featureType: "water",
                    elementType: "geometry",
                    stylers: [{ color: "#17263c" }],
                  },
                  {
                    featureType: "water",
                    elementType: "labels.text.fill",
                    stylers: [{ color: "#515c6d" }],
                  },
                  {
                    featureType: "water",
                    elementType: "labels.text.stroke",
                    stylers: [{ color: "#17263c" }],
                  },
                ]
              }}
            >
              {userLocation && (
                <Marker
                  position={userLocation}
                  icon={{
                    url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(
                      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#E2E8F0"><circle cx="12" cy="12" r="8"/></svg>'
                    ),
                  }}
                />
              )}

              {filteredStations.map((station) => (
                <Marker
                  key={station.id}
                  position={{
                    lat: Number(station.latitude),
                    lng: Number(station.longitude),
                  }}
                  onClick={() => setSelectedStation(station)}
                  icon={{
                    url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(
                      `<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="${
                        (station.available_chargers || 0) > 0 ? '#E2E8F0' : '#4a0d1d'
                      }"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>`
                    ),
                  }}
                />
              ))}

              {selectedStation && (
                <InfoWindow
                  position={{
                    lat: Number(selectedStation.latitude),
                    lng: Number(selectedStation.longitude),
                  }}
                  onCloseClick={() => setSelectedStation(null)}
                >
                  <div className="p-3 max-w-xs text-black">
                    <h3 className="font-bold text-lg mb-2">{selectedStation.name}</h3>
                    <p className="text-sm text-gray-600 mb-3">{selectedStation.address}</p>
                    <div className="space-y-1.5 text-sm mb-4">
                      <p>
                        <span className="font-medium">Type:</span> {selectedStation.charger_type}
                      </p>
                      <p>
                        <span className="font-medium">Power:</span> {selectedStation.power_output_kw} kW
                      </p>
                      <p>
                        <span className="font-medium">Available:</span>{' '}
                        {selectedStation.available_chargers}/{selectedStation.total_chargers}
                      </p>
                      <p>
                        <span className="font-medium">Pricing:</span> {selectedStation.pricing_info}
                      </p>
                      <p>
                        <span className="font-medium">Hours:</span> {selectedStation.operating_hours}
                      </p>
                    </div>
                    <button
                      onClick={() => {
                        window.open(
                          `https://www.google.com/maps/dir/?api=1&destination=${selectedStation.latitude},${selectedStation.longitude}`,
                          '_blank'
                        )
                      }}
                      className="mt-3 w-full gradient-primary text-white px-4 py-2.5 rounded-lg hover:opacity-90 transition font-semibold"
                    >
                      Get Directions
                    </button>
                  </div>
                </InfoWindow>
              )}
            </GoogleMap>
          </LoadScript>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredStations.map((station) => (
            <div
              key={station.id}
              className="glass-card tech-border p-6 hover:shadow-xl transition-all hover:-translate-y-1 cursor-pointer group"
              onClick={() => setSelectedStation(station)}
            >
              <div className="flex items-start justify-between mb-3">
                <h3 className="font-bold text-lg">{station.name}</h3>
                <span
                  className={`px-2.5 py-1 rounded-full text-xs font-semibold border ${
                    (station.available_chargers || 0) > 0
                      ? 'bg-secondary/10 text-secondary-foreground border-secondary/20'
                      : 'bg-destructive/10 text-destructive-foreground border-destructive/20'
                  }`}
                >
                  {(station.available_chargers || 0) > 0 ? 'Available' : 'Full'}
                </span>
              </div>
              <p className="text-muted-foreground text-sm mb-4">{station.address}</p>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Type:</span>
                  <span className="font-medium">{station.charger_type}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Power:</span>
                  <span className="font-medium">{station.power_output_kw} kW</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Chargers:</span>
                  <span className="font-medium">
                    {station.available_chargers}/{station.total_chargers}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Pricing:</span>
                  <span className="font-medium text-primary">{station.pricing_info}</span>
                </div>
              </div>
              {station.amenities && station.amenities.length > 0 && (
                <div className="mt-4 pt-4 border-t border-border/50">
                  <p className="text-xs text-muted-foreground mb-2">Amenities:</p>
                  <div className="flex flex-wrap gap-1">
                    {station.amenities.map((amenity, idx) => (
                      <span
                        key={idx}
                        className="px-2 py-1 bg-muted/50 text-foreground rounded text-xs border border-border/50"
                      >
                        {amenity}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>

        {filteredStations.length === 0 && (
          <div className="text-center py-12">
            <p className="text-muted-foreground">No charging stations found matching your criteria.</p>
          </div>
        )}
      </div>
    </div>
  )
}
