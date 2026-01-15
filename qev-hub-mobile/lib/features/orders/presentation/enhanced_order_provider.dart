import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/order.dart';
import '../../../../data/repositories/enhanced_order_repository.dart';

/// Provider for enhanced order repository
final enhancedOrderRepositoryProvider = Provider<EnhancedOrderRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return EnhancedOrderRepository(client);
});

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Enhanced provider for active orders with search and filter
final enhancedActiveOrdersProvider =
    StateNotifierProvider<EnhancedActiveOrdersNotifier, AsyncValue<List<Order>>>((ref) {
  final repository = ref.watch(enhancedOrderRepositoryProvider);
  return EnhancedActiveOrdersNotifier(repository);
});

/// Enhanced provider for past orders with search and filter
final enhancedPastOrdersProvider =
    StateNotifierProvider<EnhancedPastOrdersNotifier, AsyncValue<List<Order>>>((ref) {
  final repository = ref.watch(enhancedOrderRepositoryProvider);
  return EnhancedPastOrdersNotifier(repository);
});

/// Provider for all orders with search and filter
final allOrdersProvider =
    StateNotifierProvider<AllOrdersNotifier, AsyncValue<List<Order>>>((ref) {
  final repository = ref.watch(enhancedOrderRepositoryProvider);
  return AllOrdersNotifier(repository);
});

/// Enhanced provider for a single order by ID
final enhancedOrderProvider = FutureProvider.family<Order?, String>((ref, id) async {
  final repository = ref.watch(enhancedOrderRepositoryProvider);
  return repository.getOrderById(id);
});

/// Enhanced provider for order status history
final enhancedOrderStatusHistoryProvider =
    FutureProvider.family<List<OrderStatusHistory>, String>((ref, orderId) async {
  final repository = ref.watch(enhancedOrderRepositoryProvider);
  return repository.getOrderStatusHistory(orderId);
});

/// Enhanced notifier for active orders
class EnhancedActiveOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final EnhancedOrderRepository _repository;
  String _searchQuery = '';
  OrderFilter? _currentFilter;

  EnhancedActiveOrdersNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    print('🔵 [EnhancedActiveOrdersNotifier] Loading active orders...');
    state = const AsyncValue.loading();

    try {
      final orders = await _repository.getUserOrders(
        filter: _currentFilter != null 
          ? OrderFilter(status: _currentFilter!.status, activeOnly: true)
          : const OrderFilter(activeOnly: true),
      );
      
      // Apply search filter
      final filteredOrders = _applySearchFilter(orders);
      
      print('📊 [EnhancedActiveOrdersNotifier] Loaded ${filteredOrders.length} active orders');
      state = AsyncValue.data(filteredOrders);
    } catch (e, st) {
      print('❌ [EnhancedActiveOrdersNotifier] ERROR: $e');
      state = AsyncValue.error(e, st);
    }
  }

  List<Order> _applySearchFilter(List<Order> orders) {
    if (_searchQuery.isEmpty) return orders;
    
    final query = _searchQuery.toLowerCase();
    return orders.where((order) {
      final orderNumber = order.orderNumber?.toLowerCase() ?? '';
      final vehicleName = order.vehicle != null 
        ? '${order.vehicle!.manufacturer} ${order.vehicle!.model}'.toLowerCase()
        : '';
      
      return orderNumber.contains(query) || 
             vehicleName.contains(query) ||
             order.status.name.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> refresh() async {
    print('🔄 [EnhancedActiveOrdersNotifier] Refreshing...');
    await _loadOrders();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    if (state.hasValue) {
      final filteredOrders = _applySearchFilter(state.value!);
      state = AsyncValue.data(filteredOrders);
    }
  }

  void setFilter(OrderFilter? filter) {
    _currentFilter = filter;
    _loadOrders();
  }

  Future<bool> cancelOrder(String orderId, String reason) async {
    print('🔵 [EnhancedActiveOrdersNotifier] Cancelling order $orderId');
    try {
      await _repository.cancelOrder(orderId, reason: reason);
      await _loadOrders();
      return true;
    } catch (e) {
      print('❌ [EnhancedActiveOrdersNotifier] Failed to cancel: $e');
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    print('🔵 [EnhancedActiveOrdersNotifier] Updating order status $orderId -> $status');
    try {
      await _repository.updateOrderStatus(orderId, status);
      await _loadOrders();
      return true;
    } catch (e) {
      print('❌ [EnhancedActiveOrdersNotifier] Failed to update status: $e');
      return false;
    }
  }
}

/// Enhanced notifier for past orders
class EnhancedPastOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final EnhancedOrderRepository _repository;
  String _searchQuery = '';
  OrderFilter? _currentFilter;

  EnhancedPastOrdersNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    print('🔵 [EnhancedPastOrdersNotifier] Loading past orders...');
    state = const AsyncValue.loading();

    try {
      final orders = await _repository.getUserOrders(
        filter: _currentFilter != null 
          ? OrderFilter(status: _currentFilter!.status, activeOnly: false)
          : const OrderFilter(activeOnly: false),
      );
      
      // Apply search filter
      final filteredOrders = _applySearchFilter(orders);
      
      print('📊 [EnhancedPastOrdersNotifier] Loaded ${filteredOrders.length} past orders');
      state = AsyncValue.data(filteredOrders);
    } catch (e, st) {
      print('❌ [EnhancedPastOrdersNotifier] ERROR: $e');
      state = AsyncValue.error(e, st);
    }
  }

  List<Order> _applySearchFilter(List<Order> orders) {
    if (_searchQuery.isEmpty) return orders;
    
    final query = _searchQuery.toLowerCase();
    return orders.where((order) {
      final orderNumber = order.orderNumber?.toLowerCase() ?? '';
      final vehicleName = order.vehicle != null 
        ? '${order.vehicle!.manufacturer} ${order.vehicle!.model}'.toLowerCase()
        : '';
      
      return orderNumber.contains(query) || 
             vehicleName.contains(query) ||
             order.status.name.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> refresh() async {
    print('🔄 [EnhancedPastOrdersNotifier] Refreshing...');
    await _loadOrders();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    if (state.hasValue) {
      final filteredOrders = _applySearchFilter(state.value!);
      state = AsyncValue.data(filteredOrders);
    }
  }

  void setFilter(OrderFilter? filter) {
    _currentFilter = filter;
    _loadOrders();
  }
}

/// Notifier for all orders (for admin or comprehensive view)
class AllOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final EnhancedOrderRepository _repository;
  String _searchQuery = '';
  OrderFilter? _currentFilter;

  AllOrdersNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    print('🔵 [AllOrdersNotifier] Loading all orders...');
    state = const AsyncValue.loading();

    try {
      final orders = await _repository.getUserOrders(filter: _currentFilter);
      
      // Apply search filter
      final filteredOrders = _applySearchFilter(orders);
      
      print('📊 [AllOrdersNotifier] Loaded ${filteredOrders.length} orders');
      state = AsyncValue.data(filteredOrders);
    } catch (e, st) {
      print('❌ [AllOrdersNotifier] ERROR: $e');
      state = AsyncValue.error(e, st);
    }
  }

  List<Order> _applySearchFilter(List<Order> orders) {
    if (_searchQuery.isEmpty) return orders;
    
    final query = _searchQuery.toLowerCase();
    return orders.where((order) {
      final orderNumber = order.orderNumber?.toLowerCase() ?? '';
      final vehicleName = order.vehicle != null 
        ? '${order.vehicle!.manufacturer} ${order.vehicle!.model}'.toLowerCase()
        : '';
      
      return orderNumber.contains(query) || 
             vehicleName.contains(query) ||
             order.status.name.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> refresh() async {
    print('🔄 [AllOrdersNotifier] Refreshing...');
    await _loadOrders();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    if (state.hasValue) {
      final filteredOrders = _applySearchFilter(state.value!);
      state = AsyncValue.data(filteredOrders);
    }
  }

  void setFilter(OrderFilter? filter) {
    _currentFilter = filter;
    _loadOrders();
  }
}

/// Enhanced notifier for creating an order
class EnhancedCreateOrderNotifier extends StateNotifier<AsyncValue<Order?>> {
  final EnhancedOrderRepository _repository;

  EnhancedCreateOrderNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<bool> createOrder(CreateOrderRequest request) async {
    print('🔵 [EnhancedCreateOrderNotifier] Creating order for vehicle: ${request.vehicleId}');
    state = const AsyncValue.loading();

    try {
      final order = await _repository.createOrder(request);
      print('✅ [EnhancedCreateOrderNotifier] Order created: ${order.id}');
      state = AsyncValue.data(order);
      return true;
    } catch (e, st) {
      print('❌ [EnhancedCreateOrderNotifier] ERROR: $e');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for enhanced create order notifier
final enhancedCreateOrderProvider =
    StateNotifierProvider<EnhancedCreateOrderNotifier, AsyncValue<Order?>>((ref) {
  final repository = ref.watch(enhancedOrderRepositoryProvider);
  return EnhancedCreateOrderNotifier(repository);
});

/// Provider for order statistics
final orderStatsProvider = FutureProvider<OrderStats>((ref) async {
  final repository = ref.watch(enhancedOrderRepositoryProvider);
  
  try {
    final allOrders = await repository.getUserOrders();
    
    final activeOrders = allOrders.where((order) => [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.inTransit,
      OrderStatus.inCustoms,
      OrderStatus.fahesInspection,
      OrderStatus.insurancePending,
      OrderStatus.delivery,
    ].contains(order.status)).toList();
    
    final completedOrders = allOrders.where((order) => 
      order.status == OrderStatus.completed || order.status == OrderStatus.delivered
    ).toList();
    
    final cancelledOrders = allOrders.where((order) => 
      order.status == OrderStatus.cancelled
    ).toList();
    
    final totalSpent = allOrders
        .where((order) => order.paymentStatus == PaymentStatus.paid)
        .fold<double>(0, (sum, order) => sum + order.totalPrice);
    
    return OrderStats(
      totalOrders: allOrders.length,
      activeOrders: activeOrders.length,
      completedOrders: completedOrders.length,
      cancelledOrders: cancelledOrders.length,
      totalSpent: totalSpent,
    );
  } catch (e) {
    print('❌ Error loading order stats: $e');
    return OrderStats(
      totalOrders: 0,
      activeOrders: 0,
      completedOrders: 0,
      cancelledOrders: 0,
      totalSpent: 0,
    );
  }
});

/// Order statistics model
class OrderStats {
  final int totalOrders;
  final int activeOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double totalSpent;

  const OrderStats({
    required this.totalOrders,
    required this.activeOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalSpent,
  });
}
