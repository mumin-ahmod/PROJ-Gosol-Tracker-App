import 'package:gosol_tracker_app/Model/gosol_model.dart';
import 'package:gosol_tracker_app/Model/profile_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';

import 'package:path/path.dart' as path;

class DatabaseHelper {
  static const databaseVersion = 1;

  static const tableName = "gosoltable";

  static const idColumn = "id";
  static const datetimeColumn = "datetime";
  static const temperatureColumn = "temp";

  static const profileTable = "profiletable";

  static const idProfileColumn = "id";
  static const nameColumn = "name";
  static const image64bitColumn = "image64bit";

  static Database? _database;
  static late BriteDatabase _streamDatabase;

  // DATABASE CREATE QUERY
  static Future _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE $tableName (
    $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $datetimeColumn INTEGER,
    $temperatureColumn REAL
    )""");

    await db.execute("""
    CREATE TABLE $profileTable(
    $idProfileColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $nameColumn TEXT,
    $image64bitColumn TEXT
    
    )    
    """);
  }

  // OPENING THE DATABASE
  static open() async {
    final rootPath = await getDatabasesPath();

    final dbPath = path.join(rootPath, "GosolDb.db");
    print("GOSOL DB OPENED");

    return openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);

    // OpenDatabase GIVES AND INSTANCE OF THE DATABASE
  }

  static get database async {
    if (_database != null) return _database;

    if (_database == null) {
      _database = await open();

      _streamDatabase = BriteDatabase((_database!));
    }

    return _database;
  }

  static Future<BriteDatabase> get streamDatabase async {
    await database;

    return _streamDatabase;
  }

  static Future insertGosol(Map<String, dynamic> row) async {
    final briteDb = await DatabaseHelper.streamDatabase;

    print("ROW INSERTED");
    return await briteDb.insert(tableName, row);
  }

  static Stream<List<GosolModel>> getAllGosols() async* {
    final briteDb = await DatabaseHelper.streamDatabase;

    // List<Map<String, dynamic>> mapList = db.createQuery(tableName);
    // // GOT ALL THE GOSOLS!
    // return List.generate(
    //     mapList.length, (index) => GosolModel.fromMap(mapList[index]));

    ///yield* db.createQuery(tableName).forEach((map) => map(Map<String, dynamic> map)=> GosolModel.fromMap(map));

    yield* briteDb
        .createQuery(tableName, orderBy: datetimeColumn)
        .mapToList((row) => GosolModel.fromMap(row));
  }

  static Future delete(int id) async {
    final briteDb = await DatabaseHelper.streamDatabase;

    print("ROW DELETED");

    return briteDb.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  static Future insertProfile(Map<String, dynamic> row) async {
    final briteDb = await DatabaseHelper.streamDatabase;

    print("PROFILE ROW INSERTED");
    return await briteDb.insert(profileTable, row);
  }

  static Stream<List<ProfileModel>> getAllProfile() async* {
    final briteDb = await DatabaseHelper.streamDatabase;
    // List<Map<String, dynamic>> mapList = await briteDb.query(profileTable);
    // return List.generate(
    //     mapList.length, (index) => ProfileModel.fromMap(mapList[index]));
    print("PROFILE GOT");
    yield* briteDb
        .createQuery(profileTable)
        .mapToList((row) => ProfileModel.fromMap(row));
  }

  static updateProfile(ProfileModel profile) async {
    final briteDb = await DatabaseHelper.streamDatabase;

    briteDb
        .update(profileTable, profile.toMap(), where: "id =?", whereArgs: [1]);
  }
}
