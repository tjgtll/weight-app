import 'package:sqflite/sqflite.dart';
import 'package:weight/database/database_service.dart';
import 'package:weight/models/weight_data.dart';

class WeightDB {
  final tableName = 'weights';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "date" INTEGER PRIMARY KEY,
        "weight" REAL NOT NULL
    );""");
  }

  Future<void> create({required WeightData weightData}) async {
    final database = await DatabaseService().database;
    await database.rawInsert(
        """INSERT INTO $tableName (date, weight) VALUES (?,?)""",
        [weightData.date.millisecondsSinceEpoch, weightData.weight]);
  }

  Future<List<WeightData>> fetchAll() async {
    final database = await DatabaseService().database;
    final weights = await database
        .rawQuery("""SELECT * FROM $tableName ORDER BY date DESC""");
    return weights
        .map((weight) => WeightData.fromSqfliteDatabase(weight))
        .toList();
  }

  Future<WeightData?> fetchByDate(DateTime date) async {
    final database = await DatabaseService().database;
    final weight = await database.rawQuery(
        'SELECT * FROM $tableName WHERE date = ?',
        [date.millisecondsSinceEpoch]);
    if (weight.isNotEmpty) {
      return WeightData.fromSqfliteDatabase(weight.first);
    }
    return null;
  }

  Future<void> update({required WeightData weightData}) async {
    final database = await DatabaseService().database;
    await database.update(
      tableName,
      {'weight': weightData.weight},
      where: 'date = ?',
      whereArgs: [weightData.date.millisecondsSinceEpoch],
    );
  }

  Future<void> delete(DateTime date) async {
    final database = await DatabaseService().database;
    await database.rawDelete(
        'DELETE FROM $tableName WHERE date = ?', [date.millisecondsSinceEpoch]);
  }
}
