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
            "CREATE TABLE IF NOT EXISTS calendars(id TEXT PRIMARY KEY, title TEXT, msg TEXT); ");
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

  Future<void> insertOpened({required String id, required int day}) async {
    final db = await initializeDB();

    await db.insert("opendays", {
      "id": id,
      "day": day,
      "open": 0,
    });
  }

  Future<List<Map<String, Object?>>> getOpened(String id) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query("opendays", where: "id = ?", whereArgs: [id]);
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
