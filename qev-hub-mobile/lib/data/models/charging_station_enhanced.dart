import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'charging_station_enhanced.freezed.dart';
part 'charging_station_enhanced.g.dart';

/// Enhanced charging station model with Tarsheed-style connector information
@freezed
class ChargingStationEnhanced with _$ChargingStationEnhanced {
  const factory ChargingStationEnhanced({
    required String id,
    required String name,
    required String address,
    @JsonKey(name: 'operator') String? operator,
    @JsonKey(name: 'area') String? area,
    @JsonKey(name: 'latitude') required double latitude,
    @JsonKey(name: 'longitude') required double longitude,
    @JsonKey(name: 'charger_types') List<String>? chargerTypes,
    @JsonKey(name: 'total_chargers') int? totalChargers,
    @JsonKey(name: 'available_chargers') int? availableChargers,
    @JsonKey(name: 'power_output_kw') double? powerOutputKw,
    @JsonKey(name: 'amenities') List<String>? amenities,
    @JsonKey(name: 'operating_hours') String? operatingHours,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'pricing_info') String? pricingInfo,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'website_url') String? websiteUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'distance_km') double? distanceKm,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ChargingStationEnhanced;

  factory ChargingStationEnhanced.fromJson(Map<String, dynamic> json) => 
      _$ChargingStationEnhancedFromJson(json);
}

/// Connector type enum for visual representation
enum ConnectorType {
  type2('Type 2', 'assets/icons/type2.svg'),
  ccs('CCS', 'assets/icons/ccs.svg'),
  chademo('CHAdeMO', 'assets/icons/chademo.svg'),
  tesla('Tesla', 'assets/icons/tesla.svg');

  const ConnectorType(this.displayName, this.iconPath);

  final String displayName;
  final String iconPath;

  static ConnectorType? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'type 2':
      case 'type2':
        return ConnectorType.type2;
      case 'ccs':
      case 'ccs2':
        return ConnectorType.ccs;
      case 'chademo':
        return ConnectorType.chademo;
      case 'tesla':
      case 'nacs':
        return ConnectorType.tesla;
      default:
        return null;
    }
  }

  static List<ConnectorType> fromStrings(List<String>? types) {
    if (types == null) return [];
    return types
        .map((type) => ConnectorType.fromString(type))
        .where((type) => type != null)
        .cast<ConnectorType>()
        .toList();
  }
}

/// Power level classification
enum PowerLevel {
  slow('AC', 22, Colors.green, '2-4 hours'),
  fast('DC Fast', 50, Colors.orange, '30-60 min'),
  ultrafast('Ultra Fast', 150, Colors.red, '15-30 min');

  const PowerLevel(this.displayName, this.kw, this.color, this.estimatedTime);
  
  final String displayName;
  final int kw;
  final Color color;
  final String estimatedTime;

  static PowerLevel fromKw(double? kw) {
    if (kw == null) return PowerLevel.slow;
    if (kw >= 150) return PowerLevel.ultrafast;
    if (kw >= 50) return PowerLevel.fast;
    return PowerLevel.slow;
  }
}

/// Station availability status
enum StationAvailability {
  available('Available', Colors.green, true),
  limited('Limited', Colors.orange, false),
  unavailable('Unavailable', Colors.red, false);

  const StationAvailability(this.displayName, this.color, this.isAvailable);
  
  final String displayName;
  final Color color;
  final bool isAvailable;

  static StationAvailability fromCounts(int? available, int? total) {
    if (available == null || total == null) return StationAvailability.unavailable;
    if (available == 0) return StationAvailability.unavailable;
    if (available < total! / 2) return StationAvailability.limited;
    return StationAvailability.available;
  }
}