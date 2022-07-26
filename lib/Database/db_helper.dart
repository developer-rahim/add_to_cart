import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "EmployeeDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'product_table';
  static final id = 'id';
  static final productId = 'productId';
  static final columnName = 'productName';
  static final productPrice = 'productPrice';
  static final productInitialPrice = 'productInitialPrice';

  static final productImage = 'productImage';
  static final productQuntity = 'productQuntity';
  static final productTag = 'productTag';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance =
      new DatabaseHelper._privateConstructor();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
              $id INTEGER PRIMARY KEY,
            $productId INTERGER UNIQUE,
            $columnName TEXT ,
            $productPrice TEXT ,
            $productInitialPrice TEXT ,
            $productImage TEXT ,
            $productQuntity TEXT ,
            $productTag TEXT 
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var result = await db.query(table);
    return result.toList();
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    // int id = row[productId];
    return await db.update(table, row, where: '$id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$id = ?', whereArgs: [id]);
  }
}
