// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Charger _$ChargerFromJson(Map<String, dynamic> json) {
  return _Charger.fromJson(json);
}

/// @nodoc
mixin _$Charger {
  String get id => throw _privateConstructorUsedError;
  String get stationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get chargerType => throw _privateConstructorUsedError;
  double get powerKw => throw _privateConstructorUsedError;
  ChargerStatus get status => throw _privateConstructorUsedError;
  List<String> get connectorTypes => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Charger to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Charger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargerCopyWith<Charger> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargerCopyWith<$Res> {
  factory $ChargerCopyWith(Charger value, $Res Function(Charger) then) =
      _$ChargerCopyWithImpl<$Res, Charger>;
  @useResult
  $Res call({
    String id,
    String stationId,
    String name,
    String chargerType,
    double powerKw,
    ChargerStatus status,
    List<String> connectorTypes,
    bool isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ChargerCopyWithImpl<$Res, $Val extends Charger>
    implements $ChargerCopyWith<$Res> {
  _$ChargerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Charger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationId = null,
    Object? name = null,
    Object? chargerType = null,
    Object? powerKw = null,
    Object? status = null,
    Object? connectorTypes = null,
    Object? isEnabled = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            stationId: null == stationId
                ? _value.stationId
                : stationId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            chargerType: null == chargerType
                ? _value.chargerType
                : chargerType // ignore: cast_nullable_to_non_nullable
                      as String,
            powerKw: null == powerKw
                ? _value.powerKw
                : powerKw // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ChargerStatus,
            connectorTypes: null == connectorTypes
                ? _value.connectorTypes
                : connectorTypes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$ChargerImplCopyWith<$Res> implements $ChargerCopyWith<$Res> {
  factory _$$ChargerImplCopyWith(
    _$ChargerImpl value,
    $Res Function(_$ChargerImpl) then,
  ) = __$$ChargerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String stationId,
    String name,
    String chargerType,
    double powerKw,
    ChargerStatus status,
    List<String> connectorTypes,
    bool isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ChargerImplCopyWithImpl<$Res>
    extends _$ChargerCopyWithImpl<$Res, _$ChargerImpl>
    implements _$$ChargerImplCopyWith<$Res> {
  __$$ChargerImplCopyWithImpl(
    _$ChargerImpl _value,
    $Res Function(_$ChargerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Charger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationId = null,
    Object? name = null,
    Object? chargerType = null,
    Object? powerKw = null,
    Object? status = null,
    Object? connectorTypes = null,
    Object? isEnabled = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ChargerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        stationId: null == stationId
            ? _value.stationId
            : stationId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        chargerType: null == chargerType
            ? _value.chargerType
            : chargerType // ignore: cast_nullable_to_non_nullable
                  as String,
        powerKw: null == powerKw
            ? _value.powerKw
            : powerKw // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ChargerStatus,
        connectorTypes: null == connectorTypes
            ? _value._connectorTypes
            : connectorTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$ChargerImpl implements _Charger {
  const _$ChargerImpl({
    required this.id,
    required this.stationId,
    required this.name,
    required this.chargerType,
    required this.powerKw,
    required this.status,
    required final List<String> connectorTypes,
    required this.isEnabled,
    this.createdAt,
    this.updatedAt,
  }) : _connectorTypes = connectorTypes;

  factory _$ChargerImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargerImplFromJson(json);

  @override
  final String id;
  @override
  final String stationId;
  @override
  final String name;
  @override
  final String chargerType;
  @override
  final double powerKw;
  @override
  final ChargerStatus status;
  final List<String> _connectorTypes;
  @override
  List<String> get connectorTypes {
    if (_connectorTypes is EqualUnmodifiableListView) return _connectorTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connectorTypes);
  }

  @override
  final bool isEnabled;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Charger(id: $id, stationId: $stationId, name: $name, chargerType: $chargerType, powerKw: $powerKw, status: $status, connectorTypes: $connectorTypes, isEnabled: $isEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.chargerType, chargerType) ||
                other.chargerType == chargerType) &&
            (identical(other.powerKw, powerKw) || other.powerKw == powerKw) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._connectorTypes,
              _connectorTypes,
            ) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    stationId,
    name,
    chargerType,
    powerKw,
    status,
    const DeepCollectionEquality().hash(_connectorTypes),
    isEnabled,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Charger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargerImplCopyWith<_$ChargerImpl> get copyWith =>
      __$$ChargerImplCopyWithImpl<_$ChargerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargerImplToJson(this);
  }
}

abstract class _Charger implements Charger {
  const factory _Charger({
    required final String id,
    required final String stationId,
    required final String name,
    required final String chargerType,
    required final double powerKw,
    required final ChargerStatus status,
    required final List<String> connectorTypes,
    required final bool isEnabled,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ChargerImpl;

  factory _Charger.fromJson(Map<String, dynamic> json) = _$ChargerImpl.fromJson;

  @override
  String get id;
  @override
  String get stationId;
  @override
  String get name;
  @override
  String get chargerType;
  @override
  double get powerKw;
  @override
  ChargerStatus get status;
  @override
  List<String> get connectorTypes;
  @override
  bool get isEnabled;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Charger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargerImplCopyWith<_$ChargerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
