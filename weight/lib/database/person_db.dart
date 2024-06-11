import 'package:sqflite/sqflite.dart';
import 'package:weight/database/database_service.dart';
import 'package:weight/models/person_data.dart';

class PersonDB {
  final tableName = 'persons';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "requiredWeight" REAL NOT NULL,
        "height" REAL NOT NULL,
        "gender" TEXT NOT NULL,
        "age" INTEGER NOT NULL
    );""");
  }

  Future<void> create({required PersonData personData}) async {
    final database = await DatabaseService().database;
    await database.rawInsert(
        """INSERT INTO $tableName (height, gender, age, requiredWeight) VALUES (?,?,?,?,?)""",
        [
          personData.height,
          personData.gender,
          personData.age,
          personData.requiredWeight
        ]);
  }

  Future<List<PersonData>> fetchAll() async {
    final database = await DatabaseService().database;
    final persons = await database
        .rawQuery("""SELECT * FROM $tableName ORDER BY id DESC""");
    return persons
        .map((person) => PersonData.fromSqfliteDatabase(person))
        .toList();
  }

  Future<PersonData?> fetchById(int? id) async {
    if (id == null) return null;
    final database = await DatabaseService().database;
    final person =
        await database.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    if (person.isNotEmpty) {
      return PersonData.fromSqfliteDatabase(person.first);
    }
    return null;
  }

  Future<void> update({required PersonData personData}) async {
    final database = await DatabaseService().database;
    await database.update(
      tableName,
      {
        'height': personData.height,
        'gender': personData.gender,
        'age': personData.age,
        'requiredWeight': personData.requiredWeight,
      },
      where: 'id = ?',
      whereArgs: [personData.id],
    );
  }

  Future<void> delete(int? id) async {
    if (id == null) return;
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
  }
}
