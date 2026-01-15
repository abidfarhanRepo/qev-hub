import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/repositories/enhanced_charging_repository.dart';
import '../../../data/models/charging_station_enhanced.dart';
import '../../../data/models/charger.dart' as charger_model;
import '../../../../shared/widgets/charging_connectors.dart';
import '../../../../shared/widgets/charging_station_card.dart';
import '../../../../shared/widgets/charger_unit_card.dart';
import '../../../../shared/widgets/charger_connector_icons.dart';

/// Enhanced station detail screen with Tarsheed-style charger units display - FIXED VERSION
class EnhancedStationDetailFixed extends ConsumerStatefulWidget {
  final String stationId;

  const EnhancedStationDetailFixed({required this.stationId, super.key});

  @override
  ConsumerState<EnhancedStationDetailFixed> createState() => _EnhancedStationDetailFixedState();
}

class _EnhancedStationDetailFixedState extends ConsumerState<EnhancedStationDetailFixed> {
  final EnhancedChargingRepository _repository = EnhancedChargingRepository(Supabase.instance.client);

  ChargingStationEnhanced? _station;
  List<charger_model.Charger> _chargers = [];
  bool _isLoading = true;
  String? _errorMessage;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _loadData();
    _getCurrentLocation();
  }

  Future<void> _loadData() async {
    print('DEBUG: _loadData started for stationId: ${widget.stationId}');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('DEBUG: Fetching station from repository...');
      final station = await _repository.getStationById(widget.stationId);
      if (station == null) {
        throw Exception('Station not found');
      }
      print('DEBUG: Station loaded - ${station.name}');
      print('DEBUG: Station original data - chargerTypes: ${station.chargerTypes}, amenities: ${station.amenities}');
      print('DEBUG: Station original counts - available: ${station.availableChargers}, total: ${station.totalChargers}, power: ${station.powerOutputKw}');

      print('DEBUG: Fetching real chargers from database...');
      final chargers = await _repository.getChargersForStation(widget.stationId);
      print('DEBUG: Real chargers loaded - ${chargers.length} chargers');
      for (var charger in chargers) {
        print('DEBUG: Charger ${charger.chargerCode} - connector: ${charger.connectorType}, available: ${charger.isAvailable}, enabled: ${charger.isEnabled}, power: ${charger.powerOutputKw}');
      }

      // Extract connector types from chargers if station doesn't have them
      final connectorTypes = station.chargerTypes?.isNotEmpty == true
          ? station.chargerTypes!
          : chargers.map((c) => c.connectorType).where((t) => t != null).toSet().cast<String>().toList();
      print('DEBUG: Extracted connectorTypes: $connectorTypes');

      // Use station amenities or empty list if none
      final amenitiesList = station.amenities ?? <String>[];
      print('DEBUG: Amenities list: $amenitiesList');

      // Count available chargers from real data
      final availableCount = chargers.where((c) => c.isAvailable && c.isEnabled).length;
      final totalCount = chargers.length;
      print('DEBUG: Charger counts - available: $availableCount, total: $totalCount');

      // Get max power from chargers
      final maxPower = chargers.isNotEmpty
          ? chargers.map((c) => c.powerOutputKw ?? 0).reduce((a, b) => a > b ? a : b)
          : station.powerOutputKw ?? 0;
      print('DEBUG: Max power calculated: $maxPower');

      print('DEBUG: Calling copyWith...');
      final updatedStation = station.copyWith(
        chargerTypes: connectorTypes,
        amenities: amenitiesList,
        availableChargers: availableCount,
        totalChargers: totalCount,
        powerOutputKw: maxPower > 0 ? maxPower : station.powerOutputKw,
      );
      print('DEBUG: Updated station - chargerTypes: ${updatedStation.chargerTypes}, amenities: ${updatedStation.amenities}');
      print('DEBUG: Updated station counts - available: ${updatedStation.availableChargers}, total: ${updatedStation.totalChargers}, power: ${updatedStation.powerOutputKw}');

      setState(() {
        _station = updatedStation;
        _chargers = chargers;
        _isLoading = false;
      });
      print('DEBUG: setState completed, _isLoading = false');
    } catch (e) {
      print('DEBUG: Error in _loadData: $e');
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
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: build called - _isLoading: $_isLoading, _errorMessage: $_errorMessage, _station: ${_station?.name}');
    print('DEBUG: _station data - chargerTypes: ${_station?.chargerTypes}, available: ${_station?.availableChargers}, total: ${_station?.totalChargers}, power: ${_station?.powerOutputKw}');
    print('DEBUG: _chargers length: ${_chargers.length}');

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading station details...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_station == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Station Not Found')),
        body: const Center(
          child: Text('Station not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with station info
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF1E293B),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1E293B),
                      Color(0xFF334155),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: CustomPaint(
                          painter: _ChargingPatternPainter(),
                        ),
                      ),
                    ),

                    // Station info overlay
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Station name
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              _station!.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Operator badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _station!.operator ?? 'QEV',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Connector types
                          ConnectorTypesRow(
                            connectorTypes: _station!.chargerTypes,
                            iconSize: 28,
                            showLabels: true,
                          ),

                          const SizedBox(height: 12),

                          // Power and availability
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AvailabilityBadge(
                                availableChargers: _station!.availableChargers,
                                totalChargers: _station!.totalChargers,
                                large: true,
                                showNumbers: true,
                              ),

                              const SizedBox(width: 16),

                              PowerIndicator(
                                powerKw: _station!.powerOutputKw,
                                showLabel: true,
                                showEstimatedTime: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.directions),
                onPressed: _openDirections,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareStation,
              ),
            ],
          ),

          // Station details with improved spacing
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info cards with proper spacing
                  _buildQuickInfoSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Address and directions
                  _buildLocationSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Available chargers section with improved layout
                  _buildChargersSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoSection() {
    return Column(
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Station Information',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        
        // Info cards row
        Row(
          children: [
            // Availability card
            Expanded(
              child: _buildInfoCard(
                icon: Icons.ev_station,
                label: 'Available',
                value: '${_station!.availableChargers ?? 0}/${_station!.totalChargers ?? 0}',
                color: StationAvailability.fromCounts(
                  _station!.availableChargers,
                  _station!.totalChargers,
                ).color,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Power card
            Expanded(
              child: _buildInfoCard(
                icon: Icons.bolt,
                label: 'Max Power',
                value: '${_station!.powerOutputKw?.toInt() ?? 0} kW',
                color: PowerLevel.fromKw(_station!.powerOutputKw).color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Location',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _openDirections,
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Address and amenities
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _station!.address,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_station!.area != null) ...[
                    Text(
                      _station!.area!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Divider
                  if (_station!.amenities != null && _station!.amenities!.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Amenities',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    StationAmenities(
                      amenities: _station!.amenities,
                      iconSize: 24,
                      maxVisible: 10,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChargersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(
                Icons.electrical_services,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Charging Units',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_chargers.length} total',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Charger units list with proper spacing
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: ChargerUnitsList(
            chargers: _chargers,
            stationName: _station!.name,
            onChargerSelected: _onChargerSelected,
            onBookCharger: _onBookCharger,
          ),
        ),
      ],
    );
  }

  void _onChargerSelected(charger_model.Charger charger) {
    // Show charger details in a modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildChargerDetailsModal(charger),
    );
  }

  void _onBookCharger(charger_model.Charger charger) {
    if (_station == null) return;
    
    context.push(
      '/booking-simple?chargerId=${charger.id}&stationId=${_station!.id}',
    );
  }

  Widget _buildChargerDetailsModal(charger_model.Charger charger) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Modal header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      charger_model.Charger.getDisplayName(charger.chargerName, charger.chargerCode, charger.id),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
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
              
              // Charger card
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ChargerUnitCard(
                    charger: charger,
                    compact: false,
                    showBookingButton: true,
                    onBook: () {
                      Navigator.pop(context);
                      _onBookCharger(charger);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openDirections() async {
    if (_station == null) return;
    
    final uri = Uri(
      scheme: 'https',
      host: 'maps.google.com',
      queryParameters: {
        'api': '1',
        'destination': '${_station!.latitude},${_station!.longitude}',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _shareStation() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
      ),
    );
  }
}

/// Custom painter for charging pattern background
class _ChargingPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw a pattern of charging symbols
    const spacing = 30.0;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        // Draw small lightning bolt shapes
        canvas.drawCircle(
          Offset(x + spacing / 2, y + spacing / 2),
          4,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ChargingPatternPainter oldDelegate) => false;
}