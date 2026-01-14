// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charging_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChargingStation _$ChargingStationFromJson(Map<String, dynamic> json) {
  return _ChargingStation.fromJson(json);
}

/// @nodoc
mixin _$ChargingStation {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'charger_type')
  String? get chargerType => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_chargers')
  int? get totalChargers => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_chargers')
  int? get availableChargers => throw _privateConstructorUsedError;
  @JsonKey(name: 'power_output_kw')
  double? get powerOutputKw => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String? get status => throw _privateConstructorUsedError; // 'active' or other
  @JsonKey(name: 'amenities')
  List<String>? get amenities => throw _privateConstructorUsedError;
  @JsonKey(name: 'pricing_info')
  String? get pricingInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'operating_hours')
  String? get operatingHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'website_url')
  String? get websiteUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double? get distanceKm => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChargingStation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargingStationCopyWith<ChargingStation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargingStationCopyWith<$Res> {
  factory $ChargingStationCopyWith(
    ChargingStation value,
    $Res Function(ChargingStation) then,
  ) = _$ChargingStationCopyWithImpl<$Res, ChargingStation>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    double latitude,
    double longitude,
    @JsonKey(name: 'charger_type') String? chargerType,
    @JsonKey(name: 'total_chargers') int? totalChargers,
    @JsonKey(name: 'available_chargers') int? availableChargers,
    @JsonKey(name: 'power_output_kw') double? powerOutputKw,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'amenities') List<String>? amenities,
    @JsonKey(name: 'pricing_info') String? pricingInfo,
    @JsonKey(name: 'operating_hours') String? operatingHours,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'website_url') String? websiteUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'distance_km') double? distanceKm,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ChargingStationCopyWithImpl<$Res, $Val extends ChargingStation>
    implements $ChargingStationCopyWith<$Res> {
  _$ChargingStationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? chargerType = freezed,
    Object? totalChargers = freezed,
    Object? availableChargers = freezed,
    Object? powerOutputKw = freezed,
    Object? status = freezed,
    Object? amenities = freezed,
    Object? pricingInfo = freezed,
    Object? operatingHours = freezed,
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
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            chargerType: freezed == chargerType
                ? _value.chargerType
                : chargerType // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            amenities: freezed == amenities
                ? _value.amenities
                : amenities // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            pricingInfo: freezed == pricingInfo
                ? _value.pricingInfo
                : pricingInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            operatingHours: freezed == operatingHours
                ? _value.operatingHours
                : operatingHours // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ChargingStationImplCopyWith<$Res>
    implements $ChargingStationCopyWith<$Res> {
  factory _$$ChargingStationImplCopyWith(
    _$ChargingStationImpl value,
    $Res Function(_$ChargingStationImpl) then,
  ) = __$$ChargingStationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    double latitude,
    double longitude,
    @JsonKey(name: 'charger_type') String? chargerType,
    @JsonKey(name: 'total_chargers') int? totalChargers,
    @JsonKey(name: 'available_chargers') int? availableChargers,
    @JsonKey(name: 'power_output_kw') double? powerOutputKw,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'amenities') List<String>? amenities,
    @JsonKey(name: 'pricing_info') String? pricingInfo,
    @JsonKey(name: 'operating_hours') String? operatingHours,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'website_url') String? websiteUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'distance_km') double? distanceKm,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ChargingStationImplCopyWithImpl<$Res>
    extends _$ChargingStationCopyWithImpl<$Res, _$ChargingStationImpl>
    implements _$$ChargingStationImplCopyWith<$Res> {
  __$$ChargingStationImplCopyWithImpl(
    _$ChargingStationImpl _value,
    $Res Function(_$ChargingStationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? chargerType = freezed,
    Object? totalChargers = freezed,
    Object? availableChargers = freezed,
    Object? powerOutputKw = freezed,
    Object? status = freezed,
    Object? amenities = freezed,
    Object? pricingInfo = freezed,
    Object? operatingHours = freezed,
    Object? phoneNumber = freezed,
    Object? websiteUrl = freezed,
    Object? imageUrl = freezed,
    Object? distanceKm = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ChargingStationImpl(
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
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        chargerType: freezed == chargerType
            ? _value.chargerType
            : chargerType // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        amenities: freezed == amenities
            ? _value._amenities
            : amenities // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        pricingInfo: freezed == pricingInfo
            ? _value.pricingInfo
            : pricingInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        operatingHours: freezed == operatingHours
            ? _value.operatingHours
            : operatingHours // ignore: cast_nullable_to_non_nullable
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
class _$ChargingStationImpl implements _ChargingStation {
  const _$ChargingStationImpl({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    @JsonKey(name: 'charger_type') this.chargerType,
    @JsonKey(name: 'total_chargers') this.totalChargers,
    @JsonKey(name: 'available_chargers') this.availableChargers,
    @JsonKey(name: 'power_output_kw') this.powerOutputKw,
    @JsonKey(name: 'status') this.status,
    @JsonKey(name: 'amenities') final List<String>? amenities,
    @JsonKey(name: 'pricing_info') this.pricingInfo,
    @JsonKey(name: 'operating_hours') this.operatingHours,
    @JsonKey(name: 'phone_number') this.phoneNumber,
    @JsonKey(name: 'website_url') this.websiteUrl,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'distance_km') this.distanceKm,
    this.createdAt,
    this.updatedAt,
  }) : _amenities = amenities;

  factory _$ChargingStationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargingStationImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey(name: 'charger_type')
  final String? chargerType;
  @override
  @JsonKey(name: 'total_chargers')
  final int? totalChargers;
  @override
  @JsonKey(name: 'available_chargers')
  final int? availableChargers;
  @override
  @JsonKey(name: 'power_output_kw')
  final double? powerOutputKw;
  @override
  @JsonKey(name: 'status')
  final String? status;
  // 'active' or other
  final List<String>? _amenities;
  // 'active' or other
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
  @JsonKey(name: 'pricing_info')
  final String? pricingInfo;
  @override
  @JsonKey(name: 'operating_hours')
  final String? operatingHours;
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
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChargingStation(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, chargerType: $chargerType, totalChargers: $totalChargers, availableChargers: $availableChargers, powerOutputKw: $powerOutputKw, status: $status, amenities: $amenities, pricingInfo: $pricingInfo, operatingHours: $operatingHours, phoneNumber: $phoneNumber, websiteUrl: $websiteUrl, imageUrl: $imageUrl, distanceKm: $distanceKm, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargingStationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.chargerType, chargerType) ||
                other.chargerType == chargerType) &&
            (identical(other.totalChargers, totalChargers) ||
                other.totalChargers == totalChargers) &&
            (identical(other.availableChargers, availableChargers) ||
                other.availableChargers == availableChargers) &&
            (identical(other.powerOutputKw, powerOutputKw) ||
                other.powerOutputKw == powerOutputKw) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._amenities,
              _amenities,
            ) &&
            (identical(other.pricingInfo, pricingInfo) ||
                other.pricingInfo == pricingInfo) &&
            (identical(other.operatingHours, operatingHours) ||
                other.operatingHours == operatingHours) &&
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
    latitude,
    longitude,
    chargerType,
    totalChargers,
    availableChargers,
    powerOutputKw,
    status,
    const DeepCollectionEquality().hash(_amenities),
    pricingInfo,
    operatingHours,
    phoneNumber,
    websiteUrl,
    imageUrl,
    distanceKm,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargingStationImplCopyWith<_$ChargingStationImpl> get copyWith =>
      __$$ChargingStationImplCopyWithImpl<_$ChargingStationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargingStationImplToJson(this);
  }
}

abstract class _ChargingStation implements ChargingStation {
  const factory _ChargingStation({
    required final String id,
    required final String name,
    required final String address,
    required final double latitude,
    required final double longitude,
    @JsonKey(name: 'charger_type') final String? chargerType,
    @JsonKey(name: 'total_chargers') final int? totalChargers,
    @JsonKey(name: 'available_chargers') final int? availableChargers,
    @JsonKey(name: 'power_output_kw') final double? powerOutputKw,
    @JsonKey(name: 'status') final String? status,
    @JsonKey(name: 'amenities') final List<String>? amenities,
    @JsonKey(name: 'pricing_info') final String? pricingInfo,
    @JsonKey(name: 'operating_hours') final String? operatingHours,
    @JsonKey(name: 'phone_number') final String? phoneNumber,
    @JsonKey(name: 'website_url') final String? websiteUrl,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'distance_km') final double? distanceKm,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ChargingStationImpl;

  factory _ChargingStation.fromJson(Map<String, dynamic> json) =
      _$ChargingStationImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(name: 'charger_type')
  String? get chargerType;
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
  @JsonKey(name: 'status')
  String? get status; // 'active' or other
  @override
  @JsonKey(name: 'amenities')
  List<String>? get amenities;
  @override
  @JsonKey(name: 'pricing_info')
  String? get pricingInfo;
  @override
  @JsonKey(name: 'operating_hours')
  String? get operatingHours;
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
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargingStationImplCopyWith<_$ChargingStationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StationFilter _$StationFilterFromJson(Map<String, dynamic> json) {
  return _StationFilter.fromJson(json);
}

/// @nodoc
mixin _$StationFilter {
  String? get status => throw _privateConstructorUsedError;
  bool? get availableOnly => throw _privateConstructorUsedError;
  bool? get nearbyOnly => throw _privateConstructorUsedError;
  double? get maxDistanceKm => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  /// Serializes this StationFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StationFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StationFilterCopyWith<StationFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StationFilterCopyWith<$Res> {
  factory $StationFilterCopyWith(
    StationFilter value,
    $Res Function(StationFilter) then,
  ) = _$StationFilterCopyWithImpl<$Res, StationFilter>;
  @useResult
  $Res call({
    String? status,
    bool? availableOnly,
    bool? nearbyOnly,
    double? maxDistanceKm,
    String? searchQuery,
  });
}

/// @nodoc
class _$StationFilterCopyWithImpl<$Res, $Val extends StationFilter>
    implements $StationFilterCopyWith<$Res> {
  _$StationFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StationFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? availableOnly = freezed,
    Object? nearbyOnly = freezed,
    Object? maxDistanceKm = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            availableOnly: freezed == availableOnly
                ? _value.availableOnly
                : availableOnly // ignore: cast_nullable_to_non_nullable
                      as bool?,
            nearbyOnly: freezed == nearbyOnly
                ? _value.nearbyOnly
                : nearbyOnly // ignore: cast_nullable_to_non_nullable
                      as bool?,
            maxDistanceKm: freezed == maxDistanceKm
                ? _value.maxDistanceKm
                : maxDistanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
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
abstract class _$$StationFilterImplCopyWith<$Res>
    implements $StationFilterCopyWith<$Res> {
  factory _$$StationFilterImplCopyWith(
    _$StationFilterImpl value,
    $Res Function(_$StationFilterImpl) then,
  ) = __$$StationFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    bool? availableOnly,
    bool? nearbyOnly,
    double? maxDistanceKm,
    String? searchQuery,
  });
}

/// @nodoc
class __$$StationFilterImplCopyWithImpl<$Res>
    extends _$StationFilterCopyWithImpl<$Res, _$StationFilterImpl>
    implements _$$StationFilterImplCopyWith<$Res> {
  __$$StationFilterImplCopyWithImpl(
    _$StationFilterImpl _value,
    $Res Function(_$StationFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StationFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? availableOnly = freezed,
    Object? nearbyOnly = freezed,
    Object? maxDistanceKm = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(
      _$StationFilterImpl(
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        availableOnly: freezed == availableOnly
            ? _value.availableOnly
            : availableOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
        nearbyOnly: freezed == nearbyOnly
            ? _value.nearbyOnly
            : nearbyOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
        maxDistanceKm: freezed == maxDistanceKm
            ? _value.maxDistanceKm
            : maxDistanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
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
class _$StationFilterImpl implements _StationFilter {
  const _$StationFilterImpl({
    this.status,
    this.availableOnly,
    this.nearbyOnly,
    this.maxDistanceKm,
    this.searchQuery,
  });

  factory _$StationFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$StationFilterImplFromJson(json);

  @override
  final String? status;
  @override
  final bool? availableOnly;
  @override
  final bool? nearbyOnly;
  @override
  final double? maxDistanceKm;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'StationFilter(status: $status, availableOnly: $availableOnly, nearbyOnly: $nearbyOnly, maxDistanceKm: $maxDistanceKm, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationFilterImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.availableOnly, availableOnly) ||
                other.availableOnly == availableOnly) &&
            (identical(other.nearbyOnly, nearbyOnly) ||
                other.nearbyOnly == nearbyOnly) &&
            (identical(other.maxDistanceKm, maxDistanceKm) ||
                other.maxDistanceKm == maxDistanceKm) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    availableOnly,
    nearbyOnly,
    maxDistanceKm,
    searchQuery,
  );

  /// Create a copy of StationFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationFilterImplCopyWith<_$StationFilterImpl> get copyWith =>
      __$$StationFilterImplCopyWithImpl<_$StationFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StationFilterImplToJson(this);
  }
}

abstract class _StationFilter implements StationFilter {
  const factory _StationFilter({
    final String? status,
    final bool? availableOnly,
    final bool? nearbyOnly,
    final double? maxDistanceKm,
    final String? searchQuery,
  }) = _$StationFilterImpl;

  factory _StationFilter.fromJson(Map<String, dynamic> json) =
      _$StationFilterImpl.fromJson;

  @override
  String? get status;
  @override
  bool? get availableOnly;
  @override
  bool? get nearbyOnly;
  @override
  double? get maxDistanceKm;
  @override
  String? get searchQuery;

  /// Create a copy of StationFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationFilterImplCopyWith<_$StationFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StationListResult _$StationListResultFromJson(Map<String, dynamic> json) {
  return _StationListResult.fromJson(json);
}

/// @nodoc
mixin _$StationListResult {
  List<ChargingStation> get stations => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  bool? get hasMore => throw _privateConstructorUsedError;

  /// Serializes this StationListResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StationListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StationListResultCopyWith<StationListResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StationListResultCopyWith<$Res> {
  factory $StationListResultCopyWith(
    StationListResult value,
    $Res Function(StationListResult) then,
  ) = _$StationListResultCopyWithImpl<$Res, StationListResult>;
  @useResult
  $Res call({List<ChargingStation> stations, int totalCount, bool? hasMore});
}

/// @nodoc
class _$StationListResultCopyWithImpl<$Res, $Val extends StationListResult>
    implements $StationListResultCopyWith<$Res> {
  _$StationListResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StationListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stations = null,
    Object? totalCount = null,
    Object? hasMore = freezed,
  }) {
    return _then(
      _value.copyWith(
            stations: null == stations
                ? _value.stations
                : stations // ignore: cast_nullable_to_non_nullable
                      as List<ChargingStation>,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
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
abstract class _$$StationListResultImplCopyWith<$Res>
    implements $StationListResultCopyWith<$Res> {
  factory _$$StationListResultImplCopyWith(
    _$StationListResultImpl value,
    $Res Function(_$StationListResultImpl) then,
  ) = __$$StationListResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ChargingStation> stations, int totalCount, bool? hasMore});
}

/// @nodoc
class __$$StationListResultImplCopyWithImpl<$Res>
    extends _$StationListResultCopyWithImpl<$Res, _$StationListResultImpl>
    implements _$$StationListResultImplCopyWith<$Res> {
  __$$StationListResultImplCopyWithImpl(
    _$StationListResultImpl _value,
    $Res Function(_$StationListResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StationListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stations = null,
    Object? totalCount = null,
    Object? hasMore = freezed,
  }) {
    return _then(
      _$StationListResultImpl(
        stations: null == stations
            ? _value._stations
            : stations // ignore: cast_nullable_to_non_nullable
                  as List<ChargingStation>,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
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
class _$StationListResultImpl implements _StationListResult {
  const _$StationListResultImpl({
    required final List<ChargingStation> stations,
    required this.totalCount,
    this.hasMore,
  }) : _stations = stations;

  factory _$StationListResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$StationListResultImplFromJson(json);

  final List<ChargingStation> _stations;
  @override
  List<ChargingStation> get stations {
    if (_stations is EqualUnmodifiableListView) return _stations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stations);
  }

  @override
  final int totalCount;
  @override
  final bool? hasMore;

  @override
  String toString() {
    return 'StationListResult(stations: $stations, totalCount: $totalCount, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationListResultImpl &&
            const DeepCollectionEquality().equals(other._stations, _stations) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_stations),
    totalCount,
    hasMore,
  );

  /// Create a copy of StationListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationListResultImplCopyWith<_$StationListResultImpl> get copyWith =>
      __$$StationListResultImplCopyWithImpl<_$StationListResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StationListResultImplToJson(this);
  }
}

abstract class _StationListResult implements StationListResult {
  const factory _StationListResult({
    required final List<ChargingStation> stations,
    required final int totalCount,
    final bool? hasMore,
  }) = _$StationListResultImpl;

  factory _StationListResult.fromJson(Map<String, dynamic> json) =
      _$StationListResultImpl.fromJson;

  @override
  List<ChargingStation> get stations;
  @override
  int get totalCount;
  @override
  bool? get hasMore;

  /// Create a copy of StationListResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationListResultImplCopyWith<_$StationListResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
