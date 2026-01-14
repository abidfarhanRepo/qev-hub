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
        state = const AsyncValue.data([]);
        return;
      }

      final response = await _client
          .from('bookings')
          .select('*, charger:chargers(*), station:charging_stations(*)')
          .eq('user_id', userId)
          .order('start_time', ascending: true);

      final bookings = (response as List).map((json) {
        // Handle relations
        final chargerData = json['charger'] as Map<String, dynamic>?;
        final stationData = json['station'] as Map<String, dynamic>?;

        return Booking.fromJson({
          ...json,
          'charger': chargerData,
          'station': stationData,
        });
      }).toList();

      // Filter based on upcomingOnly
      final now = DateTime.now();
      final filteredBookings = bookings.where((booking) {
        if (upcomingOnly) {
          // Upcoming: pending, confirmed, in_progress, or future bookings
          return booking.status == BookingStatus.pending ||
              booking.status == BookingStatus.confirmed ||
              booking.status == BookingStatus.inProgress ||
              booking.startTime.isAfter(now);
        } else {
          // Past: completed, cancelled, no_show, or past start time
          return booking.status == BookingStatus.completed ||
              booking.status == BookingStatus.cancelled ||
              booking.status == BookingStatus.noShow ||
              booking.startTime.isBefore(now);
        }
      }).toList();

      state = AsyncValue.data(filteredBookings);
    } catch (e, st) {
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

  return Booking.fromJson({
    ...response,
    'charger': chargerData,
    'station': stationData,
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
