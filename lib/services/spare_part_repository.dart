import 'package:sqflite/sqflite.dart';
import '../models/spare_part.dart';
import 'database_service.dart';

class SparePartRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<SparePart>> getAllSpareParts() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'spare_parts',
      orderBy: 'purchaseDate DESC',
    );

    return List.generate(maps.length, (i) => SparePart.fromMap(maps[i]));
  }

  Future<List<SparePart>> getSparePartsByAutomobile(String automobileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'spare_parts',
      where: 'automobileId = ?',
      whereArgs: [automobileId],
      orderBy: 'purchaseDate DESC',
    );

    return List.generate(maps.length, (i) => SparePart.fromMap(maps[i]));
  }

  Future<SparePart?> getSparePartById(String id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'spare_parts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return SparePart.fromMap(maps.first);
  }

  Future<void> insertSparePart(SparePart sparePart) async {
    final db = await _databaseService.database;
    await db.insert(
      'spare_parts',
      sparePart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSparePart(SparePart sparePart) async {
    final db = await _databaseService.database;
    await db.update(
      'spare_parts',
      sparePart.toMap(),
      where: 'id = ?',
      whereArgs: [sparePart.id],
    );
  }

  Future<void> deleteSparePart(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'spare_parts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalCostByAutomobile(String automobileId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery('''
      SELECT SUM(price + COALESCE(importCost, 0) + COALESCE(shippingCost, 0)) as total
      FROM spare_parts
      WHERE automobileId = ?
    ''', [automobileId]);

    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<int> getCountByAutomobile(String automobileId) async {
    final db = await _databaseService.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM spare_parts WHERE automobileId = ?',
        [automobileId],
      ),
    );
    return count ?? 0;
  }
}
