import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/models/charging_station_enhanced.dart';
import 'charging_connectors.dart';

/// Enhanced charging station card with Tarsheed-style visual elements
class ChargingStationCard extends StatelessWidget {
  final ChargingStationEnhanced station;
  final VoidCallback? onTap;
  final VoidCallback? onDirections;
  final bool showOperator;
  final bool compact;

  const ChargingStationCard({
    super.key,
    required this.station,
    this.onTap,
    this.onDirections,
    this.showOperator = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and availability
              _buildHeader(),
              
              const SizedBox(height: 12),
              
              // Location and operator info
              _buildLocationInfo(),
              
              const SizedBox(height: 12),
              
              // Connectors and power
              if (!compact) ...[
                _buildChargingInfo(),
                const SizedBox(height: 12),
              ],
              
              // Amenities and actions row
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Availability badge
        AvailabilityBadge(
          availableChargers: station.availableChargers,
          totalChargers: station.totalChargers,
          large: true,
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
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (station.area != null && !compact) ...[
                const SizedBox(height: 2),
                Text(
                  station.area!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Power indicator
        PowerIndicator(
          powerKw: station.powerOutputKw,
          showLabel: !compact,
          showEstimatedTime: false,
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            station.address,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onDirections != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDirections,
            icon: Icon(
              Icons.directions,
              color: AppColors.primary,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChargingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Connector types
        ConnectorTypesRow(
          connectorTypes: station.chargerTypes,
          iconSize: 28,
          showLabels: true,
          padding: const EdgeInsets.only(bottom: 8),
        ),
        
        // Charging stats row
        Row(
          children: [
            // Available chargers text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getAvailabilityColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${station.availableChargers ?? 0} of ${station.totalChargers ?? 0} chargers available',
                style: TextStyle(
                  color: _getAvailabilityColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Power details
            if (station.powerOutputKw != null) ...[
              Icon(
                Icons.speed,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${station.powerOutputKw!.toInt()} kW max',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Amenities
        Expanded(
          child: StationAmenities(
            amenities: station.amenities,
            iconSize: 18,
            maxVisible: compact ? 2 : 4,
          ),
        ),
        
        // Operator badge
        if (showOperator && station.operator != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getOperatorColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getOperatorColor().withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              station.operator!,
              style: TextStyle(
                color: _getOperatorColor(),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        
        const SizedBox(width: 8),
        
        // Operating hours
        if (station.operatingHours != null) ...[
          Icon(
            Icons.access_time,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 2),
          Text(
            station.operatingHours!,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Color _getAvailabilityColor() {
    return StationAvailability.fromCounts(
      station.availableChargers,
      station.totalChargers,
    ).color;
  }

  Color _getOperatorColor() {
    switch (station.operator?.toLowerCase()) {
      case 'kahramaa':
        return Colors.blue;
      case 'woqod':
        return Colors.green;
      case 'abb':
        return Colors.red;
      case 'q-rail':
        return Colors.purple;
      case 'evbox':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Compact charging station card for map popup
class CompactStationCard extends StatelessWidget {
  final ChargingStationEnhanced station;
  final VoidCallback? onTap;

  const CompactStationCard({
    super.key,
    required this.station,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Availability indicator
              AvailabilityBadge(
                availableChargers: station.availableChargers,
                totalChargers: station.totalChargers,
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
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    ConnectorTypesRow(
                      connectorTypes: station.chargerTypes,
                      iconSize: 16,
                    ),
                  ],
                ),
              ),
              
              // Power indicator
              PowerIndicator(
                powerKw: station.powerOutputKw,
                showLabel: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Station list view with enhanced cards
class EnhancedStationList extends StatelessWidget {
  final List<ChargingStationEnhanced> stations;
  final Function(ChargingStationEnhanced) onStationSelected;
  final Function(ChargingStationEnhanced)? onGetDirections;
  final bool isLoading;
  final String? errorMessage;

  const EnhancedStationList({
    super.key,
    required this.stations,
    required this.onStationSelected,
    this.onGetDirections,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading stations...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {}, // Add retry functionality
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (stations.isEmpty) {
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return ChargingStationCard(
          station: station,
          onTap: () => onStationSelected(station),
          onDirections: onGetDirections != null 
              ? () => onGetDirections!(station) 
              : null,
        );
      },
    );
  }
}