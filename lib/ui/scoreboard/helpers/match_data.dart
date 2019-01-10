import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/score_data.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/set_data.dart';

class MatchData {
  String id;
  String title;
  DateTime createdDate;
  DateTime matchStartedAt;
  DateTime matchEndedAt;
  String namePlayer1Team1;
  String namePlayer2Team1;
  String namePlayer1Team2;
  String namePlayer2Team2;
  bool active;
  int winnerTeam;

  MatchData(
      {this.id,
      this.title,
      this.createdDate,
      this.matchStartedAt,
      this.matchEndedAt,
      this.namePlayer1Team1,
      this.namePlayer2Team1,
      this.namePlayer1Team2,
      this.namePlayer2Team2,
      this.active,
      this.winnerTeam = 0});

  Future<int> updateMatchWinnerTeam(int team) {
    winnerTeam = team;
    return DbHelpers.updateMatchWinnerTeam(team, id);
  }

  Future<int> updateMatchStarted(DateTime time) {
    matchStartedAt = time;
    active = true;
    return DbHelpers.updateMatchStartedAt(
        matchStartedAt.millisecondsSinceEpoch, active, id);
  }

  Future<int> updateMatchEnded(DateTime time) {
    matchEndedAt = time;
    active = false;
    return DbHelpers.updateMatchEndedAt(
        matchEndedAt.millisecondsSinceEpoch, active, id);
  }

  Future<List<SetData>> getSets() async {
    List<SetData> setsData = [];
    List<Map<String, dynamic>> sets = await DbHelpers.query(DbSql.tableSets,
        where: "matchId = ?", whereArgs: [this.id], orderBy: "setNumber asc");
    if (sets.length != 0) {
      setsData = sets.map<SetData>((Map<String, dynamic> s) {
        return SetData.fromMap(s);
      }).toList();
    }

    return setsData;
  }

  Future<ScoreData> getScore() async {
    ScoreData scoreData;
    List<Map<String, dynamic>> scores = await DbHelpers.query(DbSql.tableScores,
        where: "matchId = ?", whereArgs: [this.id]);
    if (scores.length != 0) {
      scoreData = ScoreData.fromMap(scores[0]);
    }

    return scoreData;
  }

  Future<int> delete() async {
    await DbHelpers.deleteByMatchId(DbSql.tableScores, id);
    await DbHelpers.deleteByMatchId(DbSql.tableSets, id);
    return DbHelpers.deleteById(DbSql.tableMatches, this.id);
  }

  Future<int> save() async {
    id = id ?? SystemHelpers.generateUuid();
    createdDate = createdDate ?? DateTime.now();
    matchStartedAt = matchStartedAt ?? DateTime.now();
    matchEndedAt = matchEndedAt ?? DateTime.now();
    active = active ?? false;
    title =
        "$namePlayer1Team1, $namePlayer2Team1 vs. $namePlayer1Team2, $namePlayer2Team2";

    ScoreData score = ScoreData(matchId: id, elapsedTime: Duration(seconds: 0));
    await score.initScores();
    return DbHelpers.insert(DbSql.tableMatches, this.toMap());
  }

  Future<int> update() async {
    title =
        "$namePlayer1Team1, $namePlayer2Team1 vs. $namePlayer1Team2, $namePlayer2Team2";
    return DbHelpers.update(
        DbSql.tableMatches, this.toMap(), "id = ?", [this.id]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "createdDate": createdDate.millisecondsSinceEpoch,
      "matchStartedAt": matchStartedAt.millisecondsSinceEpoch,
      "matchEndedAt": matchEndedAt.millisecondsSinceEpoch,
      "namePlayer1Team1": namePlayer1Team1,
      "namePlayer2Team1": namePlayer2Team1,
      "namePlayer1Team2": namePlayer1Team2,
      "namePlayer2Team2": namePlayer2Team2,
      "active": active,
      "winnerTeam": winnerTeam
    };
  }

  static Future<List<Map<String, dynamic>>> getMatches() {
    return DbHelpers.query(DbSql.tableMatches, orderBy: "createdDate desc");
  }

  factory MatchData.fromMap(Map<String, dynamic> item) {
    return MatchData(
        id: item["id"],
        title: item["title"],
        createdDate: DateTime.fromMillisecondsSinceEpoch(item["createdDate"]),
        matchStartedAt:
            DateTime.fromMillisecondsSinceEpoch(item["matchStartedAt"]),
        matchEndedAt: DateTime.fromMillisecondsSinceEpoch(item["matchEndedAt"]),
        namePlayer1Team1: item["namePlayer1Team1"],
        namePlayer2Team1: item["namePlayer2Team1"],
        namePlayer1Team2: item["namePlayer1Team2"],
        namePlayer2Team2: item["namePlayer2Team2"],
        active: item["active"] == 1,
        winnerTeam: item["winnerTeam"]);
  }
}
