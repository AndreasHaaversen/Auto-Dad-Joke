import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'joke.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE Joke (
          id TEXT PRIMARY KEY,
          joke TEXT
          )""");
    });
  }

  saveJoke(Joke joke) async {
    final db = await database;
    var res = await db.insert("Joke", joke.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  getJoke(String id) async {
    final db = await database;
    var res = await db.query("Joke", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Joke.fromJson(res.first) : null;
  }

  getAllJokes() async {
    final db = await database;
    var res = await db.query("Joke");
    List<Joke> list = res.isNotEmpty ? res.toList().map((f) => Joke.fromJson(f)) : null;
    return list;
  }

  deleteJoke(String id) async {
    final db = await database;
    db.delete("Joke", where: "id = ?", whereArgs: [id]);
  }
}
