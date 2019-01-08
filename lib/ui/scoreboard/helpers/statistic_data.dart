import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/score_data.dart';

class StatisticData {
  String id;
  String matchId;
  DateTime matchTime;
  Duration elapsedTime;
  int winnerOfDraw;
  int startingWithTheServe;
  int orderOfServePlayer1Team1;
  int orderOfServePlayer2Team1;
  int orderOfServePlayer1Team2;
  int orderOfServePlayer2Team2;
  int setTeam1;
  int setTeam2;
  int pointsTeam1;
  int pointsTeam2;
  int timeoutsTeam1;
  int timeoutsTeam2;
  int activeTeam;

  StatisticData(
      {this.id,
      this.matchId,
      this.matchTime,
      this.elapsedTime,
      this.winnerOfDraw = 0,
      this.startingWithTheServe = 0,
      this.orderOfServePlayer1Team1 = 0,
      this.orderOfServePlayer2Team1 = 0,
      this.orderOfServePlayer1Team2 = 0,
      this.orderOfServePlayer2Team2 = 0,
      this.setTeam1 = 0,
      this.setTeam2 = 0,
      this.pointsTeam1 = 0,
      this.pointsTeam2 = 0,
      this.timeoutsTeam1 = 0,
      this.timeoutsTeam2 = 0,
      this.activeTeam = 0});

  Future<int> save() {
    id = SystemHelpers.generateUuid();
    matchTime = DateTime.now();

    return DbHelpers.insert(DbSql.tableStatistics, this.toMap());
  }

  Future<int> delete() {
    return DbHelpers.deleteById(DbSql.tableStatistics, id);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "matchId": matchId,
      "matchTime": matchTime.millisecondsSinceEpoch,
      "elapsedTime": elapsedTime.inSeconds,
      "winnerOfDraw": winnerOfDraw,
      "startingWithTheServe": startingWithTheServe,
      "orderOfServePlayer1Team1": orderOfServePlayer1Team1,
      "orderOfServePlayer2Team1": orderOfServePlayer2Team1,
      "orderOfServePlayer1Team2": orderOfServePlayer1Team2,
      "orderOfServePlayer2Team2": orderOfServePlayer2Team2,
      "setTeam1": setTeam1,
      "setTeam2": setTeam2,
      "pointsTeam1": pointsTeam1,
      "pointsTeam2": pointsTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2,
      "activeTeam": activeTeam,
    };
  }

  factory StatisticData.fromMap(Map<String, dynamic> item) {
    return StatisticData(
        id: item["id"],
        matchId: item["matchId"],
        matchTime: DateTime.fromMillisecondsSinceEpoch(item["matchTime"]),
        elapsedTime: Duration(seconds: item["elapsedTime"]),
        winnerOfDraw: item["winnerOfDraw"],
        startingWithTheServe: item["startingWithTheServe"],
        orderOfServePlayer1Team1: item["orderOfServePlayer1Team1"],
        orderOfServePlayer2Team1: item["orderOfServePlayer2Team1"],
        orderOfServePlayer1Team2: item["orderOfServePlayer1Team2"],
        orderOfServePlayer2Team2: item["orderOfServePlayer2Team2"],
        setTeam1: item["setTeam1"],
        setTeam2: item["setTeam2"],
        pointsTeam1: item["pointsTeam1"],
        pointsTeam2: item["pointsTeam2"],
        timeoutsTeam1: item["timeoutsTeam1"],
        timeoutsTeam2: item["timeoutsTeam2"],
        activeTeam: item["activeTeam"]);
  }

  factory StatisticData.fromScore(ScoreData score) {
    return StatisticData(
      matchId: score.matchId,
      winnerOfDraw: score.winnerOfDraw,
      startingWithTheServe: score.startingWithTheServe,
      orderOfServePlayer1Team1: score.orderOfServePlayer1Team1,
      orderOfServePlayer2Team1: score.orderOfServePlayer2Team1,
      orderOfServePlayer1Team2: score.orderOfServePlayer1Team2,
      orderOfServePlayer2Team2: score.orderOfServePlayer2Team2,
      pointsTeam1: score.pointsTeam1,
      pointsTeam2: score.pointsTeam2,
      elapsedTime: score.elapsedTime,
      setTeam1: score.setTeam1,
      setTeam2: score.setTeam2,
      timeoutsTeam1: score.timeoutsTeam1,
      timeoutsTeam2: score.timeoutsTeam2,
      activeTeam: score.activeTeam
    );
  }
}
