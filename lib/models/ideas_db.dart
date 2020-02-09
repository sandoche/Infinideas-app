import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:infinideas/models/idea.dart';

class IdeasDB {

  IdeasDB._();

  static final IdeasDB db = IdeasDB._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    String path = join(await getDatabasesPath(), 'ideas_db.db');
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ideas(url TEXT PRIMARY KEY, title TEXT, description TEXT, source TEXT, votes INTEGER, timestamp INTEGER)");
    });
  }

  Future<void> insertIdea(Idea idea) async {
    final Database db = await database;
    await db.insert(
      'ideas',
      idea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Idea>> ideas() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ideas');
    return List.generate(maps.length, (i) {
      return new Idea.fromDB(maps[i]['url'], maps[i]['title'], maps[i]['description'], maps[i]['source'], maps[i]['votes'], maps[i]['timestamp']);
    });
  }

  Future<void> updateIdea(Idea idea) async {
    final db = await database;
    await db.update(
      'ideas',
      idea.toMap(),
      where: "url = ?",
      whereArgs: [idea.url],
    );
  }

  Future<void> deleteIdea(String url) async {
    final db = await database;
    await db.delete(
      'ideas',
      where: "url = ?",
      whereArgs: [url],
    );
  }

  Future<bool> existIdeaWithUrl(String url) async {
    final db = await database;
    List<dynamic>  ideaInDatabase = await db.rawQuery('SELECT * FROM ideas WHERE url=?', [url]);
    return ideaInDatabase.isNotEmpty;
  }
}