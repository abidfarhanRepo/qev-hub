import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/repositories/enhanced_charging_repository.dart';
import '../../../data/models/charging_station_enhanced.dart';

/// Enhanced charging map screen with modern, clean design
class EnhancedChargingScreen extends StatefulWidget {
  const EnhancedChargingScreen({super.key});

  @override
  State<EnhancedChargingScreen> createState() => _EnhancedChargingScreenState();
}

class _EnhancedChargingScreenState extends State<EnhancedChargingScreen> {
  MapController? _mapController;
  final EnhancedChargingRepository _repository = EnhancedChargingRepository(Supabase.instance.client);
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChargingStationEnhanced> _stations = [];
  bool _isLoading = true;
  String? _errorMessage;
  ChargingStationEnhanced? _selectedStation;
  LatLng? _userLocation;
  String _searchQuery = '';
  String? _selectedOperator;
  List<String> _selectedConnectorTypes = [];
  double? _minPowerKw;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    // Ensure status bar is visible
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _loadStations();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    // Reset system UI when leaving screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _searchController.dispose();
    _scrollController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadStations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stations = await _repository.getAllStations();
      setState(() {
        _stations = stations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      if (_userLocation != null && !_isLoading && _mapController != null) {
        _mapController!.move(_userLocation!, 14);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  List<ChargingStationEnhanced> get _filteredStations {
    var stations = _stations;

    if (_searchQuery.isNotEmpty) {
      stations = stations.where((station) =>
          station.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          station.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (station.area?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    if (_selectedOperator != null) {
      stations = stations.where((station) =>
          station.operator?.toLowerCase() == _selectedOperator!.toLowerCase()
      ).toList();
    }

    if (_selectedConnectorTypes.isNotEmpty) {
      stations = stations.where((station) {
        if (station.chargerTypes == null) return false;
        return _selectedConnectorTypes.every((type) =>
            station.chargerTypes!.contains(type)
        );
      }).toList();
    }

    if (_minPowerKw != null) {
      stations = stations.where((station) =>
          (station.powerOutputKw ?? 0) >= _minPowerKw!
      ).toList();
    }

    return stations;
  }

  List<String> get _availableOperators {
    final operators = _stations.map((s) => s.operator).where((o) => o != null).toSet().cast<String>();
    return operators.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Filters (expanded)
            if (_showFilters) _buildFilters(),

            // Map and content
            Expanded(
              child: _isLoading ? _buildLoadingState() :
              _errorMessage != null ? _buildErrorState() :
              _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final filteredCount = _filteredStations.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.ev_station,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Charging Map',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      '$filteredCount stations',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Filter toggle
              GestureDetector(
                onTap: () => setState(() => _showFilters = !_showFilters),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _hasActiveFilters
                        ? AppColors.primary.withOpacity(0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _hasActiveFilters
                          ? AppColors.primary
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: _hasActiveFilters
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Search bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stations...',
                hintStyle: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textTertiary,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // Active filters chips
          if (_hasActiveFilters && !_showFilters)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _activeFilterCount,
                  itemBuilder: (context, index) => _buildActiveFilterChip(index),
                ),
              ),
            ),
        ],
      ),
    );
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedOperator != null) count++;
    count += _selectedConnectorTypes.length;
    if (_minPowerKw != null) count++;
    return count;
  }

  bool get _hasActiveFilters {
    return _selectedOperator != null ||
        _selectedConnectorTypes.isNotEmpty ||
        _minPowerKw != null;
  }

  Widget _buildActiveFilterChip(int index) {
    // Build filter chips in order
    int currentIndex = 0;

    if (_selectedOperator != null) {
      if (currentIndex == index) {
        return _buildFilterChip(
          label: _selectedOperator!,
          onTap: () => setState(() => _selectedOperator = null),
        );
      }
      currentIndex++;
    }

    for (final type in _selectedConnectorTypes) {
      if (currentIndex == index) {
        return _buildFilterChip(
          label: type,
          onTap: () => setState(() => _selectedConnectorTypes.remove(type)),
        );
      }
      currentIndex++;
    }

    if (_minPowerKw != null && currentIndex == index) {
      return _buildFilterChip(
        label: '≥${_minPowerKw!.toInt()} kW',
        onTap: () => setState(() => _minPowerKw = null),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFilterChip({required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.close,
                size: 14,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Power filter
          const Text(
            'Charging Speed',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              _buildPowerFilterChip('Any', null),
              _buildPowerFilterChip('22 kW', 22),
              _buildPowerFilterChip('50 kW', 50),
              _buildPowerFilterChip('150 kW', 150),
            ],
          ),

          const SizedBox(height: 14),

          // Connector types
          const Text(
            'Connector Types',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: ['Type 2', 'CCS', 'CHAdeMO'].map((type) {
              final isSelected = _selectedConnectorTypes.contains(type);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedConnectorTypes.remove(type);
                    } else {
                      _selectedConnectorTypes.add(type);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          )
                        : null,
                    color: isSelected ? null : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Operator filter
          const Text(
            'Operator',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildOperatorChip(null, 'All'),
              ..._availableOperators.map((op) => _buildOperatorChip(op, op)),
            ],
          ),

          const SizedBox(height: 12),

          // Clear all button
          if (_hasActiveFilters)
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOperator = null;
                  _selectedConnectorTypes.clear();
                  _minPowerKw = null;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Center(
                  child: Text(
                    'Clear All Filters',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPowerFilterChip(String label, double? power) {
    final isSelected = _minPowerKw == power;
    return GestureDetector(
      onTap: () => setState(() => _minPowerKw = power),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                )
              : null,
          color: isSelected ? null : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorChip(String? value, String label) {
    final isSelected = _selectedOperator == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedOperator = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                )
              : null,
          color: isSelected ? null : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Loading charging stations...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
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
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 34,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load stations',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _errorMessage ?? 'Unknown error',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _loadStations,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final filteredStations = _filteredStations;

    if (filteredStations.isEmpty) {
      return _buildEmptyState();
    }

    return Stack(
      children: [
        // Map
        _buildMap(filteredStations),

        // Map controls
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current location button
              FloatingActionButton(
                heroTag: 'location',
                mini: true,
                onPressed: _centerOnUserLocation,
                backgroundColor: AppColors.surface,
                elevation: 2,
                child: Icon(
                  Icons.my_location,
                  color: _userLocation != null ? AppColors.primary : AppColors.textSecondary,
                  size: 20,
                ),
              ),

              const SizedBox(height: 8),

              // List button
              FloatingActionButton(
                heroTag: 'list',
                mini: true,
                onPressed: () => _showStationList(filteredStations),
                backgroundColor: AppColors.surface,
                elevation: 2,
                child: const Icon(
                  Icons.list,
                  size: 20,
                ),
              ),
            ],
          ),
        ),

        // Selected station info
        if (_selectedStation != null)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildStationInfoCard(_selectedStation!),
          ),
      ],
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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.ev_station_outlined,
                size: 40,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No stations found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try adjusting your filters',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            if (_hasActiveFilters)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                    _selectedOperator = null;
                    _selectedConnectorTypes.clear();
                    _minPowerKw = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(List<ChargingStationEnhanced> stations) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _userLocation ?? const LatLng(25.3548, 51.1839),
        initialZoom: 14,
        minZoom: 10,
        maxZoom: 18,
        onTap: (tapPosition, point) {
          setState(() => _selectedStation = null);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}@2x.png',
          userAgentPackageName: 'com.qev.qev_hub_mobile',
        ),
        MarkerLayer(
          markers: [
            // User location marker
            if (_userLocation != null)
              Marker(
                point: _userLocation!,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Station markers
            ...stations.map((station) {
              final isSelected = _selectedStation?.id == station.id;
              final isAvailable = (station.availableChargers ?? 0) > 0;
              final powerLevel = PowerLevel.fromKw(station.powerOutputKw);

              return Marker(
                point: LatLng(station.latitude, station.longitude),
                width: isSelected ? 56 : 46,
                height: isSelected ? 56 : 46,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedStation = station);
                    _mapController.move(
                      LatLng(station.latitude, station.longitude),
                      15,
                    );
                  },
                  onDoubleTap: () {
                    context.push('/charging/${station.id}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getAvailabilityColor(station),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white70,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getAvailabilityColor(station).withOpacity(0.35),
                          blurRadius: isSelected ? 10 : 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.ev_station,
                          color: Colors.white,
                          size: isSelected ? 20 : 16,
                        ),
                        if (powerLevel != PowerLevel.slow) ...[
                          const SizedBox(height: 2),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  Color _getAvailabilityColor(ChargingStationEnhanced station) {
    final availability = StationAvailability.fromCounts(
      station.availableChargers,
      station.totalChargers,
    );
    return availability.color;
  }

  Widget _buildStationInfoCard(ChargingStationEnhanced station) {
    final availability = StationAvailability.fromCounts(
      station.availableChargers,
      station.totalChargers,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with name and availability
          Row(
            children: [
              // Availability indicator
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: availability.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${station.availableChargers ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Station name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      station.area ?? station.address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Power indicator
              if (station.powerOutputKw != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: PowerLevel.fromKw(station.powerOutputKw).color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: PowerLevel.fromKw(station.powerOutputKw).color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt,
                        color: AppColors.primary,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${station.powerOutputKw!.toInt()} kW',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Connector types
          if (station.chargerTypes != null && station.chargerTypes!.isNotEmpty)
            Wrap(
              spacing: 6,
              children: station.chargerTypes!.take(3).map((type) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    type,
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

          // View details button
          GestureDetector(
            onTap: () => context.push('/charging/${station.id}'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Center(
                child: Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Close button
          GestureDetector(
            onTap: () => setState(() => _selectedStation = null),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _centerOnUserLocation() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 15);
    } else {
      _getCurrentLocation();
    }
  }

  void _showStationList(List<ChargingStationEnhanced> stations) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StationListModal(
        stations: stations,
        onStationTap: (station) {
          Navigator.pop(context);
          setState(() => _selectedStation = station);
          _mapController.move(
            LatLng(station.latitude, station.longitude),
            15,
          );
        },
        onStationDoubleTap: (station) {
          Navigator.pop(context);
          context.push('/charging/${station.id}');
        },
      ),
    );
  }
}

/// Station list modal bottom sheet
class _StationListModal extends StatelessWidget {
  final List<ChargingStationEnhanced> stations;
  final Function(ChargingStationEnhanced) onStationTap;
  final Function(ChargingStationEnhanced) onStationDoubleTap;

  const _StationListModal({
    required this.stations,
    required this.onStationTap,
    required this.onStationDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Handle
              Container(
                width: 34,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 12),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Charging Stations',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Station list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    return _StationListItem(
                      station: station,
                      onTap: () => onStationTap(station),
                      onDoubleTap: () => onStationDoubleTap(station),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Station list item
class _StationListItem extends StatelessWidget {
  final ChargingStationEnhanced station;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const _StationListItem({
    required this.station,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final availability = StationAvailability.fromCounts(
      station.availableChargers,
      station.totalChargers,
    );

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Availability indicator
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: availability.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: availability.color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${station.availableChargers ?? 0}',
                  style: TextStyle(
                    color: availability.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    station.area ?? station.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Connector types
                  if (station.chargerTypes != null && station.chargerTypes!.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      children: station.chargerTypes!.take(2).map((type) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            type,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Power & arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (station.powerOutputKw != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: PowerLevel.fromKw(station.powerOutputKw).color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: PowerLevel.fromKw(station.powerOutputKw).color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${station.powerOutputKw!.toInt()}kW',
                      style: TextStyle(
                        color: PowerLevel.fromKw(station.powerOutputKw).color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Power level enum
enum PowerLevel {
  slow,
  fast,
  rapid;

  static PowerLevel fromKw(double? kw) {
    if (kw == null) return slow;
    if (kw < 22) return slow;
    if (kw < 50) return fast;
    return rapid;
  }

  Color get color {
    switch (this) {
      case slow:
        return const Color(0xFF4ADE80);
      case fast:
        return const Color(0xFFFBBF24);
      case rapid:
        return const Color(0xFFEF4444);
    }
  }
}

// Station availability enum
enum StationAvailability {
  available,
  limited,
  unavailable;

  static StationAvailability fromCounts(int? available, int? total) {
    if (available == null || total == null || total == 0) return unavailable;
    final ratio = available / total;
    if (ratio >= 0.5) return available;
    if (ratio > 0) return limited;
    return unavailable;
  }

  Color get color {
    switch (this) {
      case available:
        return const Color(0xFF00D084);
      case limited:
        return const Color(0xFFF59E0B);
      case unavailable:
        return const Color(0xFFEF4444);
    }
  }

  String get displayName {
    switch (this) {
      case available:
        return 'Available';
      case limited:
        return 'Limited';
      case unavailable:
        return 'Unavailable';
    }
  }

  bool get isAvailable => this != unavailable;
}
