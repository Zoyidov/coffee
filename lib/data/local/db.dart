import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/coffee_model.dart';

class CoffeeDatabase {
  late Database _database;
  bool _initialized = false;

  static final CoffeeDatabase _instance = CoffeeDatabase._internal();

  CoffeeDatabase._internal();

  static CoffeeDatabase get instance => _instance;

  Future<void> initializeDatabase() async {
    if (!_initialized) {
      final String path = join(await getDatabasesPath(), 'coffee_database.db');
      _database = await openDatabase(path, version: 1, onCreate: (db, version) {
        db.execute('''
          CREATE TABLE coffees(
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT,
            price TEXT,
            imageUrl TEXT,
            description TEXT
          )
        ''');
      });
      _initialized = true;
    }
  }

  Future<int> insertCoffee(Coffee coffee) async {
    print('qoshildi');
    if (!_initialized) {
      throw Exception("Database not initialized. Call initializeDatabase() first.");
    }
    final int id = await _database.insert('coffees', coffee.toMap());
    return id;
  }


  Future<List<Coffee>> getAllCoffees() async {
    final List<Map<String, dynamic>> maps = await _database.query('coffees');
    return List.generate(maps.length, (i) {
      return Coffee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type'],
        price: maps[i]['price'],
        imageUrl: maps[i]['imageUrl'],
        description: maps[i]['description'],
      );
    });
  }

  Future<void> deleteCoffee(int id) async {
    await _database.delete(
      'coffees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}
