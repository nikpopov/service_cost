import 'package:sqflite/sqflite.dart';
import '../models/service_record.dart';
import 'database_service.dart';

class ServiceRecordRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<ServiceRecord>> getAllServiceRecords() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_records',
      orderBy: 'serviceDate DESC',
    );

    return List.generate(maps.length, (i) => ServiceRecord.fromMap(maps[i]));
  }

  Future<List<ServiceRecord>> getServiceRecordsByAutomobile(
      String automobileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_records',
      where: 'automobileId = ?',
      whereArgs: [automobileId],
      orderBy: 'serviceDate DESC',
    );

    return List.generate(maps.length, (i) => ServiceRecord.fromMap(maps[i]));
  }

  Future<ServiceRecord?> getServiceRecordById(String id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ServiceRecord.fromMap(maps.first);
  }

  Future<void> insertServiceRecord(ServiceRecord serviceRecord) async {
    final db = await _databaseService.database;
    await db.insert(
      'service_records',
      serviceRecord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateServiceRecord(ServiceRecord serviceRecord) async {
    final db = await _databaseService.database;
    await db.update(
      'service_records',
      serviceRecord.toMap(),
      where: 'id = ?',
      whereArgs: [serviceRecord.id],
    );
  }

  Future<void> deleteServiceRecord(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'service_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalCostByAutomobile(String automobileId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery('''
      SELECT SUM(cost) as total
      FROM service_records
      WHERE automobileId = ?
    ''', [automobileId]);

    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<int> getCountByAutomobile(String automobileId) async {
    final db = await _databaseService.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM service_records WHERE automobileId = ?',
        [automobileId],
      ),
    );
    return count ?? 0;
  }
}
