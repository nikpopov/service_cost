enum ServiceType {
  maintenance,
  repair,
  inspection,
  other,
}

class ServiceRecord {
  final String id;
  final String automobileId;
  final String title;
  final ServiceType type;
  final double cost;
  final int? mileage;
  final String? serviceProvider;
  final DateTime serviceDate;
  final String? description;
  final String? notes;
  final DateTime createdAt;

  ServiceRecord({
    required this.id,
    required this.automobileId,
    required this.title,
    required this.type,
    required this.cost,
    this.mileage,
    this.serviceProvider,
    required this.serviceDate,
    this.description,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'automobileId': automobileId,
      'title': title,
      'type': type.name,
      'cost': cost,
      'mileage': mileage,
      'serviceProvider': serviceProvider,
      'serviceDate': serviceDate.toIso8601String(),
      'description': description,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ServiceRecord.fromMap(Map<String, dynamic> map) {
    return ServiceRecord(
      id: map['id'],
      automobileId: map['automobileId'],
      title: map['title'],
      type: ServiceType.values.firstWhere((e) => e.name == map['type']),
      cost: map['cost'],
      mileage: map['mileage'],
      serviceProvider: map['serviceProvider'],
      serviceDate: DateTime.parse(map['serviceDate']),
      description: map['description'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  ServiceRecord copyWith({
    String? id,
    String? automobileId,
    String? title,
    ServiceType? type,
    double? cost,
    int? mileage,
    String? serviceProvider,
    DateTime? serviceDate,
    String? description,
    String? notes,
    DateTime? createdAt,
  }) {
    return ServiceRecord(
      id: id ?? this.id,
      automobileId: automobileId ?? this.automobileId,
      title: title ?? this.title,
      type: type ?? this.type,
      cost: cost ?? this.cost,
      mileage: mileage ?? this.mileage,
      serviceProvider: serviceProvider ?? this.serviceProvider,
      serviceDate: serviceDate ?? this.serviceDate,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
