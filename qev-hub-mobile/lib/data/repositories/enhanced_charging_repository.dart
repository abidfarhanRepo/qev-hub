import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/charging_station_enhanced.dart';
import '../models/charger.dart';

/// Enhanced charging repository with Tarsheed-style connector information
class EnhancedChargingRepository {
  final SupabaseClient _client;

  EnhancedChargingRepository(this._client);

  /// Get all charging stations with enhanced information
  Future<List<ChargingStationEnhanced>> getAllStations() async {
    try {
      final response = await _client
          .from('charging_stations_enhanced')
          .select('*')
          .order('name') as List;

      return response
          .map((json) => ChargingStationEnhanced.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to basic stations table if enhanced doesn't exist
      return await _getFallbackStations();
    }
  }

  /// Get station by ID
  Future<ChargingStationEnhanced?> getStationById(String id) async {
    try {
      final response = await _client
          .from('charging_stations_enhanced')
          .select('*')
          .eq('id', id)
          .single() as Map<String, dynamic>;

      return ChargingStationEnhanced.fromJson(response);
    } catch (e) {
      // Fallback to basic stations table
      return await _getFallbackStationById(id);
    }
  }

  /// Get stations within radius of location
  Future<List<ChargingStationEnhanced>> getStationsNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      // Using PostGIS for spatial queries if available
      final response = await _client.rpc('get_stations_nearby', params: {
        'lat': latitude,
        'lng': longitude,
        'radius_km': radiusKm,
      });

      final List<dynamic> data = response as List<dynamic>? ?? [];
      return data
          .map((json) => ChargingStationEnhanced.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback method
      return await _getStationsNearbyManual(latitude, longitude, radiusKm);
    }
  }

  /// Filter stations by connector types
  Future<List<ChargingStationEnhanced>> getStationsByConnectors({
    List<String>? connectorTypes,
    double? minPowerKw,
    bool? availableOnly,
  }) async {
    try {
      var query = _client.from('charging_stations_enhanced').select('*');

      // Filter by connector types
      if (connectorTypes != null && connectorTypes.isNotEmpty) {
        query = query.contains('charger_types', connectorTypes);
      }

      // Filter by minimum power
      if (minPowerKw != null) {
        query = query.gte('power_output_kw', minPowerKw);
      }

      // Filter by availability
      if (availableOnly == true) {
        query = query.gt('available_chargers', 0);
      }

      final response = await query.order('name') as List;

      return response
          .map((json) => ChargingStationEnhanced.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to basic stations
      return await _getFallbackStations();
    }
  }

  /// Update station availability
  Future<void> updateStationAvailability({
    required String stationId,
    required int availableChargers,
    int? totalChargers,
  }) async {
    try {
      final updateData = {
        'available_chargers': availableChargers,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (totalChargers != null) {
        updateData['total_chargers'] = totalChargers;
      }

      await _client
          .from('charging_stations_enhanced')
          .update(updateData)
          .eq('id', stationId);
    } catch (e) {
      // Try updating basic table
      await _updateFallbackAvailability(stationId, availableChargers, totalChargers);
    }
  }

  /// Get stations by operator
  Future<List<ChargingStationEnhanced>> getStationsByOperator(String operator) async {
    try {
      final response = await _client
          .from('charging_stations_enhanced')
          .select('*')
          .eq('operator', operator)
          .order('name') as List;

      return response
          .map((json) => ChargingStationEnhanced.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback
      final allStations = await _getFallbackStations();
      return allStations.where((station) =>
          station.operator?.toLowerCase() == operator.toLowerCase()).toList();
    }
  }

  /// Import Tarsheed station data
  Future<void> importTarsheedStations(List<Map<String, dynamic>> tarsheedData) async {
    try {
      // Transform Tarsheed data to our format
      final enhancedStations = tarsheedData.map((tarsheedStation) {
        return {
          'id': tarsheedStation['id'],
          'name': tarsheedStation['name'],
          'address': tarsheedStation['name'], // Tarsheed uses name as address
          'operator': tarsheedStation['operator'],
          'area': tarsheedStation['area'],
          'latitude': tarsheedStation['latitude'],
          'longitude': tarsheedStation['longitude'],
          'charger_types': tarsheedStation['charger_types'],
          'total_chargers': tarsheedStation['total_chargers'],
          'available_chargers': tarsheedStation['available_chargers'],
          'power_output_kw': tarsheedStation['power_output_kw'],
          'amenities': tarsheedStation['amenities'],
          'operating_hours': tarsheedStation['operating_hours'] ?? '24/7',
          'status': 'active',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      // Bulk insert
      await _client
          .from('charging_stations_enhanced')
          .upsert(enhancedStations);
    } catch (e) {
      throw Exception('Import failed: $e');
    }
  }

  /// Get chargers for a specific station
  Future<List<Charger>> getChargersForStation(String stationId) async {
    try {
      final response = await _client
          .from('chargers')
          .select('*')
          .eq('station_id', stationId)
          .order('name') as List;

      return response.map((json) {
        final data = json as Map<String, dynamic>;
        final connectorTypesList = data['connector_types'] as List<dynamic>?;

        return Charger(
          id: data['id'] as String? ?? '',
          stationId: data['station_id'] as String? ?? '',
          chargerCode: data['name'] as String?,
          chargerName: data['name'] as String?,
          connectorType: connectorTypesList != null && connectorTypesList.isNotEmpty
              ? connectorTypesList[0] as String?
              : null,
          connectorTypes: connectorTypesList?.cast<String>(),
          powerOutputKw: (data['power_kw'] as num?)?.toDouble(),
          isEnabled: data['is_enabled'] as bool? ?? true,
          isAvailable: (data['status'] as String?) == 'available',
          chargerStatus: data['status'] as String?,
          createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
          updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
        );
      }).toList();
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  // Fallback methods for basic stations table
  Future<List<ChargingStationEnhanced>> _getFallbackStations() async {
    final response = await _client.from('charging_stations').select('*') as List;

    return response.map((json) {
      // Convert basic station to enhanced format
      final data = json as Map<String, dynamic>;
      return ChargingStationEnhanced(
        id: data['id'] as String? ?? '',
        name: data['name'] as String? ?? '',
        address: data['address'] as String? ?? '',
        operator: data['operator'] as String?,
        area: data['area'] as String?,
        latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
        chargerTypes: data['charger_types'] != null
            ? List<String>.from(data['charger_types'] as List)
            : null,
        totalChargers: data['total_chargers'] as int?,
        availableChargers: data['available_chargers'] as int?,
        powerOutputKw: (data['power_output_kw'] as num?)?.toDouble(),
        amenities: data['amenities'] != null
            ? List<String>.from(data['amenities'] as List)
            : null,
        operatingHours: data['operating_hours'] as String?,
        status: data['status'] as String?,
        pricingInfo: data['pricing_info'] as String?,
        phoneNumber: data['phone_number'] as String?,
        websiteUrl: data['website_url'] as String?,
        createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
        updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      );
    }).toList();
  }

  Future<ChargingStationEnhanced?> _getFallbackStationById(String id) async {
    final stations = await _getFallbackStations();
    try {
      return stations.firstWhere((station) => station.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<ChargingStationEnhanced>> _getStationsNearbyManual(
    double latitude,
    double longitude,
    double radiusKm
  ) async {
    final allStations = await _getFallbackStations();

    return allStations.where((station) {
      final distance = _calculateDistance(
        latitude, longitude,
        station.latitude, station.longitude
      );
      return distance <= radiusKm;
    }).toList();
  }

  Future<void> _updateFallbackAvailability(
    String stationId,
    int availableChargers,
    int? totalChargers
  ) async {
    final updateData = {
      'available_chargers': availableChargers,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (totalChargers != null) {
      updateData['total_chargers'] = totalChargers;
    }

    await _client
        .from('charging_stations')
        .update(updateData)
        .eq('id', stationId);
  }

  /// Calculate distance between two points in kilometers
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2
  ) {
    const double earthRadius = 6371; // kilometers

    final double dLat = (lat2 - lat1).toRadians();
    final double dLon = (lon2 - lon1).toRadians();

    final double a =
        (dLat / 2).sin() * (dLat / 2).sin() +
        lat1.toRadians().cos() * lat2.toRadians().cos() *
        (dLon / 2).sin() * (dLon / 2).sin();

    final double c = 2 * a.sqrt().asin();

    return earthRadius * c;
  }
}



extension on double {
  double toRadians() => this * (3.14159265359 / 180);
  double sin() => math.sin(this);
  double cos() => math.cos(this);
  double asin() => math.asin(this);
  double sqrt() => math.sqrt(this);
}
