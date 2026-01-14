// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargerImpl _$$ChargerImplFromJson(Map<String, dynamic> json) =>
    _$ChargerImpl(
      id: json['id'] as String,
      stationId: json['stationId'] as String,
      name: json['name'] as String,
      chargerType: json['chargerType'] as String,
      powerKw: (json['powerKw'] as num).toDouble(),
      status: $enumDecode(_$ChargerStatusEnumMap, json['status']),
      connectorTypes: (json['connectorTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isEnabled: json['isEnabled'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChargerImplToJson(_$ChargerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stationId': instance.stationId,
      'name': instance.name,
      'chargerType': instance.chargerType,
      'powerKw': instance.powerKw,
      'status': _$ChargerStatusEnumMap[instance.status]!,
      'connectorTypes': instance.connectorTypes,
      'isEnabled': instance.isEnabled,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ChargerStatusEnumMap = {
  ChargerStatus.available: 'available',
  ChargerStatus.occupied: 'occupied',
  ChargerStatus.maintenance: 'maintenance',
  ChargerStatus.offline: 'offline',
};
