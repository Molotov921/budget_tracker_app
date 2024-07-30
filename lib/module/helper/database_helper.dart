import 'dart:typed_data';
import 'package:budget_tracker_app/module/views/homepage/model/fetch_category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper dbHelper = DBHelper._();

  String tableName1 = "category";
  String tableName2 = "budget";
  Database? db;

  Future<Database?> initDB() async {
    String path = await getDatabasesPath();
    String databasePath = join(path, 'budget_tracker.db');

    db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        String sql1 =
            "CREATE TABLE IF NOT EXISTS $tableName1(catId INTEGER PRIMARY KEY AUTOINCREMENT, catName TEXT, catImg BLOB)";
        String sql2 =
            "CREATE TABLE IF NOT EXISTS $tableName2(budgetId INTEGER PRIMARY KEY AUTOINCREMENT, amount TEXT, note TEXT, date TEXT, time TEXT, method TEXT, type TEXT, category TEXT)";
        await db.execute(sql1);
        await db.execute(sql2);
      },
    );
    return db;
  }

  Future<void> insertCategory(
      String categoryName, Uint8List categoryImage) async {
    db = await initDB();

    String sql = "INSERT INTO $tableName1(catName,catImg) VALUES(?,?)";
    List args = [categoryName, categoryImage];

    await db!.rawInsert(sql, args);
  }

  Future<List<FetchedCategory>> fetchCategoryAllData() async {
    db = await initDB();

    String sql = "SELECT * FROM $tableName1";

    List<Map<String, Object?>> data = await db!.rawQuery(sql);

    List<FetchedCategory> fetchedData = data
        .map((e) =>
            FetchedCategory(catName: "${e['catName']}", catImage: e['catImg']))
        .toList();

    return fetchedData;
  }

  Future<void> insertBudget(String amount, String note, String date,
      String time, String method, String type, String category) async {
    db = await initDB();

    String sql =
        "INSERT INTO $tableName2(amount, note, date, time, method, type, category) VALUES(?,?,?,?,?,?,?)";
    List args = [amount, note, date, time, method, type, category];

    await db!.rawInsert(sql, args);
  }

  Future<void> deleteBudget(int id) async {
    db = await initDB();

    String sql = "DELETE FROM $tableName2 WHERE budgetId=?";
    List args = [id];

    await db!.rawDelete(sql, args);
  }

  Future<void> updateBudgetRecord(String amount, String note, String date,
      String time, String method, String type, String category, int id) async {
    db = await initDB();

    String sql =
        "UPDATE $tableName2 SET amount=?,note=?,date=?,time=?,method=?,type=?,category=? WHERE budgetId=?";
    List args = [amount, note, date, time, method, type, category, id];

    await db!.rawUpdate(sql, args);
  }

  Future<List<Map<String, Object?>>> fetchAllBudget() async {
    String sql = "SELECT * FROM $tableName2";

    List<Map<String, Object?>> data = await db!.rawQuery(sql);

    return data;
  }
}
