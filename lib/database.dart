import 'package:sqflite/sqflite.dart';
import 'package:tp4/usermodel.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<String?> registerUser(
      String username, String email, String password) async {
    final DatabaseHelper dbHelper = DatabaseHelper.instance;

    // Check if user already exists
    final user = await dbHelper.getUserByEmail(email);
    if (user != null) {
      return 'User already exists';
    }

    User newUser = User(username: username, email: email, password: password);
    await dbHelper.createUser(newUser.toMap());

    return 'User registered successfully';
  }

  Future<String?> loginUser(String email, String password) async {
    final DatabaseHelper dbHelper = DatabaseHelper.instance;

    // Check if user exists
    final user = await dbHelper.getUserByEmail(email);
    if (user == null) {
      return 'User does not exist';
    }

    // Compare the plain text password
    if (user['password'] == password) {
      return 'Login successful';
    } else {
      return 'Incorrect password';
    }
  }
}
