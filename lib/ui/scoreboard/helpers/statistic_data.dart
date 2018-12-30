import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/score_data.dart';

class StatisticData {
  String id;
  String matchId;
  DateTime matchTime;
  Duration matchDuration;
  int setTeam1;
  int setTeam2;
  int pointsTeam1;
  int pointsTeam2;
  int timeoutsTeam1;
  int timeoutsTeam2;
  int startTeam;
  int activeTeam;

  StatisticData(
      {this.id,
      this.matchId,
      this.matchTime,
      this.matchDuration,
      this.setTeam1,
      this.setTeam2,
      this.pointsTeam1,
      this.pointsTeam2,
      this.timeoutsTeam1,
      this.timeoutsTeam2,
      this.startTeam,
      this.activeTeam});

  Future<int> save() {
    id = SystemHelpers.generateUuid();
    matchTime = DateTime.now();

    return DbHelpers.insert(DbSql.tableStatistics, this.toMap());
  }

  Future<int> delete() {
    return DbHelpers.delete(DbSql.tableStatistics, id);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "matchId": matchId,
      "matchTime": matchTime.millisecondsSinceEpoch,
      "matchDuration": matchDuration.inSeconds,
      "setTeam1": setTeam1,
      "setTeam2": setTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2,
      "startTeam": startTeam,
      "activeTeam": activeTeam,
    };
  }

  factory StatisticData.fromMap(Map<String, dynamic> item) {
    return StatisticData(
        id: item["id"],
        matchId: item["matchId"],
        matchTime: DateTime.fromMillisecondsSinceEpoch(item["matchTime"]),
        matchDuration: Duration(seconds: item["matchDuration"]),
        setTeam1: item["setTeam1"],
        setTeam2: item["setTeam2"],
        pointsTeam1: item["pointsTeam1"],
        pointsTeam2: item["pointsTeam2"],
        timeoutsTeam1: item["timeoutsTeam1"],
        timeoutsTeam2: item["timeoutsTeam2"],
        startTeam: item["startTeam"],
        activeTeam: item["activeTeam"]);
  }

  factory StatisticData.fromScore(ScoreData score) {
    return StatisticData(
      matchId: score.matchId,
      pointsTeam1: score.pointsTeam1,
      pointsTeam2: score.pointsTeam2,
      matchDuration: score.matchDuration,
      setTeam1: score.setTeam1,
      setTeam2: score.setTeam2,
      timeoutsTeam1: score.timeoutsTeam1,
      timeoutsTeam2: score.timeoutsTeam2,
      activeTeam: score.activeTeam,
      startTeam: score.startTeam
    );
  }
}
