'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'

interface Vehicle {
  id: string
  manufacturer: string
  model: string
  year: number
  range_km: number
  battery_kwh: number
  price_qar: number
  image_url: string | null
  description: string
  specs: Record<string, string>
  stock_count: number
  status: string
}

export default function MarketplacePage() {
  const [vehicles, setVehicles] = useState<Vehicle[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState<'all' | 'tesla' | 'byd'>('all')
  const [selectedVehicle, setSelectedVehicle] = useState<Vehicle | null>(null)

  useEffect(() => {
    fetchVehicles()
  }, [])

  const fetchVehicles = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('vehicles')
        .select('*')
        .eq('status', 'available')
        .order('manufacturer', { ascending: true })

      if (error) throw error
      setVehicles(data || [])
    } catch (error) {
      console.error('Error fetching vehicles:', error)
    } finally {
      setLoading(false)
    }
  }

  const filteredVehicles = vehicles.filter((vehicle) => {
    if (filter === 'tesla') return vehicle.manufacturer.toLowerCase() === 'tesla'
    if (filter === 'byd') return vehicle.manufacturer.toLowerCase() === 'byd'
    return true
  })

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR'
    }).format(price)
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            EV Marketplace
          </h1>
          <p className="text-gray-600">
            Browse and purchase electric vehicles directly from manufacturers
          </p>
        </div>

        {/* Filters */}
        <div className="mb-8 flex gap-4 flex-wrap">
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'all'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            All Vehicles ({vehicles.length})
          </button>
          <button
            onClick={() => setFilter('tesla')}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'tesla'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            Tesla
          </button>
          <button
            onClick={() => setFilter('byd')}
            className={`px-4 py-2 rounded-lg font-medium transition ${
              filter === 'byd'
                ? 'bg-primary text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            BYD
          </button>
        </div>

        {loading ? (
          <div className="flex justify-center items-center py-20">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
          </div>
        ) : filteredVehicles.length === 0 ? (
          <div className="text-center py-20">
            <p className="text-gray-600">No vehicles available</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredVehicles.map((vehicle) => (
              <div
                key={vehicle.id}
                className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition cursor-pointer"
                onClick={() => setSelectedVehicle(vehicle)}
              >
                {/* Vehicle Image Placeholder */}
                <div className="h-48 bg-gradient-to-br from-gray-100 to-gray-200 flex items-center justify-center">
                  <svg className="h-16 w-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 17a2 2 0 11-4 0 2 2 0 014 0zM19 17a2 2 0 11-4 0 2 2 0 014 0zM13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10h10zM13 16h3.586a1 1 0 00.707-.293l2.414-2.414a1 1 0 00.293-.707V16h-7z" />
                  </svg>
                </div>

                {/* Vehicle Details */}
                <div className="p-6">
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h3 className="text-xl font-bold text-gray-900">
                        {vehicle.manufacturer} {vehicle.model}
                      </h3>
                      <p className="text-sm text-gray-500">{vehicle.year}</p>
                    </div>
                    {vehicle.stock_count > 0 ? (
                      <span className="bg-green-100 text-green-800 text-xs font-medium px-2 py-1 rounded-full">
                        In Stock ({vehicle.stock_count})
                      </span>
                    ) : (
                      <span className="bg-red-100 text-red-800 text-xs font-medium px-2 py-1 rounded-full">
                        Out of Stock
                      </span>
                    )}
                  </div>

                  <p className="text-gray-600 text-sm mb-4 line-clamp-2">
                    {vehicle.description}
                  </p>

                  {/* Specs */}
                  <div className="grid grid-cols-2 gap-2 mb-4">
                    <div className="bg-gray-50 p-2 rounded">
                      <p className="text-xs text-gray-500">Range</p>
                      <p className="text-sm font-medium text-gray-900">
                        {vehicle.range_km} km
                      </p>
                    </div>
                    <div className="bg-gray-50 p-2 rounded">
                      <p className="text-xs text-gray-500">Battery</p>
                      <p className="text-sm font-medium text-gray-900">
                        {vehicle.battery_kwh} kWh
                      </p>
                    </div>
                  </div>

                  {/* Price and CTA */}
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-2xl font-bold text-primary">
                        {formatPrice(vehicle.price_qar)}
                      </p>
                      <p className="text-xs text-gray-500">Direct from manufacturer</p>
                    </div>
                    <button
                      className="bg-primary text-white px-6 py-2 rounded-lg font-medium hover:bg-primary/90 transition"
                      onClick={(e) => {
                        e.stopPropagation()
                        window.location.href = `/orders?vehicle_id=${vehicle.id}`
                      }}
                    >
                      Purchase
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Vehicle Detail Modal */}
        {selectedVehicle && (
          <div
            className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
            onClick={() => setSelectedVehicle(null)}
          >
            <div
              className="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="h-64 bg-gradient-to-br from-gray-100 to-gray-200 flex items-center justify-center">
                <svg className="h-24 w-24 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 17a2 2 0 11-4 0 2 2 0 014 0zM19 17a2 2 0 11-4 0 2 2 0 014 0zM13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10h10zM13 16h3.586a1 1 0 00.707-.293l2.414-2.414a1 1 0 00.293-.707V16h-7z" />
                </svg>
              </div>
              <div className="p-8">
                <div className="flex justify-between items-start mb-4">
                  <div>
                    <h2 className="text-3xl font-bold text-gray-900 mb-2">
                      {selectedVehicle.manufacturer} {selectedVehicle.model}
                    </h2>
                    <p className="text-gray-600">{selectedVehicle.description}</p>
                  </div>
                  <button
                    onClick={() => setSelectedVehicle(null)}
                    className="text-gray-400 hover:text-gray-600 text-2xl"
                  >
                    ×
                  </button>
                </div>

                {/* Specifications */}
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                  <div className="bg-gray-50 p-4 rounded-lg">
                    <p className="text-sm text-gray-500 mb-1">Range</p>
                    <p className="text-xl font-bold text-gray-900">
                      {selectedVehicle.range_km} km
                    </p>
                  </div>
                  <div className="bg-gray-50 p-4 rounded-lg">
                    <p className="text-sm text-gray-500 mb-1">Battery</p>
                    <p className="text-xl font-bold text-gray-900">
                      {selectedVehicle.battery_kwh} kWh
                    </p>
                  </div>
                  <div className="bg-gray-50 p-4 rounded-lg">
                    <p className="text-sm text-gray-500 mb-1">Year</p>
                    <p className="text-xl font-bold text-gray-900">
                      {selectedVehicle.year}
                    </p>
                  </div>
                  <div className="bg-gray-50 p-4 rounded-lg">
                    <p className="text-sm text-gray-500 mb-1">Stock</p>
                    <p className="text-xl font-bold text-gray-900">
                      {selectedVehicle.stock_count}
                    </p>
                  </div>
                </div>

                {/* Price and Actions */}
                <div className="flex items-center justify-between pt-6 border-t">
                  <div>
                    <p className="text-sm text-gray-500">Total Price</p>
                    <p className="text-4xl font-bold text-primary">
                      {formatPrice(selectedVehicle.price_qar)}
                    </p>
                    <p className="text-sm text-gray-600">
                      Save 30-40% by buying direct
                    </p>
                  </div>
                  <div className="flex gap-4">
                    <button
                      className="px-6 py-3 border border-gray-300 rounded-lg font-medium hover:bg-gray-50 transition"
                      onClick={() => setSelectedVehicle(null)}
                    >
                      Close
                    </button>
                    <button
                      className="bg-primary text-white px-6 py-3 rounded-lg font-medium hover:bg-primary/90 transition"
                      onClick={() => {
                        window.location.href = `/orders?vehicle_id=${selectedVehicle.id}`
                      }}
                    >
                      Purchase Now
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
