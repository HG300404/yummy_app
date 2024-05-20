// import 'package:sqflite/sqflite.dart';
//
// class DBService {
//
//   Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//
//     _database = await _initialize();
//
//     //   openDatabase(
//     // join(await getDatabasesPath(), 'YummyDB.db'),
//     // onCreate: (db, version) {
//     //   return db.execute(
//     //     'CREATE TABLE users_table('
//     //         'id TEXT PRIMARY KEY, '
//     //         'username TEXT, '
//     //         'password TEXT, '
//     //         'email TEXT, '
//     //         'phone TEXT, '
//     //         'address TEXT, '
//     //         'type INTEGER, '
//     //         'imageURL TEXT, '
//     //         'level INTEGER, '
//     //         'coin INTEGER, '
//     //         'createdAt TEXT, '
//     //         'updatedAt TEXT)',);
//     // },
//     // version: 1,
//
//     return _database!;
//   }
//
//   Future<String> get fullPath async {
//     const name = "YummyDB.db";
//     final path = await getDatabasesPath();
//     return join(path, name);
//   }
//
//   Future<Database> _initialize() async {
//     final path = await fullPath;
//     var database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: create,
//       singleInstance: true,
//     );
//     return database;
//   }
//
//   Future<void> create(Database database, int version) async =>
//       await UsersDB().createTable(database);
//
// // Future<int> insert(Users user) async {
// //   final db = await UsersDB().database;
// //   return await db.rawInsert('''INSERT INTO $tableName (
// //       user_id,
// //       username,
// //       password,
// //       email,
// //       phone,
// //       address,
// //       type,
// //       imageURL,
// //       level,
// //       coin,
// //       createdAt,
// //       updatedAt,
// //     ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)''');
// // }
//
//
//
//
// //
// // Future<void> insertUser(Users user) async {
// //   final db = await getDatabase();
// //
// //   await db.insert(
// //     'users_table',
// //     users.toMap(),
// //     conflictAlgorithm: ConflictAlgorithm.replace,
// //   );
// // }
// //
// // Future<List<Users>> getAllUsers() async {
// //   final db = await getDatabase();
// //
// //   final List<Map<String, Object?>> dataMaps = await db.query('users_table',orderBy: "updatedAt");
// //   List<Users> list = dataMaps.isNotEmpty ? dataMaps.map((c) => Users.fromMap(c)).toList() : [];
// //   return list;
// // }
// // ...
// }