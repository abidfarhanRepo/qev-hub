import 'package:freezed_annotation/freezed_annotation.dart';
import 'vehicle.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// Custom converter for numeric fields that might be strings
class NumericStringConverter implements JsonConverter<double, dynamic> {
  const NumericStringConverter();

  @override
  double fromJson(dynamic json) {
    if (json == null) {
      return 0.0;
    }
    if (json is double) {
      return json;
    }
    if (json is int) {
      return json.toDouble();
    }
    if (json is String) {
      return double.parse(json);
    }
    if (json is num) {
      return json.toDouble();
    }
    return 0.0;
  }

  @override
  String toJson(double object) => object.toString();
}

/// Order status enum
enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('processing')
  processing,
  @JsonValue('shipped')
  shipped,
  @JsonValue('in_transit')
  inTransit,
  @JsonValue('in_customs')
  inCustoms,
  @JsonValue('fahes_inspection')
  fahesInspection,
  @JsonValue('insurance_pending')
  insurancePending,
  @JsonValue('delivery')
  delivery,
  @JsonValue('delivered')
  delivered,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

/// Converter for OrderStatus enum
class OrderStatusConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();

  @override
  OrderStatus fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'in_transit':
        return OrderStatus.inTransit;
      case 'in_customs':
        return OrderStatus.inCustoms;
      case 'fahes_inspection':
        return OrderStatus.fahesInspection;
      case 'insurance_pending':
        return OrderStatus.insurancePending;
      case 'delivery':
        return OrderStatus.delivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  @override
  String toJson(OrderStatus object) {
    switch (object) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.inTransit:
        return 'in_transit';
      case OrderStatus.inCustoms:
        return 'in_customs';
      case OrderStatus.fahesInspection:
        return 'fahes_inspection';
      case OrderStatus.insurancePending:
        return 'insurance_pending';
      case OrderStatus.delivery:
        return 'delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}

/// Payment status enum
enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('paid')
  paid,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
}

/// Converter for PaymentStatus enum
class PaymentStatusConverter implements JsonConverter<PaymentStatus, String> {
  const PaymentStatusConverter();

  @override
  PaymentStatus fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  @override
  String toJson(PaymentStatus object) {
    switch (object) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.processing:
        return 'processing';
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }
}

/// Order model
@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    required String vehicleId,
    @JsonKey(name: 'order_number') String? orderNumber,
    @OrderStatusConverter() required OrderStatus status,
    @PaymentStatusConverter() @JsonKey(name: 'payment_status') PaymentStatus? paymentStatus,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @NumericStringConverter() @JsonKey(name: 'total_price_qar') required double totalPrice,
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
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Relations
    Vehicle? vehicle,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

/// Order status history timeline entry
@freezed
class OrderStatusHistory with _$OrderStatusHistory {
  const factory OrderStatusHistory({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    required OrderStatus status,
    String? location,
    String? notes,
    @JsonKey(name: 'document_url') String? documentUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _OrderStatusHistory;

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryFromJson(json);
}

/// Create order request model
@freezed
class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({
    required String vehicleId,
    @NumericStringConverter() @JsonKey(name: 'total_price_qar') required double totalPrice,
    @JsonKey(name: 'shipping_address') required String shippingAddress,
    @JsonKey(name: 'shipping_city') String? shippingCity,
    @JsonKey(name: 'shipping_country') String? shippingCountry,
    @JsonKey(name: 'shipping_phone') String? shippingPhone,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    String? notes,
  }) = _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
}

/// Order filter model
@freezed
class OrderFilter with _$OrderFilter {
  const factory OrderFilter({
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    bool? activeOnly,
  }) = _OrderFilter;

  factory OrderFilter.fromJson(Map<String, dynamic> json) =>
      _$OrderFilterFromJson(json);
}
