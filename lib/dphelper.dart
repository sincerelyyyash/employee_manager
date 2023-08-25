import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'employee_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees(
            id INTEGER PRIMARY KEY,
            name TEXT,
            role TEXT,
            startDate TEXT,
            endDate TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertEmployee(Employee employee) async {
    final db = await initializeDatabase();
    await db.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Employee>> fetchEmployees() async {
    final db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) {
      return Employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        role: maps[i]['role'],
        startDate: maps[i]['startDate'],
        endDate: maps[i]['endDate'],
      );
    });
  }

  static Future<void> deleteEmployee(int id) async {
    final db = await initializeDatabase();
    await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}

class Employee {
  final int? id;
  final String name;
  final String role;
  final String startDate;
  final String endDate;

  Employee({
    this.id,
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
