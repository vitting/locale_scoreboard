import 'dart:io';

import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

final String dbName = "board.db";
final int dbVersion = 1;

class DbHelpers {
  final _lock = new Lock();
  static Database _db;

  Future<Database> get db async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    if (_db == null || !_db.isOpen) {
      try {
        await Directory(databasesPath).create(recursive: true);
      } catch (error) {
        print("Create DB directory error: $error");
      }

      /// Avoid lock issues on Android
      await _lock.synchronized(() async {
        if (_db == null || !_db.isOpen) {
          print("******************Opening database**********************");
          _db = await openDatabase(path, version: dbVersion, onCreate: (Database db, int version) async {
            await db.execute("${DbSql.createMatches}${DbSql.createScores}${DbSql.createSets}");
            // await db.execute(DbSql.createMatches);
            // await db.execute(DbSql.createScores);
            // await db.execute(DbSql.createSets);
          });
        }
      });
    }
    
    return _db;
  }

  Future<dynamic> close() async {
    Database dbCon = await db;
    return dbCon.close();
  }

  Future<int> insert(String table, Map<String, dynamic> item) async {
    Database dbCon = await db;
    return dbCon.insert(table, item);
  }

  Future<int> update(String table, Map<String, dynamic> item) async {
    Database dbCon = await db;
    return dbCon.update(table, item);
  } 

  Future<int> delete(String table, String id) async {
    Database dbCon = await db;
    return dbCon.delete(table, where: "${DbSql.colId} = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> query(String table, {bool distinct = false, int limit = -1, String orderBy, String where, List<dynamic> whereArgs}) async {
    Database dbCon = await db;
    return dbCon.query(table, columns: [], distinct: distinct, limit: limit, orderBy: orderBy, where: where, whereArgs: whereArgs);
  }
}
