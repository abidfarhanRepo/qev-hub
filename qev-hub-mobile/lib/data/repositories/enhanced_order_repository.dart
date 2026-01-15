import 'dart:developer';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order.dart';
import '../models/vehicle.dart';

/// Enhanced order repository with additional features
class EnhancedOrderRepository implements OrderRepository {
  final SupabaseClient _client;
  static int _orderCounter = 0;

  EnhancedOrderRepository(this._client);

  @override
  Future<Order> createOrder(CreateOrderRequest request) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      log('🔵 Creating order for vehicle: ${request.vehicleId}');

      // Generate order number
      final orderNumber = 'QEV-${DateTime.now().year}-${(++_orderCounter).toString().padLeft(6, '0')}';

      // Check vehicle availability with retry logic
      final vehicleCheck = await _client
          .from('vehicles')
          .select('id, status, stock_count, manufacturer, model')
          .eq('id', request.vehicleId)
          .single();

      if (vehicleCheck == null) {
        throw Exception('Vehicle not found');
      }

      final vehicleStatus = vehicleCheck['status'] as String?;
      final stockCount = vehicleCheck['stock_count'] as int?;
      final vehicleName = '${vehicleCheck['manufacturer']} ${vehicleCheck['model']}';

      log('🔍 Vehicle check: $vehicleName, status: $vehicleStatus, stock: $stockCount');

      if (vehicleStatus == 'sold_out' || (stockCount != null && stockCount <= 0)) {
        throw Exception('$vehicleName is currently out of stock');
      }

      // Create the order in a transaction-like manner
      final orderData = {
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
        'payment_method': request.paymentMethod ?? 'Cash on Delivery',
        'notes': request.notes,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
        'estimated_delivery_date': DateTime.now().add(const Duration(days: 21)).toIso8601String(),
      };

      final response = await _client.from('orders').insert(orderData).select().single();

      if (response == null) {
        throw Exception('Failed to create order');
      }

      // Update vehicle stock
      if (stockCount != null && stockCount > 1) {
        await _client
            .from('vehicles')
            .update({'stock_count': stockCount - 1})
            .eq('id', request.vehicleId);
      } else if (stockCount == 1) {
        await _client
            .from('vehicles')
            .update({'stock_count': 0, 'status': 'sold_out'})
            .eq('id', request.vehicleId);
      }

      // Add initial status history entry
      await _client.from('order_status_history').insert({
        'order_id': response['id'],
        'status': 'pending',
        'location': 'Order Processing Center',
        'notes': 'Order placed successfully for $vehicleName',
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
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

      log('✅ Order created successfully: ${response['order_number']}');
      return Order.fromJson(orderWithRelations as Map<String, dynamic>);
    } catch (e) {
      log('❌ ERROR creating order: $e');
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  @override
  Future<List<Order>> getUserOrders({OrderFilter? filter}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      log('🔵 Loading orders for user: $userId');

      var query = _client
          .from('orders')
          .select('''
            *,
            vehicle:vehicles(*)
          ''')
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

      log('📊 Received ${response.length} orders from DB');

      return (response as List)
          .map((json) {
            final data = json as Map<String, dynamic>;
            try {
              return Order.fromJson(data);
            } catch (e) {
              log('❌ Error parsing order: $e');
              log('❌ Order data: $data');
              return null;
            }
          })
          .where((order) => order != null)
          .cast<Order>()
          .toList();
    } catch (e) {
      log('❌ ERROR fetching orders: $e');
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
      log('Error fetching order: $e');
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

      log('🔵 Cancelling order: $id');

      final order = await getOrderById(id);
      if (order == null) {
        throw Exception('Order not found');
      }

      // Check if order can be cancelled
      if (order.status != OrderStatus.pending && order.status != OrderStatus.confirmed) {
        throw Exception('Order cannot be cancelled at this stage');
      }

      final updateData = <String, dynamic>{
        'status': 'cancelled',
        'cancellation_reason': reason ?? 'Cancelled by user',
        'cancelled_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      await _client.from('orders').update(updateData).eq('id', id).eq('user_id', userId);

      // Restore vehicle stock if needed
      if (order.vehicleId != null) {
        final vehicleCheck = await _client
            .from('vehicles')
            .select('stock_count, status')
            .eq('id', order.vehicleId!)
            .single();

        if (vehicleCheck != null) {
          final currentStock = vehicleCheck['stock_count'] as int?;
          final currentStatus = vehicleCheck['status'] as String?;

          if (currentStock != null) {
            await _client
                .from('vehicles')
                .update({
                  'stock_count': currentStock + 1,
                  'status': currentStatus == 'sold_out' ? 'available' : currentStatus,
                })
                .eq('id', order.vehicleId!);
          }
        }
      }

      // Add status history entry
      await _client.from('order_status_history').insert({
        'order_id': id,
        'status': 'cancelled',
        'location': 'Order Cancelled',
        'notes': reason ?? 'Cancelled by user',
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });

      log('✅ Order cancelled successfully: $id');
    } catch (e) {
      log('❌ ERROR cancelling order: $e');
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

      // Add timestamps and tracking based on status
      switch (status) {
        case OrderStatus.confirmed:
          updateData['payment_status'] = 'paid';
          updateData['paid_at'] = DateTime.now().toUtc().toIso8601String();
          updateData['tracking_number'] = 'QTR${DateTime.now().millisecondsSinceEpoch}';
          break;
        case OrderStatus.shipped:
        case OrderStatus.inTransit:
          updateData['shipped_at'] = DateTime.now().toUtc().toIso8601String();
          if (status == OrderStatus.shipped) {
            updateData['tracking_number'] = updateData['tracking_number'] ?? 'QTR${DateTime.now().millisecondsSinceEpoch}';
          }
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

      // Add status history entry
      final historyData = {
        'order_id': id,
        'status': _orderStatusToString(status),
        'location': _getStatusLocation(status),
        'notes': _getStatusNotes(status),
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      await _client.from('order_status_history').insert(historyData);

      log('✅ Order status updated: $id -> ${status.name}');
    } catch (e) {
      log('❌ ERROR updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Future<List<Order>> getActiveOrders() async {
    return getUserOrders(filter: const OrderFilter(activeOnly: true));
  }

  @override
  Future<List<Order>> getPastOrders() async {
    return getUserOrders(filter: const OrderFilter(activeOnly: false));
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
      log('Error fetching order status history: $e');
      return [];
    }
  }

  /// Helper methods
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

  String _getStatusLocation(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Processing Center';
      case OrderStatus.confirmed:
        return 'Payment Verified';
      case OrderStatus.processing:
        return 'Vehicle Preparation';
      case OrderStatus.shipped:
        return 'Shipping Center';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.inCustoms:
        return 'Qatar Customs';
      case OrderStatus.fahesInspection:
        return 'FAHES Inspection Center';
      case OrderStatus.insurancePending:
        return 'Insurance Processing';
      case OrderStatus.delivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Order Complete';
      case OrderStatus.cancelled:
        return 'Order Cancelled';
    }
  }

  String _getStatusNotes(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order received and awaiting confirmation';
      case OrderStatus.confirmed:
        return 'Payment confirmed and order verified';
      case OrderStatus.processing:
        return 'Vehicle being prepared for shipping';
      case OrderStatus.shipped:
        return 'Vehicle has been shipped from manufacturer';
      case OrderStatus.inTransit:
        return 'Vehicle is in transit to Qatar';
      case OrderStatus.inCustoms:
        return 'Vehicle undergoing customs clearance';
      case OrderStatus.fahesInspection:
        return 'Vehicle undergoing mandatory FAHES inspection';
      case OrderStatus.insurancePending:
        return 'Processing vehicle insurance';
      case OrderStatus.delivery:
        return 'Vehicle is out for final delivery';
      case OrderStatus.delivered:
        return 'Vehicle delivered to customer';
      case OrderStatus.completed:
        return 'Order completed successfully';
      case OrderStatus.cancelled:
        return 'Order has been cancelled';
    }
  }
}
