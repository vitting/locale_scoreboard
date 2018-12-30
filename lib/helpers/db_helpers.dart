import 'dart:io';

import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

final String dbName = "board.db";
final int dbVersion = 5;

class DbHelpers {
  static final _lock = new Lock();
  static Database _db;

  static Future<Database> get db async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    // Sqflite.setDebugModeOn();
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
          _db = await openDatabase(path, version: dbVersion,
              onConfigure: (Database db) async {
            try {
            } catch (error) {
              print("DB ONCONFIGURE ERROR: $error");
            }
            print("ONCONFIG");
          }, onCreate: (Database db, int version) async {
            try {
              print("ONCREATE CREATION TABLES");
              await db.execute(
                  "${DbSql.createMatches}${DbSql.createScores}${DbSql.createSets}${DbSql.createStatistics}");
            } catch (error) {
              print("DB ONCREATE ERROR: $error");
            }
          }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
            try {
              print("ONUPGRADE CREATION TABLES");
              await db.execute(
                  "${DbSql.createMatches}${DbSql.createScores}${DbSql.createSets}${DbSql.createStatistics}");
            } catch (error) {
              print("DB ONUPGRADE ERROR: $error");
            }
          }, onOpen: (Database db) async {
            try {
              print("ONOPEN");
              // await db.execute(DbSql.createScores);
              // print(await db.rawQuery("PRAGMA table_info(scores)"));
              // await db.execute("${DbSql.dropMatches}${DbSql.dropScores}${DbSql.dropSets}${DbSql.dropStatistics}");
              // await db.execute("${DbSql.createMatches}${DbSql.createScores}${DbSql.createSets}${DbSql.createStatistics}");
            } catch (error) {
              print("DB ONOPEN ERROR: $error");
            }
          });
        }
      });
    }

    return _db;
  }

  static Future<dynamic> close() async {
    Database dbCon = await db;
    return dbCon.close();
  }

  static Future<int> insert(String table, Map<String, dynamic> item) async {
    Database dbCon = await db;
    return dbCon.insert(table, item);
  }

  static Future<int> update(String table, Map<String, dynamic> item,
      String where, List<dynamic> whereArgs) async {
    Database dbCon = await db;
    return dbCon.update(table, item, where: where, whereArgs: whereArgs);
  }

  static Future<int> delete(String table, String id) async {
    Database dbCon = await db;
    return dbCon.delete(table, where: "${DbSql.colId} = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct = false,
      int limit = -1,
      String orderBy,
      String where,
      List<dynamic> whereArgs}) async {
    Database dbCon = await db;
    return dbCon.query(table,
        columns: [],
        distinct: distinct,
        limit: limit,
        orderBy: orderBy,
        where: where,
        whereArgs: whereArgs);
  }

  static Future<int> updateMatchElapsed(int matchDuration, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET matchDuration = ? WHERE id = ?", [matchDuration, id]);
  }

  static Future<int> updateStartTeam(int team, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET startTeam = ? WHERE id = ?", [team, id]);
  }

  static Future<int> updateActiveTeam(int team, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET activeTeam = ? WHERE id = ?", [team, id]);
  }

  static Future<int> updateSets(int setTeam1, int setTeam2, int matchDuration, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET setTeam1 = ?, setTeam2 = ?, matchDuration = ? WHERE id = ?", [setTeam1, setTeam2, matchDuration, id]);
  }

  static Future<int> updatePoints(int pointsTeam1, int pointsTeam2, int matchDuration, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET pointsTeam1 = ?, pointsTeam2 = ?, matchDuration = ? WHERE id = ?", [pointsTeam1, pointsTeam2, matchDuration, id]);
  }

  static Future<int> updateTimeouts(int timeoutsTeam1, int timeoutsTeam2, int matchDuration, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET timeoutsTeam1 = ?, timeoutsTeam2 = ?, matchDuration = ? WHERE id = ?", [timeoutsTeam1, timeoutsTeam2, matchDuration, id]);
  }

  static Future<int> updateMatchDuration(int matchDuration, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET matchDuration = ? WHERE id = ?", [matchDuration, id]);
  }

  static Future<int> updateMatchStartedAt(int matchStartedAt, bool active, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE matches SET matchStartedAt = ?, active = ? WHERE id = ?", [matchStartedAt, active, id]);
  }

  static Future<int> updateMatchEndedAt(int matchEndedAt, bool active, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE matches SET matchEndedAt = ?, active = ? WHERE id = ?", [matchEndedAt, active, id]);
  }
}
