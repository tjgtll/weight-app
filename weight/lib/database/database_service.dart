import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weight/database/weight_db.dart';
import 'package:weight/database/person_db.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _init();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _init() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {
        await _checkAndCreateTable(db, 'weights', WeightDB().createTable);
        await _checkAndCreateTable(db, 'person', PersonDB().createTable);
      },
      onCreate: (db, version) async {
        await WeightDB().createTable(db);
        await PersonDB().createTable(db);
      },
      singleInstance: true,
    );
    return database;
  }

  Future<void> _checkAndCreateTable(
      Database db, String tableName, Function(Database) createTable) async {
    var result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName]);
    if (result.isEmpty) {
      await createTable(db);
    }
  }

  Future<void> create(Database database, int version) async {
    await WeightDB().createTable(database);
    await PersonDB().createTable(database);
  }

  Future<void> upgrade(
      Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
      await PersonDB().createTable(database);
    }
  }
}
