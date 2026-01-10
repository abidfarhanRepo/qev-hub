// Manufacturer types and interfaces

export interface Manufacturer {
  id: string
  user_id: string
  company_name: string
  company_name_ar?: string
  logo_url?: string
  country: string
  city?: string
  region?: string
  contact_email: string
  contact_phone?: string
  website_url?: string
  description?: string
  description_ar?: string
  business_license?: string
  business_license_expiry?: string
  verification_status: 'pending' | 'verified' | 'rejected' | 'suspended'
  verified_at?: string
  verified_by?: string
  verified_documents?: string[]
  created_at: string
  updated_at: string
}

export interface ManufacturerStats {
  id: string
  manufacturer_id: string
  stat_date: string
  views_count: number
  inquiries_count: number
  orders_count: number
  created_at: string
  updated_at: string
}

export interface VehicleInquiry {
  id: string
  vehicle_id: string
  user_id?: string
  name: string
  email: string
  phone?: string
  message?: string
  status: 'pending' | 'responded' | 'closed'
  created_at: string
  updated_at: string
}

export interface ManufacturerVehicle {
  id: string
  manufacturer_id: string
  make: string
  model: string
  year: number
  vehicle_type: 'EV' | 'PHEV' | 'FCEV'
  price: number
  battery_capacity?: number
  range?: number
  charging_time?: string
  top_speed?: number
  acceleration?: string
  seating_capacity: number
  cargo_space?: number
  availability: 'available' | 'pre-order' | 'sold-out'
  description?: string
  warranty_years: number
  warranty_km: number
  origin_country: string
  manufacturer_direct_price?: number
  broker_market_price?: number
  price_transparency_enabled: boolean
  images?: string[]
  video_url?: string
  brochure_url?: string
  created_at: string
  updated_at: string
}

// Helper functions for manufacturers

/**
 * Format vehicle price for display
 */
export const formatVehiclePrice = (price: number, currency: string = 'QAR'): string => {
  return new Intl.NumberFormat('en-QA', {
    style: 'currency',
    currency,
    maximumFractionDigits: 0
  }).format(price)
}

/**
 * Get verification status display info
 */
export const getVerificationStatusInfo = (status: Manufacturer['verification_status']) => {
  const statusMap = {
    pending: {
      label: 'Pending Verification',
      color: 'secondary',
      description: 'Your account is under review'
    },
    verified: {
      label: 'Verified',
      color: 'success',
      description: 'Your account is verified'
    },
    rejected: {
      label: 'Rejected',
      color: 'destructive',
      description: 'Verification was rejected'
    },
    suspended: {
      label: 'Suspended',
      color: 'destructive',
      description: 'Your account has been suspended'
    }
  }

  return statusMap[status] || statusMap.pending
}

/**
 * Calculate savings percentage between direct and broker prices
 */
export const calculateSavings = (
  directPrice: number,
  brokerPrice: number
): number => {
  if (!brokerPrice || brokerPrice <= directPrice) return 0
  return Math.round(((brokerPrice - directPrice) / brokerPrice) * 100)
}

/**
 * Format vehicle type for display
 */
export const formatVehicleType = (type: ManufacturerVehicle['vehicle_type']): string => {
  const typeMap = {
    'EV': 'Battery Electric Vehicle',
    'PHEV': 'Plug-in Hybrid Electric Vehicle',
    'FCEV': 'Fuel Cell Electric Vehicle'
  }
  return typeMap[type] || type
}

/**
 * Get availability badge variant
 */
export const getAvailabilityBadge = (availability: ManufacturerVehicle['availability']) => {
  const badgeMap = {
    'available': {
      variant: 'default',
      label: 'Available'
    },
    'pre-order': {
      variant: 'secondary',
      label: 'Pre-Order'
    },
    'sold-out': {
      variant: 'outline',
      label: 'Sold Out'
    }
  }
  return badgeMap[availability] || badgeMap.available
}

/**
 * Validate vehicle form data
 */
export const validateVehicleData = (data: Partial<ManufacturerVehicle>): {
  isValid: boolean
  errors: string[]
} => {
  const errors: string[] = []

  if (!data.make?.trim()) errors.push('Make is required')
  if (!data.model?.trim()) errors.push('Model is required')
  if (!data.price || data.price <= 0) errors.push('Valid price is required')
  if (!data.year || data.year < 2020 || data.year > 2030) {
    errors.push('Year must be between 2020 and 2030')
  }
  if (data.seating_capacity && (data.seating_capacity < 2 || data.seating_capacity > 9)) {
    errors.push('Seating capacity must be between 2 and 9')
  }

  return {
    isValid: errors.length === 0,
    errors
  }
}
