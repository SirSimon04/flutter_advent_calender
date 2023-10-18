import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    Database db = await openDatabase(
      join(path, 'examplex.db'),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE IF NOT EXISTS calendars(title TEXT, christmasMessage TEXT, doorId INTEGER, bgId INTEGER, name TEXT PRIMARY KEY); ");
      },
      version: 1,
    );
    db.execute(
        "CREATE TABLE IF NOT EXISTS opendays(name TEXT, day INTEGER, open INTEGER);");
    return db;
  }

  Future<void> insertCalendar(CalendarModel c) async {
    final db = await initializeDB();

    await db.insert(
      "calendars",
      c.toMapWithoutPassword(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> deleteCalendar(String name) async {
    final db = await initializeDB();
    print("in delete");
    await db.delete(
      "calendars",
      where: "name = ?",
      whereArgs: [name],
    );
    print("after delete");
  }

  Future<void> insertOpened({required String name, required int day}) async {
    final db = await initializeDB();

    await db.insert("opendays", {
      "name": name,
      "day": day,
      "open": 0,
    });
  }

  Future<void> deleteOpened({required String name, required int day}) async {
    final db = await initializeDB();

    await db.delete(
      "opendays",
      where: "name = ?",
      whereArgs: [name], // you need the id
    );
  }

  Future<void> updateOpened({required String name, required int day}) async {
    final db = await initializeDB();

    await db.update(
      "opendays",
      {
        "name": name,
        "day": day,
        "open": 1,
      },
      where: "name = ? and day = ?",
      whereArgs: [name, day],
    );
  }

  Future<List<Map<String, Object?>>> getOpenDayEntries(String name) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query("opendays", where: "name = ?", whereArgs: [name]);
    return queryResult;
  }

  Future<List<Map<String, Object?>>> getOpenededEntries(String name) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query("opendays",
        where: "name = ? and open = ?", whereArgs: [name, 1]);
    return queryResult;
  }

  Future<List<CalendarModel>> getCalendars() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('calendars');
    return queryResult.map((e) => CalendarModel.fromMap(e)).toList();
  }

  Future<void> deleteDB() async {
    String path = await getDatabasesPath();
    await deleteDatabase(join(path, 'example.db'));
  }
}
