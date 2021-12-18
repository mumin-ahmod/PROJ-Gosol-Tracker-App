import 'package:gosol_tracker_app/Model/gosol_model.dart';
import 'package:sqflite/sqflite.dart';
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
  static Future open() async {
    final rootPath = await getDatabasesPath();

    final dbPath = path.join(rootPath, "GosolDb.db");
    print("GOSOL DB OPENED");

    return openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);

    // OpenDatabase GIVES AND INSTANCE OF THE DATABASE
  }

  static Future insertGosol(Map<String, dynamic> row) async {
    final db = await open();

    print("ROW INSERTED");
    return await db.insert(tableName, row);
  }

  static Future<List<GosolModel>> getAllGosols() async {
    final db = await open();

    List<Map<String, dynamic>> mapList = await db.query(tableName);

    // GOT ALL THE GOSOLS!

    return List.generate(
        mapList.length, (index) => GosolModel.fromMap(mapList[index]));
  }
}
