import '../models/cost_summary.dart';
import '../models/spare_part.dart';
import '../models/period_cost_breakdown.dart';
import 'spare_part_repository.dart';
import 'service_record_repository.dart';

class CostCalculationService {
  final SparePartRepository _sparePartRepository = SparePartRepository();
  final ServiceRecordRepository _serviceRecordRepository =
      ServiceRecordRepository();

  Future<CostSummary> calculateCostSummary(String automobileId) async {
    // Get all spare parts for this automobile
    final spareParts =
        await _sparePartRepository.getSparePartsByAutomobile(automobileId);

    // Calculate spare parts costs
    double totalSparePartsCost = 0;
    double totalImportedPartsCost = 0;
    double totalLocalPartsCost = 0;

    for (final part in spareParts) {
      final partTotalCost = part.totalCost;
      totalSparePartsCost += partTotalCost;

      if (part.source == PartSource.imported) {
        totalImportedPartsCost += partTotalCost;
      } else {
        totalLocalPartsCost += partTotalCost;
      }
    }

    // Get service costs
    final totalServicesCost =
        await _serviceRecordRepository.getTotalCostByAutomobile(automobileId);
    final servicesCount =
        await _serviceRecordRepository.getCountByAutomobile(automobileId);

    return CostSummary(
      automobileId: automobileId,
      totalSparePartsCost: totalSparePartsCost,
      totalServicesCost: totalServicesCost,
      totalImportedPartsCost: totalImportedPartsCost,
      totalLocalPartsCost: totalLocalPartsCost,
      sparePartsCount: spareParts.length,
      servicesCount: servicesCount,
    );
  }

  Future<Map<String, CostSummary>> calculateAllCostSummaries(
      List<String> automobileIds) async {
    final Map<String, CostSummary> summaries = {};

    for (final id in automobileIds) {
      summaries[id] = await calculateCostSummary(id);
    }

    return summaries;
  }

  /// Calculate costs broken down by periods (daily, weekly, monthly, etc.)
  /// Returns cost analysis for the specified automobile and time range
  Future<CostAnalysisByPeriod> calculateCostsByPeriod({
    required String automobileId,
    required PeriodType periodType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Get all spare parts and service records for this automobile
    final spareParts =
        await _sparePartRepository.getSparePartsByAutomobile(automobileId);
    final serviceRecords =
        await _serviceRecordRepository.getServiceRecordsByAutomobile(automobileId);

    // Generate period boundaries
    final periods = _generatePeriods(periodType, startDate, endDate);

    // Calculate costs for each period
    final periodBreakdowns = <PeriodCostBreakdown>[];

    for (final period in periods) {
      final periodStart = period['start'] as DateTime;
      final periodEnd = period['end'] as DateTime;
      final label = period['label'] as String;

      // Filter spare parts within this period
      final periodSpareParts = spareParts.where((part) {
        return part.purchaseDate.isAfter(periodStart.subtract(const Duration(days: 1))) &&
            part.purchaseDate.isBefore(periodEnd.add(const Duration(days: 1)));
      }).toList();

      // Filter service records within this period
      final periodServices = serviceRecords.where((service) {
        return service.serviceDate.isAfter(periodStart.subtract(const Duration(days: 1))) &&
            service.serviceDate.isBefore(periodEnd.add(const Duration(days: 1)));
      }).toList();

      // Calculate costs (using calculation currency)
      double sparePartsCost = 0;
      for (final part in periodSpareParts) {
        sparePartsCost += part.totalCostInCalculationCurrency;
      }

      double servicesCost = 0;
      for (final service in periodServices) {
        servicesCost += service.costInCalculationCurrency;
      }

      periodBreakdowns.add(PeriodCostBreakdown(
        startDate: periodStart,
        endDate: periodEnd,
        label: label,
        sparePartsCost: sparePartsCost,
        servicesCost: servicesCost,
        sparePartsCount: periodSpareParts.length,
        servicesCount: periodServices.length,
      ));
    }

    return CostAnalysisByPeriod(
      automobileId: automobileId,
      periodType: periodType,
      periods: periodBreakdowns,
      analysisStartDate: startDate,
      analysisEndDate: endDate,
    );
  }

  /// Generate period boundaries based on period type
  List<Map<String, dynamic>> _generatePeriods(
      PeriodType periodType, DateTime startDate, DateTime endDate) {
    final periods = <Map<String, dynamic>>[];
    DateTime currentStart = _normalizeDate(startDate, periodType);

    while (currentStart.isBefore(endDate) || currentStart.isAtSameMomentAs(endDate)) {
      DateTime currentEnd;
      String label;

      switch (periodType) {
        case PeriodType.daily:
          currentEnd = DateTime(currentStart.year, currentStart.month, currentStart.day, 23, 59, 59);
          label = '${currentStart.year}-${_padZero(currentStart.month)}-${_padZero(currentStart.day)}';
          break;

        case PeriodType.weekly:
          currentEnd = currentStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
          final weekEnd = currentEnd.isAfter(endDate) ? endDate : currentEnd;
          label = 'Week of ${currentStart.year}-${_padZero(currentStart.month)}-${_padZero(currentStart.day)}';
          currentEnd = weekEnd;
          break;

        case PeriodType.monthly:
          final nextMonth = currentStart.month == 12
              ? DateTime(currentStart.year + 1, 1, 1)
              : DateTime(currentStart.year, currentStart.month + 1, 1);
          currentEnd = nextMonth.subtract(const Duration(seconds: 1));
          label = '${currentStart.year}-${_padZero(currentStart.month)}';
          break;

        case PeriodType.quarterly:
          final quarterStartMonth = ((currentStart.month - 1) ~/ 3) * 3 + 1;
          final quarterStart = DateTime(currentStart.year, quarterStartMonth, 1);
          final nextQuarter = quarterStartMonth + 3 > 12
              ? DateTime(currentStart.year + 1, 1, 1)
              : DateTime(currentStart.year, quarterStartMonth + 3, 1);
          currentEnd = nextQuarter.subtract(const Duration(seconds: 1));
          final quarter = ((currentStart.month - 1) ~/ 3) + 1;
          label = 'Q$quarter ${currentStart.year}';
          break;

        case PeriodType.yearly:
          currentEnd = DateTime(currentStart.year, 12, 31, 23, 59, 59);
          label = '${currentStart.year}';
          break;
      }

      // Don't exceed the end date
      if (currentEnd.isAfter(endDate)) {
        currentEnd = endDate;
      }

      periods.add({
        'start': currentStart,
        'end': currentEnd,
        'label': label,
      });

      // Move to next period
      currentStart = _getNextPeriodStart(currentStart, periodType);

      // Prevent infinite loop
      if (currentStart.isAfter(endDate)) {
        break;
      }
    }

    return periods;
  }

  /// Normalize date to the start of the period
  DateTime _normalizeDate(DateTime date, PeriodType periodType) {
    switch (periodType) {
      case PeriodType.daily:
        return DateTime(date.year, date.month, date.day);

      case PeriodType.weekly:
        // Start from Monday of the week
        final dayOfWeek = date.weekday;
        final daysToSubtract = dayOfWeek - 1;
        return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysToSubtract));

      case PeriodType.monthly:
        return DateTime(date.year, date.month, 1);

      case PeriodType.quarterly:
        final quarterStartMonth = ((date.month - 1) ~/ 3) * 3 + 1;
        return DateTime(date.year, quarterStartMonth, 1);

      case PeriodType.yearly:
        return DateTime(date.year, 1, 1);
    }
  }

  /// Get the start of the next period
  DateTime _getNextPeriodStart(DateTime currentStart, PeriodType periodType) {
    switch (periodType) {
      case PeriodType.daily:
        return currentStart.add(const Duration(days: 1));

      case PeriodType.weekly:
        return currentStart.add(const Duration(days: 7));

      case PeriodType.monthly:
        return currentStart.month == 12
            ? DateTime(currentStart.year + 1, 1, 1)
            : DateTime(currentStart.year, currentStart.month + 1, 1);

      case PeriodType.quarterly:
        final nextQuarterMonth = currentStart.month + 3;
        return nextQuarterMonth > 12
            ? DateTime(currentStart.year + 1, 1, 1)
            : DateTime(currentStart.year, nextQuarterMonth, 1);

      case PeriodType.yearly:
        return DateTime(currentStart.year + 1, 1, 1);
    }
  }

  /// Pad single digit numbers with zero
  String _padZero(int number) {
    return number.toString().padLeft(2, '0');
  }
}
