import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'data.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "TodoDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) => {},
      onCreate: (db, version) async =>  {
        await db.execute(createTodoTable)
      }
     );
  }

  Future<int> insert(Todo todo) async {
    final db = await database;
    return await db.insert("todo", todo.toJson());
  }

  Future<List<Todo>> selectAll() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM todo ORDER BY id DESC");
    if (result.isEmpty) {
      return null;
    }
    return result.map((todo) => Todo.fromJson(todo)).toList();
  }
  
  Future<int> delete(Todo todo) async {
    final db = await database;
    return await db.delete("todo", where: "id = ?", whereArgs: [todo.id]);
  }

  Future<int> update(Todo todo) async {
    final db = await database;
    return await db.update("todo", todo.toJson(), where: "id = ?", whereArgs: [todo.id]);
  }

  static String createTodoTable = '''
     CREATE TABLE todo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title CHARACTER(20),
        content TEXT
     );
  '''.trim();
}