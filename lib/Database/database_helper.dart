import 'package:gosol_tracker_app/Model/gosol_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';

import 'package:path/path.dart' as path;

class DatabaseHelper {
  static const tableName = "gosoltable";
  static const databaseVersion = 1;

  static const idColumn = "id";
  static const datetimeColumn = "datetime";
  static const temperatureColumn = "temp";

  // DATABASE CREATE QUERY
  static Future _onCreate(Database db, int version) {
    return db.execute("""CREATE TABLE $tableName (
    $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $datetimeColumn INTEGER,
    $temperatureColumn REAL
    )""");
  }

  // OPENING THE DATABASE
  static open() async {
    final rootPath = await getDatabasesPath();

    final dbPath = path.join(rootPath, "GosolDb.db");
    print("GOSOL DB OPENED");

    return openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);

    // OpenDatabase GIVES AND INSTANCE OF THE DATABASE
  }

  //
  // static Future<BriteDatabase> sqlBright() async {
  //
  //   final dbase = await open();
  //
  //
  //   return britedb = BriteDatabase(dbase);
  // }

  static Future insertGosol(Map<String, dynamic> row) async {
    final Database db = await open();
    final briteDb = BriteDatabase(db);

    print("ROW INSERTED");
    return await briteDb.insert(tableName, row);
  }

  static Stream<List<GosolModel>> getAllGosols() async* {
    final Database db = await open();

    final briteDb = BriteDatabase(db);

    // List<Map<String, dynamic>> mapList = db.createQuery(tableName);
    // // GOT ALL THE GOSOLS!
    // return List.generate(
    //     mapList.length, (index) => GosolModel.fromMap(mapList[index]));

    ///yield* db.createQuery(tableName).forEach((map) => map(Map<String, dynamic> map)=> GosolModel.fromMap(map));

    yield* briteDb
        .createQuery(tableName, orderBy: datetimeColumn)
        .mapToList((row) => GosolModel.fromMap(row));
  }

  static delete(int id) async {
    final Database db = await open();

    final briteDb = BriteDatabase(db);

    return briteDb.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
