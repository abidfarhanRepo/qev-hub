export enum UserRole {
  CONSUMER = 'consumer',
  DEALER = 'dealer',
  ADMIN = 'admin'
}

export enum OrderStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  SHIPPED = 'shipped',
  IN_CUSTOMS = 'in_customs',
  FAHES_INSPECTION = 'fahes_inspection',
  INSURANCE_PENDING = 'insurance_pending',
  DELIVERY = 'delivery',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled'
}

export enum LogisticsStage {
  FACTORY = 'factory',
  OCEAN_FREIGHT = 'ocean_freight',
  HAMAD_PORT = 'hamad_port',
  QATAR_CUSTOMS = 'qatar_customs',
  FAHES_INSPECTION = 'fahes_inspection',
  INSURANCE = 'insurance',
  DELIVERY = 'delivery'
}

export enum DocumentType {
  ID_CARD = 'id_card',
  LICENSE = 'license',
  CUSTOMS_FORM = 'customs_form',
  INSURANCE_POLICY = 'insurance_policy',
  EXPORT_DOCS = 'export_docs'
}

export enum DocumentStatus {
  PENDING = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected'
}

export enum GCCCountry {
  SAUDI_ARABIA = 'SA',
  UAE = 'AE',
  KUWAIT = 'KW',
  BAHRAIN = 'BH',
  OMAN = 'OM'
}

export interface Profile {
  id: string;
  full_name: string;
  phone?: string;
  role: UserRole;
  created_at: string;
  updated_at: string;
}

export interface Vehicle {
  id: string;
  manufacturer: string;
  model: string;
  year: number;
  range_km: number;
  charging_time_minutes: number;
  manufacturer_price_qar: number;
  estimated_broker_price_qar: number;
  arrival_time_days: number;
  specifications: VehicleSpecifications;
  images: string[];
  available: boolean;
  created_at: string;
}

export interface VehicleSpecifications {
  battery_capacity_kwh?: number;
  motor_type?: string;
  seats?: number;
  acceleration_0_100?: number;
  top_speed_kmh?: number;
  charging_standards?: string[];
  dimensions?: {
    length_mm: number;
    width_mm: number;
    height_mm: number;
  };
}

export interface Order {
  id: string;
  user_id: string;
  vehicle_id: string;
  tracking_id: string;
  status: OrderStatus;
  total_price_qar: number;
  deposit_paid: boolean;
  created_at: string;
  updated_at: string;
}

export interface OrderStatusHistory {
  id: string;
  order_id: string;
  status: OrderStatus;
  location: string;
  notes?: string;
  document_url?: string;
  created_at: string;
}

export interface Document {
  id: string;
  user_id: string;
  order_id?: string;
  document_type: DocumentType;
  file_url: string;
  status: DocumentStatus;
  uploaded_at: string;
  reviewed_at?: string;
}

export interface GCCExportRule {
  id: string;
  country_code: GCCCountry;
  rule_description: string;
  required_modifications: {
    type: string;
    description: string;
    mandatory: boolean;
  }[];
  created_at: string;
}

export interface SustainabilityMetrics {
  id: string;
  user_id: string;
  co2_saved_kg: number;
  vehicles_purchased: number;
  total_electricity_kwh: number;
  updated_at: string;
}

export interface VehicleSearchFilters {
  min_range_km?: number;
  max_range_km?: number;
  min_price_qar?: number;
  max_price_qar?: number;
  max_arrival_days?: number;
  manufacturer?: string;
  min_year?: number;
}

export interface CreateOrderRequest {
  vehicle_id: string;
  payment_method?: string;
}

export interface UpdateOrderStatusRequest {
  status: OrderStatus;
  location: string;
  notes?: string;
  document_url?: string;
}

export interface UploadDocumentRequest {
  document_type: DocumentType;
  file: File;
  order_id?: string;
}
