import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_team_project/model/SpeedDatabaseEntry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SpeedSQLiteRepository {
  static const int _version = 1;
  static const String _dbName = "Speeds.db";
  List<SpeedDatabaseEntry> speedList = [
    // SpeedDatabaseEntry(speed: 2.55, dateTime: DateTime(2024, 5, 10)),
    // SpeedDatabaseEntry(speed: 2.65, dateTime: DateTime(2024, 5, 10)),
    // SpeedDatabaseEntry(speed: 2.75, dateTime: DateTime(2024, 5, 10)),
  ];

  Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Speed("
                "id INTEGER PRIMARY KEY, "
                "speed REAL NOT NULL, "
                "dateTime TEXT NOT NULL"
                ");"),
        version: _version);
  }

  Future add(SpeedDatabaseEntry speedDatabaseEntry) async {

    final db = await _getDB();
    await db.insert("Speed", speedDatabaseEntry.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    speedList.add(speedDatabaseEntry);
  }

  Future update(SpeedDatabaseEntry speedDatabaseEntry) async {

    final db = await _getDB();
    await db.update("Speed", speedDatabaseEntry.toJson(),
        where: 'id = ?',
        whereArgs: [speedDatabaseEntry.id],
        conflictAlgorithm: ConflictAlgorithm.replace);

    int index = speedList.indexWhere((element) => element.id == speedDatabaseEntry.id);

    speedList[index] = speedDatabaseEntry;
  }

  Future delete(SpeedDatabaseEntry speedDatabaseEntry) async {
    if(speedDatabaseEntry.id == null){
      return;
    }

    final db = await _getDB();
    await db.delete(
      "Speed",
      where: 'id = ?',
      whereArgs: [speedDatabaseEntry.id],
    );

    int index = speedList.indexWhere((element) => element.id == speedDatabaseEntry.id);

    speedList.removeAt(index);
  }

  Future<List<SpeedDatabaseEntry>> getAll() async {
    if(speedList.isNotEmpty){
      return speedList;
    }

    final db = await _getDB();

    debugPrint("Fetched database");

    final List<Map<String, dynamic>> queryResult = await db.query("Speed");

    if (queryResult.isEmpty) {
      return [];
    }

    speedList = List.generate(queryResult.length, (index) => SpeedDatabaseEntry.fromJson(queryResult[index]));

    return speedList;
  }

  Future<List<SpeedDatabaseEntry>> getAllByDay(DateTime day) async {
    final allEntries = await getAll();

    return allEntries.where((speedDatabaseEntry) =>
      DateUtils.isSameDay(DateTime.parse(speedDatabaseEntry.dateTime), day)
    ).toList();
  }

  Future<List<String>> getAllDays() async{
    final db = await _getDB();
    final List<Map<String, dynamic>> queryResult = await db.query("Speed",
      columns: ["dateTime"],
      distinct: true
    );

    Set<String> daySet = List
        .generate(queryResult.length, (index) => queryResult[index]['dateTime'])
        .map((e) => DateFormat('dd-MM-yyyy').format(DateTime.parse(e)))
        .toSet();

    return daySet.toList();

    //final dates = dayList.map((e) => DateFormat('dd-MM-yyyy').format(e.date)).toSet();
  }
}