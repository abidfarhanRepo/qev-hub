// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      id: json['id'] as String,
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      make: json['make'] as String,
      year: (json['year'] as num).toInt(),
      range: (json['range'] as num?)?.toInt(),
      batteryCapacity: (json['battery_capacity'] as num?)?.toDouble(),
      batteryKwh: (json['battery_kwh'] as num?)?.toDouble(),
      price: (json['price'] as num).toDouble(),
      priceQar: (json['price_qar'] as num?)?.toDouble(),
      manufacturerId: json['manufacturer_id'] as String?,
      manufacturerDirectPrice: (json['manufacturer_direct_price'] as num?)
          ?.toDouble(),
      brokerMarketPrice: (json['broker_market_price'] as num?)?.toDouble(),
      greyMarketPrice: (json['grey_market_price'] as num?)?.toDouble(),
      priceTransparencyEnabled: json['price_transparency_enabled'] as bool?,
      vehicleType: _$JsonConverterFromJson<String, VehicleType>(
        json['vehicle_type'],
        const VehicleTypeConverter().fromJson,
      ),
      originCountry: json['origin_country'] as String?,
      warrantyYears: (json['warranty_years'] as num?)?.toInt(),
      warrantyKm: (json['warranty_km'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      specs: json['specs'] as Map<String, dynamic>?,
      stockCount: (json['stock_count'] as num?)?.toInt(),
      availability: _$JsonConverterFromJson<String, AvailabilityStatus>(
        json['availability'],
        const AvailabilityStatusConverter().fromJson,
      ),
      status: json['status'] as String?,
      chargingTime: json['charging_time'] as String?,
      topSpeed: (json['top_speed'] as num?)?.toInt(),
      acceleration: json['acceleration'] as String?,
      seatingCapacity: (json['seating_capacity'] as num?)?.toInt(),
      cargoSpace: (json['cargo_space'] as num?)?.toInt(),
      videoUrl: json['video_url'] as String?,
      brochureUrl: json['brochure_url'] as String?,
      greyMarketSource: json['grey_market_source'] as String?,
      greyMarketUpdatedAt: json['grey_market_updated_at'] == null
          ? null
          : DateTime.parse(json['grey_market_updated_at'] as String),
      greyMarketUrl: json['grey_market_url'] as String?,
      savingsPercentage: (json['savings_percentage'] as num?)?.toDouble(),
      savingsAmount: (json['savings_amount'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'make': instance.make,
      'year': instance.year,
      'range': instance.range,
      'battery_capacity': instance.batteryCapacity,
      'battery_kwh': instance.batteryKwh,
      'price': instance.price,
      'price_qar': instance.priceQar,
      'manufacturer_id': instance.manufacturerId,
      'manufacturer_direct_price': instance.manufacturerDirectPrice,
      'broker_market_price': instance.brokerMarketPrice,
      'grey_market_price': instance.greyMarketPrice,
      'price_transparency_enabled': instance.priceTransparencyEnabled,
      'vehicle_type': _$JsonConverterToJson<String, VehicleType>(
        instance.vehicleType,
        const VehicleTypeConverter().toJson,
      ),
      'origin_country': instance.originCountry,
      'warranty_years': instance.warrantyYears,
      'warranty_km': instance.warrantyKm,
      'imageUrl': instance.imageUrl,
      'images': instance.images,
      'description': instance.description,
      'specs': instance.specs,
      'stock_count': instance.stockCount,
      'availability': _$JsonConverterToJson<String, AvailabilityStatus>(
        instance.availability,
        const AvailabilityStatusConverter().toJson,
      ),
      'status': instance.status,
      'charging_time': instance.chargingTime,
      'top_speed': instance.topSpeed,
      'acceleration': instance.acceleration,
      'seating_capacity': instance.seatingCapacity,
      'cargo_space': instance.cargoSpace,
      'video_url': instance.videoUrl,
      'brochure_url': instance.brochureUrl,
      'grey_market_source': instance.greyMarketSource,
      'grey_market_updated_at': instance.greyMarketUpdatedAt?.toIso8601String(),
      'grey_market_url': instance.greyMarketUrl,
      'savings_percentage': instance.savingsPercentage,
      'savings_amount': instance.savingsAmount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_$VehicleFilterImpl _$$VehicleFilterImplFromJson(Map<String, dynamic> json) =>
    _$VehicleFilterImpl(
      manufacturers: (json['manufacturers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vehicleTypes: (json['vehicleTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$VehicleTypeEnumMap, e))
          .toList(),
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      minRange: (json['minRange'] as num?)?.toInt(),
      minYear: (json['minYear'] as num?)?.toInt(),
      maxYear: (json['maxYear'] as num?)?.toInt(),
      inStockOnly: json['inStockOnly'] as bool?,
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$VehicleFilterImplToJson(_$VehicleFilterImpl instance) =>
    <String, dynamic>{
      'manufacturers': instance.manufacturers,
      'vehicleTypes': instance.vehicleTypes
          ?.map((e) => _$VehicleTypeEnumMap[e]!)
          .toList(),
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'minRange': instance.minRange,
      'minYear': instance.minYear,
      'maxYear': instance.maxYear,
      'inStockOnly': instance.inStockOnly,
      'searchQuery': instance.searchQuery,
    };

const _$VehicleTypeEnumMap = {
  VehicleType.ev: 'EV',
  VehicleType.phev: 'PHEV',
  VehicleType.fcev: 'FCEV',
};

_$VehicleListResultImpl _$$VehicleListResultImplFromJson(
  Map<String, dynamic> json,
) => _$VehicleListResultImpl(
  vehicles: (json['vehicles'] as List<dynamic>)
      .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  hasMore: json['hasMore'] as bool?,
);

Map<String, dynamic> _$$VehicleListResultImplToJson(
  _$VehicleListResultImpl instance,
) => <String, dynamic>{
  'vehicles': instance.vehicles,
  'totalCount': instance.totalCount,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'hasMore': instance.hasMore,
};
