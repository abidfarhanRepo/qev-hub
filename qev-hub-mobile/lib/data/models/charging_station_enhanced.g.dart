// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charging_station_enhanced.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargingStationEnhancedImpl _$$ChargingStationEnhancedImplFromJson(
  Map<String, dynamic> json,
) => _$ChargingStationEnhancedImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  operator: json['operator'] as String?,
  area: json['area'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  chargerTypes: (json['charger_types'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  totalChargers: (json['total_chargers'] as num?)?.toInt(),
  availableChargers: (json['available_chargers'] as num?)?.toInt(),
  powerOutputKw: (json['power_output_kw'] as num?)?.toDouble(),
  amenities: (json['amenities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  operatingHours: json['operating_hours'] as String?,
  status: json['status'] as String?,
  pricingInfo: json['pricing_info'] as String?,
  phoneNumber: json['phone_number'] as String?,
  websiteUrl: json['website_url'] as String?,
  imageUrl: json['image_url'] as String?,
  distanceKm: (json['distance_km'] as num?)?.toDouble(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$ChargingStationEnhancedImplToJson(
  _$ChargingStationEnhancedImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'operator': instance.operator,
  'area': instance.area,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'charger_types': instance.chargerTypes,
  'total_chargers': instance.totalChargers,
  'available_chargers': instance.availableChargers,
  'power_output_kw': instance.powerOutputKw,
  'amenities': instance.amenities,
  'operating_hours': instance.operatingHours,
  'status': instance.status,
  'pricing_info': instance.pricingInfo,
  'phone_number': instance.phoneNumber,
  'website_url': instance.websiteUrl,
  'image_url': instance.imageUrl,
  'distance_km': instance.distanceKm,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
