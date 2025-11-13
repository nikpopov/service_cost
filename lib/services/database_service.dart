import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'spare_parts_calculator.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create automobiles table
    await db.execute('''
      CREATE TABLE automobiles (
        id TEXT PRIMARY KEY,
        make TEXT NOT NULL,
        model TEXT NOT NULL,
        year INTEGER NOT NULL,
        licensePlate TEXT NOT NULL,
        vin TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create spare_parts table
    await db.execute('''
      CREATE TABLE spare_parts (
        id TEXT PRIMARY KEY,
        automobileId TEXT NOT NULL,
        name TEXT NOT NULL,
        partNumber TEXT,
        price REAL NOT NULL,
        source TEXT NOT NULL,
        importCost REAL,
        shippingCost REAL,
        customsClearanceCost REAL,
        supplier TEXT,
        originCountry TEXT,
        purchaseDate TEXT NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (automobileId) REFERENCES automobiles (id) ON DELETE CASCADE
      )
    ''');

    // Create service_records table
    await db.execute('''
      CREATE TABLE service_records (
        id TEXT PRIMARY KEY,
        automobileId TEXT NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        cost REAL NOT NULL,
        mileage INTEGER,
        serviceProvider TEXT,
        serviceDate TEXT NOT NULL,
        description TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (automobileId) REFERENCES automobiles (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes
    await db.execute(
        'CREATE INDEX idx_spare_parts_automobile ON spare_parts(automobileId)');
    await db.execute(
        'CREATE INDEX idx_service_records_automobile ON service_records(automobileId)');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
