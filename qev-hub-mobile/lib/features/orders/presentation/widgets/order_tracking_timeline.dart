import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/order.dart';

/// Enhanced order tracking timeline widget
class OrderTrackingTimeline extends StatelessWidget {
  final Order order;
  final List<OrderStatusHistory> history;

  const OrderTrackingTimeline({
    super.key,
    required this.order,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final allSteps = _getAllSteps();
    final completedSteps = history.map((h) => h.status).toSet();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.timeline,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Order Tracking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                'Est. ${_getEstimatedDelivery()}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Timeline
          ...allSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isCompleted = completedSteps.contains(step.status);
            final isCurrent = step.status == order.status;
            final isLast = index == allSteps.length - 1;

            final historyEntry = history.isNotEmpty
                ? history.firstWhere(
                    (h) => h.status == step.status,
                    orElse: () => OrderStatusHistory(
                      id: '',
                      orderId: order.id,
                      status: step.status,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  )
                : null;

            return _TimelineStep(
              step: step,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isLast: isLast,
              historyEntry: historyEntry,
            );
          }).toList(),
        ],
      ),
    );
  }

  List<_OrderStep> _getAllSteps() {
    return [
      _OrderStep(
        status: OrderStatus.pending,
        title: 'Order Placed',
        subtitle: 'Your order has been received',
        icon: Icons.shopping_cart,
      ),
      _OrderStep(
        status: OrderStatus.confirmed,
        title: 'Order Confirmed',
        subtitle: 'Payment confirmed and order verified',
        icon: Icons.check_circle,
      ),
      _OrderStep(
        status: OrderStatus.processing,
        title: 'Processing',
        subtitle: 'Vehicle preparation in progress',
        icon: Icons.settings,
      ),
      _OrderStep(
        status: OrderStatus.shipped,
        title: 'Shipped',
        subtitle: 'Vehicle is on the way',
        icon: Icons.local_shipping,
      ),
      _OrderStep(
        status: OrderStatus.inCustoms,
        title: 'Customs Clearance',
        subtitle: 'Vehicle going through customs',
        icon: Icons.account_balance,
      ),
      _OrderStep(
        status: OrderStatus.fahesInspection,
        title: 'FAHES Inspection',
        subtitle: 'Vehicle inspection in progress',
        icon: Icons.fact_check,
      ),
      _OrderStep(
        status: OrderStatus.delivery,
        title: 'Out for Delivery',
        subtitle: 'Vehicle being delivered to your address',
        icon: Icons.delivery_dining,
      ),
      _OrderStep(
        status: OrderStatus.delivered,
        title: 'Delivered',
        subtitle: 'Vehicle delivered successfully',
        icon: Icons.home,
      ),
    ];
  }

  String _getEstimatedDelivery() {
    if (order.estimatedDeliveryDate != null) {
      return '${order.estimatedDeliveryDate!.day}/${order.estimatedDeliveryDate!.month}/${order.estimatedDeliveryDate!.year}';
    }
    
    // Estimate based on current status
    final daysFromOrder = DateTime.now().difference(order.createdAt).inDays;
    switch (order.status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
        return '${daysFromOrder + 21} days';
      case OrderStatus.processing:
      case OrderStatus.shipped:
        return '${daysFromOrder + 14} days';
      case OrderStatus.inTransit:
      case OrderStatus.inCustoms:
        return '${daysFromOrder + 7} days';
      case OrderStatus.delivery:
        return 'Today';
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return 'Delivered';
      default:
        return 'TBD';
    }
  }
}

/// Timeline step widget
class _TimelineStep extends StatelessWidget {
  final _OrderStep step;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final OrderStatusHistory? historyEntry;

  const _TimelineStep({
    required this.step,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
    this.historyEntry,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success
                      : isCurrent
                          ? AppColors.primary
                          : AppColors.textTertiary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrent ? AppColors.primary : AppColors.surface,
                    width: 2,
                  ),
                ),
                child: isCompleted || isCurrent
                    ? Icon(
                        step.icon,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted
                        ? AppColors.success.withOpacity(0.5)
                        : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isCompleted || isCurrent
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted || isCurrent
                          ? AppColors.textSecondary
                          : AppColors.textTertiary,
                    ),
                  ),
                  if (historyEntry != null && isCompleted) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(historyEntry!.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (historyEntry!.location != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        historyEntry!.location!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                  if (isCurrent) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'In Progress',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Order step model
class _OrderStep {
  final OrderStatus status;
  final String title;
  final String subtitle;
  final IconData icon;

  _OrderStep({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
