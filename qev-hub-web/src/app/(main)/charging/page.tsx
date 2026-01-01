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
          <p className="mt-4 text-gray-600">Loading charging stations...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">EV Charging Stations</h1>
          <p className="text-gray-600">Find and navigate to charging stations across Qatar</p>
        </div>

        {/* Filters */}
        <div className="mb-6 flex gap-4">
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'all'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            All Stations ({stations.length})
          </button>
          <button
            onClick={() => setFilter('available')}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'available'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            Available Now
          </button>
          <button
            onClick={() => setFilter('nearby')}
            disabled={!userLocation}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'nearby'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100 disabled:opacity-50'
            }`}
          >
            Nearby (10km)
          </button>
        </div>

        {/* Map */}
        <div className="bg-white rounded-lg shadow-lg overflow-hidden mb-8">
          <LoadScript googleMapsApiKey={process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || ''}>
            <GoogleMap
              mapContainerStyle={mapContainerStyle}
              center={userLocation || center}
              zoom={12}
            >
              {/* User location marker */}
              {userLocation && (
                <Marker
                  position={userLocation}
                  icon={{
                    url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(
                      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="blue"><circle cx="12" cy="12" r="8"/></svg>'
                    ),
                  }}
                />
              )}

              {/* Station markers */}
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
                        (station.available_chargers || 0) > 0 ? '#10b981' : '#ef4444'
                      }"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>`
                    ),
                  }}
                />
              ))}

              {/* Info window */}
              {selectedStation && (
                <InfoWindow
                  position={{
                    lat: Number(selectedStation.latitude),
                    lng: Number(selectedStation.longitude),
                  }}
                  onCloseClick={() => setSelectedStation(null)}
                >
                  <div className="p-2 max-w-xs">
                    <h3 className="font-bold text-lg mb-2">{selectedStation.name}</h3>
                    <p className="text-sm text-gray-600 mb-2">{selectedStation.address}</p>
                    <div className="space-y-1 text-sm">
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
                      className="mt-3 w-full bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary-dark transition"
                    >
                      Get Directions
                    </button>
                  </div>
                </InfoWindow>
              )}
            </GoogleMap>
          </LoadScript>
        </div>

        {/* Station List */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredStations.map((station) => (
            <div
              key={station.id}
              className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition cursor-pointer"
              onClick={() => setSelectedStation(station)}
            >
              <div className="flex items-start justify-between mb-3">
                <h3 className="font-bold text-lg">{station.name}</h3>
                <span
                  className={`px-2 py-1 rounded-full text-xs font-medium ${
                    (station.available_chargers || 0) > 0
                      ? 'bg-green-100 text-green-800'
                      : 'bg-red-100 text-red-800'
                  }`}
                >
                  {(station.available_chargers || 0) > 0 ? 'Available' : 'Full'}
                </span>
              </div>
              <p className="text-gray-600 text-sm mb-4">{station.address}</p>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-500">Type:</span>
                  <span className="font-medium">{station.charger_type}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Power:</span>
                  <span className="font-medium">{station.power_output_kw} kW</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Chargers:</span>
                  <span className="font-medium">
                    {station.available_chargers}/{station.total_chargers}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Pricing:</span>
                  <span className="font-medium text-green-600">{station.pricing_info}</span>
                </div>
              </div>
              {station.amenities && station.amenities.length > 0 && (
                <div className="mt-4 pt-4 border-t">
                  <p className="text-xs text-gray-500 mb-2">Amenities:</p>
                  <div className="flex flex-wrap gap-1">
                    {station.amenities.map((amenity, idx) => (
                      <span
                        key={idx}
                        className="px-2 py-1 bg-gray-100 text-gray-600 rounded text-xs"
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
            <p className="text-gray-500">No charging stations found matching your criteria.</p>
          </div>
        )}
      </div>
    </div>
  )
}
