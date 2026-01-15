import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/booking.dart';
import '../../../data/models/charger.dart';

/// Provider for upcoming bookings
final upcomingBookingsProvider =
    StateNotifierProvider<BookingListNotifier, AsyncValue<List<Booking>>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return BookingListNotifier(client, upcomingOnly: true);
});

/// Provider for past bookings
final pastBookingsProvider =
    StateNotifierProvider<BookingListNotifier, AsyncValue<List<Booking>>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return BookingListNotifier(client, upcomingOnly: false);
});

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Notifier for booking list
class BookingListNotifier extends StateNotifier<AsyncValue<List<Booking>>> {
  final SupabaseClient _client;
  final bool upcomingOnly;

  BookingListNotifier(this._client, {required this.upcomingOnly})
      : super(const AsyncValue.loading()) {
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    state = const AsyncValue.loading();

    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        print('🔴 No user ID found');
        state = const AsyncValue.data([]);
        return;
      }

      print('🔵 Loading bookings for user: $userId');
      final response = await _client
          .from('bookings')
          .select('*, charger:chargers(*), station:charging_stations(*)')
          .eq('user_id', userId)
          .order('start_time', ascending: true);

      print('📊 Received ${response.length} bookings from DB');
      final bookings = (response as List).map((json) {
        // Handle relations
        final chargerData = json['charger'] as Map<String, dynamic>?;
        final stationData = json['station'] as Map<String, dynamic>?;

        // Convert snake_case DB fields to camelCase for Dart model
        return Booking.fromJson({
          'id': json['id']?.toString() ?? '',
          'userId': json['user_id']?.toString() ?? '',
          'chargerId': json['charger_id']?.toString() ?? '',
          'stationId': json['station_id']?.toString() ?? '',
          'startTime': json['start_time']?.toString() ?? DateTime.now().toIso8601String(),
          'endTime': json['end_time']?.toString() ?? DateTime.now().toIso8601String(),
          'status': json['status']?.toString() ?? 'pending',
          'estimatedCost': json['estimated_cost'],
          'actualCost': json['actual_cost'],
          'energyDelivered': json['energy_delivered'],
          'notes': json['notes'],
          'cancellationReason': json['cancellation_reason'],
          'cancelledAt': json['cancelled_at']?.toString(),
          'completedAt': json['completed_at']?.toString(),
          'createdAt': json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
          'updatedAt': json['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
          // Don't include charger/station relations - they'll be loaded separately if needed
          'charger': null,
          'station': null,
        });
      }).toList();

      // Filter based on upcomingOnly
      final now = DateTime.now();
      print('⏰ Current time: $now');
      print('🔍 Filtering for upcomingOnly=$upcomingOnly');

      final filteredBookings = bookings.where((booking) {
        if (upcomingOnly) {
          // Upcoming: pending, confirmed, in_progress, or future bookings
          final match = booking.status == BookingStatus.pending ||
              booking.status == BookingStatus.confirmed ||
              booking.status == BookingStatus.inProgress ||
              booking.startTime.isAfter(now);
          print('  📋 Booking ${booking.id.substring(0,8)}: status=${booking.status}, start=${booking.startTime}, match=$match');
          return match;
        } else {
          // Past: completed, cancelled, no_show, or past start time
          return booking.status == BookingStatus.completed ||
              booking.status == BookingStatus.cancelled ||
              booking.status == BookingStatus.noShow ||
              booking.startTime.isBefore(now);
        }
      }).toList();

      print('✅ Filtered to ${filteredBookings.length} bookings');
      state = AsyncValue.data(filteredBookings);
    } catch (e, st) {
      print('❌ ERROR loading bookings: $e');
      print('❌ Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await _loadBookings();
  }

  Future<bool> cancelBooking(String bookingId, String reason) async {
    try {
      await _client
          .from('bookings')
          .update({
            'status': 'cancelled',
            'cancellation_reason': reason,
            'cancelled_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);

      // Refresh the list
      await _loadBookings();
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Provider for a single booking by ID
final bookingProvider = FutureProvider.family<Booking?, String>((ref, id) async {
  final client = ref.watch(supabaseClientProvider);

  final response = await client
      .from('bookings')
      .select('*, charger:chargers(*), station:charging_stations(*)')
      .eq('id', id)
      .single();

  final chargerData = response['charger'] as Map<String, dynamic>?;
  final stationData = response['station'] as Map<String, dynamic>?;

  // Convert snake_case DB fields to camelCase for Dart model
  return Booking.fromJson({
    'id': response['id']?.toString() ?? '',
    'userId': response['user_id']?.toString() ?? '',
    'chargerId': response['charger_id']?.toString() ?? '',
    'stationId': response['station_id']?.toString() ?? '',
    'startTime': response['start_time']?.toString() ?? DateTime.now().toIso8601String(),
    'endTime': response['end_time']?.toString() ?? DateTime.now().toIso8601String(),
    'status': response['status']?.toString() ?? 'pending',
    'estimatedCost': response['estimated_cost'],
    'actualCost': response['actual_cost'],
    'energyDelivered': response['energy_delivered'],
    'notes': response['notes'],
    'cancellationReason': response['cancellation_reason'],
    'cancelledAt': response['cancelled_at']?.toString(),
    'completedAt': response['completed_at']?.toString(),
    'createdAt': response['created_at']?.toString() ?? DateTime.now().toIso8601String(),
    'updatedAt': response['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
    // Don't include charger/station relations - they'll be loaded separately if needed
    'charger': null,
    'station': null,
  });
});

/// Provider for chargers by station ID
final stationChargersProvider = FutureProvider.family<List<Charger>, String>((ref, stationId) async {
  final client = ref.watch(supabaseClientProvider);

  final response = await client
      .from('chargers')
      .select('*')
      .eq('station_id', stationId)
      .eq('is_enabled', true)
      .order('created_at', ascending: true);

  // Handle null or non-list responses
  if (response == null || response is! List) {
    return [];
  }

  return (response as List).map((json) => Charger.fromJson(json)).toList();
});

/// Provider for a single charger by ID
final chargerProvider = FutureProvider.family<Charger?, String>((ref, id) async {
  final client = ref.watch(supabaseClientProvider);

  final response = await client
      .from('chargers')
      .select('*')
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return Charger.fromJson(response);
});
