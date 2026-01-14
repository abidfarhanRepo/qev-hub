// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateBookingRequest _$CreateBookingRequestFromJson(Map<String, dynamic> json) {
  return _CreateBookingRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateBookingRequest {
  String get chargerId => throw _privateConstructorUsedError;
  String get stationId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  double? get estimatedCost => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CreateBookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateBookingRequestCopyWith<CreateBookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBookingRequestCopyWith<$Res> {
  factory $CreateBookingRequestCopyWith(
    CreateBookingRequest value,
    $Res Function(CreateBookingRequest) then,
  ) = _$CreateBookingRequestCopyWithImpl<$Res, CreateBookingRequest>;
  @useResult
  $Res call({
    String chargerId,
    String stationId,
    DateTime startTime,
    DateTime endTime,
    double? estimatedCost,
    String? notes,
  });
}

/// @nodoc
class _$CreateBookingRequestCopyWithImpl<
  $Res,
  $Val extends CreateBookingRequest
>
    implements $CreateBookingRequestCopyWith<$Res> {
  _$CreateBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chargerId = null,
    Object? stationId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? estimatedCost = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            estimatedCost: freezed == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateBookingRequestImplCopyWith<$Res>
    implements $CreateBookingRequestCopyWith<$Res> {
  factory _$$CreateBookingRequestImplCopyWith(
    _$CreateBookingRequestImpl value,
    $Res Function(_$CreateBookingRequestImpl) then,
  ) = __$$CreateBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String chargerId,
    String stationId,
    DateTime startTime,
    DateTime endTime,
    double? estimatedCost,
    String? notes,
  });
}

/// @nodoc
class __$$CreateBookingRequestImplCopyWithImpl<$Res>
    extends _$CreateBookingRequestCopyWithImpl<$Res, _$CreateBookingRequestImpl>
    implements _$$CreateBookingRequestImplCopyWith<$Res> {
  __$$CreateBookingRequestImplCopyWithImpl(
    _$CreateBookingRequestImpl _value,
    $Res Function(_$CreateBookingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chargerId = null,
    Object? stationId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? estimatedCost = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$CreateBookingRequestImpl(
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
        estimatedCost: freezed == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBookingRequestImpl implements _CreateBookingRequest {
  const _$CreateBookingRequestImpl({
    required this.chargerId,
    required this.stationId,
    required this.startTime,
    required this.endTime,
    this.estimatedCost,
    this.notes,
  });

  factory _$CreateBookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBookingRequestImplFromJson(json);

  @override
  final String chargerId;
  @override
  final String stationId;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final double? estimatedCost;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CreateBookingRequest(chargerId: $chargerId, stationId: $stationId, startTime: $startTime, endTime: $endTime, estimatedCost: $estimatedCost, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBookingRequestImpl &&
            (identical(other.chargerId, chargerId) ||
                other.chargerId == chargerId) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    chargerId,
    stationId,
    startTime,
    endTime,
    estimatedCost,
    notes,
  );

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBookingRequestImplCopyWith<_$CreateBookingRequestImpl>
  get copyWith =>
      __$$CreateBookingRequestImplCopyWithImpl<_$CreateBookingRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBookingRequestImplToJson(this);
  }
}

abstract class _CreateBookingRequest implements CreateBookingRequest {
  const factory _CreateBookingRequest({
    required final String chargerId,
    required final String stationId,
    required final DateTime startTime,
    required final DateTime endTime,
    final double? estimatedCost,
    final String? notes,
  }) = _$CreateBookingRequestImpl;

  factory _CreateBookingRequest.fromJson(Map<String, dynamic> json) =
      _$CreateBookingRequestImpl.fromJson;

  @override
  String get chargerId;
  @override
  String get stationId;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  double? get estimatedCost;
  @override
  String? get notes;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateBookingRequestImplCopyWith<_$CreateBookingRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

BookingListResult _$BookingListResultFromJson(Map<String, dynamic> json) {
  return _BookingListResult.fromJson(json);
}

/// @nodoc
mixin _$BookingListResult {
  List<Booking> get bookings => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  bool? get hasMore => throw _privateConstructorUsedError;

  /// Serializes this BookingListResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingListResultCopyWith<BookingListResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingListResultCopyWith<$Res> {
  factory $BookingListResultCopyWith(
    BookingListResult value,
    $Res Function(BookingListResult) then,
  ) = _$BookingListResultCopyWithImpl<$Res, BookingListResult>;
  @useResult
  $Res call({List<Booking> bookings, int totalCount, bool? hasMore});
}

/// @nodoc
class _$BookingListResultCopyWithImpl<$Res, $Val extends BookingListResult>
    implements $BookingListResultCopyWith<$Res> {
  _$BookingListResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookings = null,
    Object? totalCount = null,
    Object? hasMore = freezed,
  }) {
    return _then(
      _value.copyWith(
            bookings: null == bookings
                ? _value.bookings
                : bookings // ignore: cast_nullable_to_non_nullable
                      as List<Booking>,
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
abstract class _$$BookingListResultImplCopyWith<$Res>
    implements $BookingListResultCopyWith<$Res> {
  factory _$$BookingListResultImplCopyWith(
    _$BookingListResultImpl value,
    $Res Function(_$BookingListResultImpl) then,
  ) = __$$BookingListResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Booking> bookings, int totalCount, bool? hasMore});
}

/// @nodoc
class __$$BookingListResultImplCopyWithImpl<$Res>
    extends _$BookingListResultCopyWithImpl<$Res, _$BookingListResultImpl>
    implements _$$BookingListResultImplCopyWith<$Res> {
  __$$BookingListResultImplCopyWithImpl(
    _$BookingListResultImpl _value,
    $Res Function(_$BookingListResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookings = null,
    Object? totalCount = null,
    Object? hasMore = freezed,
  }) {
    return _then(
      _$BookingListResultImpl(
        bookings: null == bookings
            ? _value._bookings
            : bookings // ignore: cast_nullable_to_non_nullable
                  as List<Booking>,
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
class _$BookingListResultImpl implements _BookingListResult {
  const _$BookingListResultImpl({
    required final List<Booking> bookings,
    required this.totalCount,
    this.hasMore,
  }) : _bookings = bookings;

  factory _$BookingListResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingListResultImplFromJson(json);

  final List<Booking> _bookings;
  @override
  List<Booking> get bookings {
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookings);
  }

  @override
  final int totalCount;
  @override
  final bool? hasMore;

  @override
  String toString() {
    return 'BookingListResult(bookings: $bookings, totalCount: $totalCount, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingListResultImpl &&
            const DeepCollectionEquality().equals(other._bookings, _bookings) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_bookings),
    totalCount,
    hasMore,
  );

  /// Create a copy of BookingListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingListResultImplCopyWith<_$BookingListResultImpl> get copyWith =>
      __$$BookingListResultImplCopyWithImpl<_$BookingListResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingListResultImplToJson(this);
  }
}

abstract class _BookingListResult implements BookingListResult {
  const factory _BookingListResult({
    required final List<Booking> bookings,
    required final int totalCount,
    final bool? hasMore,
  }) = _$BookingListResultImpl;

  factory _BookingListResult.fromJson(Map<String, dynamic> json) =
      _$BookingListResultImpl.fromJson;

  @override
  List<Booking> get bookings;
  @override
  int get totalCount;
  @override
  bool? get hasMore;

  /// Create a copy of BookingListResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingListResultImplCopyWith<_$BookingListResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
