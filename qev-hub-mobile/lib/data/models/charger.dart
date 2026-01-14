import 'package:freezed_annotation/freezed_annotation.dart';

part 'charger.freezed.dart';
part 'charger.g.dart';

enum ChargerStatus { available, occupied, maintenance, offline }

@freezed
class Charger with _$Charger {
  const factory Charger({
    required String id,
    required String stationId,
    required String name,
    required String chargerType,
    required double powerKw,
    required ChargerStatus status,
    required List<String> connectorTypes,
    required bool isEnabled,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Charger;

  factory Charger.fromJson(Map<String, dynamic> json) => _$ChargerFromJson(json);
}
