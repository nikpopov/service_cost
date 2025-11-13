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
  final int? motorHours; // Motor hours at time of service
  final String? serviceProvider;
  final DateTime serviceDate;
  final String? description;
  final String? notes;
  final DateTime createdAt;

  // Currency and exchange rate
  final String? paymentCurrency; // Currency code (e.g., 'USD', 'EUR')
  final double? exchangeRateToCalculation; // Rate to convert to calculation currency

  ServiceRecord({
    required this.id,
    required this.automobileId,
    required this.title,
    required this.type,
    required this.cost,
    this.mileage,
    this.motorHours,
    this.serviceProvider,
    required this.serviceDate,
    this.description,
    this.notes,
    required this.createdAt,
    this.paymentCurrency,
    this.exchangeRateToCalculation,
  });

  // Get cost converted to calculation currency
  double get costInCalculationCurrency {
    final rate = exchangeRateToCalculation ?? 1.0;
    return cost * rate;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'automobileId': automobileId,
      'title': title,
      'type': type.name,
      'cost': cost,
      'mileage': mileage,
      'motorHours': motorHours,
      'serviceProvider': serviceProvider,
      'serviceDate': serviceDate.toIso8601String(),
      'description': description,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'paymentCurrency': paymentCurrency,
      'exchangeRateToCalculation': exchangeRateToCalculation,
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
      motorHours: map['motorHours'],
      serviceProvider: map['serviceProvider'],
      serviceDate: DateTime.parse(map['serviceDate']),
      description: map['description'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      paymentCurrency: map['paymentCurrency'],
      exchangeRateToCalculation: map['exchangeRateToCalculation'],
    );
  }

  ServiceRecord copyWith({
    String? id,
    String? automobileId,
    String? title,
    ServiceType? type,
    double? cost,
    int? mileage,
    int? motorHours,
    String? serviceProvider,
    DateTime? serviceDate,
    String? description,
    String? notes,
    DateTime? createdAt,
    String? paymentCurrency,
    double? exchangeRateToCalculation,
  }) {
    return ServiceRecord(
      id: id ?? this.id,
      automobileId: automobileId ?? this.automobileId,
      title: title ?? this.title,
      type: type ?? this.type,
      cost: cost ?? this.cost,
      mileage: mileage ?? this.mileage,
      motorHours: motorHours ?? this.motorHours,
      serviceProvider: serviceProvider ?? this.serviceProvider,
      serviceDate: serviceDate ?? this.serviceDate,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      paymentCurrency: paymentCurrency ?? this.paymentCurrency,
      exchangeRateToCalculation: exchangeRateToCalculation ?? this.exchangeRateToCalculation,
    );
  }
}
