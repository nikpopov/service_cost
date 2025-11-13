class CostSummary {
  final String automobileId;
  final double totalSparePartsCost;
  final double totalServicesCost;
  final double totalImportedPartsCost;
  final double totalLocalPartsCost;
  final int sparePartsCount;
  final int servicesCount;

  CostSummary({
    required this.automobileId,
    required this.totalSparePartsCost,
    required this.totalServicesCost,
    required this.totalImportedPartsCost,
    required this.totalLocalPartsCost,
    required this.sparePartsCount,
    required this.servicesCount,
  });

  double get totalCost => totalSparePartsCost + totalServicesCost;

  double get averagePartCost =>
      sparePartsCount > 0 ? totalSparePartsCost / sparePartsCount : 0;

  double get averageServiceCost =>
      servicesCount > 0 ? totalServicesCost / servicesCount : 0;

  Map<String, dynamic> toMap() {
    return {
      'automobileId': automobileId,
      'totalSparePartsCost': totalSparePartsCost,
      'totalServicesCost': totalServicesCost,
      'totalImportedPartsCost': totalImportedPartsCost,
      'totalLocalPartsCost': totalLocalPartsCost,
      'sparePartsCount': sparePartsCount,
      'servicesCount': servicesCount,
    };
  }

  factory CostSummary.fromMap(Map<String, dynamic> map) {
    return CostSummary(
      automobileId: map['automobileId'],
      totalSparePartsCost: map['totalSparePartsCost'],
      totalServicesCost: map['totalServicesCost'],
      totalImportedPartsCost: map['totalImportedPartsCost'],
      totalLocalPartsCost: map['totalLocalPartsCost'],
      sparePartsCount: map['sparePartsCount'],
      servicesCount: map['servicesCount'],
    );
  }
}
