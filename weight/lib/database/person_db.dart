import 'package:sqflite/sqflite.dart';
import 'package:weight/database/database_service.dart';
import 'package:weight/models/person_data.dart';

class PersonDB {
  final tableName = 'person';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "name" TEXT PRIMARY KEY,
        "height" REAL NOT NULL,
        "gender" TEXT NOT NULL
    );""");
  }

  Future<void> create({required PersonData personData}) async {
    final database = await DatabaseService().database;
    await database.rawInsert(
        """INSERT INTO $tableName (name, height, gender) VALUES (?,?,?)""",
        [personData.name, personData.height, personData.gender]);
  }

  Future<List<PersonData>> fetchAll() async {
    final database = await DatabaseService().database;
    final persons = await database.rawQuery("""SELECT * FROM $tableName""");
    return persons
        .map((person) => PersonData.fromSqfliteDatabase(person))
        .toList();
  }

  Future<PersonData?> fetchByName(String name) async {
    final database = await DatabaseService().database;
    final person = await database
        .rawQuery('SELECT * FROM $tableName WHERE name = ?', [name]);
    if (person.isNotEmpty) {
      return PersonData.fromSqfliteDatabase(person.first);
    }
    return null;
  }

  Future<void> update({required PersonData personData}) async {
    final database = await DatabaseService().database;
    await database.update(
      tableName,
      {'height': personData.height, 'gender': personData.gender},
      where: 'name = ?',
      whereArgs: [personData.name],
    );
  }

  Future<void> delete(String name) async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM $tableName WHERE name = ?', [name]);
  }
}
