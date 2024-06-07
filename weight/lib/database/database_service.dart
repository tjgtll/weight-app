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
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version) async {
    await WeightDB().createTable(database);
    await PersonDB().createTable(database);
  }
}
