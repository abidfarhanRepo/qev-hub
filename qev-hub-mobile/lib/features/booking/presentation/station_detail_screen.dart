import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../data/models/charging_station.dart';
import '../../../../data/models/charger.dart';
import '../../charging/presentation/charging_provider.dart';
import 'booking_provider.dart';

/// Station detail screen with booking UI
class StationDetailScreen extends ConsumerStatefulWidget {
  final String stationId;

  const StationDetailScreen({
    super.key,
    required this.stationId,
  });

  @override
  ConsumerState<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends ConsumerState<StationDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  late AnimationController _favoriteController;
  late Animation<double> _favoriteAnimation;

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (_isFavorite) {
      _favoriteController.forward().then((_) => _favoriteController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationAsync = ref.watch(stationProvider(widget.stationId));
    final chargersAsync = ref.watch(stationChargersProvider(widget.stationId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: stationAsync.when(
        data: (station) {
          if (station == null) {
            return _buildNotFound(context);
          }
          return _buildContent(context, station, chargersAsync);
        },
        loading: () => const Center(child: AppLoader(size: 32)),
        error: (_, __) => _buildError(context),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ChargingStation station,
    AsyncValue<List<Charger>> chargersAsync,
  ) {
    return CustomScrollView(
      slivers: [
        // App bar with station info
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          actions: [
            AnimatedBuilder(
              animation: _favoriteAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _favoriteAnimation.value,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? AppColors.error : Colors.white,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                // Share functionality
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Gradient background with station info
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryDark,
                        AppColors.secondary,
                      ],
                    ),
                  ),
                ),
                // Pattern overlay
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.glass(opacity: 0.05),
                  ),
                ),
                // Station icon
                Center(
                  child: Icon(
                    Icons.ev_station,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
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
                // Station name and status
                _buildStationHeader(station),

                const SizedBox(height: 24),

                // Quick stats
                _buildQuickStats(station),

                const SizedBox(height: 24),

                // Amenities
                if (station.amenities != null && station.amenities!.isNotEmpty) ...[
                  _buildAmenities(station),
                  const SizedBox(height: 24),
                ],

                // Operating hours and pricing
                _buildInfoSection(station),

                const SizedBox(height: 24),

                // Chargers section
                _buildChargersSection(chargersAsync, station),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStationHeader(ChargingStation station) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          station.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                station.address,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatusChip(station),
      ],
    );
  }

  Widget _buildStatusChip(ChargingStation station) {
    final hasAvailable = (station.availableChargers ?? 0) > 0;
    final statusColor = hasAvailable ? AppColors.success : AppColors.error;
    final statusText = hasAvailable ? 'Open Now' : 'Fully Occupied';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ChargingStation station) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.ev_station,
            'Chargers',
            '${station.availableChargers ?? 0}/${station.totalChargers ?? 0}',
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        if (station.powerOutputKw != null)
          Expanded(
            child: _buildStatCard(
              Icons.bolt,
              'Max Power',
              '${station.powerOutputKw!.toInt()} kW',
              AppColors.accent,
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities(ChargingStation station) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: station.amenities!.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      amenity,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    if (lowerAmenity.contains('wifi') || lowerAmenity.contains('wi-fi')) {
      return Icons.wifi;
    } else if (lowerAmenity.contains('restroom') || lowerAmenity.contains('toilet')) {
      return Icons.wc;
    } else if (lowerAmenity.contains('food') || lowerAmenity.contains('cafe')) {
      return Icons.restaurant;
    } else if (lowerAmenity.contains('shop') || lowerAmenity.contains('store')) {
      return Icons.shopping_bag;
    } else if (lowerAmenity.contains('parking')) {
      return Icons.local_parking;
    } else if (lowerAmenity.contains('atm')) {
      return Icons.atm;
    }
    return Icons.star;
  }

  Widget _buildInfoSection(ChargingStation station) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Operating hours
          if (station.operatingHours != null) ...[
            _buildInfoItem(
              Icons.access_time,
              'Operating Hours',
              station.operatingHours!,
            ),
            const SizedBox(height: 12),
          ],
          // Pricing
          if (station.pricingInfo != null)
            _buildInfoItem(
              Icons.payments_outlined,
              'Pricing',
              station.pricingInfo!,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChargersSection(
    AsyncValue<List<Charger>> chargersAsync,
    ChargingStation station,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Chargers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        chargersAsync.when(
          data: (chargers) {
            if (chargers.isEmpty) {
              return _buildEmptyChargers();
            }
            return Column(
              children: chargers.map((charger) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ChargerCard(
                    charger: charger,
                    station: station,
                    onTap: () => _openBookingFlow(charger, station),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: AppLoader(size: 32),
            ),
          ),
          error: (_, __) => _buildChargersError(),
        ),
      ],
    );
  }

  Widget _buildEmptyChargers() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.ev_station_outlined,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          const Text(
            'No chargers available',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargersError() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Failed to load chargers',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBookingFlow(Charger charger, ChargingStation station) {
    // Navigate to booking screen with charger and station info
    context.push('/booking?chargerId=${charger.id}&stationId=${station.id}');
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
                Icons.ev_station_outlined,
                size: 64,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Station not found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'The charging station you are looking for does not exist.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
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
                'Failed to load station',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your connection and try again.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Charger card widget
class _ChargerCard extends StatelessWidget {
  final Charger charger;
  final ChargingStation station;
  final VoidCallback onTap;

  const _ChargerCard({
    required this.charger,
    required this.station,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = charger.status == ChargerStatus.available;
    final statusColor = _getStatusColor(charger.status);
    final statusLabel = _getStatusLabel(charger.status);

    return InkWell(
      onTap: isAvailable ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAvailable ? AppColors.primary.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    charger.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _buildStatusChip(statusColor, statusLabel),
              ],
            ),
            const SizedBox(height: 12),
            // Type and power
            Row(
              children: [
                const Icon(
                  Icons.bolt,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${charger.chargerType} - ${charger.powerKw.toInt()} kW',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Connector types
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: charger.connectorTypes.map((connector) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Text(
                    connector,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            // Book button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isAvailable ? onTap : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAvailable ? AppColors.primary : AppColors.surface,
                  foregroundColor: isAvailable ? Colors.white : AppColors.textDisabled,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: AppColors.surface,
                  elevation: 0,
                ),
                child: Text(
                  isAvailable ? 'Book Now' : _getDisabledButtonText(charger.status),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ChargerStatus status) {
    switch (status) {
      case ChargerStatus.available:
        return AppColors.success;
      case ChargerStatus.occupied:
        return AppColors.error;
      case ChargerStatus.maintenance:
        return AppColors.warning;
      case ChargerStatus.offline:
        return AppColors.textTertiary;
    }
  }

  String _getStatusLabel(ChargerStatus status) {
    switch (status) {
      case ChargerStatus.available:
        return 'Available';
      case ChargerStatus.occupied:
        return 'Occupied';
      case ChargerStatus.maintenance:
        return 'Maintenance';
      case ChargerStatus.offline:
        return 'Offline';
    }
  }

  String _getDisabledButtonText(ChargerStatus status) {
    switch (status) {
      case ChargerStatus.occupied:
        return 'Currently Occupied';
      case ChargerStatus.maintenance:
        return 'Under Maintenance';
      case ChargerStatus.offline:
        return 'Offline';
      case ChargerStatus.available:
        return 'Book Now';
    }
  }
}
