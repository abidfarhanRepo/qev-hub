import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/charging_station_v2.dart';

/// Simple charging repository
class SimpleChargingRepository {
  final SupabaseClient _client;

  SimpleChargingRepository(this._client);

  /// Get all active charging stations
  Future<List<ChargingStationSimple>> getAllStations() async {
    try {
      print('🔍 Fetching charging stations from Supabase...');

      final response = await _client
          .from('charging_stations')
          .select()
          .eq('status', 'active');

      print('✅ Received response: ${response.length} items');

      final stations = <ChargingStationSimple>[];

      for (var item in response as List) {
        try {
          final station = ChargingStationSimple.fromJson(item as Map<String, dynamic>);
          print('✓ Parsed: ${station.name} at (${station.latitude}, ${station.longitude})');
          stations.add(station);
        } catch (e) {
          print('✗ Error parsing station: $e');
        }
      }

      print('📊 Successfully loaded ${stations.length} stations');
      return stations;
    } catch (e) {
      print('❌ Error fetching stations: $e');
      return [];
    }
  }

  /// Get a single station by ID
  Future<ChargingStationSimple?> getStationById(String id) async {
    try {
      final response = await _client
          .from('charging_stations')
          .select()
          .eq('id', id)
          .single();

      if (response == null) return null;
      return ChargingStationSimple.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('❌ Error fetching station: $e');
      return null;
    }
  }

  /// Get chargers for a station
  Future<List<Map<String, dynamic>>> getChargersForStation(String stationId) async {
    try {
      final response = await _client
          .from('chargers')
          .select()
          .eq('station_id', stationId)
          .eq('is_enabled', true);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Error fetching chargers: $e');
      return [];
    }
  }
}
