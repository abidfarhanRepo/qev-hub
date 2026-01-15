import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/order.dart';
import '../enhanced_order_provider.dart';
import '../widgets/order_search_filter.dart';
import '../widgets/order_tracking_timeline.dart';

/// Enhanced orders screen with search and filter
class EnhancedOrdersScreen extends ConsumerStatefulWidget {
  const EnhancedOrdersScreen({super.key});

  @override
  ConsumerState<EnhancedOrdersScreen> createState() => _EnhancedOrdersScreenState();
}

class _EnhancedOrdersScreenState extends ConsumerState<EnhancedOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  OrderFilter? _filter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _EnhancedActiveOrdersTab(
            searchQuery: _searchQuery,
            filter: _filter,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              ref.read(enhancedActiveOrdersProvider.notifier).setSearchQuery(query);
            },
            onFilterChanged: (filter) {
              setState(() {
                _filter = filter;
              });
              ref.read(enhancedActiveOrdersProvider.notifier).setFilter(filter);
            },
          ),
          _EnhancedPastOrdersTab(
            searchQuery: _searchQuery,
            filter: _filter,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              ref.read(enhancedPastOrdersProvider.notifier).setSearchQuery(query);
            },
            onFilterChanged: (filter) {
              setState(() {
                _filter = filter;
              });
              ref.read(enhancedPastOrdersProvider.notifier).setFilter(filter);
            },
          ),
        ],
      ),
    );
  }
}

/// Enhanced active orders tab
class _EnhancedActiveOrdersTab extends ConsumerWidget {
  final String searchQuery;
  final OrderFilter? filter;
  final Function(String) onSearchChanged;
  final Function(OrderFilter?) onFilterChanged;

  const _EnhancedActiveOrdersTab({
    required this.searchQuery,
    this.filter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(enhancedActiveOrdersProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(enhancedActiveOrdersProvider.notifier).refresh(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // Search and filter
          OrderSearchFilter(
            onFilterChanged: onFilterChanged,
            onSearchChanged: onSearchChanged,
          ),

          // Orders list
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return _buildEmptyState(
                    icon: Icons.shopping_bag_outlined,
                    title: 'No active orders',
                    message: 'Browse the marketplace to purchase a vehicle',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _EnhancedOrderCard(order: orders[index], isActive: true);
                  },
                );
              },
              loading: () => const _LoadingState(),
              error: (error, _) => _buildErrorState(
                message: 'Failed to load orders',
                onRetry: () => ref.read(enhancedActiveOrdersProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/marketplace'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Browse Marketplace'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Enhanced past orders tab
class _EnhancedPastOrdersTab extends ConsumerWidget {
  final String searchQuery;
  final OrderFilter? filter;
  final Function(String) onSearchChanged;
  final Function(OrderFilter?) onFilterChanged;

  const _EnhancedPastOrdersTab({
    required this.searchQuery,
    this.filter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(enhancedPastOrdersProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(enhancedPastOrdersProvider.notifier).refresh(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // Search and filter
          OrderSearchFilter(
            onFilterChanged: onFilterChanged,
            onSearchChanged: onSearchChanged,
          ),

          // Orders list
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return _buildEmptyState(
                    icon: Icons.history,
                    title: 'No past orders',
                    message: 'Your completed orders will appear here',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _EnhancedOrderCard(order: orders[index], isActive: false);
                  },
                );
              },
              loading: () => const _LoadingState(),
              error: (error, _) => _buildErrorState(
                message: 'Failed to load orders',
                onRetry: () => ref.read(enhancedPastOrdersProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Enhanced order card widget
class _EnhancedOrderCard extends ConsumerWidget {
  final Order order;
  final bool isActive;

  const _EnhancedOrderCard({required this.order, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = order.vehicle;
    final orderNumber = order.orderNumber ?? '#${order.id.substring(0, 8)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: () {
            context.push('/orders/${order.id}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with order number and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderNumber,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          if (vehicle != null)
                            Text(
                              '${vehicle.manufacturer} ${vehicle.model}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    _OrderStatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 12),

                // Vehicle image and details
                if (vehicle != null) ...[
                  Row(
                    children: [
                      // Vehicle thumbnail
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: vehicle.images != null && vehicle.images!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  vehicle.images!.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.electric_car,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.electric_car,
                                color: AppColors.textTertiary,
                              ),
                      ),
                      const SizedBox(width: 12),
                      // Vehicle details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vehicle.year} ${vehicle.manufacturer} ${vehicle.model}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${vehicle.range} km range',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${order.totalPrice.toStringAsFixed(0)} QAR',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (isActive)
                            Text(
                              _getEstimatedDeliveryText(order),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Date
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(order.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                // Action buttons
                if (isActive)
                  const SizedBox(height: 12),
                if (isActive)
                  Row(
                    children: [
                      // Track button
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: OutlinedButton(
                            onPressed: () {
                              context.push('/orders/${order.id}');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: const Text('Track Order', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ),

                      // Cancel button (only for pending/confirmed active orders)
                      if (order.status == OrderStatus.pending ||
                          order.status == OrderStatus.confirmed) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 36,
                            child: OutlinedButton(
                              onPressed: () => _showCancelDialog(context, ref),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(
                                  color: AppColors.error,
                                  width: 1,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Cancel Order',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'No, Keep It',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(enhancedActiveOrdersProvider.notifier)
                  .cancelOrder(order.id, 'Cancelled by user');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Order cancelled' : 'Failed to cancel order',
                    ),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _getEstimatedDeliveryText(Order order) {
    if (order.estimatedDeliveryDate != null) {
      final daysUntil = order.estimatedDeliveryDate!.difference(DateTime.now()).inDays;
      if (daysUntil <= 0) return 'Expected today';
      if (daysUntil == 1) return 'Expected tomorrow';
      return 'Est. $daysUntil days';
    }
    
    final daysFromOrder = DateTime.now().difference(order.createdAt).inDays;
    return 'Est. ${21 - daysFromOrder} days';
  }
}

/// Loading state widget
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}

/// Order status badge widget
class _OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: config.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: config.color,
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig() {
    switch (status) {
      case OrderStatus.pending:
        return _StatusConfig(label: 'Pending', color: AppColors.warning);
      case OrderStatus.confirmed:
        return _StatusConfig(label: 'Confirmed', color: AppColors.info);
      case OrderStatus.processing:
        return _StatusConfig(label: 'Processing', color: AppColors.info);
      case OrderStatus.shipped:
        return _StatusConfig(label: 'Shipped', color: AppColors.primary);
      case OrderStatus.inTransit:
        return _StatusConfig(label: 'In Transit', color: AppColors.primary);
      case OrderStatus.inCustoms:
        return _StatusConfig(label: 'In Customs', color: AppColors.warning);
      case OrderStatus.fahesInspection:
        return _StatusConfig(label: 'FAHES', color: AppColors.warning);
      case OrderStatus.insurancePending:
        return _StatusConfig(label: 'Insurance', color: AppColors.warning);
      case OrderStatus.delivery:
        return _StatusConfig(label: 'Delivery', color: AppColors.success);
      case OrderStatus.delivered:
        return _StatusConfig(label: 'Delivered', color: AppColors.success);
      case OrderStatus.completed:
        return _StatusConfig(label: 'Completed', color: AppColors.success);
      case OrderStatus.cancelled:
        return _StatusConfig(label: 'Cancelled', color: AppColors.error);
    }
  }
}

/// Status configuration
class _StatusConfig {
  final String label;
  final Color color;

  _StatusConfig({required this.label, required this.color});
}
