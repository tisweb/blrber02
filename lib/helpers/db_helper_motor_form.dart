import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelperMotorForm {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'motordb.db'),
        onCreate: (db, version) {
      return db.execute('CREATE TABLE motortable(id TEXT PRIMARY KEY,'
          'catName TEXT,'
          'subCatType TEXT,'
          'prodName TEXT,'
          'prodDes TEXT,'
          'sellerNotes TEXT,'
          'prodCondition TEXT,'
          'price TEXT,'
          'imageUrlFeatured TEXT,'
          'deliveryInfo TEXT,'
          'typeOfAd TEXT,'
          'year TEXT,'
          'make TEXT,'
          'model TEXT,'
          'vehicleType TEXT,'
          'mileage TEXT,'
          'vin TEXT,'
          'engine TEXT,'
          'fuelType TEXT,'
          'options TEXT,'
          'subModel TEXT,'
          'numberOfCylinders TEXT,'
          'safetyFeatures TEXT,'
          'driveType TEXT,'
          'interiorColor TEXT,'
          'bodyType TEXT,'
          'exteriorColor TEXT,'
          'forSaleBy TEXT,'
          'warranty TEXT,'
          'trim TEXT,'
          'transmission TEXT,'
          'steeringLocation TEXT,'
          'vehicleTypeYear TEXT,'
          'editPost TEXT)');
    }, version: 1);
  }

  static Future<void> insertMotorForm(
      String table, Map<String, Object> data) async {
    final db = await DBHelperMotorForm.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getMotorForm(String table) async {
    final db = await DBHelperMotorForm.database();
    // return db.rawQuery('SELECT * FROM $table FETCH FIRST 1 ROWS ONLY');
    return db.query(table, limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getMotorFormCount(
      String table) async {
    final db = await DBHelperMotorForm.database();
    return db.rawQuery('SELECT COUNT(*) AS C FROM $table');
  }

  static Future<void> deleteMotorForm(String table, String id) async {
    final db = await DBHelperMotorForm.database();
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteMotorFormAll(String table) async {
    final db = await DBHelperMotorForm.database();
    return db.delete(table);
  }

  static Future<void> updateMotorForm(
      String table, String id, String columnName, String columnValue) async {
    final db = await DBHelperMotorForm.database();
    return db.rawUpdate('UPDATE $table SET $columnName = ? WHERE id = ?',
        ['$columnValue', '$id']);
  }

  static Future<void> dropMotorForm(String table) async {
    final db = await DBHelperMotorForm.database();
    return db.rawQuery('DROP TABLE IF EXISTS $table');
  }
}
