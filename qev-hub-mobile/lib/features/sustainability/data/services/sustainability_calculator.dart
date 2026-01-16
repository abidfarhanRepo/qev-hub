import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/vehicle.dart';
import '../../../../data/models/user.dart';
import 'sustainability_report.dart';

/// Constants for sustainability calculations
class SustainabilityConstants {
  static const double qatarEmissionsFactor = 0.5; // kg CO2 per kWh (Qatar grid)
  static const double petrolEmissionsFactor = 2.3; // kg CO2 per liter
  static const double treeAbsorptionRate = 22.0; // kg CO2 per year
  static const double evEfficiency = 0.16; // kWh per km
  static const double petrolConsumptionRate = 0.08; // liters per km
}

/// Service for calculating sustainability metrics based on charging data
class SustainabilityCalculator {
  final SupabaseClient _supabase;

  SustainabilityCalculator(this._supabase);

  /// Calculate sustainability metrics for a user's vehicle
  Future<SustainabilityReport> calculateSustainability({
    required User user,
    required Vehicle vehicle,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Fetch charging sessions for the user
    final chargingSessions = await _fetchUserChargingSessions(
      userId: user.id,
      startDate: startDate,
      endDate: endDate,
    );

    // Calculate monthly data for trend analysis
    final monthlyData = await _calculateMonthlyData(user.id);

    // Calculate sustainability metrics
    final totalMetrics = _calculateTotalMetrics(chargingSessions);
    final thisMonthMetrics = _calculateMonthlyMetrics(
      monthlyData[DateTime.now().month] ?? [],
    );
    final previousMonthMetrics = _calculateMonthlyMetrics(
      monthlyData[(DateTime.now().month - 1) ?? 12] ?? [],
    );

    return SustainabilityReport(
      co2SavedKg: totalMetrics.co2SavedKg,
      treesEquivalent: totalMetrics.treesEquivalent,
      petrolAvoidedLiters: totalMetrics.petrolAvoidedLiters,
      energyUsedKwh: totalMetrics.energyUsedKwh,
      thisMonthChargingSessions: thisMonthMetrics.chargingSessions,
      previousMonthChargingSessions: previousMonthMetrics.chargingSessions,
      thisMonthCo2SavedKg: thisMonthMetrics.co2SavedKg,
      previousMonthCo2SavedKg: previousMonthMetrics.co2SavedKg,
      thisMonthPetrolAvoidedLiters: thisMonthMetrics.petrolAvoidedLiters,
      previousMonthPetrolAvoidedLiters: previousMonthMetrics.petrolAvoidedLiters,
      lastUpdated: DateTime.now(),
    );
  }

  /// Fetch user's charging sessions from Supabase
  Future<List<Map<String, dynamic>>> _fetchUserChargingSessions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      query = _supabase
          .from('charging_sessions')
          .select()
          .eq('user_id', userId);

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      query = query.order('created_at', ascending: false);

      final response = await query.execute();

      if (response.data != null) {
        return List<Map<String, dynamic>>.from(response.data!);
      }
      return [];
    } catch (e) {
      print('Error fetching charging sessions: $e');
      return [];
    }
  }

  /// Calculate sustainability metrics for a list of charging sessions
  _SustainabilityMetrics _calculateTotalMetrics(List<Map<String, dynamic>> sessions) {
    double totalEnergyUsedKwh = 0;
    double totalCo2SavedKg = 0;
    double totalPetrolAvoidedLiters = 0;

    for (final session in sessions) {
      final energyUsed = session['energy_delivered_kwh']?.toDouble() ?? 0.0;
      totalEnergyUsedKwh += energyUsed;

      // Calculate CO2 saved vs petrol car
      final kmDriven = energyUsed / SustainabilityConstants.evEfficiency;
      final petrolEquivalent = kmDriven * SustainabilityConstants.petrolConsumptionRate;

      // CO2 from petrol car: petrolEquivalent * emissions factor
      final petrolCarCo2 = petrolEquivalent * SustainabilityConstants.petrolEmissionsFactor;

      // CO2 from EV: energyUsed * Qatar emissions factor
      final evCo2 = energyUsed * SustainabilityConstants.qatarEmissionsFactor;

      totalCo2SavedKg += (petrolCarCo2 - evCo2).abs();
      totalPetrolAvoidedLiters += petrolEquivalent;
    }

    return _SustainabilityMetrics(
      energyUsedKwh: totalEnergyUsedKwh,
      co2SavedKg: totalCo2SavedKg,
      petrolAvoidedLiters: totalPetrolAvoidedLiters,
      treesEquivalent: totalCo2SavedKg / SustainabilityConstants.treeAbsorptionRate,
    );
  }

  /// Calculate monthly sustainability data
  Future<Map<int, List<Map<String, dynamic>>>> _calculateMonthlyData(String userId) async {
    try {
      final now = DateTime.now();
      final oneYearAgo = DateTime(now.year - 1, now.month, now.day);

      final response = await _supabase
          .from('charging_sessions')
          .select()
          .eq('user_id', userId)
          .gte('created_at', oneYearAgo.toIso8601String())
          .order('created_at', ascending: false)
          .execute();

      final monthlyData = <int, List<Map<String, dynamic>>>{};

      if (response.data != null) {
        for (final session in response.data!) {
          final sessionDate = DateTime.parse(session['created_at']);
          final month = sessionDate.month;
          monthlyData.putIfAbsent(month, () => []).add(session);
        }
      }

      return monthlyData;
    } catch (e) {
      print('Error calculating monthly data: $e');
      return {};
    }
  }

  /// Calculate sustainability metrics for a specific month
  _MonthlyMetrics _calculateMonthlyMetrics(List<Map<String, dynamic>> sessions) {
    final totalMetrics = _calculateTotalMetrics(sessions);

    return _MonthlyMetrics(
      chargingSessions: sessions.length,
      co2SavedKg: totalMetrics.co2SavedKg,
      petrolAvoidedLiters: totalMetrics.petrolAvoidedLiters,
      energyUsedKwh: totalMetrics.energyUsedKwh,
    );
  }

  /// Calculate trend percentage between two months
  double _calculateTrend(double current, double previous) {
    if (previous == 0) return current > 0 ? 100 : 0;
    return ((current - previous) / previous) * 100;
  }
}

/// Helper class for holding sustainability calculation results
class _SustainabilityMetrics {
  final double energyUsedKwh;
  final double co2SavedKg;
  final double petrolAvoidedLiters;
  final double treesEquivalent;

  const _SustainabilityMetrics({
    required this.energyUsedKwh,
    required this.co2SavedKg,
    required this.petrolAvoidedLiters,
    required this.treesEquivalent,
  });
}

/// Helper class for holding monthly sustainability metrics
class _MonthlyMetrics {
  final int chargingSessions;
  final double co2SavedKg;
  final double petrolAvoidedLiters;
  final double energyUsedKwh;

  const _MonthlyMetrics({
    required this.chargingSessions,
    required this.co2SavedKg,
    required this.petrolAvoidedLiters,
    required this.energyUsedKwh,
  });
}