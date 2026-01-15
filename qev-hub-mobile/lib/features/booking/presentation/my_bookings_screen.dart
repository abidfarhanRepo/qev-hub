import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../data/models/booking.dart';
import 'booking_provider.dart';

/// My Bookings screen with Upcoming and Past tabs
class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
          'My Bookings',
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
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _UpcomingBookingsTab(),
          _PastBookingsTab(),
        ],
      ),
    );
  }
}

/// Upcoming bookings tab
class _UpcomingBookingsTab extends ConsumerWidget {
  const _UpcomingBookingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(upcomingBookingsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(upcomingBookingsProvider.notifier).refresh(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return _buildEmptyState(
              icon: Icons.event_available,
              title: 'No upcoming bookings',
              message: 'Book a charging session to get started',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              return _UpcomingBookingCard(booking: bookings[index]);
            },
          );
        },
        loading: () => const Center(child: AppLoader(size: 32)),
        error: (error, _) => _buildErrorState(
          message: 'Failed to load bookings',
          onRetry: () => ref.read(upcomingBookingsProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
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
    );
  }
}

/// Past bookings tab
class _PastBookingsTab extends ConsumerWidget {
  const _PastBookingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(pastBookingsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(pastBookingsProvider.notifier).refresh(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return _buildEmptyState(
              icon: Icons.history,
              title: 'No past bookings',
              message: 'Your completed bookings will appear here',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              return _PastBookingCard(booking: bookings[index]);
            },
          );
        },
        loading: () => const Center(child: AppLoader(size: 32)),
        error: (error, _) => _buildErrorState(
          message: 'Failed to load bookings',
          onRetry: () => ref.read(pastBookingsProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
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
    );
  }
}

/// Upcoming booking card
class _UpcomingBookingCard extends ConsumerWidget {
  final Booking booking;

  const _UpcomingBookingCard({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final station = booking.station;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header with status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Charging Session',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 12),

          // Date and time
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                _formatDateTime(booking.startTime),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                _formatTimeRange(booking.startTime, booking.endTime),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // Estimated cost
          if (booking.estimatedCost != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Est. ${booking.estimatedCost!.toStringAsFixed(2)} QAR',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // Action buttons - single row
          Row(
            children: [
              // Cancel button (only for pending/confirmed)
              if (booking.status == BookingStatus.pending ||
                  booking.status == BookingStatus.confirmed)
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

              // View QR button
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: () => _showQRCode(context),
                    icon: const Icon(Icons.qr_code, size: 16),
                    label: const Text('View QR', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),

              // Navigate button (if station available)
              if (station != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: station != null
                            ? () => _openNavigation(station.latitude, station.longitude)
                            : null,
                        icon: const Icon(Icons.directions, size: 16),
                        label: const Text('Navigate', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceVariant,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Cancel Booking',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
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
                  .read(upcomingBookingsProvider.notifier)
                  .cancelBooking(booking.id, 'Cancelled by user');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Booking cancelled' : 'Failed to cancel booking',
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

  void _showQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Check-in QR Code',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // QR Code placeholder
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_2,
                            size: 80,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            booking.id.substring(0, 8).toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Scan this code at the station',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _openNavigation(double lat, double lng) {
    final url = 'https://www.openstreetmap.org/directions?from=&to=$lat,$lng';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (bookingDate == today) {
      return 'Today';
    } else if (bookingDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Past booking card
class _PastBookingCard extends StatelessWidget {
  final Booking booking;

  const _PastBookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header with status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Charging Session',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 12),

          // Date and time
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                '${_formatDate(booking.startTime)} at ${_formatTime(booking.startTime)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // Cost (for completed bookings)
          if (booking.status == BookingStatus.completed) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.payments,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${booking.actualCost?.toStringAsFixed(2) ?? booking.estimatedCost?.toStringAsFixed(2) ?? '0.00'} QAR',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // Book Again button
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton.icon(
              onPressed: () {
                // Navigate to booking flow
                Navigator.pop(context);
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Book Again', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: config.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: config.color,
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig() {
    switch (status) {
      case BookingStatus.pending:
        return _StatusConfig(
          label: 'Pending',
          color: AppColors.warning,
        );
      case BookingStatus.confirmed:
        return _StatusConfig(
          label: 'Confirmed',
          color: AppColors.info,
        );
      case BookingStatus.inProgress:
        return _StatusConfig(
          label: 'In Progress',
          color: AppColors.success,
        );
      case BookingStatus.completed:
        return _StatusConfig(
          label: 'Completed',
          color: AppColors.success,
        );
      case BookingStatus.cancelled:
        return _StatusConfig(
          label: 'Cancelled',
          color: AppColors.error,
        );
      case BookingStatus.noShow:
        return _StatusConfig(
          label: 'No Show',
          color: AppColors.textTertiary,
        );
    }
  }
}

/// Status configuration
class _StatusConfig {
  final String label;
  final Color color;

  _StatusConfig({required this.label, required this.color});
}
