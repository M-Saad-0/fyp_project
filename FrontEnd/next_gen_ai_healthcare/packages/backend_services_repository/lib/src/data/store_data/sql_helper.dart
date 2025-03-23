// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class SqlHelper {
//   static final SqlHelper _instance = SqlHelper._internal();
//   static Database? _database;
//   factory SqlHelper() {
//     return _instance;
//   }
//   SqlHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     } else {
//       _database = await _initDatabase();
//       return _database!;
//     }
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'user_symptoms.db');
//     return await openDatabase(path, version: 1, onCreate: _onCreate);
//   }

//   Future _onCreate(Database db, int version) async {
//     String sql = '''CREATE TABLE user(
//       id TEXT PRIMARY KEY,
//       name TEXT,
//       email TEXT,
//       token TEXT,
//       image TEXT
//     )''';
//     await db.execute(sql);
//     await db.execute('CREATE TABLE theme(id INTEGER PRIMARY KEY, isLight INTEGER)');
//   }

  

//   Future<void> closeDatabase() async {
//     if (_database != null) {
//       await _database!.close();
//       _database = null;
//     }
//   }


// }
