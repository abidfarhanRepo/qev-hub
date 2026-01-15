import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/order.dart';
import '../../../../data/repositories/order_repository.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for OrderRepository
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseOrderRepository(client);
});

/// Provider for active orders
final activeOrdersProvider =
    StateNotifierProvider<ActiveOrdersNotifier, AsyncValue<List<Order>>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return ActiveOrdersNotifier(repository);
});

/// Provider for past orders
final pastOrdersProvider =
    StateNotifierProvider<PastOrdersNotifier, AsyncValue<List<Order>>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return PastOrdersNotifier(repository);
});

/// Provider for a single order by ID
final orderProvider = FutureProvider.family<Order?, String>((ref, id) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getOrderById(id);
});

/// Provider for order status history
final orderStatusHistoryProvider =
    FutureProvider.family<List<OrderStatusHistory>, String>((ref, orderId) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getOrderStatusHistory(orderId);
});

/// Notifier for active orders
class ActiveOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderRepository _repository;

  ActiveOrdersNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    print('🔵 [ActiveOrdersNotifier] Loading active orders...');
    state = const AsyncValue.loading();

    try {
      final orders = await _repository.getActiveOrders();
      print('📊 [ActiveOrdersNotifier] Loaded ${orders.length} active orders');
      state = AsyncValue.data(orders);
    } catch (e, st) {
      print('❌ [ActiveOrdersNotifier] ERROR: $e');
      print('❌ [ActiveOrdersNotifier] Stack: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    print('🔄 [ActiveOrdersNotifier] Refreshing...');
    await _loadOrders();
  }

  Future<bool> cancelOrder(String orderId, String reason) async {
    print('🔵 [ActiveOrdersNotifier] Cancelling order $orderId');
    try {
      await _repository.cancelOrder(orderId, reason: reason);
      await _loadOrders();
      return true;
    } catch (e) {
      print('❌ [ActiveOrdersNotifier] Failed to cancel: $e');
      return false;
    }
  }
}

/// Notifier for past orders
class PastOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderRepository _repository;

  PastOrdersNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    print('🔵 [PastOrdersNotifier] Loading past orders...');
    state = const AsyncValue.loading();

    try {
      final orders = await _repository.getPastOrders();
      print('📊 [PastOrdersNotifier] Loaded ${orders.length} past orders');
      state = AsyncValue.data(orders);
    } catch (e, st) {
      print('❌ [PastOrdersNotifier] ERROR: $e');
      print('❌ [PastOrdersNotifier] Stack: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    print('🔄 [PastOrdersNotifier] Refreshing...');
    await _loadOrders();
  }
}

/// Notifier for creating an order
class CreateOrderNotifier extends StateNotifier<AsyncValue<Order?>> {
  final OrderRepository _repository;

  CreateOrderNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<bool> createOrder(CreateOrderRequest request) async {
    print('🔵 [CreateOrderNotifier] Creating order for vehicle: ${request.vehicleId}');
    state = const AsyncValue.loading();

    try {
      final order = await _repository.createOrder(request);
      print('✅ [CreateOrderNotifier] Order created: ${order.id}');
      state = AsyncValue.data(order);
      return true;
    } catch (e, st) {
      print('❌ [CreateOrderNotifier] ERROR: $e');
      print('❌ [CreateOrderNotifier] Stack: $st');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for create order notifier
final createOrderProvider =
    StateNotifierProvider<CreateOrderNotifier, AsyncValue<Order?>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CreateOrderNotifier(repository);
});
