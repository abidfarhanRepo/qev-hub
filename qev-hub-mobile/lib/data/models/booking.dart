import 'package:freezed_annotation/freezed_annotation.dart';
import 'charging_station.dart';
import 'charger.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
}

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String chargerId,
    required String stationId,
    required DateTime startTime,
    required DateTime endTime,
    required BookingStatus status,
    double? estimatedCost,
    double? actualCost,
    double? energyDelivered,
    String? notes,
    String? cancellationReason,
    DateTime? cancelledAt,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    // Relations
    Charger? charger,
    ChargingStation? station,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}

// Filter model
@freezed
class BookingFilter with _$BookingFilter {
  const factory BookingFilter({
    BookingStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    bool? upcomingOnly,
  }) = _BookingFilter;

  factory BookingFilter.fromJson(Map<String, dynamic> json) => _$BookingFilterFromJson(json);
}
