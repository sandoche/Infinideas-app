import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:infinideas/models/idea.dart';

void main() async {

  final database = openDatabase(
    join(await getDatabasesPath(), 'ideas_db.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE ideas(url TEXT PRIMARY KEY, title TEXT, description TEXT, source TEXT, votes INTEGER, timestamp INTEGER)",
      );
    },
    version: 1,
  );

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

  Future<void> deleteIdea(int id) async {
    final db = await database;
    await db.delete(
      'ideas',
      where: "url = ?",
      whereArgs: [url],
    );
  }
}