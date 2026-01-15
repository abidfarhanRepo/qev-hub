import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/price_display.dart';
import '../../../../data/models/vehicle.dart';
import '../../../../data/models/order.dart';
import '../../orders/presentation/order_provider.dart';
import 'vehicle_provider.dart';

/// Vehicle detail screen
class VehicleDetailScreen extends ConsumerWidget {
  final String vehicleId;

  const VehicleDetailScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider(vehicleId));
    final savedVehicles = ref.watch(savedVehiclesProvider);
    final isSaved = savedVehicles.contains(vehicleId);

    return vehicleAsync.when(
      data: (vehicle) {
        if (vehicle == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: _buildNotFound(context),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          body: _buildContent(context, ref, vehicle, isSaved),
          bottomNavigationBar: _buildBottomBar(context, ref, vehicle),
        );
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: AppLoader(size: 32)),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        body: _buildError(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Vehicle vehicle, bool isSaved) {
    final images = vehicle.images ?? [];
    final primaryImage = images.isNotEmpty ? images.first : vehicle.imageUrl ?? '';

    return CustomScrollView(
      slivers: [
        // App bar with image
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? AppColors.error : Colors.white,
              ),
              onPressed: () {
                // Toggle save
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                // Share
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                primaryImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: primaryImage,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(child: AppLoader(size: 32)),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(
                            Icons.electric_car,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.surfaceVariant,
                        child: const Icon(
                          Icons.electric_car,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                      ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and price
                _buildHeader(vehicle),
                const SizedBox(height: 24),
                // Price display
                _buildPriceSection(vehicle),
                const SizedBox(height: 24),
                // Specs grid
                _buildSpecsGrid(vehicle),
                const SizedBox(height: 24),
                // Availability
                _buildAvailabilitySection(vehicle),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Vehicle vehicle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${vehicle.manufacturer} ${vehicle.model}',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Text(
                _getVehicleTypeLabel(vehicle.vehicleType),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${vehicle.year}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection(Vehicle vehicle) {
    final displayPrice = vehicle.priceQar ?? vehicle.price;

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 12),
            PriceDisplay(
              price: displayPrice,
              compareAtPrice: vehicle.brokerMarketPrice,
              savingsAmount: vehicle.savingsAmount,
              savingsPercentage: vehicle.savingsPercentage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecsGrid(Vehicle vehicle) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Specs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSpecItem(
                    Icons.battery_full_outlined,
                    'Range',
                    '${vehicle.range} km',
                  ),
                ),
                Expanded(
                  child: _buildSpecItem(
                    Icons.bolt,
                    'Battery',
                    '${vehicle.batteryCapacity ?? vehicle.batteryKwh ?? '-'} kWh',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(Vehicle vehicle) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getAvailabilityColor(vehicle.availability).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getAvailabilityIcon(vehicle.availability),
                color: _getAvailabilityColor(vehicle.availability),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getAvailabilityLabel(vehicle.availability),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (vehicle.stockCount != null && vehicle.stockCount! > 0)
                    Text(
                      '${vehicle.stockCount} units available',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref, Vehicle vehicle) {
    final displayPrice = vehicle.priceQar ?? vehicle.price;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: vehicle.availability == AvailabilityStatus.available ||
                        vehicle.availability == AvailabilityStatus.preOrder
                    ? () => _showPurchaseDialog(context, ref, vehicle, displayPrice)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.textTertiary,
                ),
                child: Text(
                  vehicle.availability == AvailabilityStatus.preOrder
                      ? 'Pre-Order'
                      : vehicle.availability == AvailabilityStatus.soldOut
                          ? 'Sold Out'
                          : 'Purchase',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.contact_phone, color: AppColors.primary),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
              ),
              onPressed: () {
                // Contact seller
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref, Vehicle vehicle, double price) {
    final addressController = TextEditingController();
    final cityController = TextEditingController(text: 'Doha');
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Complete Your Purchase',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Purchase button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Create order request
                      final orderRequest = CreateOrderRequest(
                        vehicleId: vehicle.id,
                        totalPrice: price,
                        shippingAddress: 'Test Address',
                        shippingCity: 'Doha',
                        shippingCountry: 'Qatar',
                        shippingPhone: '12345678',
                        paymentMethod: 'Cash on Delivery',
                      );

                      // Create the order using repository
                      try {
                        final orderRepository = ref.read(orderRepositoryProvider);
                        final createdOrder = await orderRepository.createOrder(orderRequest);

                        // Navigate to orders screen
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Order #${createdOrder.orderNumber ?? createdOrder.id.substring(0, 8)} created successfully!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                          context.go('/order-confirmation/${createdOrder.id}');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to create order: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Confirm Order'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.electric_car_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Vehicle not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load vehicle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  String _getVehicleTypeLabel(VehicleType? type) {
    switch (type) {
      case VehicleType.ev:
        return 'Electric';
      case VehicleType.phev:
        return 'Hybrid';
      case VehicleType.fcev:
        return 'Fuel Cell';
      case null:
        return 'Electric';
    }
  }

  Color _getAvailabilityColor(AvailabilityStatus? status) {
    switch (status) {
      case AvailabilityStatus.available:
        return AppColors.success;
      case AvailabilityStatus.preOrder:
        return AppColors.warning;
      case AvailabilityStatus.soldOut:
        return AppColors.error;
      case null:
        return AppColors.textTertiary;
    }
  }

  IconData _getAvailabilityIcon(AvailabilityStatus? status) {
    switch (status) {
      case AvailabilityStatus.available:
        return Icons.check_circle_outline;
      case AvailabilityStatus.preOrder:
        return Icons.access_time;
      case AvailabilityStatus.soldOut:
        return Icons.cancel_outlined;
      case null:
        return Icons.help_outline;
    }
  }

  String _getAvailabilityLabel(AvailabilityStatus? status) {
    switch (status) {
      case AvailabilityStatus.available:
        return 'Available';
      case AvailabilityStatus.preOrder:
        return 'Pre-Order';
      case AvailabilityStatus.soldOut:
        return 'Sold Out';
      case null:
        return 'Unknown';
    }
  }
}