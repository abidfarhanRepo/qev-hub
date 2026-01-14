// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      chargerId: json['chargerId'] as String,
      stationId: json['stationId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
      actualCost: (json['actualCost'] as num?)?.toDouble(),
      energyDelivered: (json['energyDelivered'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      charger: json['charger'] == null
          ? null
          : Charger.fromJson(json['charger'] as Map<String, dynamic>),
      station: json['station'] == null
          ? null
          : ChargingStation.fromJson(json['station'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'chargerId': instance.chargerId,
      'stationId': instance.stationId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': _$BookingStatusEnumMap[instance.status]!,
      'estimatedCost': instance.estimatedCost,
      'actualCost': instance.actualCost,
      'energyDelivered': instance.energyDelivered,
      'notes': instance.notes,
      'cancellationReason': instance.cancellationReason,
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'charger': instance.charger,
      'station': instance.station,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.inProgress: 'inProgress',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.noShow: 'noShow',
};

_$BookingFilterImpl _$$BookingFilterImplFromJson(Map<String, dynamic> json) =>
    _$BookingFilterImpl(
      status: $enumDecodeNullable(_$BookingStatusEnumMap, json['status']),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      upcomingOnly: json['upcomingOnly'] as bool?,
    );

Map<String, dynamic> _$$BookingFilterImplToJson(_$BookingFilterImpl instance) =>
    <String, dynamic>{
      'status': _$BookingStatusEnumMap[instance.status],
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'upcomingOnly': instance.upcomingOnly,
    };
