import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_flutter/model.dart';

class DatabaseHelper {
  static const _dbVersion = 1;
  static const _dbName = "student.db";
  static const tableName = "student";

  static const name = "name";
  static const idd = "id";
  static const address = "address";


  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

//it will check database is already exist or not and return database
  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

//it will create directory and database
  initDatabase() async {
    //create a directory for input
    Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, _dbName);
    var db = await openDatabase(path, version: _dbVersion, onCreate: onCreate);
    return db;
  }

  //it create tabel and column
  Future<void> onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $tableName ($idd INTEGER PRIMARY KEY AUTOINCREMENT  ,  $name TEXT, $address TEXT)''');
  }
  // Future close()async{
  //   final db=await instance.db;
  //   db!.close();
  // }

  // Future<List<Student>> readAllData()async{
  //   var dbClient=await instance.db;
  //   var response=await dbClient!.query(tableName);
  //   List<Student> list=response.map((e) => Student.fromJson(e)).toList();
  //   return list;
  // }

  // Future<Student?> readData(int id)async{
  //   var dbClient=await instance.db;
  //   var response=await dbClient!.query(tableName,where: "id=?",whereArgs: [id]);
  //
  //   return response.isNotEmpty?Student.fromJson(response.first):null;
  // }

  Future<bool> insertData(StudentModel student) async {
    final dbClient = await initDatabase();
    dbClient!.insert(tableName, student.toMap());

    return true;
  }

  Future<List<StudentModel>> getData() async {
    final Database dbClient = await initDatabase();
    final List<Map<String, dynamic>> data = await dbClient.query(tableName);
    return data.map((e) => StudentModel.fromMap(e)).toList();
  }
//   Future<StudentModel> getCurrentData(int id) async {
//   final Database dbClient = await initDatabase();
//  var data= await dbClient.query(tableName, where: idd+"=?",whereArgs: [id]);
//  return StudentModel.fromMap(data.first);
//
//
//
// }

  Future<void> update(StudentModel student, int  id) async {
    final  Database dbClient = await initDatabase();
    await dbClient
        .update(tableName, student.toMap(), where: "id=?", whereArgs: [id]);
  }
  Future<void> delete(int  id) async {
    final  Database dbClient = await initDatabase();
    await dbClient
        .delete(tableName, where: "id=?", whereArgs: [id]);
  }
}
