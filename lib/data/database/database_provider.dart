import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subscriptions/data/database/subscription_dao.dart';

class DatabaseProvider {
  static const DATABASE_NAME = "subscriptions_database.db";
  static const DATABASE_VERSION = 1;

  DatabaseProvider._();

  static final DatabaseProvider instance = DatabaseProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();

    String path = join(documentsDirectory, DATABASE_NAME);
    return await openDatabase(path,
        version: DATABASE_VERSION, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(_createSubscriptionTable());
  }

  String _createSubscriptionTable() {
    return SubscriptionDao.createSubscriptionTable();
  }
}

abstract class DataBaseConstants {
  static const PRIMARY_KEY = "PRIMARY KEY";
  static const TEXT = "TEXT";
  static const INTEGER = "INTEGER";
  static const REAL = "REAL";
  static const NUMERIC = "NUMERIC";
}
