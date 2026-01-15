// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  vehicleId: json['vehicleId'] as String,
  orderNumber: json['order_number'] as String?,
  status: const OrderStatusConverter().fromJson(json['status'] as String),
  paymentStatus: _$JsonConverterFromJson<String, PaymentStatus>(
    json['payment_status'],
    const PaymentStatusConverter().fromJson,
  ),
  paymentMethod: json['payment_method'] as String?,
  totalPrice: const NumericStringConverter().fromJson(json['total_price_qar']),
  shippingAddress: json['shipping_address'] as String?,
  shippingCity: json['shipping_city'] as String?,
  shippingCountry: json['shipping_country'] as String?,
  shippingPhone: json['shipping_phone'] as String?,
  trackingNumber: json['tracking_number'] as String?,
  estimatedDeliveryDate: json['estimated_delivery_date'] == null
      ? null
      : DateTime.parse(json['estimated_delivery_date'] as String),
  actualDeliveryDate: json['actual_delivery_date'] == null
      ? null
      : DateTime.parse(json['actual_delivery_date'] as String),
  notes: json['notes'] as String?,
  cancellationReason: json['cancellation_reason'] as String?,
  cancelledAt: json['cancelled_at'] == null
      ? null
      : DateTime.parse(json['cancelled_at'] as String),
  paidAt: json['paid_at'] == null
      ? null
      : DateTime.parse(json['paid_at'] as String),
  shippedAt: json['shipped_at'] == null
      ? null
      : DateTime.parse(json['shipped_at'] as String),
  deliveredAt: json['delivered_at'] == null
      ? null
      : DateTime.parse(json['delivered_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  vehicle: json['vehicle'] == null
      ? null
      : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$OrderImplToJson(
  _$OrderImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'vehicleId': instance.vehicleId,
  'order_number': instance.orderNumber,
  'status': const OrderStatusConverter().toJson(instance.status),
  'payment_status': _$JsonConverterToJson<String, PaymentStatus>(
    instance.paymentStatus,
    const PaymentStatusConverter().toJson,
  ),
  'payment_method': instance.paymentMethod,
  'total_price_qar': const NumericStringConverter().toJson(instance.totalPrice),
  'shipping_address': instance.shippingAddress,
  'shipping_city': instance.shippingCity,
  'shipping_country': instance.shippingCountry,
  'shipping_phone': instance.shippingPhone,
  'tracking_number': instance.trackingNumber,
  'estimated_delivery_date': instance.estimatedDeliveryDate?.toIso8601String(),
  'actual_delivery_date': instance.actualDeliveryDate?.toIso8601String(),
  'notes': instance.notes,
  'cancellation_reason': instance.cancellationReason,
  'cancelled_at': instance.cancelledAt?.toIso8601String(),
  'paid_at': instance.paidAt?.toIso8601String(),
  'shipped_at': instance.shippedAt?.toIso8601String(),
  'delivered_at': instance.deliveredAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'vehicle': instance.vehicle,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_$OrderStatusHistoryImpl _$$OrderStatusHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$OrderStatusHistoryImpl(
  id: json['id'] as String,
  orderId: json['order_id'] as String,
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  location: json['location'] as String?,
  notes: json['notes'] as String?,
  documentUrl: json['document_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$OrderStatusHistoryImplToJson(
  _$OrderStatusHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.orderId,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'location': instance.location,
  'notes': instance.notes,
  'document_url': instance.documentUrl,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.inTransit: 'in_transit',
  OrderStatus.inCustoms: 'in_customs',
  OrderStatus.fahesInspection: 'fahes_inspection',
  OrderStatus.insurancePending: 'insurance_pending',
  OrderStatus.delivery: 'delivery',
  OrderStatus.delivered: 'delivered',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

_$CreateOrderRequestImpl _$$CreateOrderRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateOrderRequestImpl(
  vehicleId: json['vehicleId'] as String,
  totalPrice: const NumericStringConverter().fromJson(json['total_price_qar']),
  shippingAddress: json['shipping_address'] as String,
  shippingCity: json['shipping_city'] as String?,
  shippingCountry: json['shipping_country'] as String?,
  shippingPhone: json['shipping_phone'] as String?,
  paymentMethod: json['payment_method'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$CreateOrderRequestImplToJson(
  _$CreateOrderRequestImpl instance,
) => <String, dynamic>{
  'vehicleId': instance.vehicleId,
  'total_price_qar': const NumericStringConverter().toJson(instance.totalPrice),
  'shipping_address': instance.shippingAddress,
  'shipping_city': instance.shippingCity,
  'shipping_country': instance.shippingCountry,
  'shipping_phone': instance.shippingPhone,
  'payment_method': instance.paymentMethod,
  'notes': instance.notes,
};

_$OrderFilterImpl _$$OrderFilterImplFromJson(Map<String, dynamic> json) =>
    _$OrderFilterImpl(
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']),
      paymentStatus: $enumDecodeNullable(
        _$PaymentStatusEnumMap,
        json['paymentStatus'],
      ),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      activeOnly: json['activeOnly'] as bool?,
    );

Map<String, dynamic> _$$OrderFilterImplToJson(_$OrderFilterImpl instance) =>
    <String, dynamic>{
      'status': _$OrderStatusEnumMap[instance.status],
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus],
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'activeOnly': instance.activeOnly,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};
