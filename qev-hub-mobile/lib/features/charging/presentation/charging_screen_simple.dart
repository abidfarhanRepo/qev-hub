import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/repositories/charging_repository_simple.dart';
import '../../../data/models/charging_station_v2.dart';

/// Simple charging screen - rebuilt from scratch
class ChargingScreenSimple extends StatefulWidget {
  const ChargingScreenSimple({super.key});

  @override
  State<ChargingScreenSimple> createState() => _ChargingScreenSimpleState();
}

class _ChargingScreenSimpleState extends State<ChargingScreenSimple> {
  final MapController _mapController = MapController();
  final SimpleChargingRepository _repository = SimpleChargingRepository(Supabase.instance.client);

  List<ChargingStationSimple> _stations = [];
  bool _isLoading = true;
  String? _errorMessage;
  ChargingStationSimple? _selectedStation;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _loadStations();
    _getCurrentLocation();
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
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      // Center map on user location after stations load
      if (_userLocation != null && !_isLoading) {
        _mapController.move(_userLocation!, 14);
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _centerOnUserLocation() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 15);
    } else {
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading charging stations...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStations,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_stations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ev_station_outlined, size: 64),
            SizedBox(height: 16),
            Text('No charging stations found'),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Map
        _buildMap(),

        // Header with count
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          child: _buildHeader(),
        ),

        // Current location button (above list button)
        Positioned(
          right: 16,
          bottom: 80,
          child: FloatingActionButton(
            heroTag: 'location',
            mini: true,
            onPressed: _centerOnUserLocation,
            backgroundColor: AppColors.surface,
            child: Icon(
              Icons.my_location,
              color: _userLocation != null ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),

        // List button
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            heroTag: 'list',
            onPressed: () => _showStationList(),
            child: const Icon(Icons.list),
          ),
        ),

        // Selected station info
        if (_selectedStation != null)
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: _buildStationInfo(_selectedStation!),
          ),
      ],
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _userLocation ?? const LatLng(25.3548, 51.1839), // User location or Doha
        initialZoom: 14,
        minZoom: 10,
        maxZoom: 18,
        onTap: (tapPosition, point) {
          setState(() {
            _selectedStation = null;
          });
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
                    color: AppColors.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 3,
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
            ..._stations.map((station) {
            final isSelected = _selectedStation?.id == station.id;
            final isAvailable = (station.availableChargers ?? 0) > 0;

            return Marker(
              point: LatLng(station.latitude, station.longitude),
              width: isSelected ? 50 : 40,
              height: isSelected ? 50 : 40,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStation = station;
                  });
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
                    color: isAvailable ? Colors.cyan : Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white70,
                      width: isSelected ? 3 : 2,
                    ),
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
                      Icons.ev_station,
                      color: Colors.white,
                      size: isSelected ? 20 : 14,
                    ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
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
          const Icon(Icons.ev_station, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            '${_stations.length} Charging Stations',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationInfo(ChargingStationSimple station) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            station.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            station.address,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${station.availableChargers ?? 0}/${station.totalChargers ?? 0} chargers available',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push('/charging/${station.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStationList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Charging Stations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _stations.length,
                    itemBuilder: (context, index) {
                      final station = _stations[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                (station.availableChargers ?? 0) > 0
                                    ? Colors.green
                                    : Colors.red,
                            child: Text('${station.availableChargers ?? 0}'),
                          ),
                          title: Text(station.name),
                          subtitle: Text(station.address),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              _selectedStation = station;
                            });
                            _mapController.move(
                              LatLng(station.latitude, station.longitude),
                              15,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
