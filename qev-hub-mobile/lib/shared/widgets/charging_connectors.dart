import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../data/models/charging_station_enhanced.dart';

/// Individual connector icon widget
class ConnectorIcon extends StatelessWidget {
  final ConnectorType connectorType;
  final double size;
  final bool isActive;
  final String? tooltip;

  const ConnectorIcon({
    super.key,
    required this.connectorType,
    this.size = 24.0,
    this.isActive = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = isActive ? AppColors.primary : AppColors.textTertiary;
    
    Widget icon;
    switch (connectorType) {
      case ConnectorType.type2:
        icon = _buildType2Icon(iconColor);
        break;
      case ConnectorType.ccs:
        icon = _buildCCSIcon(iconColor);
        break;
      case ConnectorType.chademo:
        icon = _buildCHAdeMOIcon(iconColor);
        break;
    }

    Widget wrappedIcon = SizedBox(
      width: size,
      height: size,
      child: icon,
    );

    if (tooltip != null) {
      wrappedIcon = Tooltip(
        message: tooltip!,
        child: wrappedIcon,
      );
    }

    return wrappedIcon;
  }

  /// Type 2 connector icon (AC charging)
  Widget _buildType2Icon(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Center(
        child: Icon(
          Icons.power,
          color: color,
          size: size * 0.6,
        ),
      ),
    );
  }

  /// CCS connector icon (DC fast charging)
  Widget _buildCCSIcon(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
      child: Center(
        child: Icon(
          Icons.bolt,
          color: color,
          size: size * 0.6,
        ),
      ),
    );
  }

  /// CHAdeMO connector icon (Japanese standard)
  Widget _buildCHAdeMOIcon(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Center(
        child: Icon(
          Icons.electric_car,
          color: color,
          size: size * 0.6,
        ),
      ),
    );
  }
}

/// Connector types row widget
class ConnectorTypesRow extends StatelessWidget {
  final List<String>? connectorTypes;
  final double iconSize;
  final bool showLabels;
  final EdgeInsetsGeometry? padding;

  const ConnectorTypesRow({
    super.key,
    this.connectorTypes,
    this.iconSize = 24.0,
    this.showLabels = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final connectors = ConnectorType.fromStrings(connectorTypes);
    
    if (connectors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: connectors.map((connector) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConnectorIcon(
                  connectorType: connector,
                  size: iconSize,
                  tooltip: connector.displayName,
                ),
                if (showLabels) ...[
                  const SizedBox(height: 4),
                  Text(
                    connector.displayName,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Power indicator widget
class PowerIndicator extends StatelessWidget {
  final double? powerKw;
  final bool showLabel;
  final bool showEstimatedTime;

  const PowerIndicator({
    super.key,
    this.powerKw,
    this.showLabel = true,
    this.showEstimatedTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final powerLevel = PowerLevel.fromKw(powerKw);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: powerLevel.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: powerLevel.color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt,
            color: powerLevel.color,
            size: 16,
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${powerKw?.toInt() ?? 0} kW',
                  style: TextStyle(
                    color: powerLevel.color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showEstimatedTime)
                  Text(
                    powerLevel.estimatedTime,
                    style: TextStyle(
                      color: powerLevel.color.withOpacity(0.8),
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Availability badge widget
class AvailabilityBadge extends StatelessWidget {
  final int? availableChargers;
  final int? totalChargers;
  final bool showNumbers;
  final bool large;

  const AvailabilityBadge({
    super.key,
    this.availableChargers,
    this.totalChargers,
    this.showNumbers = true,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final availability = StationAvailability.fromCounts(availableChargers, totalChargers);
    final size = large ? 32.0 : 24.0;
    
    Widget badge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: availability.color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: availability.color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: showNumbers
            ? FittedBox(
                child: Text(
                  '${availableChargers ?? 0}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Icon(
                availability.isAvailable ? Icons.check : Icons.close,
                color: Colors.white,
                size: size * 0.5,
              ),
      ),
    );

    if (large && showNumbers) {
      badge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: availability.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              availability.isAvailable ? Icons.ev_station : Icons.ev_station_outlined,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '${availableChargers ?? 0}/${totalChargers ?? 0}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Tooltip(
      message: availability.displayName,
      child: badge,
    );
  }
}

/// Station amenities widget
class StationAmenities extends StatelessWidget {
  final List<String>? amenities;
  final double iconSize;
  final int maxVisible;

  const StationAmenities({
    super.key,
    this.amenities,
    this.iconSize = 20.0,
    this.maxVisible = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (amenities == null || amenities!.isEmpty) {
      return const SizedBox.shrink();
    }

    final amenityList = amenities!.take(maxVisible).toList();
    final hasMore = (amenities?.length ?? 0) > maxVisible;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...amenityList.map((amenity) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _buildAmenityIcon(amenity),
        )),
        if (hasMore)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${(amenities?.length ?? 0) - maxVisible}',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAmenityIcon(String amenity) {
    IconData icon;
    Color color = AppColors.textSecondary;

    switch (amenity.toLowerCase()) {
      case 'parking':
        icon = Icons.local_parking;
        break;
      case 'restroom':
        icon = Icons.wc;
        break;
      case 'wifi':
        icon = Icons.wifi;
        color = AppColors.primary;
        break;
      case 'food':
        icon = Icons.restaurant;
        color = Colors.orange;
        break;
      case 'convenience store':
        icon = Icons.store;
        color = Colors.blue;
        break;
      default:
        icon = Icons.star_outline;
    }

    return Tooltip(
      message: amenity,
      child: Icon(
        icon,
        size: iconSize,
        color: color,
      ),
    );
  }
}