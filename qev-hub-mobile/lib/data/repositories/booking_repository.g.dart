// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateBookingRequestImpl _$$CreateBookingRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateBookingRequestImpl(
  chargerId: json['chargerId'] as String,
  stationId: json['stationId'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$CreateBookingRequestImplToJson(
  _$CreateBookingRequestImpl instance,
) => <String, dynamic>{
  'chargerId': instance.chargerId,
  'stationId': instance.stationId,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'estimatedCost': instance.estimatedCost,
  'notes': instance.notes,
};

_$BookingListResultImpl _$$BookingListResultImplFromJson(
  Map<String, dynamic> json,
) => _$BookingListResultImpl(
  bookings: (json['bookings'] as List<dynamic>)
      .map((e) => Booking.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  hasMore: json['hasMore'] as bool?,
);

Map<String, dynamic> _$$BookingListResultImplToJson(
  _$BookingListResultImpl instance,
) => <String, dynamic>{
  'bookings': instance.bookings,
  'totalCount': instance.totalCount,
  'hasMore': instance.hasMore,
};
