import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../../data/models/vehicle.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for VehicleRepository
final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseVehicleRepository(client);
});

/// Provider for current vehicle filter
final vehicleFilterProvider = StateProvider<VehicleFilter>((ref) {
  return const VehicleFilter();
});

/// Provider for vehicle list state
class VehicleListNotifier extends StateNotifier<AsyncValue<VehicleListResult>> {
  final VehicleRepository _repository;
  VehicleFilter? _currentFilter;

  VehicleListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadVehicles();
  }

  Future<void> loadVehicles({VehicleFilter? filter, int page = 1}) async {
    if (page == 1) {
      _currentFilter = filter;
    }

    state = const AsyncValue.loading();

    try {
      final result = await _repository.getVehicles(
        filter: _currentFilter,
        page: page,
      );

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    // Handle null hasMore safely without force unwrap
    if (current == null || current.hasMore != true) return;

    try {
      final result = await _repository.getVehicles(
        filter: _currentFilter,
        page: current.page + 1,
        pageSize: current.pageSize,
      );

      final updated = VehicleListResult(
        vehicles: [...current.vehicles, ...result.vehicles],
        totalCount: result.totalCount,
        page: result.page,
        pageSize: result.pageSize,
        hasMore: result.hasMore,
      );

      state = AsyncValue.data(updated);
    } catch (e, st) {
      // Log error but keep existing data to allow retry
      debugPrint('Failed to load more vehicles: $e');
    }
  }

  Future<void> refresh() async {
    await loadVehicles(page: 1);
  }

  void applyFilter(VehicleFilter filter) {
    loadVehicles(filter: filter, page: 1);
  }

  void clearFilter() {
    loadVehicles(filter: const VehicleFilter(), page: 1);
  }
}

/// Provider for vehicle list
final vehicleListProvider =
    StateNotifierProvider<VehicleListNotifier, AsyncValue<VehicleListResult>>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return VehicleListNotifier(repository);
});

/// Provider for a single vehicle by ID
final vehicleProvider = FutureProvider.family<Vehicle?, String>((ref, id) async {
  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getVehicleById(id);
});

/// Provider for manufacturers list
final manufacturersProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getManufacturers();
});

/// Provider for vehicle types
final vehicleTypesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getVehicleTypes();
});

/// Provider for saved/favorite vehicles (stored in local storage)
final savedVehiclesProvider = StateProvider<Set<String>>((ref) {
  return const {};
});

/// Action to toggle saved vehicle
void toggleSavedVehicle(WidgetRef ref, String vehicleId) {
  final current = ref.read(savedVehiclesProvider);
  final updated = current.contains(vehicleId)
      ? current.where((id) => id != vehicleId).toSet()
      : {...current, vehicleId};
  ref.read(savedVehiclesProvider.notifier).state = updated;
}
