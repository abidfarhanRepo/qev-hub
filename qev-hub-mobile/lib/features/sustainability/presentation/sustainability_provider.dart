import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/presentation/auth_provider.dart';

/// Vehicle data model
class UserVehicle {
  final String id;
  final String manufacturer;
  final String model;
  final int year;
  final int? rangeKm;
  final double? batteryKwh;
  final String? imageUrl;

  UserVehicle({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.year,
    this.rangeKm,
    this.batteryKwh,
    this.imageUrl,
  });

  factory UserVehicle.fromJson(Map<String, dynamic> json) {
    return UserVehicle(
      id: json['id'] as String,
      manufacturer: json['manufacturer'] ?? json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      rangeKm: json['range_km'] as int?,
      batteryKwh: (json['battery_kwh'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
    );
  }
}

/// Sustainability calculation results
class SustainabilityMetrics {
  final double co2Saved;
  final double treesEquivalent;
  final double petrolAvoided;
  final double monthlyCo2Trend;
  final String co2SavedFormatted;
  final String treesEquivalentFormatted;
  final String petrolAvoidedFormatted;
  final String monthlyTrendFormatted;

  const SustainabilityMetrics({
    required this.co2Saved,
    required this.treesEquivalent,
    required this.petrolAvoided,
    required this.monthlyCo2Trend,
    required this.co2SavedFormatted,
    required this.treesEquivalentFormatted,
    required this.petrolAvoidedFormatted,
    required this.monthlyTrendFormatted,
  });

  factory SustainabilityMetrics.empty() {
    return const SustainabilityMetrics(
      co2Saved: 0,
      treesEquivalent: 0,
      petrolAvoided: 0,
      monthlyCo2Trend: 0,
      co2SavedFormatted: '0',
      treesEquivalentFormatted: '0',
      petrolAvoidedFormatted: '0',
      monthlyTrendFormatted: '+0',
    );
  }
}

/// Provider for user's selected vehicle
final selectedVehicleProvider = FutureProvider<UserVehicle?>((ref) async {
  final client = ref.read(supabaseClientProvider);

  try {
    // Get the current user
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return null;

    // Query the user's active vehicle
    final response = await client
        .from('user_vehicles')
        .select('vehicle_id, vehicles!inner(*)')
        .eq('user_id', user.id)
        .eq('is_active', true)
        .single();

    if (response == null) return null;

    final vehicleData = response['vehicles'] as Map<String, dynamic>;
    return UserVehicle.fromJson(vehicleData);
  } catch (e) {
    // If no selected vehicle or error, return null
    return null;
  }
});

/// Provider for sustainability calculations
final sustainabilityProvider = FutureProvider<SustainabilityMetrics>((ref) async {
  final vehicle = ref.watch(selectedVehicleProvider).value;

  if (vehicle == null) {
    return SustainabilityMetrics.empty();
  }

  // Calculate sustainability metrics based on vehicle specs
  return _calculateSustainabilityMetrics(vehicle);
});

/// Helper function to calculate sustainability metrics
SustainabilityMetrics _calculateSustainabilityMetrics(UserVehicle vehicle) {
  // Qatar-specific calculations
  // Based on vehicle battery capacity and efficiency

  // Constants for Qatar
  const double gridEmissionFactor = 0.5; // kg CO2 per kWh (Qatar grid)
  const double petrolEmissionFactor = 2.3; // kg CO2 per liter
  const double treeAbsorptionRate = 22.0; // kg CO2 per year per tree
  const double evEfficiency = 0.16; // kWh per km
  const double petrolConsumptionRate = 0.08; // liters per km

  // Calculate based on vehicle's battery capacity
  // Assuming vehicle is charged once per week (52 times per year)
  final double batteryCapacity = vehicle.batteryKwh ?? 60.0; // Default 60kWh
  final double chargingSessionsPerYear = 52.0;
  final double totalEnergyPerYear = batteryCapacity * chargingSessionsPerYear;

  // CO2 calculations
  final double co2FromElectricity = totalEnergyPerYear * gridEmissionFactor;
  final double distanceDriven = totalEnergyPerYear / evEfficiency;
  final double petrolWouldHaveUsed = distanceDriven * petrolConsumptionRate;
  final double co2FromPetrol = petrolWouldHaveUsed * petrolEmissionFactor;
  final double co2Saved = co2FromPetrol - co2FromElectricity;

  // Trees equivalent
  final double treesEquivalent = co2Saved / treeAbsorptionRate;

  // Petrol avoided
  final double petrolAvoided = petrolWouldHaveUsed;

  // Monthly trend (assuming 1/12 of annual for current month)
  final double monthlyCo2Trend = co2Saved / 12;

  // Format numbers for display
  String formatNumber(double num) {
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return num.toStringAsFixed(0);
  }

  return SustainabilityMetrics(
    co2Saved: co2Saved,
    treesEquivalent: treesEquivalent,
    petrolAvoided: petrolAvoided,
    monthlyCo2Trend: monthlyCo2Trend,
    co2SavedFormatted: formatNumber(co2Saved),
    treesEquivalentFormatted: formatNumber(treesEquivalent),
    petrolAvoidedFormatted: formatNumber(petrolAvoided),
    monthlyTrendFormatted: '+${formatNumber(monthlyCo2Trend)}',
  );
}

/// Action to set user's selected vehicle
Future<void> setSelectedVehicle(WidgetRef ref, String vehicleId) async {
  final client = ref.read(supabaseClientProvider);
  final user = ref.watch(currentUserProvider).value;

  if (user == null) return;

  try {
    // First, deactivate all existing vehicles for this user
    await client
        .from('user_vehicles')
        .update({'is_active': false})
        .eq('user_id', user.id);

    // Then, insert or update the selected vehicle as active
    final existing = await client
        .from('user_vehicles')
        .select()
        .eq('user_id', user.id)
        .eq('vehicle_id', vehicleId)
        .maybeSingle();

    if (existing != null) {
      // Update existing
      await client
          .from('user_vehicles')
          .update({'is_active': true})
          .eq('id', existing['id']);
    } else {
      // Insert new
      await client
          .from('user_vehicles')
          .insert({
            'user_id': user.id,
            'vehicle_id': vehicleId,
            'is_active': true,
          });
    }

    // Invalidate the selected vehicle provider to trigger refresh
    ref.invalidate(selectedVehicleProvider);
  } catch (e) {
    throw Exception('Failed to set selected vehicle: $e');
  }
}

/// Action to clear user's selected vehicle
Future<void> clearSelectedVehicle(WidgetRef ref) async {
  final client = ref.read(supabaseClientProvider);
  final user = ref.watch(currentUserProvider).value;

  if (user == null) return;

  try {
    await client
        .from('user_vehicles')
        .update({'is_active': false})
        .eq('user_id', user.id);

    // Invalidate the selected vehicle provider to trigger refresh
    ref.invalidate(selectedVehicleProvider);
  } catch (e) {
    throw Exception('Failed to clear selected vehicle: $e');
  }
}