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

/// Converter for BookingStatus enum
class BookingStatusConverter implements JsonConverter<BookingStatus, String> {
  const BookingStatusConverter();

  @override
  BookingStatus fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'in_progress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'no_show':
        return BookingStatus.noShow;
      default:
        return BookingStatus.pending;
    }
  }

  @override
  String toJson(BookingStatus object) {
    switch (object) {
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

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String chargerId,
    required String stationId,
    required DateTime startTime,
    required DateTime endTime,
    @BookingStatusConverter() required BookingStatus status,
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
