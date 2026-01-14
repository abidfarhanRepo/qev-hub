import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/repositories/charging_station_repository.dart';
import '../../../data/models/charging_station.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for ChargingStationRepository
final chargingStationRepositoryProvider = Provider<ChargingStationRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseChargingStationRepository(client);
});

/// Provider for current station filter
final stationFilterProvider = StateProvider<StationFilter>((ref) {
  return const StationFilter();
});

/// Provider for user location
final userLocationProvider = StateProvider<Position?>((ref) {
  return null;
});

/// Provider for charging stations state
class StationListNotifier extends StateNotifier<AsyncValue<StationListResult>> {
  final ChargingStationRepository _repository;

  StationListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadStations();
  }

  Future<void> loadStations({StationFilter? filter}) async {
    state = const AsyncValue.loading();

    try {
      // Get user location if available
      Position? userPosition;
      try {
        userPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
      } catch (e) {
        // Location not available, continue without it
      }

      final result = await _repository.getStations(
        filter: filter,
        userLat: userPosition?.latitude,
        userLng: userPosition?.longitude,
      );

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadStations();
  }

  void applyFilter(StationFilter filter) {
    loadStations(filter: filter);
  }

  void clearFilter() {
    loadStations(filter: const StationFilter());
  }
}

/// Provider for station list
final stationListProvider =
    StateNotifierProvider<StationListNotifier, AsyncValue<StationListResult>>((ref) {
  final repository = ref.watch(chargingStationRepositoryProvider);
  return StationListNotifier(repository);
});

/// Provider for a single station by ID
final stationProvider = FutureProvider.family<ChargingStation?, String>((ref, id) async {
  final repository = ref.watch(chargingStationRepositoryProvider);
  return repository.getStationById(id);
});

/// Provider for nearby stations
final nearbyStationsProvider = FutureProvider<List<ChargingStation>>((ref) async {
  final repository = ref.watch(chargingStationRepositoryProvider);
  final userPosition = ref.watch(userLocationProvider);

  if (userPosition == null) {
    return [];
  }

  return repository.getNearbyStations(
    latitude: userPosition.latitude,
    longitude: userPosition.longitude,
    radiusKm: 10,
  );
});

/// Action to get current user location
Future<Position?> getCurrentUserLocation(WidgetRef ref) async {
  try {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check for permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    ref.read(userLocationProvider.notifier).state = position;
    return position;
  } catch (e) {
    return null;
  }
}

/// Filter option enum
enum StationFilterOption {
  all,
  available,
  nearby,
}

/// Provider for selected filter option
final selectedFilterOptionProvider = StateProvider<StationFilterOption>((ref) {
  return StationFilterOption.all;
});
