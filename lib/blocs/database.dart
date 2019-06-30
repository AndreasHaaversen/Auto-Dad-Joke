import 'dart:io';
import 'package:auto_dad_joke/models/joke.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
    String path = join(documentsDirectory.path, "JokeDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE Joke (
          id TEXT PRIMARY KEY,
          joke TEXT
          )""");
    });
  }

  Future<int> saveJoke(Joke joke) async {
    final db = await database;
    var res = await db.insert("Joke", joke.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<Joke> getJoke(String id) async {
    final db = await database;
    var res = await db.query("Joke", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Joke.fromJson(res.first) : null;
  }

  Future<List<Joke>> getAllJokes() async {
    final db = await database;
    var res = await db.query("Joke", orderBy: 'id');
    List<Joke> list = res.isNotEmpty
        ? res.toList().map((f) => Joke.fromJson(f)).toList()
        : null;
    return list;
  }

  Future<int> deleteJoke(String id) async {
    final db = await database;
    return db.delete("Joke", where: "id = ?", whereArgs: [id]);
  }

  Future<int> indexOfSavedJoke(String id) async {
    List<Joke> res = await getAllJokes();
    return res.map((joke) => joke.id).toList().indexOf(id);
  }
}
