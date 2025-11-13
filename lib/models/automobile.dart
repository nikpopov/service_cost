class Automobile {
  final String id;
  final String make;
  final String model;
  final int year;
  final String licensePlate;
  final String? vin;
  final DateTime createdAt;

  // Engine and fluid specifications
  final String? engineType;
  final String? engineOilType;
  final double? engineOilCapacity; // in liters
  final String? coolantType;
  final double? coolantVolume; // in liters

  // Transmission specifications
  final String? transmissionType;
  final String? transmissionLiquidType;
  final double? transmissionLiquidVolume; // in liters

  // Transfer case specifications
  final String? transferCaseType;
  final String? transferCaseOilType;
  final double? transferCaseOilCapacity; // in liters

  // Front axle specifications
  final String? frontAxleType;
  final String? frontAxleOilType;
  final double? frontAxleOilCapacity; // in liters

  // Rear axle specifications
  final String? rearAxleType;
  final String? rearAxleOilType;
  final double? rearAxleOilCapacity; // in liters

  Automobile({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    this.vin,
    required this.createdAt,
    this.engineType,
    this.engineOilType,
    this.engineOilCapacity,
    this.coolantType,
    this.coolantVolume,
    this.transmissionType,
    this.transmissionLiquidType,
    this.transmissionLiquidVolume,
    this.transferCaseType,
    this.transferCaseOilType,
    this.transferCaseOilCapacity,
    this.frontAxleType,
    this.frontAxleOilType,
    this.frontAxleOilCapacity,
    this.rearAxleType,
    this.rearAxleOilType,
    this.rearAxleOilCapacity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
      'vin': vin,
      'createdAt': createdAt.toIso8601String(),
      'engineType': engineType,
      'engineOilType': engineOilType,
      'engineOilCapacity': engineOilCapacity,
      'coolantType': coolantType,
      'coolantVolume': coolantVolume,
      'transmissionType': transmissionType,
      'transmissionLiquidType': transmissionLiquidType,
      'transmissionLiquidVolume': transmissionLiquidVolume,
      'transferCaseType': transferCaseType,
      'transferCaseOilType': transferCaseOilType,
      'transferCaseOilCapacity': transferCaseOilCapacity,
      'frontAxleType': frontAxleType,
      'frontAxleOilType': frontAxleOilType,
      'frontAxleOilCapacity': frontAxleOilCapacity,
      'rearAxleType': rearAxleType,
      'rearAxleOilType': rearAxleOilType,
      'rearAxleOilCapacity': rearAxleOilCapacity,
    };
  }

  factory Automobile.fromMap(Map<String, dynamic> map) {
    return Automobile(
      id: map['id'],
      make: map['make'],
      model: map['model'],
      year: map['year'],
      licensePlate: map['licensePlate'],
      vin: map['vin'],
      createdAt: DateTime.parse(map['createdAt']),
      engineType: map['engineType'],
      engineOilType: map['engineOilType'],
      engineOilCapacity: map['engineOilCapacity'],
      coolantType: map['coolantType'],
      coolantVolume: map['coolantVolume'],
      transmissionType: map['transmissionType'],
      transmissionLiquidType: map['transmissionLiquidType'],
      transmissionLiquidVolume: map['transmissionLiquidVolume'],
      transferCaseType: map['transferCaseType'],
      transferCaseOilType: map['transferCaseOilType'],
      transferCaseOilCapacity: map['transferCaseOilCapacity'],
      frontAxleType: map['frontAxleType'],
      frontAxleOilType: map['frontAxleOilType'],
      frontAxleOilCapacity: map['frontAxleOilCapacity'],
      rearAxleType: map['rearAxleType'],
      rearAxleOilType: map['rearAxleOilType'],
      rearAxleOilCapacity: map['rearAxleOilCapacity'],
    );
  }

  String get displayName => '$year $make $model';

  Automobile copyWith({
    String? id,
    String? make,
    String? model,
    int? year,
    String? licensePlate,
    String? vin,
    DateTime? createdAt,
    String? engineType,
    String? engineOilType,
    double? engineOilCapacity,
    String? coolantType,
    double? coolantVolume,
    String? transmissionType,
    String? transmissionLiquidType,
    double? transmissionLiquidVolume,
    String? transferCaseType,
    String? transferCaseOilType,
    double? transferCaseOilCapacity,
    String? frontAxleType,
    String? frontAxleOilType,
    double? frontAxleOilCapacity,
    String? rearAxleType,
    String? rearAxleOilType,
    double? rearAxleOilCapacity,
  }) {
    return Automobile(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      vin: vin ?? this.vin,
      createdAt: createdAt ?? this.createdAt,
      engineType: engineType ?? this.engineType,
      engineOilType: engineOilType ?? this.engineOilType,
      engineOilCapacity: engineOilCapacity ?? this.engineOilCapacity,
      coolantType: coolantType ?? this.coolantType,
      coolantVolume: coolantVolume ?? this.coolantVolume,
      transmissionType: transmissionType ?? this.transmissionType,
      transmissionLiquidType: transmissionLiquidType ?? this.transmissionLiquidType,
      transmissionLiquidVolume: transmissionLiquidVolume ?? this.transmissionLiquidVolume,
      transferCaseType: transferCaseType ?? this.transferCaseType,
      transferCaseOilType: transferCaseOilType ?? this.transferCaseOilType,
      transferCaseOilCapacity: transferCaseOilCapacity ?? this.transferCaseOilCapacity,
      frontAxleType: frontAxleType ?? this.frontAxleType,
      frontAxleOilType: frontAxleOilType ?? this.frontAxleOilType,
      frontAxleOilCapacity: frontAxleOilCapacity ?? this.frontAxleOilCapacity,
      rearAxleType: rearAxleType ?? this.rearAxleType,
      rearAxleOilType: rearAxleOilType ?? this.rearAxleOilType,
      rearAxleOilCapacity: rearAxleOilCapacity ?? this.rearAxleOilCapacity,
    );
  }
}
