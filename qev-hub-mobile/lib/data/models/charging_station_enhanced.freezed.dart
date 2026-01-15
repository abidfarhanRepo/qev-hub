// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charging_station_enhanced.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChargingStationEnhanced _$ChargingStationEnhancedFromJson(
  Map<String, dynamic> json,
) {
  return _ChargingStationEnhanced.fromJson(json);
}

/// @nodoc
mixin _$ChargingStationEnhanced {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'operator')
  String? get operator => throw _privateConstructorUsedError;
  @JsonKey(name: 'area')
  String? get area => throw _privateConstructorUsedError;
  @JsonKey(name: 'latitude')
  double get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'longitude')
  double get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'charger_types')
  List<String>? get chargerTypes => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_chargers')
  int? get totalChargers => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_chargers')
  int? get availableChargers => throw _privateConstructorUsedError;
  @JsonKey(name: 'power_output_kw')
  double? get powerOutputKw => throw _privateConstructorUsedError;
  @JsonKey(name: 'amenities')
  List<String>? get amenities => throw _privateConstructorUsedError;
  @JsonKey(name: 'operating_hours')
  String? get operatingHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'pricing_info')
  String? get pricingInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'website_url')
  String? get websiteUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double? get distanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChargingStationEnhanced to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChargingStationEnhanced
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargingStationEnhancedCopyWith<ChargingStationEnhanced> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargingStationEnhancedCopyWith<$Res> {
  factory $ChargingStationEnhancedCopyWith(
    ChargingStationEnhanced value,
    $Res Function(ChargingStationEnhanced) then,
  ) = _$ChargingStationEnhancedCopyWithImpl<$Res, ChargingStationEnhanced>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    @JsonKey(name: 'operator') String? operator,
    @JsonKey(name: 'area') String? area,
    @JsonKey(name: 'latitude') double latitude,
    @JsonKey(name: 'longitude') double longitude,
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
  });
}

/// @nodoc
class _$ChargingStationEnhancedCopyWithImpl<
  $Res,
  $Val extends ChargingStationEnhanced
>
    implements $ChargingStationEnhancedCopyWith<$Res> {
  _$ChargingStationEnhancedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChargingStationEnhanced
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? operator = freezed,
    Object? area = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? chargerTypes = freezed,
    Object? totalChargers = freezed,
    Object? availableChargers = freezed,
    Object? powerOutputKw = freezed,
    Object? amenities = freezed,
    Object? operatingHours = freezed,
    Object? status = freezed,
    Object? pricingInfo = freezed,
    Object? phoneNumber = freezed,
    Object? websiteUrl = freezed,
    Object? imageUrl = freezed,
    Object? distanceKm = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            operator: freezed == operator
                ? _value.operator
                : operator // ignore: cast_nullable_to_non_nullable
                      as String?,
            area: freezed == area
                ? _value.area
                : area // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            chargerTypes: freezed == chargerTypes
                ? _value.chargerTypes
                : chargerTypes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            totalChargers: freezed == totalChargers
                ? _value.totalChargers
                : totalChargers // ignore: cast_nullable_to_non_nullable
                      as int?,
            availableChargers: freezed == availableChargers
                ? _value.availableChargers
                : availableChargers // ignore: cast_nullable_to_non_nullable
                      as int?,
            powerOutputKw: freezed == powerOutputKw
                ? _value.powerOutputKw
                : powerOutputKw // ignore: cast_nullable_to_non_nullable
                      as double?,
            amenities: freezed == amenities
                ? _value.amenities
                : amenities // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            operatingHours: freezed == operatingHours
                ? _value.operatingHours
                : operatingHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            pricingInfo: freezed == pricingInfo
                ? _value.pricingInfo
                : pricingInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            websiteUrl: freezed == websiteUrl
                ? _value.websiteUrl
                : websiteUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ChargingStationEnhancedImplCopyWith<$Res>
    implements $ChargingStationEnhancedCopyWith<$Res> {
  factory _$$ChargingStationEnhancedImplCopyWith(
    _$ChargingStationEnhancedImpl value,
    $Res Function(_$ChargingStationEnhancedImpl) then,
  ) = __$$ChargingStationEnhancedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    @JsonKey(name: 'operator') String? operator,
    @JsonKey(name: 'area') String? area,
    @JsonKey(name: 'latitude') double latitude,
    @JsonKey(name: 'longitude') double longitude,
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
  });
}

/// @nodoc
class __$$ChargingStationEnhancedImplCopyWithImpl<$Res>
    extends
        _$ChargingStationEnhancedCopyWithImpl<
          $Res,
          _$ChargingStationEnhancedImpl
        >
    implements _$$ChargingStationEnhancedImplCopyWith<$Res> {
  __$$ChargingStationEnhancedImplCopyWithImpl(
    _$ChargingStationEnhancedImpl _value,
    $Res Function(_$ChargingStationEnhancedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingStationEnhanced
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? operator = freezed,
    Object? area = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? chargerTypes = freezed,
    Object? totalChargers = freezed,
    Object? availableChargers = freezed,
    Object? powerOutputKw = freezed,
    Object? amenities = freezed,
    Object? operatingHours = freezed,
    Object? status = freezed,
    Object? pricingInfo = freezed,
    Object? phoneNumber = freezed,
    Object? websiteUrl = freezed,
    Object? imageUrl = freezed,
    Object? distanceKm = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ChargingStationEnhancedImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        operator: freezed == operator
            ? _value.operator
            : operator // ignore: cast_nullable_to_non_nullable
                  as String?,
        area: freezed == area
            ? _value.area
            : area // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        chargerTypes: freezed == chargerTypes
            ? _value._chargerTypes
            : chargerTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        totalChargers: freezed == totalChargers
            ? _value.totalChargers
            : totalChargers // ignore: cast_nullable_to_non_nullable
                  as int?,
        availableChargers: freezed == availableChargers
            ? _value.availableChargers
            : availableChargers // ignore: cast_nullable_to_non_nullable
                  as int?,
        powerOutputKw: freezed == powerOutputKw
            ? _value.powerOutputKw
            : powerOutputKw // ignore: cast_nullable_to_non_nullable
                  as double?,
        amenities: freezed == amenities
            ? _value._amenities
            : amenities // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        operatingHours: freezed == operatingHours
            ? _value.operatingHours
            : operatingHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        pricingInfo: freezed == pricingInfo
            ? _value.pricingInfo
            : pricingInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        websiteUrl: freezed == websiteUrl
            ? _value.websiteUrl
            : websiteUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
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
class _$ChargingStationEnhancedImpl implements _ChargingStationEnhanced {
  const _$ChargingStationEnhancedImpl({
    required this.id,
    required this.name,
    required this.address,
    @JsonKey(name: 'operator') this.operator,
    @JsonKey(name: 'area') this.area,
    @JsonKey(name: 'latitude') required this.latitude,
    @JsonKey(name: 'longitude') required this.longitude,
    @JsonKey(name: 'charger_types') final List<String>? chargerTypes,
    @JsonKey(name: 'total_chargers') this.totalChargers,
    @JsonKey(name: 'available_chargers') this.availableChargers,
    @JsonKey(name: 'power_output_kw') this.powerOutputKw,
    @JsonKey(name: 'amenities') final List<String>? amenities,
    @JsonKey(name: 'operating_hours') this.operatingHours,
    @JsonKey(name: 'status') this.status,
    @JsonKey(name: 'pricing_info') this.pricingInfo,
    @JsonKey(name: 'phone_number') this.phoneNumber,
    @JsonKey(name: 'website_url') this.websiteUrl,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'distance_km') this.distanceKm,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _chargerTypes = chargerTypes,
       _amenities = amenities;

  factory _$ChargingStationEnhancedImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargingStationEnhancedImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  @JsonKey(name: 'operator')
  final String? operator;
  @override
  @JsonKey(name: 'area')
  final String? area;
  @override
  @JsonKey(name: 'latitude')
  final double latitude;
  @override
  @JsonKey(name: 'longitude')
  final double longitude;
  final List<String>? _chargerTypes;
  @override
  @JsonKey(name: 'charger_types')
  List<String>? get chargerTypes {
    final value = _chargerTypes;
    if (value == null) return null;
    if (_chargerTypes is EqualUnmodifiableListView) return _chargerTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'total_chargers')
  final int? totalChargers;
  @override
  @JsonKey(name: 'available_chargers')
  final int? availableChargers;
  @override
  @JsonKey(name: 'power_output_kw')
  final double? powerOutputKw;
  final List<String>? _amenities;
  @override
  @JsonKey(name: 'amenities')
  List<String>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'operating_hours')
  final String? operatingHours;
  @override
  @JsonKey(name: 'status')
  final String? status;
  @override
  @JsonKey(name: 'pricing_info')
  final String? pricingInfo;
  @override
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @override
  @JsonKey(name: 'website_url')
  final String? websiteUrl;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChargingStationEnhanced(id: $id, name: $name, address: $address, operator: $operator, area: $area, latitude: $latitude, longitude: $longitude, chargerTypes: $chargerTypes, totalChargers: $totalChargers, availableChargers: $availableChargers, powerOutputKw: $powerOutputKw, amenities: $amenities, operatingHours: $operatingHours, status: $status, pricingInfo: $pricingInfo, phoneNumber: $phoneNumber, websiteUrl: $websiteUrl, imageUrl: $imageUrl, distanceKm: $distanceKm, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargingStationEnhancedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(
              other._chargerTypes,
              _chargerTypes,
            ) &&
            (identical(other.totalChargers, totalChargers) ||
                other.totalChargers == totalChargers) &&
            (identical(other.availableChargers, availableChargers) ||
                other.availableChargers == availableChargers) &&
            (identical(other.powerOutputKw, powerOutputKw) ||
                other.powerOutputKw == powerOutputKw) &&
            const DeepCollectionEquality().equals(
              other._amenities,
              _amenities,
            ) &&
            (identical(other.operatingHours, operatingHours) ||
                other.operatingHours == operatingHours) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pricingInfo, pricingInfo) ||
                other.pricingInfo == pricingInfo) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
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
    name,
    address,
    operator,
    area,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_chargerTypes),
    totalChargers,
    availableChargers,
    powerOutputKw,
    const DeepCollectionEquality().hash(_amenities),
    operatingHours,
    status,
    pricingInfo,
    phoneNumber,
    websiteUrl,
    imageUrl,
    distanceKm,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of ChargingStationEnhanced
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargingStationEnhancedImplCopyWith<_$ChargingStationEnhancedImpl>
  get copyWith =>
      __$$ChargingStationEnhancedImplCopyWithImpl<
        _$ChargingStationEnhancedImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargingStationEnhancedImplToJson(this);
  }
}

abstract class _ChargingStationEnhanced implements ChargingStationEnhanced {
  const factory _ChargingStationEnhanced({
    required final String id,
    required final String name,
    required final String address,
    @JsonKey(name: 'operator') final String? operator,
    @JsonKey(name: 'area') final String? area,
    @JsonKey(name: 'latitude') required final double latitude,
    @JsonKey(name: 'longitude') required final double longitude,
    @JsonKey(name: 'charger_types') final List<String>? chargerTypes,
    @JsonKey(name: 'total_chargers') final int? totalChargers,
    @JsonKey(name: 'available_chargers') final int? availableChargers,
    @JsonKey(name: 'power_output_kw') final double? powerOutputKw,
    @JsonKey(name: 'amenities') final List<String>? amenities,
    @JsonKey(name: 'operating_hours') final String? operatingHours,
    @JsonKey(name: 'status') final String? status,
    @JsonKey(name: 'pricing_info') final String? pricingInfo,
    @JsonKey(name: 'phone_number') final String? phoneNumber,
    @JsonKey(name: 'website_url') final String? websiteUrl,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'distance_km') final double? distanceKm,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$ChargingStationEnhancedImpl;

  factory _ChargingStationEnhanced.fromJson(Map<String, dynamic> json) =
      _$ChargingStationEnhancedImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  @JsonKey(name: 'operator')
  String? get operator;
  @override
  @JsonKey(name: 'area')
  String? get area;
  @override
  @JsonKey(name: 'latitude')
  double get latitude;
  @override
  @JsonKey(name: 'longitude')
  double get longitude;
  @override
  @JsonKey(name: 'charger_types')
  List<String>? get chargerTypes;
  @override
  @JsonKey(name: 'total_chargers')
  int? get totalChargers;
  @override
  @JsonKey(name: 'available_chargers')
  int? get availableChargers;
  @override
  @JsonKey(name: 'power_output_kw')
  double? get powerOutputKw;
  @override
  @JsonKey(name: 'amenities')
  List<String>? get amenities;
  @override
  @JsonKey(name: 'operating_hours')
  String? get operatingHours;
  @override
  @JsonKey(name: 'status')
  String? get status;
  @override
  @JsonKey(name: 'pricing_info')
  String? get pricingInfo;
  @override
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  @JsonKey(name: 'website_url')
  String? get websiteUrl;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'distance_km')
  double? get distanceKm;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of ChargingStationEnhanced
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargingStationEnhancedImplCopyWith<_$ChargingStationEnhancedImpl>
  get copyWith => throw _privateConstructorUsedError;
}
