import 'dart:io';

import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

final String dbName = "board.db";
final int dbVersion = 2;

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
              await db.execute("${DbSql.createMatches}");
              await db.execute("${DbSql.createScores}");
              await db.execute("${DbSql.createSets}");
              await db.execute("${DbSql.createStatistics}");
            } catch (error) {
              print("DB ONCONFIGURE ERROR: $error");
            }
            print("ONCONFIG");
          }, onCreate: (Database db, int version) async {
            try {
              print("ONCREATE CREATION TABLES");
              await db.execute("${DbSql.createMatches}");
              await db.execute("${DbSql.createScores}");
              await db.execute("${DbSql.createSets}");
              await db.execute("${DbSql.createStatistics}");
            } catch (error) {
              print("DB ONCREATE ERROR: $error");
            }
          }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
            try {
              print("ONUPGRADE CREATION TABLES");
              await db.execute("${DbSql.createMatches}");
              await db.execute("${DbSql.createScores}");
              await db.execute("${DbSql.createSets}");
              await db.execute("${DbSql.createStatistics}");
            } catch (error) {
              print("DB ONUPGRADE ERROR: $error");
            }
          }, onOpen: (Database db) async {
            try {
              print("ONOPEN");
              // await db.execute(DbSql.createScores);
              
              // await db.execute("${DbSql.dropMatches}");
              // await db.execute("${DbSql.dropScores}");
              // await db.execute("${DbSql.dropSets}");
              // await db.execute("${DbSql.dropStatistics}");

              // print(await db.rawQuery("PRAGMA table_info(matches)"));
              // print(await db.rawQuery("PRAGMA table_info(scores)"));
              // await db.execute("${DbSql.createMatches}${DbSql.createScores}${DbSql.createSets}${DbSql.createStatistics}");
            } catch (error) {
              print("DB ONOPEN ERROR: $error");
            }
          }, onDowngrade: (Database db, int oldVersion, int newVersion) {
            print("ONDOWNGRADE");
            try {
              File f = File.fromUri(Uri.file(path));
              f.delete();  
            } catch (e) {
              print("FILE ERROR: $e");
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

  static Future<int> deleteById(String table, String id) async {
    Database dbCon = await db;
    return dbCon.delete(table, where: "${DbSql.colId} = ?", whereArgs: [id]);
  }

  static Future<int> deleteByMatchId(String table, String matchId) async {
    Database dbCon = await db;
    return dbCon.delete(table, where: "${DbSql.colMatchId} = ?", whereArgs: [matchId]);
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

  static Future<int> updateScoreState(int state, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET state = ? WHERE id = ?", [state, id]);
  }

  static Future<int> updateSetPointsFirstTo(int points, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET setPointsFirstTo = ? WHERE id = ?", [points, id]);
  }

  static Future<int> updateSetStart(int setStart, int state, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET setStart = ?, state = ? WHERE id = ?", [setStart, state, id]);
  }

  static Future<int> updateSetEnd(int setEnd, int state, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET setEnd = ?, state = ? WHERE id = ?", [setEnd, state, id]);
  }

  static Future<int> updateElapsedTime(int elapsedTime, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET elapsedTime = ? WHERE id = ?", [elapsedTime, id]);
  }

  static Future<int> updateStartingWithTheServe(int team, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET startingWithTheServe = ? WHERE id = ?", [team, id]);
  }

  static Future<int> updateWinnerOfDraw(int team, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET winnerOfDraw = ? WHERE id = ?", [team, id]);
  }

  static Future<int> updateOrderOfServe(int team, int player1, int player2, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET orderOfServePlayer1Team$team = ?, orderOfServePlayer2Team$team = ? WHERE id = ?", [player1, player2, id]);
  }

  static Future<int> updateActiveTeam(int team, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET activeTeam = ? WHERE id = ?", [team, id]);
  }

  static Future<int> updateSets(int setTeam1, int setTeam2, int elapsedTime, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET setTeam1 = ?, setTeam2 = ?, elapsedTime = ? WHERE id = ?", [setTeam1, setTeam2, elapsedTime, id]);
  }

  static Future<int> updatePoints(int pointsTeam1, int pointsTeam2, int elapsedTime, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET pointsTeam1 = ?, pointsTeam2 = ?, elapsedTime = ? WHERE id = ?", [pointsTeam1, pointsTeam2, elapsedTime, id]);
  }

  static Future<int> updateTimeouts(int timeoutsTeam1, int timeoutsTeam2, int elapsedTime, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE scores SET timeoutsTeam1 = ?, timeoutsTeam2 = ?, elapsedTime = ? WHERE id = ?", [timeoutsTeam1, timeoutsTeam2, elapsedTime, id]);
  }

  static Future<int> updateMatchStartedAt(int matchStartedAt, bool active, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE matches SET matchStartedAt = ?, active = ? WHERE id = ?", [matchStartedAt, active, id]);
  }

  static Future<int> updateMatchEndedAt(int matchEndedAt, bool active, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE matches SET matchEndedAt = ?, active = ? WHERE id = ?", [matchEndedAt, active, id]);
  }

  static Future<int> updateMatchWinnerTeam(int team, String id) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE matches SET winnerTeam = ? WHERE id = ?", [team, id]);
  }
}
