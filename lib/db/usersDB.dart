import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_app/model/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UsersDB {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initialize();

    return _database!;
  }

  Future<String> get fullPath async {
    const name = "YummyDB.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<void> deleteDatabase() async {
    try {
      final path = await fullPath;
      databaseFactory.deleteDatabase(path);
      print("xoa");
    } catch (e) {
      print('Error: $e');
    }

  }




  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async =>
      await UsersDB().createTable(database);

  final tableName = "users";

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
            user_id TEXT PRIMARY KEY NOT NULL,
            username TEXT NOT NULL,
            password TEXT NULL,
            email TEXT NOT NULL,
            phone TEXT NULL,
            address TEXT NULL,
            type INTEGER NOT NULL,
            imageURL TEXT NULL,
            level INTEGER NOT NULL,
            coin INTEGER NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL   
    )""");
  }

  Future<void> insert(Users user) async {
    try {
      final db = await UsersDB().database;
      await db.insert(
        tableName,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("success");
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Users>> getAll() async {

    try {
      final db = await UsersDB().database;
      final List<Map<String, Object?>> dataMaps = await db.query(tableName,orderBy: "updatedAt");
      List<Users> list = dataMaps.isNotEmpty ? dataMaps.map((c) => Users.fromMap(c)).toList() : [];
      print("list: $list");
      return list;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<Users> fetchById(String id) async {
    final db = await database;
    final maps = await db.query(tableName, where: 'user_id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Users.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> update(Users user) async {
    final db = await database;
    return await db.update(
      tableName,
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [user.user_id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Users>> searchByUsername(String username) async {
    final db = await database;
    final List<Map<String, Object?>> dataMaps = await db.query(tableName, where: 'username LIKE ?', whereArgs: ['%$username%']);
    List<Users> list = dataMaps.isNotEmpty ? dataMaps.map((c) => Users.fromMap(c)).toList() : [];
    return list;
  }
}
