import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE IF NOT EXISTS calendars(id TEXT PRIMARY KEY, title TEXT, msg TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertCalendar(CalendarModel c) async {
    final db = await initializeDB();

    await db.insert(
      "calendars",
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<CalendarModel>> getCalendars() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('calendars');
    return queryResult.map((e) => CalendarModel.fromMap(e)).toList();
  }
}
