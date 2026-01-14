import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../presentation/charging_provider.dart';
import '../../../data/models/charging_station.dart';

/// Charging stations screen with OpenStreetMap
class ChargingScreen extends ConsumerStatefulWidget {
  const ChargingScreen({super.key});

  @override
  ConsumerState<ChargingScreen> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends ConsumerState<ChargingScreen> {
  final MapController _mapController = MapController();
  StationFilterOption _selectedFilter = StationFilterOption.all;
  LatLng _mapCenter = const LatLng(25.3548, 51.1839); // Doha
  double _mapZoom = 12;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final position = await getCurrentUserLocation(ref);
    if (position != null) {
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _mapCenter = _userLocation!;
        _mapZoom = 14;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with filters
          _buildHeader(),

          // Map and stations list
          Expanded(
            child: stationsAsync.when(
              data: (result) {
                if (result.stations.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  children: [
                    // Map view
                    _buildMap(result.stations),

                    // Stations list
                    Expanded(
                      child: _buildStationsList(result.stations),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: AppLoader(size: 32)),
              error: (_, __) => _buildErrorState(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Charging Stations',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          Wrap(
            spacing: 8,
            children: StationFilterOption.values.map((option) {
              final isSelected = _selectedFilter == option;
              return FilterChip(
                label: Text(_getFilterLabel(option)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = option;
                  });
                  ref.read(selectedFilterOptionProvider.notifier).state = option;
                  _applyFilter(option);
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                backgroundColor: AppColors.surfaceVariant,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(List<ChargingStation> stations) {
    return SizedBox(
      height: 300,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _mapCenter,
          initialZoom: _mapZoom,
          minZoom: 10,
          maxZoom: 18,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          // OpenStreetMap tile layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.qev.qev_hub_mobile',
            maxZoom: 19,
          ),

          // User location marker
          if (_userLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _userLocation!,
                  width: 24,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

          // Station markers
          MarkerLayer(
            markers: stations.map((station) {
              final lat = station.latitude;
              final lng = station.longitude;
              final isAvailable = (station.availableChargers ?? 0) > 0;

              return Marker(
                point: LatLng(lat, lng),
                width: 32,
                height: 32,
                child: GestureDetector(
                  onTap: () => _showStationDetails(station),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isAvailable ? const Color(0xFF00FFFF) : const Color(0xFF4a0d1d),
                      border: Border.all(
                        color: isAvailable ? const Color(0xFF00FFFF) : const Color(0xFF8A1538),
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStationsList(List<ChargingStation> stations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return _StationCard(
          station: station,
          onTap: () {
            _showStationDetails(station);
            final lat = station.latitude;
            final lng = station.longitude;
            setState(() {
              _mapCenter = LatLng(lat, lng);
              _mapZoom = 15;
            });
            _mapController.move(LatLng(lat, lng), 15);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.ev_station_outlined,
                size: 48,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No charging stations found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for new stations',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
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
              'Failed to load charging stations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(stationListProvider.notifier).refresh();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  String _getFilterLabel(StationFilterOption option) {
    switch (option) {
      case StationFilterOption.all:
        return 'All Stations';
      case StationFilterOption.available:
        return 'Available';
      case StationFilterOption.nearby:
        return 'Nearby';
    }
  }

  void _applyFilter(StationFilterOption option) {
    StationFilter filter;
    switch (option) {
      case StationFilterOption.all:
        filter = const StationFilter(status: 'active');
        break;
      case StationFilterOption.available:
        filter = const StationFilter(status: 'active', availableOnly: true);
        break;
      case StationFilterOption.nearby:
        filter = const StationFilter(status: 'active', nearbyOnly: true, maxDistanceKm: 10);
        break;
    }
    ref.read(stationListProvider.notifier).applyFilter(filter);
  }

  void _showStationDetails(ChargingStation station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StationDetailSheet(station: station),
    );
  }
}

/// Station card widget
class _StationCard extends StatelessWidget {
  final ChargingStation station;
  final VoidCallback onTap;

  const _StationCard({
    required this.station,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = (station.availableChargers ?? 0) > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        station.address,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(isAvailable: isAvailable),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.ev_station,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${station.availableChargers ?? 0}/${station.totalChargers ?? 0} available',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (station.distanceKm != null) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${station.distanceKm!.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  final bool isAvailable;

  const _StatusBadge({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? AppColors.success : AppColors.error;
    final label = isAvailable ? 'Available' : 'Full';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Station detail bottom sheet
class _StationDetailSheet extends StatelessWidget {
  final ChargingStation station;

  const _StationDetailSheet({required this.station});

  @override
  Widget build(BuildContext context) {
    final isAvailable = (station.availableChargers ?? 0) > 0;
    final lat = station.latitude;
    final lng = station.longitude;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                station.address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _StatusBadge(isAvailable: isAvailable),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Details grid
                    _DetailRow(
                      icon: Icons.ev_station,
                      label: 'Available Chargers',
                      value: '${station.availableChargers ?? 0} / ${station.totalChargers ?? 0}',
                    ),
                    if (station.powerOutputKw != null)
                      _DetailRow(
                        icon: Icons.bolt,
                        label: 'Power Output',
                        value: '${station.powerOutputKw!.toStringAsFixed(1)} kW',
                      ),
                    if (station.chargerType != null)
                      _DetailRow(
                        icon: Icons.settings_input_component,
                        label: 'Charger Type',
                        value: station.chargerType!,
                      ),
                    if (station.distanceKm != null)
                      _DetailRow(
                        icon: Icons.location_on_outlined,
                        label: 'Distance',
                        value: '${station.distanceKm!.toStringAsFixed(1)} km',
                      ),

                    if (station.pricingInfo != null) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Pricing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        station.pricingInfo!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],

                    if (station.operatingHours != null) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Operating Hours',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        station.operatingHours!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],

                    if (station.amenities != null && station.amenities!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Amenities',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: station.amenities!.map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              amenity,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _openDirections(lat, lng);
                            },
                            icon: const Icon(Icons.directions, size: 18),
                            label: const Text('Navigate'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: station.phoneNumber != null
                                ? () => _makeCall(station.phoneNumber!)
                                : null,
                            icon: const Icon(Icons.phone, size: 18),
                            label: const Text('Call'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: station.phoneNumber != null
                                  ? AppColors.textPrimary
                                  : AppColors.textTertiary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDirections(double lat, double lng) {
    final url = 'https://www.openstreetmap.org/directions?from=&to=$lat,$lng';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _makeCall(String phoneNumber) {
    launchUrl(Uri.parse('tel:$phoneNumber'));
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
