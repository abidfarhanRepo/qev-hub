// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargerImpl _$$ChargerImplFromJson(Map<String, dynamic> json) =>
    _$ChargerImpl(
      id: json['id'] as String,
      stationId: json['stationId'] as String,
      chargerCode: json['chargerCode'] as String?,
      chargerName: json['chargerName'] as String?,
      connectorType: json['connectorType'] as String?,
      connectorTypes: (json['connectorTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      powerOutputKw: (json['powerOutputKw'] as num?)?.toDouble(),
      isEnabled: json['isEnabled'] as bool,
      isAvailable: json['isAvailable'] as bool,
      chargerStatus: json['chargerStatus'] as String?,
      pricingPerKwh: (json['pricingPerKwh'] as num?)?.toDouble(),
      pricingPerMinute: (json['pricingPerMinute'] as num?)?.toDouble(),
      maxCurrent: (json['maxCurrent'] as num?)?.toInt(),
      maxVoltage: (json['maxVoltage'] as num?)?.toInt(),
      sessionStartTime: json['sessionStartTime'] == null
          ? null
          : DateTime.parse(json['sessionStartTime'] as String),
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
      'chargerCode': instance.chargerCode,
      'chargerName': instance.chargerName,
      'connectorType': instance.connectorType,
      'connectorTypes': instance.connectorTypes,
      'powerOutputKw': instance.powerOutputKw,
      'isEnabled': instance.isEnabled,
      'isAvailable': instance.isAvailable,
      'chargerStatus': instance.chargerStatus,
      'pricingPerKwh': instance.pricingPerKwh,
      'pricingPerMinute': instance.pricingPerMinute,
      'maxCurrent': instance.maxCurrent,
      'maxVoltage': instance.maxVoltage,
      'sessionStartTime': instance.sessionStartTime?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
