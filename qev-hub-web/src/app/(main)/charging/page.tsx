'use client'

import { useEffect, useState } from 'react'
import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet'
import 'leaflet/dist/leaflet.css'
import L from 'leaflet'
import { supabase } from '@/lib/supabase'
import { ChargingStation } from '@/lib/charging-data-provider'
import { Button } from '@/components/ui/button'

const dohaCenter: [number, number] = [25.3548, 51.1839]

const TILE_CONFIGS = {
  en: {
    url: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
    attribution: '&copy; <a href="https://www.esri.com/">Esri</a>, &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 17
  },
  ar: {
    url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 19
  }
}

const customMarkerIcon = (isAvailable: boolean) =>
  L.divIcon({
    className: 'custom-marker',
    html: `<div style="
      background-color: ${isAvailable ? '#00FFFF' : '#4a0d1d'};
      border: 3px solid ${isAvailable ? '#00FFFF' : '#8A1538'};
      border-radius: 50%;
      width: 32px;
      height: 32px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.3);
      display: flex;
      align-items: center;
      justify-content: center;
    ">
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="white">
        <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
      </svg>
    </div>`,
    iconSize: [32, 32],
    iconAnchor: [16, 32],
  })

const userLocationIcon = L.divIcon({
  className: 'custom-marker',
  html: `<div style="
    background-color: #E2E8F0;
    border: 3px solid #8A1538;
    border-radius: 50%;
    width: 24px;
    height: 24px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.3);
  "></div>`,
  iconSize: [24, 24],
  iconAnchor: [12, 12],
})

function MapController({ center, zoom }: { center: [number, number]; zoom: number }) {
  const map = useMap()
  useEffect(() => {
    map.setView(center, zoom)
  }, [center, zoom, map])
  return null
}

export default function ChargingPage() {
  const [stations, setStations] = useState<ChargingStation[]>([])
  const [selectedStation, setSelectedStation] = useState<ChargingStation | null>(null)
  const [loading, setLoading] = useState(true)
  const [userLocation, setUserLocation] = useState<[number, number] | null>(null)
  const [filter, setFilter] = useState<'all' | 'available' | 'nearby'>('all')
  const [mapCenter, setMapCenter] = useState<[number, number]>(dohaCenter)
  const [mapZoom, setMapZoom] = useState(12)
  const [mapLanguage, setMapLanguage] = useState<'en' | 'ar'>('en')

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
          const location: [number, number] = [
            position.coords.latitude,
            position.coords.longitude,
          ]
          setUserLocation(location)
          setMapCenter(location)
          setMapZoom(14)
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
        userLocation[0],
        userLocation[1],
        Number(station.latitude),
        Number(station.longitude)
      )
      return distance <= 10
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
      <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 relative z-10">
        <div className="mb-8">
          <h1 className="text-4xl font-black uppercase tracking-widest text-foreground mb-2">EV Charging <span className="text-primary">Stations</span></h1>
          <p className="text-muted-foreground">Find and navigate to charging stations across Qatar</p>
        </div>

        <div className="mb-6 flex flex-wrap gap-3 justify-between items-center">
          <div className="flex gap-3 flex-wrap">
            <Button
              onClick={() => setFilter('all')}
              variant={filter === 'all' ? 'default' : 'outline'}
              className="font-bold uppercase tracking-wider"
            >
              All Stations ({stations.length})
            </Button>
            <Button
              onClick={() => setFilter('available')}
              variant={filter === 'available' ? 'default' : 'outline'}
              className="font-bold uppercase tracking-wider"
            >
              Available Now
            </Button>
            <Button
              onClick={() => {
                if (userLocation) {
                  setFilter('nearby')
                  setMapCenter(userLocation)
                  setMapZoom(14)
                } else {
                  getUserLocation()
                }
              }}
              variant={filter === 'nearby' ? 'default' : 'outline'}
              className="font-bold uppercase tracking-wider"
            >
              Nearby (10km)
            </Button>
          </div>
          <Button
            onClick={() => setMapLanguage(mapLanguage === 'en' ? 'ar' : 'en')}
            variant="outline"
            className="font-bold uppercase tracking-wider"
          >
            {mapLanguage === 'en' ? 'العربية' : 'English'}
          </Button>
        </div>

        <div className="bg-card/50 border border-border backdrop-blur-sm rounded-xl shadow-lg overflow-hidden mb-8">
          <MapContainer
            center={mapCenter}
            zoom={mapZoom}
            style={{ height: '600px', width: '100%' }}
            className="z-10"
          >
            <TileLayer
              attribution={TILE_CONFIGS[mapLanguage].attribution}
              url={TILE_CONFIGS[mapLanguage].url}
              maxZoom={TILE_CONFIGS[mapLanguage].maxZoom}
            />
            <MapController center={mapCenter} zoom={mapZoom} />

            {userLocation && (
              <Marker position={userLocation} icon={userLocationIcon}>
                <Popup>Your Location</Popup>
              </Marker>
            )}

            {filteredStations.map((station) => (
              <Marker
                key={station.id}
                position={[Number(station.latitude), Number(station.longitude)]}
                icon={customMarkerIcon((station.available_chargers || 0) > 0)}
                eventHandlers={{
                  click: () => setSelectedStation(station),
                }}
              >
                <Popup>
                  <div className="p-2 min-w-[200px]">
                    <h3 className="font-bold text-lg mb-1">{station.name}</h3>
                    <p className="text-sm text-gray-600 mb-2">{station.address}</p>
                    <div className="space-y-1 text-sm mb-3">
                      <p><span className="font-medium">Type:</span> {station.charger_type}</p>
                      <p><span className="font-medium">Power:</span> {station.power_output_kw} kW</p>
                      <p><span className="font-medium">Available:</span> {station.available_chargers}/{station.total_chargers}</p>
                      <p><span className="font-medium">Pricing:</span> {station.pricing_info}</p>
                      <p><span className="font-medium">Hours:</span> {station.operating_hours}</p>
                    </div>
                    <Button
                      onClick={() => {
                        window.open(
                          `https://www.openstreetmap.org/directions?from=&to=${station.latitude},${station.longitude}`,
                          '_blank'
                        )
                      }}
                      className="w-full"
                      size="sm"
                    >
                      Get Directions
                    </Button>
                  </div>
                </Popup>
              </Marker>
            ))}
          </MapContainer>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredStations.map((station) => (
            <div
              key={station.id}
              className="glass-card tech-border p-6 hover:shadow-xl transition-all hover:-translate-y-1 cursor-pointer group"
              onClick={() => {
                setSelectedStation(station)
                setMapCenter([Number(station.latitude), Number(station.longitude)])
                setMapZoom(15)
              }}
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
