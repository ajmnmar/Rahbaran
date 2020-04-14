import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    String path=join(await getDatabasesPath(), 'rahbaran.db');

    return await openDatabase(
        path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE Setting(token TEXT, refreshtoken TEXT)');
  }
}