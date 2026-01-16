/// User vehicle association model
class UserVehicle {
  final String id;
  final String userId;
  final String vehicleId;
  final String vehicleName;
  final String manufacturer;
  final String model;
  final double batteryCapacity;
  final double range;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserVehicle({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.vehicleName,
    required this.manufacturer,
    required this.model,
    required this.batteryCapacity,
    required this.range,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a UserVehicle from JSON
  factory UserVehicle.fromJson(Map<String, dynamic> json) {
    return UserVehicle(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      vehicleId: json['vehicle_id'] as String,
      vehicleName: json['vehicle_name'] as String,
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      batteryCapacity: (json['battery_capacity'] as num).toDouble(),
      range: (json['range'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert UserVehicle to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'vehicle_name': vehicleName,
      'manufacturer': manufacturer,
      'model': model,
      'battery_capacity': batteryCapacity,
      'range': range,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  UserVehicle copyWith({
    String? id,
    String? userId,
    String? vehicleId,
    String? vehicleName,
    String? manufacturer,
    String? model,
    double? batteryCapacity,
    double? range,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserVehicle(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleName: vehicleName ?? this.vehicleName,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      range: range ?? this.range,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}