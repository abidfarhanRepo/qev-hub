// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String? get orderNumber => throw _privateConstructorUsedError;
  @OrderStatusConverter()
  OrderStatus get status => throw _privateConstructorUsedError;
  @PaymentStatusConverter()
  @JsonKey(name: 'payment_status')
  PaymentStatus? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  @NumericStringConverter()
  @JsonKey(name: 'total_price_qar')
  double get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_address')
  String? get shippingAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_city')
  String? get shippingCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_country')
  String? get shippingCountry => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_phone')
  String? get shippingPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'tracking_number')
  String? get trackingNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_delivery_date')
  DateTime? get estimatedDeliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_delivery_date')
  DateTime? get actualDeliveryDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipped_at')
  DateTime? get shippedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  Vehicle? get vehicle => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    String id,
    String userId,
    String vehicleId,
    @JsonKey(name: 'order_number') String? orderNumber,
    @OrderStatusConverter() OrderStatus status,
    @PaymentStatusConverter()
    @JsonKey(name: 'payment_status')
    PaymentStatus? paymentStatus,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @NumericStringConverter()
    @JsonKey(name: 'total_price_qar')
    double totalPrice,
    @JsonKey(name: 'shipping_address') String? shippingAddress,
    @JsonKey(name: 'shipping_city') String? shippingCity,
    @JsonKey(name: 'shipping_country') String? shippingCountry,
    @JsonKey(name: 'shipping_phone') String? shippingPhone,
    @JsonKey(name: 'tracking_number') String? trackingNumber,
    @JsonKey(name: 'estimated_delivery_date') DateTime? estimatedDeliveryDate,
    @JsonKey(name: 'actual_delivery_date') DateTime? actualDeliveryDate,
    String? notes,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    Vehicle? vehicle,
  });

  $VehicleCopyWith<$Res>? get vehicle;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? vehicleId = null,
    Object? orderNumber = freezed,
    Object? status = null,
    Object? paymentStatus = freezed,
    Object? paymentMethod = freezed,
    Object? totalPrice = null,
    Object? shippingAddress = freezed,
    Object? shippingCity = freezed,
    Object? shippingCountry = freezed,
    Object? shippingPhone = freezed,
    Object? trackingNumber = freezed,
    Object? estimatedDeliveryDate = freezed,
    Object? actualDeliveryDate = freezed,
    Object? notes = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledAt = freezed,
    Object? paidAt = freezed,
    Object? shippedAt = freezed,
    Object? deliveredAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? vehicle = freezed,
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
            vehicleId: null == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNumber: freezed == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as PaymentStatus?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            shippingAddress: freezed == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            shippingCity: freezed == shippingCity
                ? _value.shippingCity
                : shippingCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            shippingCountry: freezed == shippingCountry
                ? _value.shippingCountry
                : shippingCountry // ignore: cast_nullable_to_non_nullable
                      as String?,
            shippingPhone: freezed == shippingPhone
                ? _value.shippingPhone
                : shippingPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            trackingNumber: freezed == trackingNumber
                ? _value.trackingNumber
                : trackingNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedDeliveryDate: freezed == estimatedDeliveryDate
                ? _value.estimatedDeliveryDate
                : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            actualDeliveryDate: freezed == actualDeliveryDate
                ? _value.actualDeliveryDate
                : actualDeliveryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            shippedAt: freezed == shippedAt
                ? _value.shippedAt
                : shippedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliveredAt: freezed == deliveredAt
                ? _value.deliveredAt
                : deliveredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            vehicle: freezed == vehicle
                ? _value.vehicle
                : vehicle // ignore: cast_nullable_to_non_nullable
                      as Vehicle?,
          )
          as $Val,
    );
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleCopyWith<$Res>? get vehicle {
    if (_value.vehicle == null) {
      return null;
    }

    return $VehicleCopyWith<$Res>(_value.vehicle!, (value) {
      return _then(_value.copyWith(vehicle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String vehicleId,
    @JsonKey(name: 'order_number') String? orderNumber,
    @OrderStatusConverter() OrderStatus status,
    @PaymentStatusConverter()
    @JsonKey(name: 'payment_status')
    PaymentStatus? paymentStatus,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @NumericStringConverter()
    @JsonKey(name: 'total_price_qar')
    double totalPrice,
    @JsonKey(name: 'shipping_address') String? shippingAddress,
    @JsonKey(name: 'shipping_city') String? shippingCity,
    @JsonKey(name: 'shipping_country') String? shippingCountry,
    @JsonKey(name: 'shipping_phone') String? shippingPhone,
    @JsonKey(name: 'tracking_number') String? trackingNumber,
    @JsonKey(name: 'estimated_delivery_date') DateTime? estimatedDeliveryDate,
    @JsonKey(name: 'actual_delivery_date') DateTime? actualDeliveryDate,
    String? notes,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    Vehicle? vehicle,
  });

  @override
  $VehicleCopyWith<$Res>? get vehicle;
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? vehicleId = null,
    Object? orderNumber = freezed,
    Object? status = null,
    Object? paymentStatus = freezed,
    Object? paymentMethod = freezed,
    Object? totalPrice = null,
    Object? shippingAddress = freezed,
    Object? shippingCity = freezed,
    Object? shippingCountry = freezed,
    Object? shippingPhone = freezed,
    Object? trackingNumber = freezed,
    Object? estimatedDeliveryDate = freezed,
    Object? actualDeliveryDate = freezed,
    Object? notes = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledAt = freezed,
    Object? paidAt = freezed,
    Object? shippedAt = freezed,
    Object? deliveredAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? vehicle = freezed,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleId: null == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: freezed == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as PaymentStatus?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        shippingAddress: freezed == shippingAddress
            ? _value.shippingAddress
            : shippingAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        shippingCity: freezed == shippingCity
            ? _value.shippingCity
            : shippingCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        shippingCountry: freezed == shippingCountry
            ? _value.shippingCountry
            : shippingCountry // ignore: cast_nullable_to_non_nullable
                  as String?,
        shippingPhone: freezed == shippingPhone
            ? _value.shippingPhone
            : shippingPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackingNumber: freezed == trackingNumber
            ? _value.trackingNumber
            : trackingNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedDeliveryDate: freezed == estimatedDeliveryDate
            ? _value.estimatedDeliveryDate
            : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        actualDeliveryDate: freezed == actualDeliveryDate
            ? _value.actualDeliveryDate
            : actualDeliveryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        shippedAt: freezed == shippedAt
            ? _value.shippedAt
            : shippedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliveredAt: freezed == deliveredAt
            ? _value.deliveredAt
            : deliveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        vehicle: freezed == vehicle
            ? _value.vehicle
            : vehicle // ignore: cast_nullable_to_non_nullable
                  as Vehicle?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl({
    required this.id,
    required this.userId,
    required this.vehicleId,
    @JsonKey(name: 'order_number') this.orderNumber,
    @OrderStatusConverter() required this.status,
    @PaymentStatusConverter()
    @JsonKey(name: 'payment_status')
    this.paymentStatus,
    @JsonKey(name: 'payment_method') this.paymentMethod,
    @NumericStringConverter()
    @JsonKey(name: 'total_price_qar')
    required this.totalPrice,
    @JsonKey(name: 'shipping_address') this.shippingAddress,
    @JsonKey(name: 'shipping_city') this.shippingCity,
    @JsonKey(name: 'shipping_country') this.shippingCountry,
    @JsonKey(name: 'shipping_phone') this.shippingPhone,
    @JsonKey(name: 'tracking_number') this.trackingNumber,
    @JsonKey(name: 'estimated_delivery_date') this.estimatedDeliveryDate,
    @JsonKey(name: 'actual_delivery_date') this.actualDeliveryDate,
    this.notes,
    @JsonKey(name: 'cancellation_reason') this.cancellationReason,
    @JsonKey(name: 'cancelled_at') this.cancelledAt,
    @JsonKey(name: 'paid_at') this.paidAt,
    @JsonKey(name: 'shipped_at') this.shippedAt,
    @JsonKey(name: 'delivered_at') this.deliveredAt,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    this.vehicle,
  });

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String vehicleId;
  @override
  @JsonKey(name: 'order_number')
  final String? orderNumber;
  @override
  @OrderStatusConverter()
  final OrderStatus status;
  @override
  @PaymentStatusConverter()
  @JsonKey(name: 'payment_status')
  final PaymentStatus? paymentStatus;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  @NumericStringConverter()
  @JsonKey(name: 'total_price_qar')
  final double totalPrice;
  @override
  @JsonKey(name: 'shipping_address')
  final String? shippingAddress;
  @override
  @JsonKey(name: 'shipping_city')
  final String? shippingCity;
  @override
  @JsonKey(name: 'shipping_country')
  final String? shippingCountry;
  @override
  @JsonKey(name: 'shipping_phone')
  final String? shippingPhone;
  @override
  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;
  @override
  @JsonKey(name: 'estimated_delivery_date')
  final DateTime? estimatedDeliveryDate;
  @override
  @JsonKey(name: 'actual_delivery_date')
  final DateTime? actualDeliveryDate;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;
  @override
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;
  @override
  @JsonKey(name: 'shipped_at')
  final DateTime? shippedAt;
  @override
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  // Relations
  @override
  final Vehicle? vehicle;

  @override
  String toString() {
    return 'Order(id: $id, userId: $userId, vehicleId: $vehicleId, orderNumber: $orderNumber, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, totalPrice: $totalPrice, shippingAddress: $shippingAddress, shippingCity: $shippingCity, shippingCountry: $shippingCountry, shippingPhone: $shippingPhone, trackingNumber: $trackingNumber, estimatedDeliveryDate: $estimatedDeliveryDate, actualDeliveryDate: $actualDeliveryDate, notes: $notes, cancellationReason: $cancellationReason, cancelledAt: $cancelledAt, paidAt: $paidAt, shippedAt: $shippedAt, deliveredAt: $deliveredAt, createdAt: $createdAt, updatedAt: $updatedAt, vehicle: $vehicle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.shippingCity, shippingCity) ||
                other.shippingCity == shippingCity) &&
            (identical(other.shippingCountry, shippingCountry) ||
                other.shippingCountry == shippingCountry) &&
            (identical(other.shippingPhone, shippingPhone) ||
                other.shippingPhone == shippingPhone) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.estimatedDeliveryDate, estimatedDeliveryDate) ||
                other.estimatedDeliveryDate == estimatedDeliveryDate) &&
            (identical(other.actualDeliveryDate, actualDeliveryDate) ||
                other.actualDeliveryDate == actualDeliveryDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.shippedAt, shippedAt) ||
                other.shippedAt == shippedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    vehicleId,
    orderNumber,
    status,
    paymentStatus,
    paymentMethod,
    totalPrice,
    shippingAddress,
    shippingCity,
    shippingCountry,
    shippingPhone,
    trackingNumber,
    estimatedDeliveryDate,
    actualDeliveryDate,
    notes,
    cancellationReason,
    cancelledAt,
    paidAt,
    shippedAt,
    deliveredAt,
    createdAt,
    updatedAt,
    vehicle,
  ]);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(this);
  }
}

abstract class _Order implements Order {
  const factory _Order({
    required final String id,
    required final String userId,
    required final String vehicleId,
    @JsonKey(name: 'order_number') final String? orderNumber,
    @OrderStatusConverter() required final OrderStatus status,
    @PaymentStatusConverter()
    @JsonKey(name: 'payment_status')
    final PaymentStatus? paymentStatus,
    @JsonKey(name: 'payment_method') final String? paymentMethod,
    @NumericStringConverter()
    @JsonKey(name: 'total_price_qar')
    required final double totalPrice,
    @JsonKey(name: 'shipping_address') final String? shippingAddress,
    @JsonKey(name: 'shipping_city') final String? shippingCity,
    @JsonKey(name: 'shipping_country') final String? shippingCountry,
    @JsonKey(name: 'shipping_phone') final String? shippingPhone,
    @JsonKey(name: 'tracking_number') final String? trackingNumber,
    @JsonKey(name: 'estimated_delivery_date')
    final DateTime? estimatedDeliveryDate,
    @JsonKey(name: 'actual_delivery_date') final DateTime? actualDeliveryDate,
    final String? notes,
    @JsonKey(name: 'cancellation_reason') final String? cancellationReason,
    @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt,
    @JsonKey(name: 'paid_at') final DateTime? paidAt,
    @JsonKey(name: 'shipped_at') final DateTime? shippedAt,
    @JsonKey(name: 'delivered_at') final DateTime? deliveredAt,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    final Vehicle? vehicle,
  }) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get vehicleId;
  @override
  @JsonKey(name: 'order_number')
  String? get orderNumber;
  @override
  @OrderStatusConverter()
  OrderStatus get status;
  @override
  @PaymentStatusConverter()
  @JsonKey(name: 'payment_status')
  PaymentStatus? get paymentStatus;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  @NumericStringConverter()
  @JsonKey(name: 'total_price_qar')
  double get totalPrice;
  @override
  @JsonKey(name: 'shipping_address')
  String? get shippingAddress;
  @override
  @JsonKey(name: 'shipping_city')
  String? get shippingCity;
  @override
  @JsonKey(name: 'shipping_country')
  String? get shippingCountry;
  @override
  @JsonKey(name: 'shipping_phone')
  String? get shippingPhone;
  @override
  @JsonKey(name: 'tracking_number')
  String? get trackingNumber;
  @override
  @JsonKey(name: 'estimated_delivery_date')
  DateTime? get estimatedDeliveryDate;
  @override
  @JsonKey(name: 'actual_delivery_date')
  DateTime? get actualDeliveryDate;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;
  @override
  @JsonKey(name: 'shipped_at')
  DateTime? get shippedAt;
  @override
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // Relations
  @override
  Vehicle? get vehicle;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderStatusHistory _$OrderStatusHistoryFromJson(Map<String, dynamic> json) {
  return _OrderStatusHistory.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusHistory {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_url')
  String? get documentUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OrderStatusHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusHistoryCopyWith<OrderStatusHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusHistoryCopyWith<$Res> {
  factory $OrderStatusHistoryCopyWith(
    OrderStatusHistory value,
    $Res Function(OrderStatusHistory) then,
  ) = _$OrderStatusHistoryCopyWithImpl<$Res, OrderStatusHistory>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    OrderStatus status,
    String? location,
    String? notes,
    @JsonKey(name: 'document_url') String? documentUrl,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$OrderStatusHistoryCopyWithImpl<$Res, $Val extends OrderStatusHistory>
    implements $OrderStatusHistoryCopyWith<$Res> {
  _$OrderStatusHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? status = null,
    Object? location = freezed,
    Object? notes = freezed,
    Object? documentUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentUrl: freezed == documentUrl
                ? _value.documentUrl
                : documentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderStatusHistoryImplCopyWith<$Res>
    implements $OrderStatusHistoryCopyWith<$Res> {
  factory _$$OrderStatusHistoryImplCopyWith(
    _$OrderStatusHistoryImpl value,
    $Res Function(_$OrderStatusHistoryImpl) then,
  ) = __$$OrderStatusHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    OrderStatus status,
    String? location,
    String? notes,
    @JsonKey(name: 'document_url') String? documentUrl,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$OrderStatusHistoryImplCopyWithImpl<$Res>
    extends _$OrderStatusHistoryCopyWithImpl<$Res, _$OrderStatusHistoryImpl>
    implements _$$OrderStatusHistoryImplCopyWith<$Res> {
  __$$OrderStatusHistoryImplCopyWithImpl(
    _$OrderStatusHistoryImpl _value,
    $Res Function(_$OrderStatusHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? status = null,
    Object? location = freezed,
    Object? notes = freezed,
    Object? documentUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$OrderStatusHistoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentUrl: freezed == documentUrl
            ? _value.documentUrl
            : documentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusHistoryImpl implements _OrderStatusHistory {
  const _$OrderStatusHistoryImpl({
    required this.id,
    @JsonKey(name: 'order_id') required this.orderId,
    required this.status,
    this.location,
    this.notes,
    @JsonKey(name: 'document_url') this.documentUrl,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$OrderStatusHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderStatusHistoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  final OrderStatus status;
  @override
  final String? location;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'document_url')
  final String? documentUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'OrderStatusHistory(id: $id, orderId: $orderId, status: $status, location: $location, notes: $notes, documentUrl: $documentUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
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
    orderId,
    status,
    location,
    notes,
    documentUrl,
    createdAt,
    updatedAt,
  );

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusHistoryImplCopyWith<_$OrderStatusHistoryImpl> get copyWith =>
      __$$OrderStatusHistoryImplCopyWithImpl<_$OrderStatusHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusHistoryImplToJson(this);
  }
}

abstract class _OrderStatusHistory implements OrderStatusHistory {
  const factory _OrderStatusHistory({
    required final String id,
    @JsonKey(name: 'order_id') required final String orderId,
    required final OrderStatus status,
    final String? location,
    final String? notes,
    @JsonKey(name: 'document_url') final String? documentUrl,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$OrderStatusHistoryImpl;

  factory _OrderStatusHistory.fromJson(Map<String, dynamic> json) =
      _$OrderStatusHistoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  OrderStatus get status;
  @override
  String? get location;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'document_url')
  String? get documentUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusHistoryImplCopyWith<_$OrderStatusHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) {
  return _CreateOrderRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderRequest {
  String get vehicleId => throw _privateConstructorUsedError;
  @NumericStringConverter()
  @JsonKey(name: 'total_price_qar')
  double get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_address')
  String get shippingAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_city')
  String? get shippingCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_country')
  String? get shippingCountry => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_phone')
  String? get shippingPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CreateOrderRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateOrderRequestCopyWith<CreateOrderRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderRequestCopyWith<$Res> {
  factory $CreateOrderRequestCopyWith(
    CreateOrderRequest value,
    $Res Function(CreateOrderRequest) then,
  ) = _$CreateOrderRequestCopyWithImpl<$Res, CreateOrderRequest>;
  @useResult
  $Res call({
    String vehicleId,
    @NumericStringConverter()
    @JsonKey(name: 'total_price_qar')
    double totalPrice,
    @JsonKey(name: 'shipping_address') String shippingAddress,
    @JsonKey(name: 'shipping_city') String? shippingCity,
    @JsonKey(name: 'shipping_country') String? shippingCountry,
    @JsonKey(name: 'shipping_phone') String? shippingPhone,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    String? notes,
  });
}

/// @nodoc
class _$CreateOrderRequestCopyWithImpl<$Res, $Val extends CreateOrderRequest>
    implements $CreateOrderRequestCopyWith<$Res> {
  _$CreateOrderRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? totalPrice = null,
    Object? shippingAddress = null,
    Object? shippingCity = freezed,
    Object? shippingCountry = freezed,
    Object? shippingPhone = freezed,
    Object? paymentMethod = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            vehicleId: null == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            shippingAddress: null == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            shippingCity: freezed == shippingCity
                ? _value.shippingCity
                : shippingCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            shippingCountry: freezed == shippingCountry
                ? _value.shippingCountry
                : shippingCountry // ignore: cast_nullable_to_non_nullable
                      as String?,
            shippingPhone: freezed == shippingPhone
                ? _value.shippingPhone
                : shippingPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$CreateOrderRequestImplCopyWith<$Res>
    implements $CreateOrderRequestCopyWith<$Res> {
  factory _$$CreateOrderRequestImplCopyWith(
    _$CreateOrderRequestImpl value,
    $Res Function(_$CreateOrderRequestImpl) then,
  ) = __$$CreateOrderRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String vehicleId,
    @NumericStringConverter()
    @JsonKey(name: 'total_price_qar')
    double totalPrice,
    @JsonKey(name: 'shipping_address') String shippingAddress,
    @JsonKey(name: 'shipping_city') String? shippingCity,
    @JsonKey(name: 'shipping_country') String? shippingCountry,
    @JsonKey(name: 'shipping_phone') String? shippingPhone,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    String? notes,
  });
}

/// @nodoc
class __$$CreateOrderRequestImplCopyWithImpl<$Res>
    extends _$CreateOrderRequestCopyWithImpl<$Res, _$CreateOrderRequestImpl>
    implements _$$CreateOrderRequestImplCopyWith<$Res> {
  __$$CreateOrderRequestImplCopyWithImpl(
    _$CreateOrderRequestImpl _value,
    $Res Function(_$CreateOrderRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? totalPrice = null,
    Object? shippingAddress = null,
    Object? shippingCity = freezed,
    Object? shippingCountry = freezed,
    Object? shippingPhone = freezed,
    Object? paymentMethod = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$CreateOrderRequestImpl(
        vehicleId: null == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        shippingAddress: null == shippingAddress
            ? _value.shippingAddress
            : shippingAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        shippingCity: freezed == shippingCity
            ? _value.shippingCity
            : shippingCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        shippingCountry: freezed == shippingCountry
            ? _value.shippingCountry
            : shippingCountry // ignore: cast_nullable_to_non_nullable
                  as String?,
        shippingPhone: freezed == shippingPhone
            ? _value.shippingPhone
            : shippingPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$CreateOrderRequestImpl implements _CreateOrderRequest {
  const _$CreateOrderRequestImpl({
    required this.vehicleId,
    @NumericStringConverter()
    @JsonKey(name: 'total_price_qar')
    required this.totalPrice,
    @JsonKey(name: 'shipping_address') required this.shippingAddress,
    @JsonKey(name: 'shipping_city') this.shippingCity,
    @JsonKey(name: 'shipping_country') this.shippingCountry,
    @JsonKey(name: 'shipping_phone') this.shippingPhone,
    @JsonKey(name: 'payment_method') this.paymentMethod,
    this.notes,
  });

  factory _$CreateOrderRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrderRequestImplFromJson(json);

  @override
  final String vehicleId;
  @override
  @NumericStringConverter()
  @JsonKey(name: 'total_price_qar')
  final double totalPrice;
  @override
  @JsonKey(name: 'shipping_address')
  final String shippingAddress;
  @override
  @JsonKey(name: 'shipping_city')
  final String? shippingCity;
  @override
  @JsonKey(name: 'shipping_country')
  final String? shippingCountry;
  @override
  @JsonKey(name: 'shipping_phone')
  final String? shippingPhone;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CreateOrderRequest(vehicleId: $vehicleId, totalPrice: $totalPrice, shippingAddress: $shippingAddress, shippingCity: $shippingCity, shippingCountry: $shippingCountry, shippingPhone: $shippingPhone, paymentMethod: $paymentMethod, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderRequestImpl &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.shippingCity, shippingCity) ||
                other.shippingCity == shippingCity) &&
            (identical(other.shippingCountry, shippingCountry) ||
                other.shippingCountry == shippingCountry) &&
            (identical(other.shippingPhone, shippingPhone) ||
                other.shippingPhone == shippingPhone) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    vehicleId,
    totalPrice,
    shippingAddress,
    shippingCity,
    shippingCountry,
    shippingPhone,
    paymentMethod,
    notes,
  );

  /// Create a copy of CreateOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderRequestImplCopyWith<_$CreateOrderRequestImpl> get copyWith =>
      __$$CreateOrderRequestImplCopyWithImpl<_$CreateOrderRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderRequestImplToJson(this);
  }
}

abstract class _CreateOrderRequest implements CreateOrderRequest {
  const factory _CreateOrderRequest({
    required final String vehicleId,
    @NumericStringConverter()
    @JsonKey(name: 'total_price_qar')
    required final double totalPrice,
    @JsonKey(name: 'shipping_address') required final String shippingAddress,
    @JsonKey(name: 'shipping_city') final String? shippingCity,
    @JsonKey(name: 'shipping_country') final String? shippingCountry,
    @JsonKey(name: 'shipping_phone') final String? shippingPhone,
    @JsonKey(name: 'payment_method') final String? paymentMethod,
    final String? notes,
  }) = _$CreateOrderRequestImpl;

  factory _CreateOrderRequest.fromJson(Map<String, dynamic> json) =
      _$CreateOrderRequestImpl.fromJson;

  @override
  String get vehicleId;
  @override
  @NumericStringConverter()
  @JsonKey(name: 'total_price_qar')
  double get totalPrice;
  @override
  @JsonKey(name: 'shipping_address')
  String get shippingAddress;
  @override
  @JsonKey(name: 'shipping_city')
  String? get shippingCity;
  @override
  @JsonKey(name: 'shipping_country')
  String? get shippingCountry;
  @override
  @JsonKey(name: 'shipping_phone')
  String? get shippingPhone;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  String? get notes;

  /// Create a copy of CreateOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrderRequestImplCopyWith<_$CreateOrderRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderFilter _$OrderFilterFromJson(Map<String, dynamic> json) {
  return _OrderFilter.fromJson(json);
}

/// @nodoc
mixin _$OrderFilter {
  OrderStatus? get status => throw _privateConstructorUsedError;
  PaymentStatus? get paymentStatus => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool? get activeOnly => throw _privateConstructorUsedError;

  /// Serializes this OrderFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderFilterCopyWith<OrderFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderFilterCopyWith<$Res> {
  factory $OrderFilterCopyWith(
    OrderFilter value,
    $Res Function(OrderFilter) then,
  ) = _$OrderFilterCopyWithImpl<$Res, OrderFilter>;
  @useResult
  $Res call({
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    bool? activeOnly,
  });
}

/// @nodoc
class _$OrderFilterCopyWithImpl<$Res, $Val extends OrderFilter>
    implements $OrderFilterCopyWith<$Res> {
  _$OrderFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? paymentStatus = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? activeOnly = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus?,
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as PaymentStatus?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            activeOnly: freezed == activeOnly
                ? _value.activeOnly
                : activeOnly // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderFilterImplCopyWith<$Res>
    implements $OrderFilterCopyWith<$Res> {
  factory _$$OrderFilterImplCopyWith(
    _$OrderFilterImpl value,
    $Res Function(_$OrderFilterImpl) then,
  ) = __$$OrderFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    bool? activeOnly,
  });
}

/// @nodoc
class __$$OrderFilterImplCopyWithImpl<$Res>
    extends _$OrderFilterCopyWithImpl<$Res, _$OrderFilterImpl>
    implements _$$OrderFilterImplCopyWith<$Res> {
  __$$OrderFilterImplCopyWithImpl(
    _$OrderFilterImpl _value,
    $Res Function(_$OrderFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? paymentStatus = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? activeOnly = freezed,
  }) {
    return _then(
      _$OrderFilterImpl(
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus?,
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as PaymentStatus?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        activeOnly: freezed == activeOnly
            ? _value.activeOnly
            : activeOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderFilterImpl implements _OrderFilter {
  const _$OrderFilterImpl({
    this.status,
    this.paymentStatus,
    this.startDate,
    this.endDate,
    this.activeOnly,
  });

  factory _$OrderFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderFilterImplFromJson(json);

  @override
  final OrderStatus? status;
  @override
  final PaymentStatus? paymentStatus;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final bool? activeOnly;

  @override
  String toString() {
    return 'OrderFilter(status: $status, paymentStatus: $paymentStatus, startDate: $startDate, endDate: $endDate, activeOnly: $activeOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderFilterImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.activeOnly, activeOnly) ||
                other.activeOnly == activeOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    paymentStatus,
    startDate,
    endDate,
    activeOnly,
  );

  /// Create a copy of OrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderFilterImplCopyWith<_$OrderFilterImpl> get copyWith =>
      __$$OrderFilterImplCopyWithImpl<_$OrderFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderFilterImplToJson(this);
  }
}

abstract class _OrderFilter implements OrderFilter {
  const factory _OrderFilter({
    final OrderStatus? status,
    final PaymentStatus? paymentStatus,
    final DateTime? startDate,
    final DateTime? endDate,
    final bool? activeOnly,
  }) = _$OrderFilterImpl;

  factory _OrderFilter.fromJson(Map<String, dynamic> json) =
      _$OrderFilterImpl.fromJson;

  @override
  OrderStatus? get status;
  @override
  PaymentStatus? get paymentStatus;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  bool? get activeOnly;

  /// Create a copy of OrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderFilterImplCopyWith<_$OrderFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
