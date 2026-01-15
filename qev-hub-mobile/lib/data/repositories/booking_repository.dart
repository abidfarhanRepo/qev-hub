import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';
import '../models/charger.dart';
import '../models/time_slot.dart';

part 'booking_repository.freezed.dart';
part 'booking_repository.g.dart';

/// Booking repository interface
abstract class BookingRepository {
  Future<List<Charger>> getChargersByStation(String stationId);
  Future<Charger?> getChargerById(String id);
  Future<List<TimeSlot>> getAvailableSlots(String chargerId, DateTime date);
  Future<Booking> createBooking(CreateBookingRequest request);
  Future<List<Booking>> getUserBookings({BookingFilter? filter});
  Future<Booking?> getBookingById(String id);
  Future<void> cancelBooking(String id, {String? reason});
  Future<void> updateBookingStatus(String id, BookingStatus status);
  Future<List<Booking>> getUpcomingBookings();
  Future<List<Booking>> getPastBookings();
}

/// Request model for creating a booking
@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    required String chargerId,
    required String stationId,
    required DateTime startTime,
    required DateTime endTime,
    double? estimatedCost,
    String? notes,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);
}

/// Result model for booking list operations
@freezed
class BookingListResult with _$BookingListResult {
  const factory BookingListResult({
    required List<Booking> bookings,
    required int totalCount,
    bool? hasMore,
  }) = _BookingListResult;

  factory BookingListResult.fromJson(Map<String, dynamic> json) =>
      _$BookingListResultFromJson(json);
}

/// Supabase implementation of BookingRepository
class SupabaseBookingRepository implements BookingRepository {
  final SupabaseClient _client;

  SupabaseBookingRepository(this._client);

  @override
  Future<List<Charger>> getChargersByStation(String stationId) async {
    try {
      final response = await _client
          .from('chargers')
          .select()
          .eq('station_id', stationId)
          .eq('is_enabled', true)
          .order('name');

      if (response == null) return [];

      return (response as List)
          .map((json) => Charger.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching chargers: $e');
      return [];
    }
  }

  @override
  Future<Charger?> getChargerById(String id) async {
    try {
      final response = await _client
          .from('chargers')
          .select()
          .eq('id', id)
          .single();

      if (response == null) return null;

      return Charger.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<TimeSlot>> getAvailableSlots(
    String chargerId,
    DateTime date,
  ) async {
    try {
      // Convert date to UTC for querying
      final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Get existing bookings for this charger on the given date
      final response = await _client
          .from('bookings')
          .select()
          .eq('charger_id', chargerId)
          .gte('start_time', startOfDay.toIso8601String())
          .lt('start_time', endOfDay.toIso8601String())
          .inFilter('status', [
            'pending',
            'confirmed',
            'in_progress',
          ]);

      final bookings = (response as List?)
              ?.map((json) => Booking.fromJson(json as Map<String, dynamic>))
              .toList() ??
          [];

      // Generate hourly slots for the day
      final slots = <TimeSlot>[];
      final slotDuration = const Duration(hours: 1);

      for (int i = 0; i < 24; i++) {
        final slotStart = startOfDay.add(Duration(hours: i));
        final slotEnd = slotStart.add(slotDuration);

        // Check if this slot overlaps with any existing booking
        final hasConflict = bookings.any((booking) =>
            booking.startTime.isBefore(slotEnd) &&
            booking.endTime.isAfter(slotStart));

        final isAvailable = !hasConflict;

        slots.add(TimeSlot(
          startTime: slotStart,
          endTime: slotEnd,
          isAvailable: isAvailable,
          reason: isAvailable ? null : 'Already booked',
          existingBookingId: isAvailable ? null : bookings.firstWhere(
            (booking) =>
                booking.startTime.isBefore(slotEnd) &&
                booking.endTime.isAfter(slotStart),
            orElse: () => BookingExtension.empty(),
          ).id,
        ));
      }

      return slots;
    } catch (e) {
      print('Error fetching available slots: $e');
      return [];
    }
  }

  @override
  Future<Booking> createBooking(CreateBookingRequest request) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Convert times to UTC
      final startTimeUtc = request.startTime.toUtc();
      final endTimeUtc = request.endTime.toUtc();

      // Check charger availability using the database function
      final availabilityCheck = await _client.rpc('check_charger_available',
          params: {
            'p_charger_id': request.chargerId,
            'p_start_time': startTimeUtc.toIso8601String(),
            'p_end_time': endTimeUtc.toIso8601String(),
          });

      if (availabilityCheck == false) {
        throw Exception(
            'Charger is not available for the selected time slot');
      }

      // Create the booking
      final response = await _client.from('bookings').insert({
        'user_id': userId,
        'charger_id': request.chargerId,
        'station_id': request.stationId,
        'start_time': startTimeUtc.toIso8601String(),
        'end_time': endTimeUtc.toIso8601String(),
        'status': 'pending',
        'estimated_cost': request.estimatedCost,
        'notes': request.notes,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).select().single();

      if (response == null) {
        throw Exception('Failed to create booking');
      }

      // Fetch the booking with relations
      final bookingWithRelations = await _client
          .from('bookings')
          .select('''
            *,
            charger:chargers(*),
            station:charging_stations(*)
          ''')
          .eq('id', response['id'])
          .single();

      return Booking.fromJson(
          bookingWithRelations as Map<String, dynamic>);
    } catch (e) {
      // Check for constraint violations (exclusion constraint for overlapping bookings)
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('23p01') || errorMsg.contains('exclusion') || errorMsg.contains('overlap')) {
        throw Exception('This time slot is already booked. Please choose another time.');
      }
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<List<Booking>> getUserBookings({BookingFilter? filter}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Build query with select and filters
      var query = _client
          .from('bookings')
          .select('''
            *,
            charger:chargers(*),
            station:charging_stations(*)
          ''')
          .eq('user_id', userId);

      // Apply filters after select
      if (filter != null) {
        if (filter.status != null) {
          final statusValue = _bookingStatusToString(filter.status!);
          query = query.eq('status', statusValue);
        }

        if (filter.startDate != null) {
          query = query.gte('start_time',
              filter.startDate!.toUtc().toIso8601String());
        }

        if (filter.endDate != null) {
          query = query.lte('start_time',
              filter.endDate!.toUtc().toIso8601String());
        }

        if (filter.upcomingOnly == true) {
          query = query.gte('start_time',
              DateTime.now().toUtc().toIso8601String());
        }
      }

      // Apply order and execute
      final response = await query.order('start_time', ascending: false);

      return (response as List)
          .map((json) => Booking.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching user bookings: $e');
      return [];
    }
  }

  @override
  Future<Booking?> getBookingById(String id) async {
    try {
      final response = await _client
          .from('bookings')
          .select('''
            *,
            charger:chargers(*),
            station:charging_stations(*)
          ''')
          .eq('id', id)
          .single();

      if (response == null) return null;

      return Booking.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cancelBooking(String id, {String? reason}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _client.from('bookings').update({
        'status': 'cancelled',
        'cancellation_reason': reason,
        'cancelled_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', id).eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  @override
  Future<void> updateBookingStatus(String id, BookingStatus status) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updateData = <String, dynamic>{
        'status': _bookingStatusToString(status),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      // Add completed_at timestamp if status is completed
      if (status == BookingStatus.completed) {
        updateData['completed_at'] =
            DateTime.now().toUtc().toIso8601String();
      }

      await _client.from('bookings').update(updateData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  @override
  Future<List<Booking>> getUpcomingBookings() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from('bookings')
          .select('''
            *,
            charger:chargers(*),
            station:charging_stations(*)
          ''')
          .eq('user_id', userId)
          .inFilter('status', ['pending', 'confirmed'])
          .gte('start_time', DateTime.now().toUtc().toIso8601String())
          .order('start_time', ascending: true);

      return (response as List)
          .map((json) => Booking.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching upcoming bookings: $e');
      return [];
    }
  }

  @override
  Future<List<Booking>> getPastBookings() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from('bookings')
          .select('''
            *,
            charger:chargers(*),
            station:charging_stations(*)
          ''')
          .eq('user_id', userId)
          .or('end_time.lt.${DateTime.now().toUtc().toIso8601String()},status.in.(completed,cancelled,no_show)')
          .order('start_time', ascending: false);

      return (response as List)
          .map((json) => Booking.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching past bookings: $e');
      return [];
    }
  }

  /// Convert BookingStatus enum to database string value
  String _bookingStatusToString(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.inProgress:
        return 'in_progress';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.noShow:
        return 'no_show';
    }
  }
}

// Extension to provide an empty Booking for TimeSlot fallback
extension BookingExtension on Booking {
  static Booking empty() => Booking(
    id: '',
    userId: '',
    chargerId: '',
    stationId: '',
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    status: BookingStatus.pending,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
