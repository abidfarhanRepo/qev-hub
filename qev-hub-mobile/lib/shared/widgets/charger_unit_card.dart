import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/models/charger.dart';
import 'charger_connector_icons.dart';

/// Individual charger unit card with Tarsheed-style connector icons and status
class ChargerUnitCard extends StatelessWidget {
  final Charger charger;
  final VoidCallback? onTap;
  final VoidCallback? onBook;
  final bool showBookingButton;
  final bool compact;

  const ChargerUnitCard({
    super.key,
    required this.charger,
    this.onTap,
    this.onBook,
    this.showBookingButton = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = Charger.getEnhancedStatus(charger.chargerStatus, charger.isEnabled, charger.isAvailable);
    final connectorType = charger.connectorType;
    final powerLevel = Charger.getPowerLevel(charger.powerOutputKw);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: status.color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(compact ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                status.color.withOpacity(0.05),
                status.color.withOpacity(0.02),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and connector info
              _buildHeader(status, connectorType, powerLevel),

              if (!compact) ...[
                const SizedBox(height: 12),

                // Power and pricing info
                _buildPowerInfo(status),

                const SizedBox(height: 12),

                // Connector type badges (prominently displayed) - show all available types
                if (charger.connectorTypes != null && charger.connectorTypes!.isNotEmpty)
                  _buildConnectorTypesBadges(charger.connectorTypes!),

                if (charger.connectorTypes != null && charger.connectorTypes!.isNotEmpty)
                  const SizedBox(height: 12),

                // Session details or action buttons
                _buildActionArea(status),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectorTypeBadge(String connectorType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.electrical_services,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            connectorType,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectorTypesBadges(List<String> connectorTypes) {
    // Display multiple connector types as small badges
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: connectorTypes.map((type) {
        final connectorTypeObj = ChargerConnectorType.fromString(type);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: connectorTypeObj?.color.withOpacity(0.1) ?? AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: connectorTypeObj?.color.withOpacity(0.4) ?? AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                connectorTypeObj?.icon ?? Icons.electrical_services,
                color: connectorTypeObj?.color ?? AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                connectorTypeObj?.displayName ?? type,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: connectorTypeObj?.color ?? AppColors.primary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHeader(ChargerStatus status, String? connectorType, PowerLevel powerLevel) {
    return Row(
      children: [
        // Status indicator
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: status.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: status.color.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              // Connector icon
              Center(
                child: _buildConnectorIcon(connectorType, status),
              ),

              // Status badge
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: status.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      status.icon,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Charger info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Charger.getDisplayName(charger.chargerName, charger.chargerCode, charger.id),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status.displayName,
                style: TextStyle(
                  fontSize: 12,
                  color: status.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Power level indicator
        _buildPowerIndicator(powerLevel),
      ],
    );
  }

  Widget _buildConnectorIcon(String? connectorType, ChargerStatus status) {
    return ChargerConnectorIcons.getIconForType(
      connectorType,
      size: 32,
      color: status.color.withOpacity(0.7),
    );
  }

  Widget _buildPowerIndicator(PowerLevel powerLevel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getPowerColor(powerLevel).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getPowerColor(powerLevel).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bolt,
                color: _getPowerColor(powerLevel),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${charger.powerOutputKw?.toInt() ?? 0}',
                style: TextStyle(
                  color: _getPowerColor(powerLevel),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: 2),
            Text(
              'kW',
              style: TextStyle(
                color: _getPowerColor(powerLevel),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getPowerColor(PowerLevel level) {
    switch (level) {
      case PowerLevel.slow:
        return const Color(0xFF4ADE80);
      case PowerLevel.fast:
        return const Color(0xFFFBBF24);
      case PowerLevel.rapid:
        return const Color(0xFFEF4444);
    }
  }

  Widget _buildPowerInfo(ChargerStatus status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Power output
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bolt,
                      size: 16,
                      color: status.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${charger.powerOutputKw?.toInt() ?? 0} kW',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: status.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  Charger.getPowerLevel(charger.powerOutputKw).displayName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Pricing info
          if (charger.pricingPerKwh != null) ...[
            Container(
              width: 1,
              height: 40,
              color: AppColors.border,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'QAR ${charger.pricingPerKwh?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'per kWh',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
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

  Widget _buildActionArea(ChargerStatus status) {
    if (status.isAvailable && showBookingButton) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onBook,
          style: ElevatedButton.styleFrom(
            backgroundColor: status.color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flash_on),
              SizedBox(width: 8),
              Text(
                'Start Charging',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (status == ChargerStatus.occupied) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: status.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: status.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: status.color,
                ),
                const SizedBox(width: 4),
                Text(
                  'Currently in use',
                  style: TextStyle(
                    fontSize: 12,
                    color: status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (charger.sessionStartTime != null) ...[
              const SizedBox(height: 4),
              Text(
                'Started at ${_formatTime(charger.sessionStartTime!)}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // For maintenance, offline, error states
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            status.icon,
            size: 16,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Text(
            status.displayName,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// List of charger units for a station
class ChargerUnitsList extends StatelessWidget {
  final List<Charger> chargers;
  final Function(Charger) onChargerSelected;
  final Function(Charger)? onBookCharger;
  final String stationName;

  const ChargerUnitsList({
    super.key,
    required this.chargers,
    required this.onChargerSelected,
    this.onBookCharger,
    required this.stationName,
  });

  @override
  Widget build(BuildContext context) {
    if (chargers.isEmpty) {
      return _buildEmptyState();
    }

    // Group chargers by status
    final availableChargers = chargers.where((c) => Charger.getEnhancedStatus(c.chargerStatus, c.isEnabled, c.isAvailable).isAvailable).toList();
    final occupiedChargers = chargers.where((c) => Charger.getEnhancedStatus(c.chargerStatus, c.isEnabled, c.isAvailable) == ChargerStatus.occupied).toList();
    final otherChargers = chargers.where((c) =>
        !Charger.getEnhancedStatus(c.chargerStatus, c.isEnabled, c.isAvailable).isAvailable && Charger.getEnhancedStatus(c.chargerStatus, c.isEnabled, c.isAvailable) != ChargerStatus.occupied
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Available chargers
        if (availableChargers.isNotEmpty) ...[
          _buildSectionHeader('${availableChargers.length} Available', Colors.green),
          ...availableChargers.map((charger) => ChargerUnitCard(
            charger: charger,
            onTap: () => onChargerSelected(charger),
            onBook: onBookCharger != null ? () => onBookCharger!(charger) : null,
          )),
        ],

        // Occupied chargers
        if (occupiedChargers.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader('${occupiedChargers.length} In Use', Colors.blue),
          ...occupiedChargers.map((charger) => ChargerUnitCard(
            charger: charger,
            onTap: () => onChargerSelected(charger),
            showBookingButton: false,
          )),
        ],

        // Other status chargers
        if (otherChargers.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader('${otherChargers.length} Unavailable', Colors.grey),
          ...otherChargers.map((charger) => ChargerUnitCard(
            charger: charger,
            onTap: () => onChargerSelected(charger),
            showBookingButton: false,
          )),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ev_station_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No chargers available at this station',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check back later or try another station',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}