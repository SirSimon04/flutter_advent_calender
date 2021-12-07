import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    Database db = await openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE IF NOT EXISTS calendars(id TEXT PRIMARY KEY, title TEXT, msg TEXT, doorId INTEGER, bgId INTEGER); ");
      },
      version: 1,
    );
    db.execute(
        "CREATE TABLE IF NOT EXISTS opendays(id TEXT, day INTEGER, open INTEGER);");
    return db;
  }

  Future<void> insertCalendar(CalendarModel c) async {
    final db = await initializeDB();

    await db.insert(
      "calendars",
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> deleteCalendar(String id) async {
    final db = await initializeDB();

    await db.delete(
      "calendars",
      where: "id = ?",
      whereArgs: [id], // you need the id
    );
  }

  Future<void> insertOpened({required String id, required int day}) async {
    final db = await initializeDB();

    await db.insert("opendays", {
      "id": id,
      "day": day,
      "open": 0,
    });
  }

  Future<void> deleteOpened({required String id, required int day}) async {
    final db = await initializeDB();

    await db.delete(
      "opendays",
      where: "id = ? AND day = ?",
      whereArgs: [id], // you need the id
    );
  }

  Future<void> updateOpened({required String id, required int day}) async {
    final db = await initializeDB();

    await db.update(
      "opendays",
      {
        "id": id,
        "day": day,
        "open": 1,
      },
      where: "id = ? and day = ?",
      whereArgs: [id, day],
    );
  }

  Future<List<Map<String, Object?>>> getOpenDayEntries(String id) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query("opendays", where: "id = ?", whereArgs: [id]);
    return queryResult;
  }

  Future<List<Map<String, Object?>>> getOpenededEntries(String id) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .query("opendays", where: "id = ? and open = ?", whereArgs: [id, 1]);
    return queryResult;
  }

  Future<List<CalendarModel>> getCalendars() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('calendars');
    return queryResult.map((e) => CalendarModel.fromMap(e)).toList();
  }

  // Future<void> deleteDB() async {
  //   String path = await getDatabasesPath();
  //   await deleteDatabase(join(path, 'example.db'));
  // }
}
