import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/vehicle.dart';
import '../../../../data/models/user.dart';
import '../models/sustainability_report.dart';
import '../services/sustainability_calculator.dart';

/// Provider for the SustainabilityCalculator
final sustainabilityCalculatorProvider = Provider<SustainabilityCalculator>(
  (ref) => SustainabilityCalculator(Supabase.instance.client),
);

/// State for sustainability data loading
class SustainabilityState {
  final AsyncValue<SustainabilityReport?> report;
  final AsyncValue<List<Map<String, dynamic>>> userVehicles;
  final AsyncValue<Vehicle?> currentVehicle;
  final bool isLoading;
  final String? error;

  const SustainabilityState({
    this.report = const AsyncValue.data(null),
    this.userVehicles = const AsyncValue.data([]),
    this.currentVehicle = const AsyncValue.data(null),
    this.isLoading = false,
    this.error,
  });

  SustainabilityState copyWith({
    AsyncValue<SustainabilityReport?>? report,
    AsyncValue<List<Map<String, dynamic>>>? userVehicles,
    AsyncValue<Vehicle?>? currentVehicle,
    bool? isLoading,
    String? error,
    bool? clearError,
  }) {
    return SustainabilityState(
      report: report ?? this.report,
      userVehicles: userVehicles ?? this.userVehicles,
      currentVehicle: currentVehicle ?? this.currentVehicle,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Provider for sustainability state management
final sustainabilityProvider = StateNotifierProvider<SustainabilityNotifier, SustainabilityState>((ref) {
  final calculator = ref.watch(sustainabilityCalculatorProvider);
  return SustainabilityNotifier(calculator);
});

/// Notifier for managing sustainability state
class SustainabilityNotifier extends StateNotifier<SustainabilityState> {
  final SustainabilityCalculator _calculator;

  SustainabilityNotifier(this._calculator) : super(const SustainabilityState());

  /// Load sustainability data for a user
  Future<void> loadSustainabilityData(User user) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // Fetch user's vehicles
      final vehicles = await _fetchUserVehicles(user.id);
      state = state.copyWith(
        userVehicles: AsyncValue.data(vehicles),
        isLoading: false,
      );

      // If user has vehicles, calculate sustainability for the first one
      if (vehicles.isNotEmpty) {
        await calculateSustainability(user: user, vehicleId: vehicles[0]['id']);
      }
    } catch (e, stack) {
      print('Error loading sustainability data: $e');
      print('Stack trace: $stack');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load sustainability data: $e',
      );
    }
  }

  /// Calculate sustainability metrics for a specific vehicle
  Future<void> calculateSustainability({
    required User user,
    required String vehicleId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // Get vehicle details
      final vehicle = await _fetchVehicleDetails(vehicleId);
      state = state.copyWith(currentVehicle: AsyncValue.data(vehicle));

      if (vehicle != null) {
        // Calculate sustainability report
        final report = await _calculator.calculateSustainability(
          user: user,
          vehicle: vehicle,
          startDate: startDate,
          endDate: endDate,
        );

        state = state.copyWith(
          report: AsyncValue.data(report),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Vehicle not found',
        );
      }
    } catch (e, stack) {
      print('Error calculating sustainability: $e');
      print('Stack trace: $stack');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to calculate sustainability metrics: $e',
      );
    }
  }

  /// Refresh sustainability data
  Future<void> refreshSustainabilityData(User user) async {
    if (state.userVehicles.value?.isNotEmpty == true) {
      await calculateSustainability(
        user: user,
        vehicleId: state.userVehicles.value![0]['id'],
      );
    }
  }

  /// Fetch user's vehicles from the database
  Future<List<Map<String, dynamic>>> _fetchUserVehicles(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('user_vehicles')
          .select('''
            *,
            vehicles (*)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .execute();

      if (response.data != null) {
        return List<Map<String, dynamic>>.from(response.data!);
      }
      return [];
    } catch (e) {
      print('Error fetching user vehicles: $e');
      throw Exception('Failed to fetch user vehicles');
    }
  }

  /// Fetch vehicle details by ID
  Future<Vehicle?> _fetchVehicleDetails(String vehicleId) async {
    try {
      final response = await Supabase.instance.client
          .from('vehicles')
          .select()
          .eq('id', vehicleId)
          .single()
          .execute();

      if (response.data != null) {
        return Vehicle.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching vehicle details: $e');
      throw Exception('Failed to fetch vehicle details');
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for formatted sustainability summary
final sustainabilitySummaryProvider = Provider.autoDispose((ref) {
  final report = ref.watch(sustainabilityProvider.select((state) => state.report.value));
  final state = ref.watch(sustainabilityProvider);

  if (report == null) {
    return const SustainabilitySummary(
      totalCo2SavedKg: 0,
      totalTreesEquivalent: 0,
      totalPetrolAvoidedLiters: 0,
      co2SavedFormatted: '0 kg',
      treesEquivalentFormatted: '0 trees',
      petrolAvoidedFormatted: '0 L',
      monthlyTrendPercentage: 0,
      isPositiveTrend: true,
    );
  }

  // Calculate monthly trend
  final monthlyTrendPercentage = report.previousMonthCo2SavedKg > 0
      ? ((report.thisMonthCo2SavedKg - report.previousMonthCo2SavedKg) /
         report.previousMonthCo2SavedKg) * 100
      : 0;

  // Format values for display
  final co2SavedFormatted = _formatNumber(report.co2SavedKg, 'kg');
  final treesEquivalentFormatted = _formatNumber(report.treesEquivalent, 'tree', plural: 'trees');
  final petrolAvoidedFormatted = _formatNumber(report.petrolAvoidedLiters, 'L');

  return SustainabilitySummary(
    totalCo2SavedKg: report.co2SavedKg,
    totalTreesEquivalent: report.treesEquivalent,
    totalPetrolAvoidedLiters: report.petrolAvoidedLiters,
    co2SavedFormatted: co2SavedFormatted,
    treesEquivalentFormatted: treesEquivalentFormatted,
    petrolAvoidedFormatted: petrolAvoidedFormatted,
    monthlyTrendPercentage: monthlyTrendPercentage,
    isPositiveTrend: monthlyTrendPercentage >= 0,
  );
});

/// Helper function to format numbers with units
String _formatNumber(double value, String unit, {String plural = ''}) {
  if (value >= 1000) {
    final formattedValue = (value / 1000).toStringAsFixed(1);
    return '$formattedValue k$unit';
  } else if (value >= 1) {
    final formattedValue = value.toStringAsFixed(1);
    return '$formattedValue $unit${(value > 1 && plural.isNotEmpty ? plural : unit)}';
  } else if (value > 0) {
    final formattedValue = value.toStringAsFixed(2);
    return '$formattedValue $unit${(value > 1 && plural.isNotEmpty ? plural : unit)}';
  } else {
    return '0 $unit${plural.isNotEmpty ? plural : unit}';
  }
}

/// Provider for sustainability insights
final sustainabilityInsightsProvider = Provider.autoDispose((ref) {
  final report = ref.watch(sustainabilityProvider.select((state) => state.report.value));
  final summary = ref.watch(sustainabilitySummaryProvider);

  if (report == null) {
    return const <String>[];
  }

  final insights = <String>[];

  // Add insights based on usage patterns
  if (report.thisMonthChargingSessions > 0) {
    final avgEnergyPerSession = report.energyUsedKwh / report.thisMonthChargingSessions;
    insights.add('You saved ${summary.totalCo2SavedFormatted} this month');

    if (report.previousMonthChargingSessions > 0) {
      final sessionChange = report.thisMonthChargingSessions - report.previousMonthChargingSessions;
      if (sessionChange > 0) {
        insights.add('$sessionChange more charging sessions than last month');
      } else if (sessionChange < 0) {
        insights.add('${abs(sessionChange)} fewer charging sessions than last month');
      } else {
        insights.add('Same number of charging sessions as last month');
      }
    }

    if (summary.monthlyTrendPercentage > 0) {
      insights.add('${summary.monthlyTrendPercentage.abs().toStringAsFixed(1)}% improvement in CO₂ savings');
    }
  } else {
    insights.add('No charging sessions recorded this month');
  }

  return insights;
});