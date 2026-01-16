import 'package:freezed_annotation/freezed_annotation.dart';

part 'sustainability_report.freezed.dart';

/// Sustainability report model containing calculated environmental impact metrics
@freezed
class SustainabilityReport with _$SustainabilityReport {
  const factory SustainabilityReport({
    required double co2SavedKg,
    required double treesEquivalent,
    required double petrolAvoidedLiters,
    required double energyUsedKwh,
    required int thisMonthChargingSessions,
    required int previousMonthChargingSessions,
    required double thisMonthCo2SavedKg,
    required double previousMonthCo2SavedKg,
    required double thisMonthPetrolAvoidedLiters,
    required double previousMonthPetrolAvoidedLiters,
    required DateTime lastUpdated,
  }) = _SustainabilityReport;

  factory SustainabilityReport.fromJson(Map<String, dynamic> json) =>
      _$SustainabilityReportFromJson(json);
}

/// Monthly sustainability data for trend analysis
@freezed
class MonthlySustainabilityData with _$MonthlySustainabilityData {
  const factory MonthlySustainabilityData({
    required DateTime month,
    required double co2SavedKg,
    required double petrolAvoidedLiters,
    required int chargingSessions,
    required double energyUsedKwh,
  }) = _MonthlySustainabilityData;

  factory MonthlySustainabilityData.fromJson(Map<String, dynamic> json) =>
      _$MonthlySustainabilityDataFromJson(json);
}

/// Sustainability summary for dashboard display
@freezed
class SustainabilitySummary with _$SustainabilitySummary {
  const factory SustainabilitySummary({
    required double totalCo2SavedKg,
    required double totalTreesEquivalent,
    required double totalPetrolAvoidedLiters,
    required String co2SavedFormatted,
    required String treesEquivalentFormatted,
    required String petrolAvoidedFormatted,
    required double monthlyTrendPercentage,
    required bool isPositiveTrend,
  }) = _SustainabilitySummary;

  factory SustainabilitySummary.fromJson(Map<String, dynamic> json) =>
      _$SustainabilitySummaryFromJson(json);
}