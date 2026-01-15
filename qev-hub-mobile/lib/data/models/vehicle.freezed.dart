// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return _Vehicle.fromJson(json);
}

/// @nodoc
mixin _$Vehicle {
  String get id => throw _privateConstructorUsedError;
  String get manufacturer => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get make => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int? get range => throw _privateConstructorUsedError;
  @JsonKey(name: 'battery_capacity')
  double? get batteryCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'battery_kwh')
  double? get batteryKwh => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_qar')
  double? get priceQar => throw _privateConstructorUsedError;
  @JsonKey(name: 'manufacturer_id')
  String? get manufacturerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'manufacturer_direct_price')
  double? get manufacturerDirectPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'broker_market_price')
  double? get brokerMarketPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'grey_market_price')
  double? get greyMarketPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_transparency_enabled')
  @JsonKey(name: 'price_transparency_enabled')
  bool? get priceTransparencyEnabled => throw _privateConstructorUsedError;
  @VehicleTypeConverter()
  @JsonKey(name: 'vehicle_type')
  VehicleType? get vehicleType => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_country')
  String? get originCountry => throw _privateConstructorUsedError;
  @JsonKey(name: 'warranty_years')
  int? get warrantyYears => throw _privateConstructorUsedError;
  @JsonKey(name: 'warranty_km')
  int? get warrantyKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get specs => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_count')
  int? get stockCount => throw _privateConstructorUsedError;
  @AvailabilityStatusConverter()
  @JsonKey(name: 'availability')
  AvailabilityStatus? get availability => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'charging_time')
  String? get chargingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_speed')
  int? get topSpeed => throw _privateConstructorUsedError;
  String? get acceleration => throw _privateConstructorUsedError;
  @JsonKey(name: 'seating_capacity')
  int? get seatingCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'cargo_space')
  int? get cargoSpace => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'brochure_url')
  String? get brochureUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'grey_market_source')
  String? get greyMarketSource => throw _privateConstructorUsedError;
  @JsonKey(name: 'grey_market_updated_at')
  DateTime? get greyMarketUpdatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'grey_market_url')
  String? get greyMarketUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'savings_percentage')
  double? get savingsPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'savings_amount')
  double? get savingsAmount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleCopyWith<Vehicle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleCopyWith<$Res> {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) then) =
      _$VehicleCopyWithImpl<$Res, Vehicle>;
  @useResult
  $Res call({
    String id,
    String manufacturer,
    String model,
    String make,
    int year,
    int? range,
    @JsonKey(name: 'battery_capacity') double? batteryCapacity,
    @JsonKey(name: 'battery_kwh') double? batteryKwh,
    double price,
    @JsonKey(name: 'price_qar') double? priceQar,
    @JsonKey(name: 'manufacturer_id') String? manufacturerId,
    @JsonKey(name: 'manufacturer_direct_price') double? manufacturerDirectPrice,
    @JsonKey(name: 'broker_market_price') double? brokerMarketPrice,
    @JsonKey(name: 'grey_market_price') double? greyMarketPrice,
    @JsonKey(name: 'price_transparency_enabled')
    @JsonKey(name: 'price_transparency_enabled')
    bool? priceTransparencyEnabled,
    @VehicleTypeConverter()
    @JsonKey(name: 'vehicle_type')
    VehicleType? vehicleType,
    @JsonKey(name: 'origin_country') String? originCountry,
    @JsonKey(name: 'warranty_years') int? warrantyYears,
    @JsonKey(name: 'warranty_km') int? warrantyKm,
    @JsonKey(name: 'image_url') String? imageUrl,
    List<String>? images,
    String? description,
    Map<String, dynamic>? specs,
    @JsonKey(name: 'stock_count') int? stockCount,
    @AvailabilityStatusConverter()
    @JsonKey(name: 'availability')
    AvailabilityStatus? availability,
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
  });
}

/// @nodoc
class _$VehicleCopyWithImpl<$Res, $Val extends Vehicle>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? manufacturer = null,
    Object? model = null,
    Object? make = null,
    Object? year = null,
    Object? range = freezed,
    Object? batteryCapacity = freezed,
    Object? batteryKwh = freezed,
    Object? price = null,
    Object? priceQar = freezed,
    Object? manufacturerId = freezed,
    Object? manufacturerDirectPrice = freezed,
    Object? brokerMarketPrice = freezed,
    Object? greyMarketPrice = freezed,
    Object? priceTransparencyEnabled = freezed,
    Object? vehicleType = freezed,
    Object? originCountry = freezed,
    Object? warrantyYears = freezed,
    Object? warrantyKm = freezed,
    Object? imageUrl = freezed,
    Object? images = freezed,
    Object? description = freezed,
    Object? specs = freezed,
    Object? stockCount = freezed,
    Object? availability = freezed,
    Object? status = freezed,
    Object? chargingTime = freezed,
    Object? topSpeed = freezed,
    Object? acceleration = freezed,
    Object? seatingCapacity = freezed,
    Object? cargoSpace = freezed,
    Object? videoUrl = freezed,
    Object? brochureUrl = freezed,
    Object? greyMarketSource = freezed,
    Object? greyMarketUpdatedAt = freezed,
    Object? greyMarketUrl = freezed,
    Object? savingsPercentage = freezed,
    Object? savingsAmount = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            manufacturer: null == manufacturer
                ? _value.manufacturer
                : manufacturer // ignore: cast_nullable_to_non_nullable
                      as String,
            model: null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String,
            make: null == make
                ? _value.make
                : make // ignore: cast_nullable_to_non_nullable
                      as String,
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
            range: freezed == range
                ? _value.range
                : range // ignore: cast_nullable_to_non_nullable
                      as int?,
            batteryCapacity: freezed == batteryCapacity
                ? _value.batteryCapacity
                : batteryCapacity // ignore: cast_nullable_to_non_nullable
                      as double?,
            batteryKwh: freezed == batteryKwh
                ? _value.batteryKwh
                : batteryKwh // ignore: cast_nullable_to_non_nullable
                      as double?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            priceQar: freezed == priceQar
                ? _value.priceQar
                : priceQar // ignore: cast_nullable_to_non_nullable
                      as double?,
            manufacturerId: freezed == manufacturerId
                ? _value.manufacturerId
                : manufacturerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            manufacturerDirectPrice: freezed == manufacturerDirectPrice
                ? _value.manufacturerDirectPrice
                : manufacturerDirectPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            brokerMarketPrice: freezed == brokerMarketPrice
                ? _value.brokerMarketPrice
                : brokerMarketPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            greyMarketPrice: freezed == greyMarketPrice
                ? _value.greyMarketPrice
                : greyMarketPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            priceTransparencyEnabled: freezed == priceTransparencyEnabled
                ? _value.priceTransparencyEnabled
                : priceTransparencyEnabled // ignore: cast_nullable_to_non_nullable
                      as bool?,
            vehicleType: freezed == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                      as VehicleType?,
            originCountry: freezed == originCountry
                ? _value.originCountry
                : originCountry // ignore: cast_nullable_to_non_nullable
                      as String?,
            warrantyYears: freezed == warrantyYears
                ? _value.warrantyYears
                : warrantyYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            warrantyKm: freezed == warrantyKm
                ? _value.warrantyKm
                : warrantyKm // ignore: cast_nullable_to_non_nullable
                      as int?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            specs: freezed == specs
                ? _value.specs
                : specs // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            stockCount: freezed == stockCount
                ? _value.stockCount
                : stockCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            availability: freezed == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as AvailabilityStatus?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            chargingTime: freezed == chargingTime
                ? _value.chargingTime
                : chargingTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            topSpeed: freezed == topSpeed
                ? _value.topSpeed
                : topSpeed // ignore: cast_nullable_to_non_nullable
                      as int?,
            acceleration: freezed == acceleration
                ? _value.acceleration
                : acceleration // ignore: cast_nullable_to_non_nullable
                      as String?,
            seatingCapacity: freezed == seatingCapacity
                ? _value.seatingCapacity
                : seatingCapacity // ignore: cast_nullable_to_non_nullable
                      as int?,
            cargoSpace: freezed == cargoSpace
                ? _value.cargoSpace
                : cargoSpace // ignore: cast_nullable_to_non_nullable
                      as int?,
            videoUrl: freezed == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            brochureUrl: freezed == brochureUrl
                ? _value.brochureUrl
                : brochureUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            greyMarketSource: freezed == greyMarketSource
                ? _value.greyMarketSource
                : greyMarketSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            greyMarketUpdatedAt: freezed == greyMarketUpdatedAt
                ? _value.greyMarketUpdatedAt
                : greyMarketUpdatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            greyMarketUrl: freezed == greyMarketUrl
                ? _value.greyMarketUrl
                : greyMarketUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            savingsPercentage: freezed == savingsPercentage
                ? _value.savingsPercentage
                : savingsPercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
            savingsAmount: freezed == savingsAmount
                ? _value.savingsAmount
                : savingsAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleImplCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$$VehicleImplCopyWith(
    _$VehicleImpl value,
    $Res Function(_$VehicleImpl) then,
  ) = __$$VehicleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String manufacturer,
    String model,
    String make,
    int year,
    int? range,
    @JsonKey(name: 'battery_capacity') double? batteryCapacity,
    @JsonKey(name: 'battery_kwh') double? batteryKwh,
    double price,
    @JsonKey(name: 'price_qar') double? priceQar,
    @JsonKey(name: 'manufacturer_id') String? manufacturerId,
    @JsonKey(name: 'manufacturer_direct_price') double? manufacturerDirectPrice,
    @JsonKey(name: 'broker_market_price') double? brokerMarketPrice,
    @JsonKey(name: 'grey_market_price') double? greyMarketPrice,
    @JsonKey(name: 'price_transparency_enabled')
    @JsonKey(name: 'price_transparency_enabled')
    bool? priceTransparencyEnabled,
    @VehicleTypeConverter()
    @JsonKey(name: 'vehicle_type')
    VehicleType? vehicleType,
    @JsonKey(name: 'origin_country') String? originCountry,
    @JsonKey(name: 'warranty_years') int? warrantyYears,
    @JsonKey(name: 'warranty_km') int? warrantyKm,
    @JsonKey(name: 'image_url') String? imageUrl,
    List<String>? images,
    String? description,
    Map<String, dynamic>? specs,
    @JsonKey(name: 'stock_count') int? stockCount,
    @AvailabilityStatusConverter()
    @JsonKey(name: 'availability')
    AvailabilityStatus? availability,
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
  });
}

/// @nodoc
class __$$VehicleImplCopyWithImpl<$Res>
    extends _$VehicleCopyWithImpl<$Res, _$VehicleImpl>
    implements _$$VehicleImplCopyWith<$Res> {
  __$$VehicleImplCopyWithImpl(
    _$VehicleImpl _value,
    $Res Function(_$VehicleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? manufacturer = null,
    Object? model = null,
    Object? make = null,
    Object? year = null,
    Object? range = freezed,
    Object? batteryCapacity = freezed,
    Object? batteryKwh = freezed,
    Object? price = null,
    Object? priceQar = freezed,
    Object? manufacturerId = freezed,
    Object? manufacturerDirectPrice = freezed,
    Object? brokerMarketPrice = freezed,
    Object? greyMarketPrice = freezed,
    Object? priceTransparencyEnabled = freezed,
    Object? vehicleType = freezed,
    Object? originCountry = freezed,
    Object? warrantyYears = freezed,
    Object? warrantyKm = freezed,
    Object? imageUrl = freezed,
    Object? images = freezed,
    Object? description = freezed,
    Object? specs = freezed,
    Object? stockCount = freezed,
    Object? availability = freezed,
    Object? status = freezed,
    Object? chargingTime = freezed,
    Object? topSpeed = freezed,
    Object? acceleration = freezed,
    Object? seatingCapacity = freezed,
    Object? cargoSpace = freezed,
    Object? videoUrl = freezed,
    Object? brochureUrl = freezed,
    Object? greyMarketSource = freezed,
    Object? greyMarketUpdatedAt = freezed,
    Object? greyMarketUrl = freezed,
    Object? savingsPercentage = freezed,
    Object? savingsAmount = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$VehicleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        manufacturer: null == manufacturer
            ? _value.manufacturer
            : manufacturer // ignore: cast_nullable_to_non_nullable
                  as String,
        model: null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
        make: null == make
            ? _value.make
            : make // ignore: cast_nullable_to_non_nullable
                  as String,
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
        range: freezed == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as int?,
        batteryCapacity: freezed == batteryCapacity
            ? _value.batteryCapacity
            : batteryCapacity // ignore: cast_nullable_to_non_nullable
                  as double?,
        batteryKwh: freezed == batteryKwh
            ? _value.batteryKwh
            : batteryKwh // ignore: cast_nullable_to_non_nullable
                  as double?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        priceQar: freezed == priceQar
            ? _value.priceQar
            : priceQar // ignore: cast_nullable_to_non_nullable
                  as double?,
        manufacturerId: freezed == manufacturerId
            ? _value.manufacturerId
            : manufacturerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        manufacturerDirectPrice: freezed == manufacturerDirectPrice
            ? _value.manufacturerDirectPrice
            : manufacturerDirectPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        brokerMarketPrice: freezed == brokerMarketPrice
            ? _value.brokerMarketPrice
            : brokerMarketPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        greyMarketPrice: freezed == greyMarketPrice
            ? _value.greyMarketPrice
            : greyMarketPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        priceTransparencyEnabled: freezed == priceTransparencyEnabled
            ? _value.priceTransparencyEnabled
            : priceTransparencyEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        vehicleType: freezed == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as VehicleType?,
        originCountry: freezed == originCountry
            ? _value.originCountry
            : originCountry // ignore: cast_nullable_to_non_nullable
                  as String?,
        warrantyYears: freezed == warrantyYears
            ? _value.warrantyYears
            : warrantyYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        warrantyKm: freezed == warrantyKm
            ? _value.warrantyKm
            : warrantyKm // ignore: cast_nullable_to_non_nullable
                  as int?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        specs: freezed == specs
            ? _value._specs
            : specs // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        stockCount: freezed == stockCount
            ? _value.stockCount
            : stockCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        availability: freezed == availability
            ? _value.availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as AvailabilityStatus?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        chargingTime: freezed == chargingTime
            ? _value.chargingTime
            : chargingTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        topSpeed: freezed == topSpeed
            ? _value.topSpeed
            : topSpeed // ignore: cast_nullable_to_non_nullable
                  as int?,
        acceleration: freezed == acceleration
            ? _value.acceleration
            : acceleration // ignore: cast_nullable_to_non_nullable
                  as String?,
        seatingCapacity: freezed == seatingCapacity
            ? _value.seatingCapacity
            : seatingCapacity // ignore: cast_nullable_to_non_nullable
                  as int?,
        cargoSpace: freezed == cargoSpace
            ? _value.cargoSpace
            : cargoSpace // ignore: cast_nullable_to_non_nullable
                  as int?,
        videoUrl: freezed == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        brochureUrl: freezed == brochureUrl
            ? _value.brochureUrl
            : brochureUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        greyMarketSource: freezed == greyMarketSource
            ? _value.greyMarketSource
            : greyMarketSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        greyMarketUpdatedAt: freezed == greyMarketUpdatedAt
            ? _value.greyMarketUpdatedAt
            : greyMarketUpdatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        greyMarketUrl: freezed == greyMarketUrl
            ? _value.greyMarketUrl
            : greyMarketUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        savingsPercentage: freezed == savingsPercentage
            ? _value.savingsPercentage
            : savingsPercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
        savingsAmount: freezed == savingsAmount
            ? _value.savingsAmount
            : savingsAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleImpl implements _Vehicle {
  const _$VehicleImpl({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.make,
    required this.year,
    this.range,
    @JsonKey(name: 'battery_capacity') this.batteryCapacity,
    @JsonKey(name: 'battery_kwh') this.batteryKwh,
    required this.price,
    @JsonKey(name: 'price_qar') this.priceQar,
    @JsonKey(name: 'manufacturer_id') this.manufacturerId,
    @JsonKey(name: 'manufacturer_direct_price') this.manufacturerDirectPrice,
    @JsonKey(name: 'broker_market_price') this.brokerMarketPrice,
    @JsonKey(name: 'grey_market_price') this.greyMarketPrice,
    @JsonKey(name: 'price_transparency_enabled')
    @JsonKey(name: 'price_transparency_enabled')
    this.priceTransparencyEnabled,
    @VehicleTypeConverter() @JsonKey(name: 'vehicle_type') this.vehicleType,
    @JsonKey(name: 'origin_country') this.originCountry,
    @JsonKey(name: 'warranty_years') this.warrantyYears,
    @JsonKey(name: 'warranty_km') this.warrantyKm,
    @JsonKey(name: 'image_url') this.imageUrl,
    final List<String>? images,
    this.description,
    final Map<String, dynamic>? specs,
    @JsonKey(name: 'stock_count') this.stockCount,
    @AvailabilityStatusConverter()
    @JsonKey(name: 'availability')
    this.availability,
    this.status,
    @JsonKey(name: 'charging_time') this.chargingTime,
    @JsonKey(name: 'top_speed') this.topSpeed,
    this.acceleration,
    @JsonKey(name: 'seating_capacity') this.seatingCapacity,
    @JsonKey(name: 'cargo_space') this.cargoSpace,
    @JsonKey(name: 'video_url') this.videoUrl,
    @JsonKey(name: 'brochure_url') this.brochureUrl,
    @JsonKey(name: 'grey_market_source') this.greyMarketSource,
    @JsonKey(name: 'grey_market_updated_at') this.greyMarketUpdatedAt,
    @JsonKey(name: 'grey_market_url') this.greyMarketUrl,
    @JsonKey(name: 'savings_percentage') this.savingsPercentage,
    @JsonKey(name: 'savings_amount') this.savingsAmount,
    this.createdAt,
    this.updatedAt,
  }) : _images = images,
       _specs = specs;

  factory _$VehicleImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleImplFromJson(json);

  @override
  final String id;
  @override
  final String manufacturer;
  @override
  final String model;
  @override
  final String make;
  @override
  final int year;
  @override
  final int? range;
  @override
  @JsonKey(name: 'battery_capacity')
  final double? batteryCapacity;
  @override
  @JsonKey(name: 'battery_kwh')
  final double? batteryKwh;
  @override
  final double price;
  @override
  @JsonKey(name: 'price_qar')
  final double? priceQar;
  @override
  @JsonKey(name: 'manufacturer_id')
  final String? manufacturerId;
  @override
  @JsonKey(name: 'manufacturer_direct_price')
  final double? manufacturerDirectPrice;
  @override
  @JsonKey(name: 'broker_market_price')
  final double? brokerMarketPrice;
  @override
  @JsonKey(name: 'grey_market_price')
  final double? greyMarketPrice;
  @override
  @JsonKey(name: 'price_transparency_enabled')
  @JsonKey(name: 'price_transparency_enabled')
  final bool? priceTransparencyEnabled;
  @override
  @VehicleTypeConverter()
  @JsonKey(name: 'vehicle_type')
  final VehicleType? vehicleType;
  @override
  @JsonKey(name: 'origin_country')
  final String? originCountry;
  @override
  @JsonKey(name: 'warranty_years')
  final int? warrantyYears;
  @override
  @JsonKey(name: 'warranty_km')
  final int? warrantyKm;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? description;
  final Map<String, dynamic>? _specs;
  @override
  Map<String, dynamic>? get specs {
    final value = _specs;
    if (value == null) return null;
    if (_specs is EqualUnmodifiableMapView) return _specs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'stock_count')
  final int? stockCount;
  @override
  @AvailabilityStatusConverter()
  @JsonKey(name: 'availability')
  final AvailabilityStatus? availability;
  @override
  final String? status;
  @override
  @JsonKey(name: 'charging_time')
  final String? chargingTime;
  @override
  @JsonKey(name: 'top_speed')
  final int? topSpeed;
  @override
  final String? acceleration;
  @override
  @JsonKey(name: 'seating_capacity')
  final int? seatingCapacity;
  @override
  @JsonKey(name: 'cargo_space')
  final int? cargoSpace;
  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @override
  @JsonKey(name: 'brochure_url')
  final String? brochureUrl;
  @override
  @JsonKey(name: 'grey_market_source')
  final String? greyMarketSource;
  @override
  @JsonKey(name: 'grey_market_updated_at')
  final DateTime? greyMarketUpdatedAt;
  @override
  @JsonKey(name: 'grey_market_url')
  final String? greyMarketUrl;
  @override
  @JsonKey(name: 'savings_percentage')
  final double? savingsPercentage;
  @override
  @JsonKey(name: 'savings_amount')
  final double? savingsAmount;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Vehicle(id: $id, manufacturer: $manufacturer, model: $model, make: $make, year: $year, range: $range, batteryCapacity: $batteryCapacity, batteryKwh: $batteryKwh, price: $price, priceQar: $priceQar, manufacturerId: $manufacturerId, manufacturerDirectPrice: $manufacturerDirectPrice, brokerMarketPrice: $brokerMarketPrice, greyMarketPrice: $greyMarketPrice, priceTransparencyEnabled: $priceTransparencyEnabled, vehicleType: $vehicleType, originCountry: $originCountry, warrantyYears: $warrantyYears, warrantyKm: $warrantyKm, imageUrl: $imageUrl, images: $images, description: $description, specs: $specs, stockCount: $stockCount, availability: $availability, status: $status, chargingTime: $chargingTime, topSpeed: $topSpeed, acceleration: $acceleration, seatingCapacity: $seatingCapacity, cargoSpace: $cargoSpace, videoUrl: $videoUrl, brochureUrl: $brochureUrl, greyMarketSource: $greyMarketSource, greyMarketUpdatedAt: $greyMarketUpdatedAt, greyMarketUrl: $greyMarketUrl, savingsPercentage: $savingsPercentage, savingsAmount: $savingsAmount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.make, make) || other.make == make) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.batteryCapacity, batteryCapacity) ||
                other.batteryCapacity == batteryCapacity) &&
            (identical(other.batteryKwh, batteryKwh) ||
                other.batteryKwh == batteryKwh) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.priceQar, priceQar) ||
                other.priceQar == priceQar) &&
            (identical(other.manufacturerId, manufacturerId) ||
                other.manufacturerId == manufacturerId) &&
            (identical(
                  other.manufacturerDirectPrice,
                  manufacturerDirectPrice,
                ) ||
                other.manufacturerDirectPrice == manufacturerDirectPrice) &&
            (identical(other.brokerMarketPrice, brokerMarketPrice) ||
                other.brokerMarketPrice == brokerMarketPrice) &&
            (identical(other.greyMarketPrice, greyMarketPrice) ||
                other.greyMarketPrice == greyMarketPrice) &&
            (identical(
                  other.priceTransparencyEnabled,
                  priceTransparencyEnabled,
                ) ||
                other.priceTransparencyEnabled == priceTransparencyEnabled) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.originCountry, originCountry) ||
                other.originCountry == originCountry) &&
            (identical(other.warrantyYears, warrantyYears) ||
                other.warrantyYears == warrantyYears) &&
            (identical(other.warrantyKm, warrantyKm) ||
                other.warrantyKm == warrantyKm) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._specs, _specs) &&
            (identical(other.stockCount, stockCount) ||
                other.stockCount == stockCount) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.chargingTime, chargingTime) ||
                other.chargingTime == chargingTime) &&
            (identical(other.topSpeed, topSpeed) ||
                other.topSpeed == topSpeed) &&
            (identical(other.acceleration, acceleration) ||
                other.acceleration == acceleration) &&
            (identical(other.seatingCapacity, seatingCapacity) ||
                other.seatingCapacity == seatingCapacity) &&
            (identical(other.cargoSpace, cargoSpace) ||
                other.cargoSpace == cargoSpace) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.brochureUrl, brochureUrl) ||
                other.brochureUrl == brochureUrl) &&
            (identical(other.greyMarketSource, greyMarketSource) ||
                other.greyMarketSource == greyMarketSource) &&
            (identical(other.greyMarketUpdatedAt, greyMarketUpdatedAt) ||
                other.greyMarketUpdatedAt == greyMarketUpdatedAt) &&
            (identical(other.greyMarketUrl, greyMarketUrl) ||
                other.greyMarketUrl == greyMarketUrl) &&
            (identical(other.savingsPercentage, savingsPercentage) ||
                other.savingsPercentage == savingsPercentage) &&
            (identical(other.savingsAmount, savingsAmount) ||
                other.savingsAmount == savingsAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    manufacturer,
    model,
    make,
    year,
    range,
    batteryCapacity,
    batteryKwh,
    price,
    priceQar,
    manufacturerId,
    manufacturerDirectPrice,
    brokerMarketPrice,
    greyMarketPrice,
    priceTransparencyEnabled,
    vehicleType,
    originCountry,
    warrantyYears,
    warrantyKm,
    imageUrl,
    const DeepCollectionEquality().hash(_images),
    description,
    const DeepCollectionEquality().hash(_specs),
    stockCount,
    availability,
    status,
    chargingTime,
    topSpeed,
    acceleration,
    seatingCapacity,
    cargoSpace,
    videoUrl,
    brochureUrl,
    greyMarketSource,
    greyMarketUpdatedAt,
    greyMarketUrl,
    savingsPercentage,
    savingsAmount,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      __$$VehicleImplCopyWithImpl<_$VehicleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleImplToJson(this);
  }
}

abstract class _Vehicle implements Vehicle {
  const factory _Vehicle({
    required final String id,
    required final String manufacturer,
    required final String model,
    required final String make,
    required final int year,
    final int? range,
    @JsonKey(name: 'battery_capacity') final double? batteryCapacity,
    @JsonKey(name: 'battery_kwh') final double? batteryKwh,
    required final double price,
    @JsonKey(name: 'price_qar') final double? priceQar,
    @JsonKey(name: 'manufacturer_id') final String? manufacturerId,
    @JsonKey(name: 'manufacturer_direct_price')
    final double? manufacturerDirectPrice,
    @JsonKey(name: 'broker_market_price') final double? brokerMarketPrice,
    @JsonKey(name: 'grey_market_price') final double? greyMarketPrice,
    @JsonKey(name: 'price_transparency_enabled')
    @JsonKey(name: 'price_transparency_enabled')
    final bool? priceTransparencyEnabled,
    @VehicleTypeConverter()
    @JsonKey(name: 'vehicle_type')
    final VehicleType? vehicleType,
    @JsonKey(name: 'origin_country') final String? originCountry,
    @JsonKey(name: 'warranty_years') final int? warrantyYears,
    @JsonKey(name: 'warranty_km') final int? warrantyKm,
    @JsonKey(name: 'image_url') final String? imageUrl,
    final List<String>? images,
    final String? description,
    final Map<String, dynamic>? specs,
    @JsonKey(name: 'stock_count') final int? stockCount,
    @AvailabilityStatusConverter()
    @JsonKey(name: 'availability')
    final AvailabilityStatus? availability,
    final String? status,
    @JsonKey(name: 'charging_time') final String? chargingTime,
    @JsonKey(name: 'top_speed') final int? topSpeed,
    final String? acceleration,
    @JsonKey(name: 'seating_capacity') final int? seatingCapacity,
    @JsonKey(name: 'cargo_space') final int? cargoSpace,
    @JsonKey(name: 'video_url') final String? videoUrl,
    @JsonKey(name: 'brochure_url') final String? brochureUrl,
    @JsonKey(name: 'grey_market_source') final String? greyMarketSource,
    @JsonKey(name: 'grey_market_updated_at')
    final DateTime? greyMarketUpdatedAt,
    @JsonKey(name: 'grey_market_url') final String? greyMarketUrl,
    @JsonKey(name: 'savings_percentage') final double? savingsPercentage,
    @JsonKey(name: 'savings_amount') final double? savingsAmount,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$VehicleImpl;

  factory _Vehicle.fromJson(Map<String, dynamic> json) = _$VehicleImpl.fromJson;

  @override
  String get id;
  @override
  String get manufacturer;
  @override
  String get model;
  @override
  String get make;
  @override
  int get year;
  @override
  int? get range;
  @override
  @JsonKey(name: 'battery_capacity')
  double? get batteryCapacity;
  @override
  @JsonKey(name: 'battery_kwh')
  double? get batteryKwh;
  @override
  double get price;
  @override
  @JsonKey(name: 'price_qar')
  double? get priceQar;
  @override
  @JsonKey(name: 'manufacturer_id')
  String? get manufacturerId;
  @override
  @JsonKey(name: 'manufacturer_direct_price')
  double? get manufacturerDirectPrice;
  @override
  @JsonKey(name: 'broker_market_price')
  double? get brokerMarketPrice;
  @override
  @JsonKey(name: 'grey_market_price')
  double? get greyMarketPrice;
  @override
  @JsonKey(name: 'price_transparency_enabled')
  @JsonKey(name: 'price_transparency_enabled')
  bool? get priceTransparencyEnabled;
  @override
  @VehicleTypeConverter()
  @JsonKey(name: 'vehicle_type')
  VehicleType? get vehicleType;
  @override
  @JsonKey(name: 'origin_country')
  String? get originCountry;
  @override
  @JsonKey(name: 'warranty_years')
  int? get warrantyYears;
  @override
  @JsonKey(name: 'warranty_km')
  int? get warrantyKm;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  List<String>? get images;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get specs;
  @override
  @JsonKey(name: 'stock_count')
  int? get stockCount;
  @override
  @AvailabilityStatusConverter()
  @JsonKey(name: 'availability')
  AvailabilityStatus? get availability;
  @override
  String? get status;
  @override
  @JsonKey(name: 'charging_time')
  String? get chargingTime;
  @override
  @JsonKey(name: 'top_speed')
  int? get topSpeed;
  @override
  String? get acceleration;
  @override
  @JsonKey(name: 'seating_capacity')
  int? get seatingCapacity;
  @override
  @JsonKey(name: 'cargo_space')
  int? get cargoSpace;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  @JsonKey(name: 'brochure_url')
  String? get brochureUrl;
  @override
  @JsonKey(name: 'grey_market_source')
  String? get greyMarketSource;
  @override
  @JsonKey(name: 'grey_market_updated_at')
  DateTime? get greyMarketUpdatedAt;
  @override
  @JsonKey(name: 'grey_market_url')
  String? get greyMarketUrl;
  @override
  @JsonKey(name: 'savings_percentage')
  double? get savingsPercentage;
  @override
  @JsonKey(name: 'savings_amount')
  double? get savingsAmount;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VehicleFilter _$VehicleFilterFromJson(Map<String, dynamic> json) {
  return _VehicleFilter.fromJson(json);
}

/// @nodoc
mixin _$VehicleFilter {
  List<String>? get manufacturers => throw _privateConstructorUsedError;
  List<VehicleType>? get vehicleTypes => throw _privateConstructorUsedError;
  double? get minPrice => throw _privateConstructorUsedError;
  double? get maxPrice => throw _privateConstructorUsedError;
  int? get minRange => throw _privateConstructorUsedError;
  int? get minYear => throw _privateConstructorUsedError;
  int? get maxYear => throw _privateConstructorUsedError;
  bool? get inStockOnly => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  /// Serializes this VehicleFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleFilterCopyWith<VehicleFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleFilterCopyWith<$Res> {
  factory $VehicleFilterCopyWith(
    VehicleFilter value,
    $Res Function(VehicleFilter) then,
  ) = _$VehicleFilterCopyWithImpl<$Res, VehicleFilter>;
  @useResult
  $Res call({
    List<String>? manufacturers,
    List<VehicleType>? vehicleTypes,
    double? minPrice,
    double? maxPrice,
    int? minRange,
    int? minYear,
    int? maxYear,
    bool? inStockOnly,
    String? searchQuery,
  });
}

/// @nodoc
class _$VehicleFilterCopyWithImpl<$Res, $Val extends VehicleFilter>
    implements $VehicleFilterCopyWith<$Res> {
  _$VehicleFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? manufacturers = freezed,
    Object? vehicleTypes = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? minRange = freezed,
    Object? minYear = freezed,
    Object? maxYear = freezed,
    Object? inStockOnly = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(
      _value.copyWith(
            manufacturers: freezed == manufacturers
                ? _value.manufacturers
                : manufacturers // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            vehicleTypes: freezed == vehicleTypes
                ? _value.vehicleTypes
                : vehicleTypes // ignore: cast_nullable_to_non_nullable
                      as List<VehicleType>?,
            minPrice: freezed == minPrice
                ? _value.minPrice
                : minPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxPrice: freezed == maxPrice
                ? _value.maxPrice
                : maxPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            minRange: freezed == minRange
                ? _value.minRange
                : minRange // ignore: cast_nullable_to_non_nullable
                      as int?,
            minYear: freezed == minYear
                ? _value.minYear
                : minYear // ignore: cast_nullable_to_non_nullable
                      as int?,
            maxYear: freezed == maxYear
                ? _value.maxYear
                : maxYear // ignore: cast_nullable_to_non_nullable
                      as int?,
            inStockOnly: freezed == inStockOnly
                ? _value.inStockOnly
                : inStockOnly // ignore: cast_nullable_to_non_nullable
                      as bool?,
            searchQuery: freezed == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleFilterImplCopyWith<$Res>
    implements $VehicleFilterCopyWith<$Res> {
  factory _$$VehicleFilterImplCopyWith(
    _$VehicleFilterImpl value,
    $Res Function(_$VehicleFilterImpl) then,
  ) = __$$VehicleFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String>? manufacturers,
    List<VehicleType>? vehicleTypes,
    double? minPrice,
    double? maxPrice,
    int? minRange,
    int? minYear,
    int? maxYear,
    bool? inStockOnly,
    String? searchQuery,
  });
}

/// @nodoc
class __$$VehicleFilterImplCopyWithImpl<$Res>
    extends _$VehicleFilterCopyWithImpl<$Res, _$VehicleFilterImpl>
    implements _$$VehicleFilterImplCopyWith<$Res> {
  __$$VehicleFilterImplCopyWithImpl(
    _$VehicleFilterImpl _value,
    $Res Function(_$VehicleFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? manufacturers = freezed,
    Object? vehicleTypes = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? minRange = freezed,
    Object? minYear = freezed,
    Object? maxYear = freezed,
    Object? inStockOnly = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(
      _$VehicleFilterImpl(
        manufacturers: freezed == manufacturers
            ? _value._manufacturers
            : manufacturers // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        vehicleTypes: freezed == vehicleTypes
            ? _value._vehicleTypes
            : vehicleTypes // ignore: cast_nullable_to_non_nullable
                  as List<VehicleType>?,
        minPrice: freezed == minPrice
            ? _value.minPrice
            : minPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxPrice: freezed == maxPrice
            ? _value.maxPrice
            : maxPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        minRange: freezed == minRange
            ? _value.minRange
            : minRange // ignore: cast_nullable_to_non_nullable
                  as int?,
        minYear: freezed == minYear
            ? _value.minYear
            : minYear // ignore: cast_nullable_to_non_nullable
                  as int?,
        maxYear: freezed == maxYear
            ? _value.maxYear
            : maxYear // ignore: cast_nullable_to_non_nullable
                  as int?,
        inStockOnly: freezed == inStockOnly
            ? _value.inStockOnly
            : inStockOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
        searchQuery: freezed == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleFilterImpl implements _VehicleFilter {
  const _$VehicleFilterImpl({
    final List<String>? manufacturers,
    final List<VehicleType>? vehicleTypes,
    this.minPrice,
    this.maxPrice,
    this.minRange,
    this.minYear,
    this.maxYear,
    this.inStockOnly,
    this.searchQuery,
  }) : _manufacturers = manufacturers,
       _vehicleTypes = vehicleTypes;

  factory _$VehicleFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleFilterImplFromJson(json);

  final List<String>? _manufacturers;
  @override
  List<String>? get manufacturers {
    final value = _manufacturers;
    if (value == null) return null;
    if (_manufacturers is EqualUnmodifiableListView) return _manufacturers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<VehicleType>? _vehicleTypes;
  @override
  List<VehicleType>? get vehicleTypes {
    final value = _vehicleTypes;
    if (value == null) return null;
    if (_vehicleTypes is EqualUnmodifiableListView) return _vehicleTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? minPrice;
  @override
  final double? maxPrice;
  @override
  final int? minRange;
  @override
  final int? minYear;
  @override
  final int? maxYear;
  @override
  final bool? inStockOnly;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'VehicleFilter(manufacturers: $manufacturers, vehicleTypes: $vehicleTypes, minPrice: $minPrice, maxPrice: $maxPrice, minRange: $minRange, minYear: $minYear, maxYear: $maxYear, inStockOnly: $inStockOnly, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleFilterImpl &&
            const DeepCollectionEquality().equals(
              other._manufacturers,
              _manufacturers,
            ) &&
            const DeepCollectionEquality().equals(
              other._vehicleTypes,
              _vehicleTypes,
            ) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.minRange, minRange) ||
                other.minRange == minRange) &&
            (identical(other.minYear, minYear) || other.minYear == minYear) &&
            (identical(other.maxYear, maxYear) || other.maxYear == maxYear) &&
            (identical(other.inStockOnly, inStockOnly) ||
                other.inStockOnly == inStockOnly) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_manufacturers),
    const DeepCollectionEquality().hash(_vehicleTypes),
    minPrice,
    maxPrice,
    minRange,
    minYear,
    maxYear,
    inStockOnly,
    searchQuery,
  );

  /// Create a copy of VehicleFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleFilterImplCopyWith<_$VehicleFilterImpl> get copyWith =>
      __$$VehicleFilterImplCopyWithImpl<_$VehicleFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleFilterImplToJson(this);
  }
}

abstract class _VehicleFilter implements VehicleFilter {
  const factory _VehicleFilter({
    final List<String>? manufacturers,
    final List<VehicleType>? vehicleTypes,
    final double? minPrice,
    final double? maxPrice,
    final int? minRange,
    final int? minYear,
    final int? maxYear,
    final bool? inStockOnly,
    final String? searchQuery,
  }) = _$VehicleFilterImpl;

  factory _VehicleFilter.fromJson(Map<String, dynamic> json) =
      _$VehicleFilterImpl.fromJson;

  @override
  List<String>? get manufacturers;
  @override
  List<VehicleType>? get vehicleTypes;
  @override
  double? get minPrice;
  @override
  double? get maxPrice;
  @override
  int? get minRange;
  @override
  int? get minYear;
  @override
  int? get maxYear;
  @override
  bool? get inStockOnly;
  @override
  String? get searchQuery;

  /// Create a copy of VehicleFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleFilterImplCopyWith<_$VehicleFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VehicleListResult _$VehicleListResultFromJson(Map<String, dynamic> json) {
  return _VehicleListResult.fromJson(json);
}

/// @nodoc
mixin _$VehicleListResult {
  List<Vehicle> get vehicles => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  bool? get hasMore => throw _privateConstructorUsedError;

  /// Serializes this VehicleListResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleListResultCopyWith<VehicleListResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleListResultCopyWith<$Res> {
  factory $VehicleListResultCopyWith(
    VehicleListResult value,
    $Res Function(VehicleListResult) then,
  ) = _$VehicleListResultCopyWithImpl<$Res, VehicleListResult>;
  @useResult
  $Res call({
    List<Vehicle> vehicles,
    int totalCount,
    int page,
    int pageSize,
    bool? hasMore,
  });
}

/// @nodoc
class _$VehicleListResultCopyWithImpl<$Res, $Val extends VehicleListResult>
    implements $VehicleListResultCopyWith<$Res> {
  _$VehicleListResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicles = null,
    Object? totalCount = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = freezed,
  }) {
    return _then(
      _value.copyWith(
            vehicles: null == vehicles
                ? _value.vehicles
                : vehicles // ignore: cast_nullable_to_non_nullable
                      as List<Vehicle>,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: freezed == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleListResultImplCopyWith<$Res>
    implements $VehicleListResultCopyWith<$Res> {
  factory _$$VehicleListResultImplCopyWith(
    _$VehicleListResultImpl value,
    $Res Function(_$VehicleListResultImpl) then,
  ) = __$$VehicleListResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Vehicle> vehicles,
    int totalCount,
    int page,
    int pageSize,
    bool? hasMore,
  });
}

/// @nodoc
class __$$VehicleListResultImplCopyWithImpl<$Res>
    extends _$VehicleListResultCopyWithImpl<$Res, _$VehicleListResultImpl>
    implements _$$VehicleListResultImplCopyWith<$Res> {
  __$$VehicleListResultImplCopyWithImpl(
    _$VehicleListResultImpl _value,
    $Res Function(_$VehicleListResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicles = null,
    Object? totalCount = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = freezed,
  }) {
    return _then(
      _$VehicleListResultImpl(
        vehicles: null == vehicles
            ? _value._vehicles
            : vehicles // ignore: cast_nullable_to_non_nullable
                  as List<Vehicle>,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: freezed == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleListResultImpl implements _VehicleListResult {
  const _$VehicleListResultImpl({
    required final List<Vehicle> vehicles,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    this.hasMore,
  }) : _vehicles = vehicles;

  factory _$VehicleListResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleListResultImplFromJson(json);

  final List<Vehicle> _vehicles;
  @override
  List<Vehicle> get vehicles {
    if (_vehicles is EqualUnmodifiableListView) return _vehicles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vehicles);
  }

  @override
  final int totalCount;
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final bool? hasMore;

  @override
  String toString() {
    return 'VehicleListResult(vehicles: $vehicles, totalCount: $totalCount, page: $page, pageSize: $pageSize, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleListResultImpl &&
            const DeepCollectionEquality().equals(other._vehicles, _vehicles) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_vehicles),
    totalCount,
    page,
    pageSize,
    hasMore,
  );

  /// Create a copy of VehicleListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleListResultImplCopyWith<_$VehicleListResultImpl> get copyWith =>
      __$$VehicleListResultImplCopyWithImpl<_$VehicleListResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleListResultImplToJson(this);
  }
}

abstract class _VehicleListResult implements VehicleListResult {
  const factory _VehicleListResult({
    required final List<Vehicle> vehicles,
    required final int totalCount,
    required final int page,
    required final int pageSize,
    final bool? hasMore,
  }) = _$VehicleListResultImpl;

  factory _VehicleListResult.fromJson(Map<String, dynamic> json) =
      _$VehicleListResultImpl.fromJson;

  @override
  List<Vehicle> get vehicles;
  @override
  int get totalCount;
  @override
  int get page;
  @override
  int get pageSize;
  @override
  bool? get hasMore;

  /// Create a copy of VehicleListResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleListResultImplCopyWith<_$VehicleListResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
