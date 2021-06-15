import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'images.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE prod_images(id TEXT PRIMARY KEY, imageUrl TEXT, imageType TEXT, featuredImage TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(
      String table, String imgType) async {
    final db = await DBHelper.database();
    return db.rawQuery('SELECT * FROM $table WHERE imageType=?', ['$imgType']);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll(String table) async {
    final db = await DBHelper.database();
    return db.delete(table);
  }

  static Future<List<Map<String, dynamic>>> getProdImagesCount(
      String table) async {
    final db = await DBHelper.database();
    return db.rawQuery('SELECT COUNT(*) AS C FROM $table');
  }

  static Future<List<Map<String, dynamic>>> getProdImagesCountByType(
      String table, String imgType) async {
    final db = await DBHelper.database();
    return db.rawQuery(
        'SELECT COUNT(*) AS C FROM $table WHERE imageType=?', ['$imgType']);
  }
}
