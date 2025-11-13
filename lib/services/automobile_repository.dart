import 'package:sqflite/sqflite.dart';
import '../models/automobile.dart';
import 'database_service.dart';

class AutomobileRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Automobile>> getAllAutomobiles() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'automobiles',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) => Automobile.fromMap(maps[i]));
  }

  Future<Automobile?> getAutomobileById(String id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'automobiles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Automobile.fromMap(maps.first);
  }

  Future<void> insertAutomobile(Automobile automobile) async {
    final db = await _databaseService.database;
    await db.insert(
      'automobiles',
      automobile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAutomobile(Automobile automobile) async {
    final db = await _databaseService.database;
    await db.update(
      'automobiles',
      automobile.toMap(),
      where: 'id = ?',
      whereArgs: [automobile.id],
    );
  }

  Future<void> deleteAutomobile(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'automobiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getAutomobileCount() async {
    final db = await _databaseService.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM automobiles'),
    );
    return count ?? 0;
  }
}
