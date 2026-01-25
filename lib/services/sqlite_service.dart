import 'package:restaurant_app/model/restaurant_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'favorite_restaurants.db';
  static const String _tableName = 'restaurants';
  static const int _version = 2; // Increment version untuk trigger onUpgrade

  Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE $_tableName(
       id TEXT PRIMARY KEY NOT NULL,
       name TEXT,
       description TEXT,
       pictureId TEXT,
       city TEXT,
       rating REAL
     )
     """);
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        // Hapus tabel lama dan buat ulang dengan skema yang benar
        await database.execute("DROP TABLE IF EXISTS $_tableName");
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(Restaurant restaurant) async {
    final db = await _initializeDb();

    final data = restaurant.toJson();

    
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Restaurant>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, orderBy: "id");

    return results.map((result) => Restaurant.fromJson(result)).toList();
  }

  Future<Restaurant?> getItemById(String id) async {
    final db = await _initializeDb();
    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Restaurant.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<int> deleteItem(String id) async {
    final db = await _initializeDb();
    return await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
