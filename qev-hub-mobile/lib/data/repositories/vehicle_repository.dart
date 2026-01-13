import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vehicle.dart';

/// Vehicle repository interface
abstract class VehicleRepository {
  Future<VehicleListResult> getVehicles({
    VehicleFilter? filter,
    int page = 1,
    int pageSize = 20,
  });

  Future<Vehicle?> getVehicleById(String id);

  Future<List<Vehicle>> searchVehicles(String query);

  Future<List<String>> getManufacturers();

  Future<List<String>> getVehicleTypes();
}

/// Supabase implementation of VehicleRepository
class SupabaseVehicleRepository implements VehicleRepository {
  final SupabaseClient _client;

  SupabaseVehicleRepository(this._client);

  @override
  Future<VehicleListResult> getVehicles({
    VehicleFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final from = (page - 1) * pageSize;
      final to = from + pageSize - 1;

      // For now, fetch all vehicles and paginate client-side
      // This can be optimized later with server-side filtering
      final response = await _client
          .from('vehicles')
          .select()
          .order('created_at', ascending: false)
          .range(from, to);

      print('DEBUG: Vehicles response: $response');

      final vehicles = (response as List)
          .map((json) => Vehicle.fromJson(json as Map<String, dynamic>))
          .toList();

      print('DEBUG: Parsed ${vehicles.length} vehicles');

      // Apply client-side filters for now
      var filteredVehicles = vehicles;

      if (filter != null) {
        if (filter.vehicleTypes != null && filter.vehicleTypes!.isNotEmpty) {
          final types = filter.vehicleTypes!.map((e) => e.name.toUpperCase()).toSet();
          filteredVehicles = filteredVehicles
              .where((v) => v.vehicleType != null && types.contains(v.vehicleType!.name.toUpperCase()))
              .toList();
        }

        if (filter.minPrice != null) {
          filteredVehicles = filteredVehicles
              .where((v) => (v.priceQar ?? v.price) >= filter.minPrice!)
              .toList();
        }

        if (filter.maxPrice != null) {
          filteredVehicles = filteredVehicles
              .where((v) => (v.priceQar ?? v.price) <= filter.maxPrice!)
              .toList();
        }

        if (filter.minRange != null) {
          filteredVehicles = filteredVehicles
              .where((v) => v.range != null && v.range! >= filter.minRange!)
              .toList();
        }

        if (filter.inStockOnly == true) {
          filteredVehicles = filteredVehicles
              .where((v) => (v.stockCount ?? 0) > 0)
              .toList();
        }
      }

      print('DEBUG: Filtered to ${filteredVehicles.length} vehicles');

      final hasMore = filteredVehicles.length == pageSize;

      return VehicleListResult(
        vehicles: filteredVehicles,
        totalCount: filteredVehicles.length + (hasMore ? 1 : 0),
        page: page,
        pageSize: pageSize,
        hasMore: hasMore,
      );
    } catch (e) {
      print('DEBUG: Error fetching vehicles: $e');
      return VehicleListResult(
        vehicles: [],
        totalCount: 0,
        page: page,
        pageSize: pageSize,
        hasMore: false,
      );
    }
  }

  @override
  Future<Vehicle?> getVehicleById(String id) async {
    try {
      final response = await _client
          .from('vehicles')
          .select()
          .eq('id', id)
          .single();

      if (response == null) return null;

      return Vehicle.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Vehicle>> searchVehicles(String query) async {
    try {
      // Search using a simple text filter
      final response = await _client
          .from('vehicles')
          .select()
          .or('manufacturer.ilike.%$query%,model.ilike.%$query%')
          .limit(20);

      return (response as List)
          .map((json) => Vehicle.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> getManufacturers() async {
    try {
      final response = await _client
          .from('vehicles')
          .select('manufacturer');

      final manufacturers = <String>{};
      for (final row in response as List) {
        final manufacturer = (row as Map<String, dynamic>)['manufacturer'] as String?;
        if (manufacturer != null) {
          manufacturers.add(manufacturer);
        }
      }

      return manufacturers.toList()..sort();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> getVehicleTypes() async {
    try {
      final response = await _client
          .from('vehicles')
          .select('vehicle_type')
          .not('vehicle_type', 'is', null);

      final types = <String>{};
      for (final row in response as List) {
        final type = (row as Map<String, dynamic>)['vehicle_type'] as String?;
        if (type != null) {
          types.add(type);
        }
      }

      return types.toList();
    } catch (e) {
      return ['EV', 'PHEV', 'FCEV'];
    }
  }
}
