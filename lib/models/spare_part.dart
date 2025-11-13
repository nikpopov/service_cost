enum PartSource {
  imported,
  local,
}

enum ShippingMethod {
  sea,
  air,
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
  final double? customsClearanceCost; // Only for imported parts
  final String? supplier;
  final String? originCountry; // For imported parts
  final DateTime purchaseDate;
  final String? notes;
  final DateTime createdAt;

  // Shipment tracking fields (only for imported parts)
  final DateTime? orderPlacedDate;
  final DateTime? shipmentDate;
  final DateTime? deliveryToWarehouseDate;
  final DateTime? expectedDeliveryDate;
  final DateTime? receivingDate;
  final ShippingMethod? shippingMethod;

  SparePart({
    required this.id,
    required this.automobileId,
    required this.name,
    this.partNumber,
    required this.price,
    required this.source,
    this.importCost,
    this.shippingCost,
    this.customsClearanceCost,
    this.supplier,
    this.originCountry,
    required this.purchaseDate,
    this.notes,
    required this.createdAt,
    this.orderPlacedDate,
    this.shipmentDate,
    this.deliveryToWarehouseDate,
    this.expectedDeliveryDate,
    this.receivingDate,
    this.shippingMethod,
  });

  double get totalCost {
    double total = price;
    if (source == PartSource.imported) {
      total += (importCost ?? 0) + (shippingCost ?? 0) + (customsClearanceCost ?? 0);
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
      'customsClearanceCost': customsClearanceCost,
      'supplier': supplier,
      'originCountry': originCountry,
      'purchaseDate': purchaseDate.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'orderPlacedDate': orderPlacedDate?.toIso8601String(),
      'shipmentDate': shipmentDate?.toIso8601String(),
      'deliveryToWarehouseDate': deliveryToWarehouseDate?.toIso8601String(),
      'expectedDeliveryDate': expectedDeliveryDate?.toIso8601String(),
      'receivingDate': receivingDate?.toIso8601String(),
      'shippingMethod': shippingMethod?.name,
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
      customsClearanceCost: map['customsClearanceCost'],
      supplier: map['supplier'],
      originCountry: map['originCountry'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      orderPlacedDate: map['orderPlacedDate'] != null
          ? DateTime.parse(map['orderPlacedDate'])
          : null,
      shipmentDate:
          map['shipmentDate'] != null ? DateTime.parse(map['shipmentDate']) : null,
      deliveryToWarehouseDate: map['deliveryToWarehouseDate'] != null
          ? DateTime.parse(map['deliveryToWarehouseDate'])
          : null,
      expectedDeliveryDate: map['expectedDeliveryDate'] != null
          ? DateTime.parse(map['expectedDeliveryDate'])
          : null,
      receivingDate: map['receivingDate'] != null
          ? DateTime.parse(map['receivingDate'])
          : null,
      shippingMethod: map['shippingMethod'] != null
          ? ShippingMethod.values.firstWhere((e) => e.name == map['shippingMethod'])
          : null,
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
    double? customsClearanceCost,
    String? supplier,
    String? originCountry,
    DateTime? purchaseDate,
    String? notes,
    DateTime? createdAt,
    DateTime? orderPlacedDate,
    DateTime? shipmentDate,
    DateTime? deliveryToWarehouseDate,
    DateTime? expectedDeliveryDate,
    DateTime? receivingDate,
    ShippingMethod? shippingMethod,
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
      customsClearanceCost: customsClearanceCost ?? this.customsClearanceCost,
      supplier: supplier ?? this.supplier,
      originCountry: originCountry ?? this.originCountry,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      orderPlacedDate: orderPlacedDate ?? this.orderPlacedDate,
      shipmentDate: shipmentDate ?? this.shipmentDate,
      deliveryToWarehouseDate: deliveryToWarehouseDate ?? this.deliveryToWarehouseDate,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      receivingDate: receivingDate ?? this.receivingDate,
      shippingMethod: shippingMethod ?? this.shippingMethod,
    );
  }
}
