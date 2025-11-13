class Automobile {
  final String id;
  final String make;
  final String model;
  final int year;
  final String licensePlate;
  final String? vin;
  final DateTime createdAt;

  Automobile({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    this.vin,
    required this.createdAt,
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
  }) {
    return Automobile(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      vin: vin ?? this.vin,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
