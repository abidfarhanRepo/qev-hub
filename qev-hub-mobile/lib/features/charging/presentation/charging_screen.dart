import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../presentation/charging_provider.dart';
import '../../../data/models/charging_station.dart';

/// Charging stations screen - Redesigned for better UX
class ChargingScreen extends ConsumerStatefulWidget {
  const ChargingScreen({super.key});

  @override
  ConsumerState<ChargingScreen> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends ConsumerState<ChargingScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  StationFilterOption _selectedFilter = StationFilterOption.all;
  LatLng _mapCenter = const LatLng(25.3548, 51.1839); // Doha
  double _mapZoom = 12;
  LatLng? _userLocation;
  ChargingStation? _selectedStation;
  bool _showList = false;

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
  void tick() {
    // Performance: Only rebuild when map center/zoom changes significantly
    // This prevents excessive rebuilds
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: stationsAsync.when(
        data: (result) {
          if (result.stations.isEmpty) {
            return _buildEmptyState();
          }

          return Stack(
            children: [
              // Full screen map
              _buildMap(result.stations),

              // Floating action button to toggle list
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  heroTag: 'toggle_list',
                  onPressed: () {
                    setState(() => _showList = !_showList);
                  },
                  backgroundColor: AppColors.surface,
                  child: Icon(_showList ? Icons.map : Icons.list),
                ),
              ),

              // Filter chips (floating, more compact)
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                right: 16,
                child: _buildCompactFilters(result.stations.length),
              ),

              // Compact station list overlay (when shown)
              if (_showList)
                Positioned.fill(
                  child: _buildStationListOverlay(result.stations),
                ),

              // Selected station quick info (when selected)
              if (_selectedStation != null)
                _buildStationQuickInfo(_selectedStation!),
            ],
          );
        },
        loading: () => const Center(child: AppLoader(size: 32)),
        error: (_, __) => _buildErrorState(),
      ),
    );
  }

  Widget _buildMap(List<ChargingStation> stations) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _mapCenter,
        initialZoom: _mapZoom,
        minZoom: 11,
        maxZoom: 18,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        // OpenStreetMap tile layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.qev.qev_hub_mobile',
          maxZoom: 19,
          // Use cached network tile provider for better performance
          tileProvider: NetworkTileProvider(),
        ),

        // User location marker
        if (_userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _userLocation!,
                width: 20,
                height: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        // Station markers
        MarkerLayer(
          markers: stations.map((station) {
            final isAvailable = (station.availableChargers ?? 0) > 0;
            final isSelected = _selectedStation?.id == station.id;

            return Marker(
              point: LatLng(station.latitude, station.longitude),
              width: isSelected ? 60 : 48,
              height: isSelected ? 60 : 48,
              child: GestureDetector(
                onTap: () {
                  if (_selectedStation?.id == station.id) {
                    // Navigate to station detail if already selected
                    context.push('/charging/${station.id}');
                  } else {
                    setState(() {
                      // Select this station
                      _selectedStation = station;
                      _mapCenter = LatLng(station.latitude, station.longitude);
                      _mapZoom = 15;
                      _mapController.move(
                        LatLng(station.latitude, station.longitude),
                        _mapZoom,
                      );
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isAvailable ? const Color(0xFF00FFFF) : const Color(0xFF4a0d1d),
                    border: Border.all(
                      color: isAvailable ? const Color(0xFF00FFFF) : const Color(0xFF8A1538),
                      width: isSelected ? 3 : 2,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: isSelected ? 6 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.ev_station,
                      color: Colors.white,
                      size: isSelected ? 24 : 18,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCompactFilters(int stationCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Close button (clear filter)
          if (_selectedFilter != StationFilterOption.all)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: AppColors.textSecondary,
              onPressed: () {
                setState(() {
                  _selectedFilter = StationFilterOption.all;
                  ref.read(selectedFilterOptionProvider.notifier).state = StationFilterOption.all;
                  _applyFilter(StationFilterOption.all);
                });
              },
            ),

          // Filter chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: StationFilterOption.values.map((option) {
                  final isSelected = _selectedFilter == option;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(_getFilterLabel(option)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = option;
                          ref.read(selectedFilterOptionProvider.notifier).state = option;
                          _applyFilter(option);
                        });
                      },
                      selectedColor: AppColors.primary.withOpacity(0.3),
                      checkmarkColor: AppColors.primary,
                      backgroundColor: Colors.transparent,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationListOverlay(List<ChargingStation> stations) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surface.withOpacity(0.95),
            AppColors.surface,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
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

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Charging Stations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  onPressed: () => setState(() => _showList = false),
                ),
              ],
            ),
          ),

          // Station list (scrollable, takes available space)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: stations.length,
              itemBuilder: (context, index) {
                final station = stations[index];
                final isSelected = _selectedStation?.id == station.id;
                return _CompactStationCard(
                  station: station,
                  isSelected: isSelected,
                  onTap: () => context.push('/charging/${station.id}'),
                  onNavigate: () => _openNavigation(station.latitude, station.longitude),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationQuickInfo(ChargingStation station) {
    final isAvailable = (station.availableChargers ?? 0) > 0;

    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () => setState(() => _selectedStation = null),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Station name
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Address
                      Text(
                        station.address,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF808080),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Quick stats
                      Row(
                        children: [
                          _buildQuickChip(Icons.ev_station, '${station.availableChargers ?? 0} available', isAvailable ? 'Open' : 'Full'),
                          const SizedBox(width: 8),
                          if (station.powerOutputKw != null)
                            _buildQuickChip(Icons.bolt, '${station.powerOutputKw!.toInt()} kW'),
                          if (station.distanceKm != null)
                            _buildQuickChip(Icons.location_on_outlined, '${station.distanceKm!.toStringAsFixed(1)} km'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: AppColors.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: () => setState(() => _selectedStation = null),
                    ),
                    const SizedBox(height: 4),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      color: AppColors.primary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: () => context.push('/charging/${station.id}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(IconData icon, String text, [String? status]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (status != null && status.contains('Full'))
            ? const Color(0xFF4a0d1d).withOpacity(0.1)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (status != null && status.contains('Open'))
              ? AppColors.success.withOpacity(0.3)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: (status != null && status.contains('Full'))
                  ? const Color(0xFF8A1538)
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            'No charging stations found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adjust your filters or check back later',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
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
          const Text(
            'Failed to load charging stations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF808080),
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
    );
  }

  String _getFilterLabel(StationFilterOption option) {
    switch (option) {
      case StationFilterOption.all:
        return 'All';
      case StationFilterOption.available:
        return 'Open';
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

  void _openNavigation(double lat, double lng) {
    final url = 'https://www.openstreetmap.org/directions?from=&to=$lat,$lng';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

/// Compact station card for list
class _CompactStationCard extends StatelessWidget {
  final ChargingStation station;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onNavigate;

  const _CompactStationCard({
    required this.station,
    required this.isSelected,
    required this.onTap,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = (station.availableChargers ?? 0) > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceVariant.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isAvailable ? const Color(0xFF00FFFF) : const Color(0xFF4a0d1d),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isAvailable ? const Color(0xFF00FFFF) : const Color(0xFF8A1538),
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Station info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    station.address,
                    style: const TextStyle(
                      fontSize: 11,
                      color: const Color(0xFF808080),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Quick stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${station.availableChargers ?? 0}/${station.totalChargers ?? 0}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? AppColors.success : AppColors.error,
                  ),
                ),
                if (station.distanceKm != null)
                  Text(
                    '${station.distanceKm!.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      fontSize: 10,
                      color: const Color(0xFF808080),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            // Navigate button
            IconButton(
              icon: const Icon(Icons.directions, color: AppColors.primary),
              onPressed: onNavigate,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
