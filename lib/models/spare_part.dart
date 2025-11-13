enum PartSource {
  imported,
  local,
}

class SparePart {
  final String id;
  final String automobileId;
  final String name;
  final String? partNumber;
  final double price;
  final PartSource source;
  final double? importCost; // Only for imported parts
  final double? shippingCost; // Only for imported parts
  final String? supplier;
  final String? originCountry; // For imported parts
  final DateTime purchaseDate;
  final String? notes;
  final DateTime createdAt;

  SparePart({
    required this.id,
    required this.automobileId,
    required this.name,
    this.partNumber,
    required this.price,
    required this.source,
    this.importCost,
    this.shippingCost,
    this.supplier,
    this.originCountry,
    required this.purchaseDate,
    this.notes,
    required this.createdAt,
  });

  double get totalCost {
    double total = price;
    if (source == PartSource.imported) {
      total += (importCost ?? 0) + (shippingCost ?? 0);
    }
    return total;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'automobileId': automobileId,
      'name': name,
      'partNumber': partNumber,
      'price': price,
      'source': source.name,
      'importCost': importCost,
      'shippingCost': shippingCost,
      'supplier': supplier,
      'originCountry': originCountry,
      'purchaseDate': purchaseDate.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SparePart.fromMap(Map<String, dynamic> map) {
    return SparePart(
      id: map['id'],
      automobileId: map['automobileId'],
      name: map['name'],
      partNumber: map['partNumber'],
      price: map['price'],
      source: PartSource.values.firstWhere((e) => e.name == map['source']),
      importCost: map['importCost'],
      shippingCost: map['shippingCost'],
      supplier: map['supplier'],
      originCountry: map['originCountry'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  SparePart copyWith({
    String? id,
    String? automobileId,
    String? name,
    String? partNumber,
    double? price,
    PartSource? source,
    double? importCost,
    double? shippingCost,
    String? supplier,
    String? originCountry,
    DateTime? purchaseDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return SparePart(
      id: id ?? this.id,
      automobileId: automobileId ?? this.automobileId,
      name: name ?? this.name,
      partNumber: partNumber ?? this.partNumber,
      price: price ?? this.price,
      source: source ?? this.source,
      importCost: importCost ?? this.importCost,
      shippingCost: shippingCost ?? this.shippingCost,
      supplier: supplier ?? this.supplier,
      originCountry: originCountry ?? this.originCountry,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
