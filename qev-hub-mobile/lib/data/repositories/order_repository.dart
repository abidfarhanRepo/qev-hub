import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order.dart';
import '../models/vehicle.dart';

/// Order repository interface
abstract class OrderRepository {
  Future<Order> createOrder(CreateOrderRequest request);
  Future<List<Order>> getUserOrders({OrderFilter? filter});
  Future<Order?> getOrderById(String id);
  Future<void> cancelOrder(String id, {String? reason});
  Future<void> updateOrderStatus(String id, OrderStatus status);
  Future<List<Order>> getActiveOrders();
  Future<List<Order>> getPastOrders();
  Future<List<OrderStatusHistory>> getOrderStatusHistory(String orderId);
}

/// Supabase implementation of OrderRepository
class SupabaseOrderRepository implements OrderRepository {
  final SupabaseClient _client;
  static int _orderCounter = 0;

  SupabaseOrderRepository(this._client);

  @override
  Future<Order> createOrder(CreateOrderRequest request) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Generate order number
      final orderNumber = 'ORD-${DateTime.now().year}-${(++_orderCounter).toString().padLeft(6, '0')}';

      // Check vehicle availability
      final vehicleCheck = await _client
          .from('vehicles')
          .select('id, status, stock_count')
          .eq('id', request.vehicleId)
          .single();

      if (vehicleCheck == null) {
        throw Exception('Vehicle not found');
      }

      final vehicleStatus = vehicleCheck['status'] as String?;
      final stockCount = vehicleCheck['stock_count'] as int?;

      if (vehicleStatus == 'sold_out' || (stockCount != null && stockCount <= 0)) {
        throw Exception('Vehicle is out of stock');
      }

      // Create the order
      final response = await _client.from('orders').insert({
        'user_id': userId,
        'vehicle_id': request.vehicleId,
        'order_number': orderNumber,
        'status': 'pending',
        'payment_status': 'pending',
        'total_price_qar': request.totalPrice,
        'shipping_address': request.shippingAddress,
        'shipping_city': request.shippingCity,
        'shipping_country': request.shippingCountry ?? 'Qatar',
        'shipping_phone': request.shippingPhone,
        'payment_method': request.paymentMethod,
        'notes': request.notes,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).select().single();

      if (response == null) {
        throw Exception('Failed to create order');
      }

      // Add initial status history entry
      await _client.from('order_status_history').insert({
        'order_id': response['id'],
        'status': 'pending',
        'location': 'Order Processing',
        'notes': 'Order placed successfully',
      });

      // Fetch the order with relations
      final orderWithRelations = await _client
          .from('orders')
          .select('''
            *,
            vehicle:vehicles(*)
          ''')
          .eq('id', response['id'])
          .single();

      return Order.fromJson(orderWithRelations as Map<String, dynamic>);
    } catch (e) {
      print('🔴 ERROR creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<List<Order>> getUserOrders({OrderFilter? filter}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('🔵 Loading orders for user: $userId');

      // Build query - first fetch orders without vehicle relation
      var query = _client
          .from('orders')
          .select('*')
          .eq('user_id', userId);

      // Apply filters
      if (filter != null) {
        if (filter.status != null) {
          final statusValue = _orderStatusToString(filter.status!);
          query = query.eq('status', statusValue);
        }

        if (filter.paymentStatus != null) {
          final paymentStatusValue = _paymentStatusToString(filter.paymentStatus!);
          query = query.eq('payment_status', paymentStatusValue);
        }

        if (filter.startDate != null) {
          query = query.gte('created_at', filter.startDate!.toUtc().toIso8601String());
        }

        if (filter.endDate != null) {
          query = query.lte('created_at', filter.endDate!.toUtc().toIso8601String());
        }

        if (filter.activeOnly == true) {
          query = query.inFilter('status', [
            'pending',
            'confirmed',
            'processing',
            'shipped',
            'in_transit',
            'in_customs',
            'fahes_inspection',
            'insurance_pending',
            'delivery',
          ]);
        }
      }

      final response = await query.order('created_at', ascending: false);

      print('📊 Received ${response.length} orders from DB');

      return (response as List)
          .map((json) {
            final data = json as Map<String, dynamic>;
            print('🔍 Order JSON: $data');
            return Order.fromJson(data);
          })
          .toList();
    } catch (e) {
      print('❌ ERROR fetching orders: $e');
      return [];
    }
  }

  @override
  Future<Order?> getOrderById(String id) async {
    try {
      final response = await _client
          .from('orders')
          .select('''
            *,
            vehicle:vehicles(*)
          ''')
          .eq('id', id)
          .single();

      if (response == null) return null;

      return Order.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

  @override
  Future<void> cancelOrder(String id, {String? reason}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updateData = <String, dynamic>{
        'status': 'cancelled',
        'cancellation_reason': reason,
        'cancelled_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      await _client.from('orders').update(updateData).eq('id', id).eq('user_id', userId);

      // Add status history entry
      await _client.from('order_status_history').insert({
        'order_id': id,
        'status': 'cancelled',
        'location': 'Order Cancelled',
        'notes': reason ?? 'Cancelled by user',
      });
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(String id, OrderStatus status) async {
    try {
      final updateData = <String, dynamic>{
        'status': _orderStatusToString(status),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      // Add timestamps based on status
      switch (status) {
        case OrderStatus.confirmed:
        case OrderStatus.processing:
          // When confirmed, mark as paid
          updateData['payment_status'] = 'paid';
          updateData['paid_at'] = DateTime.now().toUtc().toIso8601String();
          break;
        case OrderStatus.shipped:
        case OrderStatus.inTransit:
          updateData['shipped_at'] = DateTime.now().toUtc().toIso8601String();
          break;
        case OrderStatus.delivered:
        case OrderStatus.completed:
          updateData['delivered_at'] = DateTime.now().toUtc().toIso8601String();
          updateData['actual_delivery_date'] = DateTime.now().toIso8601String().split('T')[0];
          break;
        default:
          break;
      }

      await _client.from('orders').update(updateData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Future<List<Order>> getActiveOrders() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('🔵 Loading active orders for user: $userId');

      final response = await _client
          .from('orders')
          .select('*')
          .eq('user_id', userId)
          .inFilter('status', [
            'pending',
            'confirmed',
            'processing',
            'shipped',
            'in_transit',
            'in_customs',
            'fahes_inspection',
            'insurance_pending',
            'delivery',
            'delivered',
          ])
          .order('created_at', ascending: false);

      print('📊 Received ${response.length} orders from DB');

      return (response as List)
          .map((json) {
            final data = json as Map<String, dynamic>;
            print('🔍 Order JSON: $data');
            try {
              return Order.fromJson(data);
            } catch (e) {
              print('❌ Error parsing order: $e');
              print('❌ Order data: $data');
              rethrow;
            }
          })
          .toList();
    } catch (e) {
      print('❌ ERROR fetching active orders: $e');
      return [];
    }
  }

  @override
  Future<List<Order>> getPastOrders() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('🔵 Loading past orders for user: $userId');

      final response = await _client
          .from('orders')
          .select('*')
          .eq('user_id', userId)
          .inFilter('status', ['completed', 'cancelled'])
          .order('created_at', ascending: false);

      print('📊 Received ${response.length} past orders from DB');

      return (response as List)
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ ERROR fetching past orders: $e');
      return [];
    }
  }

  @override
  Future<List<OrderStatusHistory>> getOrderStatusHistory(String orderId) async {
    try {
      final response = await _client
          .from('order_status_history')
          .select('*')
          .eq('order_id', orderId)
          .order('created_at', ascending: true);

      if (response == null) return [];

      return (response as List)
          .map((json) {
            // Convert status string to OrderStatus enum
            final statusStr = json['status'] as String;
            final status = _stringToOrderStatus(statusStr);

            return OrderStatusHistory(
              id: json['id'] as String,
              orderId: json['order_id'] as String,
              status: status,
              location: json['location'] as String?,
              notes: json['notes'] as String?,
              documentUrl: json['document_url'] as String?,
              createdAt: DateTime.parse(json['created_at'] as String),
              updatedAt: DateTime.parse(json['updated_at'] as String),
            );
          })
          .toList();
    } catch (e) {
      print('Error fetching order status history: $e');
      return [];
    }
  }

  /// Convert OrderStatus enum to database string value
  String _orderStatusToString(OrderStatus status) {
    switch (status) {
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

  /// Convert database string to OrderStatus enum
  OrderStatus _stringToOrderStatus(String status) {
    switch (status.toLowerCase()) {
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

  /// Convert PaymentStatus enum to database string value
  String _paymentStatusToString(PaymentStatus status) {
    switch (status) {
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
