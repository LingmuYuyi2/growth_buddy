import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/record.dart';

class DatabaseHelper {
  static const _databaseName = 'my_database.db';
  static const _databaseVersion = 1;

  static const table = 'records';

  static const columnId = 'id';
  static const columnCategory = 'category';
  static const columnContent = 'content';
  static const columnEffort = 'effort';

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
        $columnEffort TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertRecord(Record record) async {
    final db = await instance.database;
    final Map<String, dynamic> recordMap = {
      columnId: record.id,
      columnCategory: record.category,
      columnContent: record.content,
      columnEffort: record.effort,
    };
    return await db.insert(table, recordMap);
  }

  Future<List<Record>> getRecords() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    print(maps);
    return List.generate(maps.length, (i) {
      return Record(
        id: maps[i][columnId],
        category: maps[i][columnCategory],
        content: maps[i][columnContent],
        effort: double.parse(maps[i][columnEffort]),
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

}
