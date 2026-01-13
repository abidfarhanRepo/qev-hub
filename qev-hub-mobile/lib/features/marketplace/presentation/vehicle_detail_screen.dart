import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/price_display.dart';
import '../../../../shared/widgets/savings_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../data/models/vehicle.dart';
import '../presentation/vehicle_provider.dart';

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
          bottomNavigationBar: _buildBottomBar(context, vehicle),
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
    final primaryImage = images.isNotEmpty
        ? images.first
        : vehicle.imageUrl ?? '';

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
          child: SingleChildScrollView(
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

                // Description
                if (vehicle.description != null && vehicle.description!.isNotEmpty) ...[
                  _buildSectionTitle('Description'),
                  const SizedBox(height: 12),
                  Text(
                    vehicle.description!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Availability
                _buildAvailabilitySection(vehicle),

                const SizedBox(height: 24),

                // Specs from JSON
                if (vehicle.specs != null && vehicle.specs!.isNotEmpty) ...[
                  _buildSectionTitle('Specifications'),
                  const SizedBox(height: 12),
                  _buildSpecsList(vehicle.specs!),
                  const SizedBox(height: 24),
                ],

                // Warranty
                _buildWarrantySection(vehicle),

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

    return AppCard(
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

          // Main price
          PriceDisplay(
            price: displayPrice,
            compareAtPrice: vehicle.brokerMarketPrice,
            savingsAmount: vehicle.savingsAmount,
            savingsPercentage: vehicle.savingsPercentage,
          ),

          // Grey market price info
          if (vehicle.greyMarketPrice != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Grey Market Price',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'QAR ${vehicle.greyMarketPrice?.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecsGrid(Vehicle vehicle) {
    return AppCard(
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
          const SizedBox(height: 16),
          Row(
            children: [
              if (vehicle.topSpeed != null)
                Expanded(
                  child: _buildSpecItem(
                    Icons.speed,
                    'Top Speed',
                    '${vehicle.topSpeed} km/h',
                  ),
                ),
              if (vehicle.acceleration != null)
                Expanded(
                  child: _buildSpecItem(
                    Icons.timer,
                    '0-100',
                    vehicle.acceleration!,
                  ),
                ),
            ],
          ),
        ],
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSpecsList(Map<String, dynamic> specs) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: specs.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  entry.value.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAvailabilitySection(Vehicle vehicle) {
    return AppCard(
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
    );
  }

  Widget _buildWarrantySection(Vehicle vehicle) {
    if (vehicle.warrantyYears == null && vehicle.warrantyKm == null) {
      return const SizedBox.shrink();
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Warranty',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (vehicle.warrantyYears != null || vehicle.warrantyKm != null)
                  Text(
                    [
                      if (vehicle.warrantyYears != null) '${vehicle.warrantyYears} years',
                      if (vehicle.warrantyKm != null) '${vehicle.warrantyKm} km',
                    ].join(' / '),
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
    );
  }

  Widget _buildBottomBar(BuildContext context, Vehicle vehicle) {
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
                onPressed: vehicle.availability == AvailabilityStatus.available
                    ? () {
                        // Purchase action
                      }
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

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      body: Center(
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
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Scaffold(
      body: Center(
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
