import 'package:freezed_annotation/freezed_annotation.dart';

part 'charging_station.freezed.dart';
part 'charging_station.g.dart';

/// Charging station model matching Supabase table
@freezed
class ChargingStation with _$ChargingStation {
  const factory ChargingStation({
    required String id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'charger_type') String? chargerType,
    @JsonKey(name: 'total_chargers') int? totalChargers,
    @JsonKey(name: 'available_chargers') int? availableChargers,
    @JsonKey(name: 'power_output_kw') double? powerOutputKw,
    @JsonKey(name: 'status') String? status, // 'active' or other
    @JsonKey(name: 'amenities') List<String>? amenities,
    @JsonKey(name: 'pricing_info') String? pricingInfo,
    @JsonKey(name: 'operating_hours') String? operatingHours,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'website_url') String? websiteUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'distance_km') double? distanceKm,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ChargingStation;

  factory ChargingStation.fromJson(Map<String, dynamic> json) => _$ChargingStationFromJson(json);
}

/// Station filter model
@freezed
class StationFilter with _$StationFilter {
  const factory StationFilter({
    String? status,
    bool? availableOnly,
    bool? nearbyOnly,
    double? maxDistanceKm,
    String? searchQuery,
  }) = _StationFilter;

  factory StationFilter.fromJson(Map<String, dynamic> json) => _$StationFilterFromJson(json);
}

/// Station list result
@freezed
class StationListResult with _$StationListResult {
  const factory StationListResult({
    required List<ChargingStation> stations,
    required int totalCount,
    bool? hasMore,
  }) = _StationListResult;

  factory StationListResult.fromJson(Map<String, dynamic> json) => _$StationListResultFromJson(json);
}
