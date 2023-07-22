import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/record.dart';

class DatabaseHelper {
  static const _databaseName = 'my_database.db';
  static const _databaseVersion = 1;

  static const table = 'records';
  static const counterTable = 'counter';
  static const lastUpdateTable = 'lastupdate';
  static const experienceTable = 'keikenchi';

  static const columnId = 'id';
  static const columnCategory = 'category';
  static const columnContent = 'content';
  static const columnEffort = 'effort';
  static const columnDate = 'date';

  static const columnCounterId = 'id';
  static const columnCount = 'count';

  static const columnLastUpdateId = 'id';
  static const columnLastUpdated = 'last_updated_id';
  
  static const columnExperienceId = 'id';
  static const columnExperience = 'experience';


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCategory TEXT NOT NULL,
        $columnContent TEXT NOT NULL,
        $columnEffort TEXT NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $counterTable (
        $columnCounterId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCount INTEGER NOT NULL
      )
    ''');
    await db.insert(counterTable, {'count': 0});  // 初期値として 0 を挿入

    await db.execute(
      '''
      CREATE TABLE $lastUpdateTable (
        $columnLastUpdateId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnLastUpdated INTEGER NOT NULL
      )
    ''');
    await db.insert(lastUpdateTable, {'last_updated_id': ""});  // 初期値として ""を挿入

    await db.execute('''
      CREATE TABLE $experienceTable (
        $columnExperienceId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnExperience INTEGER NOT NULL
      )
    ''');
    await db.insert(experienceTable, {'experience': 0});  // 初期値として 0 を挿入
  }

  Future<int> insertRecord(Record record) async {
    final db = await instance.database;
    final Map<String, dynamic> recordMap = {
      columnId: record.id,
      columnCategory: record.category,
      columnContent: record.content,
      columnEffort: record.effort,
      columnDate: record.date,
    };
    return await db.insert(table, recordMap);
  }

  Future<List<Record>> getRecords() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    // print(maps);
    return List.generate(maps.length, (i) {
      return Record(
        id: maps[i][columnId],
        category: maps[i][columnCategory],
        content: maps[i][columnContent],
        effort: double.parse(maps[i][columnEffort]),
        date: maps[i][columnDate],
      );
    });
  }

  Future<int> deleteRecord(int id) async {
  final db = await instance.database;
  return await db.delete(
    table,
    where: '$columnId = ?',
    whereArgs: [id],
  );
  }

  Future<int> getRecordCount() async {
    Database db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT (*) from records');
    int? count = Sqflite.firstIntValue(x);
    return count ?? 0;
  }

  Future<List<Map<String, dynamic>>> getTextsAndEffort({int? limit, String orderBy = 'id DESC'}) async {
    final db = await instance.database;
    limit ??= await getCount();
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: [columnContent, columnEffort],
      limit: limit,
      orderBy: orderBy,
    );
    return maps;
  }

  Future<int> getCount() async {
    Database db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT from $counterTable WHERE id = 1');
    int? count = Sqflite.firstIntValue(x);
    return count ?? 0;
  }

  Future<void> incrementCount() async {
    Database db = await instance.database;
    int currentCount = await getCount();
    await db.update(counterTable, {'count': currentCount + 1}, where: 'id = ?', whereArgs: [1]);
  }

  Future<void> resetCount() async {
    Database db = await instance.database;
    await db.update(counterTable, {'count': 0}, where: 'id = ?', whereArgs: [1]);
  }

  Future<String> getLastUpdated() async {
    Database db = await instance.database;
    var x = await db.rawQuery('SELECT $columnLastUpdated from $lastUpdateTable WHERE id = 1');
    String lastUpdated = Sqflite.firstIntValue(x)?.toString() ?? "";
    return lastUpdated;
  }

  Future<void> writeLastUpdated(String lastUpdate) async {
    Database db = await instance.database;
    await db.update(lastUpdateTable, {'last_updated_id': lastUpdate}, where: 'id = ?', whereArgs: [1]);
  }
  
  Future<void> incrementExperience(Record record) async {
  Database db = await instance.database;
  int currentExperience = await getExperience();
  await db.update(experienceTable, {'experience': currentExperience + record.effort * 10}, where: 'id = ?', whereArgs: [1]);
  }

  Future<int> getExperience() async {
    Database db = await instance.database;
    var x = await db.rawQuery('SELECT $columnExperience from $experienceTable WHERE id = 1');
    int? count = Sqflite.firstIntValue(x);
    return count ?? 0;
  }
}
