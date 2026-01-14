import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/charging_station.dart';

/// Charging station repository interface
abstract class ChargingStationRepository {
  Future<StationListResult> getStations({
    StationFilter? filter,
    double? userLat,
    double? userLng,
  });

  Future<ChargingStation?> getStationById(String id);

  Future<List<ChargingStation>> getNearbyStations({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  });
}

/// Supabase implementation of ChargingStationRepository
class SupabaseChargingStationRepository implements ChargingStationRepository {
  final SupabaseClient _client;

  SupabaseChargingStationRepository(this._client);

  @override
  Future<StationListResult> getStations({
    StationFilter? filter,
    double? userLat,
    double? userLng,
  }) async {
    try {
      // Fetch all active stations
      var query = _client
          .from('charging_stations')
          .select();

      // Filter by status
      if (filter?.status != null) {
        query = query.eq('status', filter!.status!);
      } else {
        // Default to active stations only
        query = query.eq('status', 'active');
      }

      final response = await query.order('name');

      var stations = (response as List)
          .map((json) => ChargingStation.fromJson(json as Map<String, dynamic>))
          .toList();

      // Apply client-side filters
      if (filter != null) {
        // Filter by availability
        if (filter.availableOnly == true) {
          stations = stations
              .where((s) => (s.availableChargers ?? 0) > 0)
              .toList();
        }

        // Search query
        if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
          final query = filter.searchQuery!.toLowerCase();
          stations = stations
              .where((s) =>
                  s.name.toLowerCase().contains(query) ||
                  s.address.toLowerCase().contains(query))
              .toList();
        }
      }

      // Calculate distance if user location provided
      if (userLat != null && userLng != null) {
        for (var i = 0; i < stations.length; i++) {
          final station = stations[i];
          final distance = _calculateDistance(
            userLat,
            userLng,
            station.latitude,
            station.longitude,
          );
          stations[i] = station.copyWith(distanceKm: distance);
        }

        // Filter by nearby if requested
        if (filter?.nearbyOnly == true) {
          final maxDistance = filter?.maxDistanceKm ?? 10;
          stations.retainWhere((s) => (s.distanceKm ?? double.infinity) <= maxDistance);
        }

        // Sort by distance
        stations.sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));
      }

      return StationListResult(
        stations: stations,
        totalCount: stations.length,
        hasMore: false,
      );
    } catch (e) {
      print('Error fetching charging stations: $e');
      return StationListResult(
        stations: [],
        totalCount: 0,
        hasMore: false,
      );
    }
  }

  @override
  Future<ChargingStation?> getStationById(String id) async {
    try {
      final response = await _client
          .from('charging_stations')
          .select()
          .eq('id', id)
          .single();

      if (response == null) return null;

      return ChargingStation.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ChargingStation>> getNearbyStations({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    try {
      // Get all stations first
      final result = await getStations();

      // Calculate distance and filter
      final nearbyStations = <ChargingStation>[];
      for (var station in result.stations) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          station.latitude,
          station.longitude,
        );

        if (distance <= radiusKm) {
          nearbyStations.add(station.copyWith(distanceKm: distance));
        }
      }

      // Sort by distance
      nearbyStations.sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));

      return nearbyStations;
    } catch (e) {
      return [];
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadiusKm = 6371;

    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a = (dLat * dLat) +
        _toRadians(lat1) *
            _toRadians(lat2) *
            (dLng * dLng);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
