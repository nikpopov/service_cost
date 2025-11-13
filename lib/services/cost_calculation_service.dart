import '../models/cost_summary.dart';
import '../models/spare_part.dart';
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
}
