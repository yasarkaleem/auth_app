import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../src/shared/models/user.dart';

class DatabaseService {
  static Database? _database;
  static const String tableUsers = 'users';

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'auth.db');
    return await openDatabase(
      path,
      version: 2, // Updated version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tableUsers ADD COLUMN name TEXT NOT NULL DEFAULT ""');
      await db.execute('ALTER TABLE $tableUsers ADD COLUMN username TEXT UNIQUE NOT NULL DEFAULT ""');
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(tableUsers, user);
  }

  Future<User?> getUser(String email) async {
    final db = await database;
    final result = await db.query(
      tableUsers,
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      tableUsers,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }
}
