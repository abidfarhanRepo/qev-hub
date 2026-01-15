/// Simple charging station model - V2
class ChargingStationSimple {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int? totalChargers;
  final int? availableChargers;
  final String? status;

  ChargingStationSimple({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.totalChargers,
    this.availableChargers,
    this.status,
  });

  /// Create from Supabase JSON
  factory ChargingStationSimple.fromJson(Map<String, dynamic> json) {
    // Parse latitude/longitude - handle both string and numeric types
    double parseLat(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ChargingStationSimple(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Station',
      address: json['address'] as String? ?? '',
      latitude: parseLat(json['latitude']),
      longitude: parseLat(json['longitude']),
      totalChargers: json['total_chargers'] as int?,
      availableChargers: json['available_chargers'] as int?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'total_chargers': totalChargers,
      'available_chargers': availableChargers,
      'status': status,
    };
  }
}
