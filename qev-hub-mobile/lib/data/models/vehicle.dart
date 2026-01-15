import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

/// Vehicle type enum
enum VehicleType {
  @JsonValue('EV')
  ev,
  @JsonValue('PHEV')
  phev,
  @JsonValue('FCEV')
  fcev,
}

/// Vehicle type converter for JSON serialization
class VehicleTypeConverter implements JsonConverter<VehicleType, String?> {
  const VehicleTypeConverter();

  @override
  VehicleType fromJson(String? json) {
    if (json == null) return VehicleType.ev;
    return VehicleType.values.firstWhere(
      (e) => e.name.toUpperCase() == json.toUpperCase(),
      orElse: () => VehicleType.ev,
    );
  }

  @override
  String? toJson(VehicleType? object) {
    if (object == null) return null;
    return object.name.toUpperCase();
  }
}

/// Availability status enum
enum AvailabilityStatus {
  @JsonValue('available')
  available,
  @JsonValue('pre-order')
  preOrder,
  @JsonValue('sold-out')
  soldOut,
}

/// Availability status converter
class AvailabilityStatusConverter implements JsonConverter<AvailabilityStatus, String?> {
  const AvailabilityStatusConverter();

  @override
  AvailabilityStatus fromJson(String? json) {
    if (json == null) return AvailabilityStatus.available;
    return AvailabilityStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase().replaceAll('-', ''),
      orElse: () => AvailabilityStatus.available,
    );
  }

  @override
  String? toJson(AvailabilityStatus? object) {
    if (object == null) return null;
    return object.name.toLowerCase().replaceAll('_', '-');
  }
}

/// Vehicle model representing an electric vehicle
@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    required String manufacturer,
    required String model,
    required String make,
    required int year,
    int? range,
    @JsonKey(name: 'battery_capacity') double? batteryCapacity,
    @JsonKey(name: 'battery_kwh') double? batteryKwh,
    required double price,
    @JsonKey(name: 'price_qar') double? priceQar,
    @JsonKey(name: 'manufacturer_id') String? manufacturerId,
    @JsonKey(name: 'manufacturer_direct_price') double? manufacturerDirectPrice,
    @JsonKey(name: 'broker_market_price') double? brokerMarketPrice,
    @JsonKey(name: 'grey_market_price') double? greyMarketPrice,
    @JsonKey(name: 'price_transparency_enabled') @JsonKey(name: 'price_transparency_enabled') bool? priceTransparencyEnabled,
    @VehicleTypeConverter() @JsonKey(name: 'vehicle_type') VehicleType? vehicleType,
    @JsonKey(name: 'origin_country') String? originCountry,
    @JsonKey(name: 'warranty_years') int? warrantyYears,
    @JsonKey(name: 'warranty_km') int? warrantyKm,
    @JsonKey(name: 'image_url') String? imageUrl,
    List<String>? images,
    String? description,
    Map<String, dynamic>? specs,
    @JsonKey(name: 'stock_count') int? stockCount,
    @AvailabilityStatusConverter() @JsonKey(name: 'availability') AvailabilityStatus? availability,
    String? status,
    @JsonKey(name: 'charging_time') String? chargingTime,
    @JsonKey(name: 'top_speed') int? topSpeed,
    String? acceleration,
    @JsonKey(name: 'seating_capacity') int? seatingCapacity,
    @JsonKey(name: 'cargo_space') int? cargoSpace,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'brochure_url') String? brochureUrl,
    @JsonKey(name: 'grey_market_source') String? greyMarketSource,
    @JsonKey(name: 'grey_market_updated_at') DateTime? greyMarketUpdatedAt,
    @JsonKey(name: 'grey_market_url') String? greyMarketUrl,
    @JsonKey(name: 'savings_percentage') double? savingsPercentage,
    @JsonKey(name: 'savings_amount') double? savingsAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
}

/// Vehicle filter model for search and filtering
@freezed
class VehicleFilter with _$VehicleFilter {
  const factory VehicleFilter({
    List<String>? manufacturers,
    List<VehicleType>? vehicleTypes,
    double? minPrice,
    double? maxPrice,
    int? minRange,
    int? minYear,
    int? maxYear,
    bool? inStockOnly,
    String? searchQuery,
  }) = _VehicleFilter;

  factory VehicleFilter.fromJson(Map<String, dynamic> json) => _$VehicleFilterFromJson(json);
}

/// Vehicle list result with pagination
@freezed
class VehicleListResult with _$VehicleListResult {
  const factory VehicleListResult({
    required List<Vehicle> vehicles,
    required int totalCount,
    required int page,
    required int pageSize,
    bool? hasMore,
  }) = _VehicleListResult;

  factory VehicleListResult.fromJson(Map<String, dynamic> json) => _$VehicleListResultFromJson(json);
}
