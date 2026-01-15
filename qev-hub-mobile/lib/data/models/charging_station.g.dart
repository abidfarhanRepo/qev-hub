// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charging_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargingStationImpl _$$ChargingStationImplFromJson(
  Map<String, dynamic> json,
) => _$ChargingStationImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  latitude: const StringToDoubleConverter().fromJson(json['latitude']),
  longitude: const StringToDoubleConverter().fromJson(json['longitude']),
  chargerType: json['charger_type'] as String?,
  totalChargers: (json['total_chargers'] as num?)?.toInt(),
  availableChargers: (json['available_chargers'] as num?)?.toInt(),
  powerOutputKw: (json['power_output_kw'] as num?)?.toDouble(),
  status: json['status'] as String?,
  amenities: (json['amenities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  pricingInfo: json['pricing_info'] as String?,
  operatingHours: json['operating_hours'] as String?,
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

Map<String, dynamic> _$$ChargingStationImplToJson(
  _$ChargingStationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'latitude': const StringToDoubleConverter().toJson(instance.latitude),
  'longitude': const StringToDoubleConverter().toJson(instance.longitude),
  'charger_type': instance.chargerType,
  'total_chargers': instance.totalChargers,
  'available_chargers': instance.availableChargers,
  'power_output_kw': instance.powerOutputKw,
  'status': instance.status,
  'amenities': instance.amenities,
  'pricing_info': instance.pricingInfo,
  'operating_hours': instance.operatingHours,
  'phone_number': instance.phoneNumber,
  'website_url': instance.websiteUrl,
  'image_url': instance.imageUrl,
  'distance_km': instance.distanceKm,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_$StationFilterImpl _$$StationFilterImplFromJson(Map<String, dynamic> json) =>
    _$StationFilterImpl(
      status: json['status'] as String?,
      availableOnly: json['availableOnly'] as bool?,
      nearbyOnly: json['nearbyOnly'] as bool?,
      maxDistanceKm: (json['maxDistanceKm'] as num?)?.toDouble(),
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$StationFilterImplToJson(_$StationFilterImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'availableOnly': instance.availableOnly,
      'nearbyOnly': instance.nearbyOnly,
      'maxDistanceKm': instance.maxDistanceKm,
      'searchQuery': instance.searchQuery,
    };

_$StationListResultImpl _$$StationListResultImplFromJson(
  Map<String, dynamic> json,
) => _$StationListResultImpl(
  stations: (json['stations'] as List<dynamic>)
      .map((e) => ChargingStation.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  hasMore: json['hasMore'] as bool?,
);

Map<String, dynamic> _$$StationListResultImplToJson(
  _$StationListResultImpl instance,
) => <String, dynamic>{
  'stations': instance.stations,
  'totalCount': instance.totalCount,
  'hasMore': instance.hasMore,
};
