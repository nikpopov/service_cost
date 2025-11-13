enum PeriodType {
  daily('Daily', 1),
  weekly('Weekly', 7),
  monthly('Monthly', 30),
  quarterly('Quarterly', 90),
  yearly('Yearly', 365);

  final String label;
  final int days;

  const PeriodType(this.label, this.days);
}

class PeriodCostBreakdown {
  final DateTime startDate;
  final DateTime endDate;
  final String label; // e.g., "Jan 2024", "Week 1", "Q1 2024"
  final double sparePartsCost;
  final double servicesCost;
  final int sparePartsCount;
  final int servicesCount;

  PeriodCostBreakdown({
    required this.startDate,
    required this.endDate,
    required this.label,
    required this.sparePartsCost,
    required this.servicesCost,
    required this.sparePartsCount,
    required this.servicesCount,
  });

  double get totalCost => sparePartsCost + servicesCost;

  bool get hasData => sparePartsCount > 0 || servicesCount > 0;
}

class CostAnalysisByPeriod {
  final String automobileId;
  final PeriodType periodType;
  final List<PeriodCostBreakdown> periods;
  final DateTime analysisStartDate;
  final DateTime analysisEndDate;

  CostAnalysisByPeriod({
    required this.automobileId,
    required this.periodType,
    required this.periods,
    required this.analysisStartDate,
    required this.analysisEndDate,
  });

  double get totalCost => periods.fold(0, (sum, period) => sum + period.totalCost);

  double get totalSparePartsCost =>
      periods.fold(0, (sum, period) => sum + period.sparePartsCost);

  double get totalServicesCost =>
      periods.fold(0, (sum, period) => sum + period.servicesCost);

  int get totalSparePartsCount =>
      periods.fold(0, (sum, period) => sum + period.sparePartsCount);

  int get totalServicesCount =>
      periods.fold(0, (sum, period) => sum + period.servicesCount);

  List<PeriodCostBreakdown> get periodsWithData =>
      periods.where((p) => p.hasData).toList();

  double get averageCostPerPeriod {
    final validPeriods = periodsWithData;
    if (validPeriods.isEmpty) return 0;
    return totalCost / validPeriods.length;
  }

  PeriodCostBreakdown? get highestCostPeriod {
    if (periodsWithData.isEmpty) return null;
    return periodsWithData.reduce(
      (a, b) => a.totalCost > b.totalCost ? a : b,
    );
  }

  PeriodCostBreakdown? get lowestCostPeriod {
    if (periodsWithData.isEmpty) return null;
    return periodsWithData.reduce(
      (a, b) => a.totalCost < b.totalCost ? a : b,
    );
  }
}
