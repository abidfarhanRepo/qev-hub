import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'charger.freezed.dart';
part 'charger.g.dart';

enum ChargerStatus { available, occupied, maintenance, offline }

enum ChargerConnectorType {
  type2,
  ccs,
  chademo;

  static ChargerConnectorType? fromString(String? type) {
    if (type == null) return null;
    switch (type.toLowerCase()) {
      case 'type 2':
      case 'type2':
        return ChargerConnectorType.type2;
      case 'ccs':
        return ChargerConnectorType.ccs;
      case 'chademo':
        return ChargerConnectorType.chademo;
      default:
        return null;
    }
  }

  String get displayName {
    switch (this) {
      case ChargerConnectorType.type2:
        return 'Type 2';
      case ChargerConnectorType.ccs:
        return 'CCS';
      case ChargerConnectorType.chademo:
        return 'CHAdeMO';
    }
  }

  IconData get icon {
    switch (this) {
      case ChargerConnectorType.type2:
        return Icons.power;
      case ChargerConnectorType.ccs:
        return Icons.bolt;
      case ChargerConnectorType.chademo:
        return Icons.electric_car;
    }
  }

  Color get color {
    switch (this) {
      case ChargerConnectorType.type2:
        return const Color(0xFF00D084);
      case ChargerConnectorType.ccs:
        return const Color(0xFF3B82F6);
      case ChargerConnectorType.chademo:
        return const Color(0xFF8B5CF6);
    }
  }
}

enum PowerLevel {
  slow,
  fast,
  rapid;

  String get displayName {
    switch (this) {
      case PowerLevel.slow:
        return 'Slow Charging';
      case PowerLevel.fast:
        return 'Fast Charging';
      case PowerLevel.rapid:
        return 'Rapid Charging';
    }
  }

  static PowerLevel fromKw(double? kw) {
    if (kw == null) return PowerLevel.slow;
    if (kw < 22) return PowerLevel.slow;
    if (kw < 50) return PowerLevel.fast;
    return PowerLevel.rapid;
  }
}

@freezed
class Charger with _$Charger {
  const factory Charger({
    required String id,
    required String stationId,
    String? chargerCode,
    String? chargerName,
    String? connectorType,
    List<String>? connectorTypes,
    double? powerOutputKw,
    required bool isEnabled,
    required bool isAvailable,
    String? chargerStatus,
    double? pricingPerKwh,
    double? pricingPerMinute,
    int? maxCurrent,
    int? maxVoltage,
    DateTime? sessionStartTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Charger;

  factory Charger.fromJson(Map<String, dynamic> json) => _$ChargerFromJson(json);

  // Static methods for backward compatibility
  static String getDisplayName(String? name, String? code, String id) {
    return name ?? code ?? id.substring(0, 8).toUpperCase();
  }

  static ChargerStatus getEnhancedStatus(String? status, bool isEnabled, bool isAvailable) {
    if (!isEnabled) return ChargerStatus.offline;
    if (status == 'maintenance') return ChargerStatus.maintenance;
    if (!isAvailable || status == 'occupied') return ChargerStatus.occupied;
    return ChargerStatus.available;
  }

  static PowerLevel getPowerLevel(double? kw) {
    return PowerLevel.fromKw(kw);
  }

  static ChargerConnectorType? getConnectorTypeObject(String? type) {
    return ChargerConnectorType.fromString(type);
  }
}

// Extension for status color and icon
extension ChargerStatusExtension on ChargerStatus {
  Color get color {
    switch (this) {
      case ChargerStatus.available:
        return const Color(0xFF00D084);
      case ChargerStatus.occupied:
        return const Color(0xFFF59E0B);
      case ChargerStatus.maintenance:
        return const Color(0xFFEF4444);
      case ChargerStatus.offline:
        return const Color(0xFF737373);
    }
  }

  IconData get icon {
    switch (this) {
      case ChargerStatus.available:
        return Icons.check_circle;
      case ChargerStatus.occupied:
        return Icons.ev_station;
      case ChargerStatus.maintenance:
        return Icons.build;
      case ChargerStatus.offline:
        return Icons.block;
    }
  }

  String get displayName {
    switch (this) {
      case ChargerStatus.available:
        return 'Available';
      case ChargerStatus.occupied:
        return 'In Use';
      case ChargerStatus.maintenance:
        return 'Maintenance';
      case ChargerStatus.offline:
        return 'Offline';
    }
  }

  bool get isAvailable => this == ChargerStatus.available;
}
