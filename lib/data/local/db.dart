import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/coffee_model.dart';

class CoffeeDatabase {
  late final Database _database;

  CoffeeDatabase._privateConstructor();
  static final CoffeeDatabase instance = CoffeeDatabase._privateConstructor();

  Future<void> initializeDatabase() async {
    if (_database != null) {
      return;
    }
    String path = join(await getDatabasesPath(), 'coffee_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE coffee(
        id INTEGER PRIMARY KEY,
        name TEXT,
        type TEXT,
        price TEXT,
        imageUrl TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertCoffee(Coffee coffee) async {
    await initializeDatabase();
    return await _database.insert('coffee', coffee.toMap());
  }

  Future<int> deleteAllCoffees() async {
    await initializeDatabase();
    return await _database.delete('coffee');
  }

  Future<List<Coffee>> getAllCoffees() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('coffee');
    return List.generate(maps.length, (i) {
      return Coffee.fromMap(maps[i]);
    });
  }
}
