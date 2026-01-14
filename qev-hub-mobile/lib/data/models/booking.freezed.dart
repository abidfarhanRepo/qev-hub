// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get chargerId => throw _privateConstructorUsedError;
  String get stationId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  double? get estimatedCost => throw _privateConstructorUsedError;
  double? get actualCost => throw _privateConstructorUsedError;
  double? get energyDelivered => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get cancellationReason => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  Charger? get charger => throw _privateConstructorUsedError;
  ChargingStation? get station => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    String id,
    String userId,
    String chargerId,
    String stationId,
    DateTime startTime,
    DateTime endTime,
    BookingStatus status,
    double? estimatedCost,
    double? actualCost,
    double? energyDelivered,
    String? notes,
    String? cancellationReason,
    DateTime? cancelledAt,
    DateTime? completedAt,
    DateTime createdAt,
    DateTime updatedAt,
    Charger? charger,
    ChargingStation? station,
  });

  $ChargerCopyWith<$Res>? get charger;
  $ChargingStationCopyWith<$Res>? get station;
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? chargerId = null,
    Object? stationId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? estimatedCost = freezed,
    Object? actualCost = freezed,
    Object? energyDelivered = freezed,
    Object? notes = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledAt = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? charger = freezed,
    Object? station = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            chargerId: null == chargerId
                ? _value.chargerId
                : chargerId // ignore: cast_nullable_to_non_nullable
                      as String,
            stationId: null == stationId
                ? _value.stationId
                : stationId // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BookingStatus,
            estimatedCost: freezed == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as double?,
            actualCost: freezed == actualCost
                ? _value.actualCost
                : actualCost // ignore: cast_nullable_to_non_nullable
                      as double?,
            energyDelivered: freezed == energyDelivered
                ? _value.energyDelivered
                : energyDelivered // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            cancellationReason: freezed == cancellationReason
                ? _value.cancellationReason
                : cancellationReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            cancelledAt: freezed == cancelledAt
                ? _value.cancelledAt
                : cancelledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            charger: freezed == charger
                ? _value.charger
                : charger // ignore: cast_nullable_to_non_nullable
                      as Charger?,
            station: freezed == station
                ? _value.station
                : station // ignore: cast_nullable_to_non_nullable
                      as ChargingStation?,
          )
          as $Val,
    );
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChargerCopyWith<$Res>? get charger {
    if (_value.charger == null) {
      return null;
    }

    return $ChargerCopyWith<$Res>(_value.charger!, (value) {
      return _then(_value.copyWith(charger: value) as $Val);
    });
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChargingStationCopyWith<$Res>? get station {
    if (_value.station == null) {
      return null;
    }

    return $ChargingStationCopyWith<$Res>(_value.station!, (value) {
      return _then(_value.copyWith(station: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String chargerId,
    String stationId,
    DateTime startTime,
    DateTime endTime,
    BookingStatus status,
    double? estimatedCost,
    double? actualCost,
    double? energyDelivered,
    String? notes,
    String? cancellationReason,
    DateTime? cancelledAt,
    DateTime? completedAt,
    DateTime createdAt,
    DateTime updatedAt,
    Charger? charger,
    ChargingStation? station,
  });

  @override
  $ChargerCopyWith<$Res>? get charger;
  @override
  $ChargingStationCopyWith<$Res>? get station;
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? chargerId = null,
    Object? stationId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? estimatedCost = freezed,
    Object? actualCost = freezed,
    Object? energyDelivered = freezed,
    Object? notes = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledAt = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? charger = freezed,
    Object? station = freezed,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        chargerId: null == chargerId
            ? _value.chargerId
            : chargerId // ignore: cast_nullable_to_non_nullable
                  as String,
        stationId: null == stationId
            ? _value.stationId
            : stationId // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BookingStatus,
        estimatedCost: freezed == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        actualCost: freezed == actualCost
            ? _value.actualCost
            : actualCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        energyDelivered: freezed == energyDelivered
            ? _value.energyDelivered
            : energyDelivered // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        cancellationReason: freezed == cancellationReason
            ? _value.cancellationReason
            : cancellationReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        cancelledAt: freezed == cancelledAt
            ? _value.cancelledAt
            : cancelledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        charger: freezed == charger
            ? _value.charger
            : charger // ignore: cast_nullable_to_non_nullable
                  as Charger?,
        station: freezed == station
            ? _value.station
            : station // ignore: cast_nullable_to_non_nullable
                  as ChargingStation?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl implements _Booking {
  const _$BookingImpl({
    required this.id,
    required this.userId,
    required this.chargerId,
    required this.stationId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.estimatedCost,
    this.actualCost,
    this.energyDelivered,
    this.notes,
    this.cancellationReason,
    this.cancelledAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.charger,
    this.station,
  });

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String chargerId;
  @override
  final String stationId;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final BookingStatus status;
  @override
  final double? estimatedCost;
  @override
  final double? actualCost;
  @override
  final double? energyDelivered;
  @override
  final String? notes;
  @override
  final String? cancellationReason;
  @override
  final DateTime? cancelledAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  // Relations
  @override
  final Charger? charger;
  @override
  final ChargingStation? station;

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, chargerId: $chargerId, stationId: $stationId, startTime: $startTime, endTime: $endTime, status: $status, estimatedCost: $estimatedCost, actualCost: $actualCost, energyDelivered: $energyDelivered, notes: $notes, cancellationReason: $cancellationReason, cancelledAt: $cancelledAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, charger: $charger, station: $station)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.chargerId, chargerId) ||
                other.chargerId == chargerId) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.actualCost, actualCost) ||
                other.actualCost == actualCost) &&
            (identical(other.energyDelivered, energyDelivered) ||
                other.energyDelivered == energyDelivered) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.charger, charger) || other.charger == charger) &&
            (identical(other.station, station) || other.station == station));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    chargerId,
    stationId,
    startTime,
    endTime,
    status,
    estimatedCost,
    actualCost,
    energyDelivered,
    notes,
    cancellationReason,
    cancelledAt,
    completedAt,
    createdAt,
    updatedAt,
    charger,
    station,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking implements Booking {
  const factory _Booking({
    required final String id,
    required final String userId,
    required final String chargerId,
    required final String stationId,
    required final DateTime startTime,
    required final DateTime endTime,
    required final BookingStatus status,
    final double? estimatedCost,
    final double? actualCost,
    final double? energyDelivered,
    final String? notes,
    final String? cancellationReason,
    final DateTime? cancelledAt,
    final DateTime? completedAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final Charger? charger,
    final ChargingStation? station,
  }) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get chargerId;
  @override
  String get stationId;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  BookingStatus get status;
  @override
  double? get estimatedCost;
  @override
  double? get actualCost;
  @override
  double? get energyDelivered;
  @override
  String? get notes;
  @override
  String? get cancellationReason;
  @override
  DateTime? get cancelledAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // Relations
  @override
  Charger? get charger;
  @override
  ChargingStation? get station;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingFilter _$BookingFilterFromJson(Map<String, dynamic> json) {
  return _BookingFilter.fromJson(json);
}

/// @nodoc
mixin _$BookingFilter {
  BookingStatus? get status => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool? get upcomingOnly => throw _privateConstructorUsedError;

  /// Serializes this BookingFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingFilterCopyWith<BookingFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingFilterCopyWith<$Res> {
  factory $BookingFilterCopyWith(
    BookingFilter value,
    $Res Function(BookingFilter) then,
  ) = _$BookingFilterCopyWithImpl<$Res, BookingFilter>;
  @useResult
  $Res call({
    BookingStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    bool? upcomingOnly,
  });
}

/// @nodoc
class _$BookingFilterCopyWithImpl<$Res, $Val extends BookingFilter>
    implements $BookingFilterCopyWith<$Res> {
  _$BookingFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? upcomingOnly = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BookingStatus?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            upcomingOnly: freezed == upcomingOnly
                ? _value.upcomingOnly
                : upcomingOnly // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingFilterImplCopyWith<$Res>
    implements $BookingFilterCopyWith<$Res> {
  factory _$$BookingFilterImplCopyWith(
    _$BookingFilterImpl value,
    $Res Function(_$BookingFilterImpl) then,
  ) = __$$BookingFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BookingStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    bool? upcomingOnly,
  });
}

/// @nodoc
class __$$BookingFilterImplCopyWithImpl<$Res>
    extends _$BookingFilterCopyWithImpl<$Res, _$BookingFilterImpl>
    implements _$$BookingFilterImplCopyWith<$Res> {
  __$$BookingFilterImplCopyWithImpl(
    _$BookingFilterImpl _value,
    $Res Function(_$BookingFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? upcomingOnly = freezed,
  }) {
    return _then(
      _$BookingFilterImpl(
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BookingStatus?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        upcomingOnly: freezed == upcomingOnly
            ? _value.upcomingOnly
            : upcomingOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingFilterImpl implements _BookingFilter {
  const _$BookingFilterImpl({
    this.status,
    this.startDate,
    this.endDate,
    this.upcomingOnly,
  });

  factory _$BookingFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingFilterImplFromJson(json);

  @override
  final BookingStatus? status;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final bool? upcomingOnly;

  @override
  String toString() {
    return 'BookingFilter(status: $status, startDate: $startDate, endDate: $endDate, upcomingOnly: $upcomingOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingFilterImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.upcomingOnly, upcomingOnly) ||
                other.upcomingOnly == upcomingOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, startDate, endDate, upcomingOnly);

  /// Create a copy of BookingFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingFilterImplCopyWith<_$BookingFilterImpl> get copyWith =>
      __$$BookingFilterImplCopyWithImpl<_$BookingFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingFilterImplToJson(this);
  }
}

abstract class _BookingFilter implements BookingFilter {
  const factory _BookingFilter({
    final BookingStatus? status,
    final DateTime? startDate,
    final DateTime? endDate,
    final bool? upcomingOnly,
  }) = _$BookingFilterImpl;

  factory _BookingFilter.fromJson(Map<String, dynamic> json) =
      _$BookingFilterImpl.fromJson;

  @override
  BookingStatus? get status;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  bool? get upcomingOnly;

  /// Create a copy of BookingFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingFilterImplCopyWith<_$BookingFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
