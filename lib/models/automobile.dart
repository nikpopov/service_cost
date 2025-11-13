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
    );
  }
}
