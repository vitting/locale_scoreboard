import 'package:locale_scoreboard/helpers/datetime_helpers.dart';
import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/score_data.dart';

class SetData {
  String id;
  String matchId;
  int startTeam;
  int setNumber;
  int pointsTeam1;
  int pointsTeam2;
  int setTeam1;
  int setTeam2;
  int timeoutsTeam1;
  int timeoutsTeam2;
  DateTime setStart;
  DateTime setEnd;
  int winnerTeam;

  SetData(
      {this.id,
      this.matchId,
      this.startTeam,
      this.setNumber,
      this.pointsTeam1,
      this.pointsTeam2,
      this.setTeam1,
      this.setTeam2,
      this.timeoutsTeam1,
      this.timeoutsTeam2,
      this.setStart,
      this.setEnd,
      this.winnerTeam});

  int getSetTime() {
    return DateTimeHelpers.totalTime(setStart, setEnd).inMinutes;
  }

  Future<int> save() {
    id = SystemHelpers.generateUuid();
    return DbHelpers.insert(DbSql.tableSets, this.toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "matchId": matchId,
      "startTeam": startTeam,
      "setNumber": setNumber,
      "pointsTeam1": pointsTeam1,
      "pointsTeam2": pointsTeam2,
      "setTeam1": setTeam1,
      "setTeam2": setTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2,
      "setStart": setStart.millisecondsSinceEpoch,
      "setEnd": setEnd.millisecondsSinceEpoch,
      "winnerTeam": winnerTeam
    };
  }

  factory SetData.fromMap(Map<String, dynamic> item) {
    return SetData(
        id: item["id"],
        matchId: item["matchId"],
        startTeam: item["startTeam"],
        setNumber: item["setNumber"],
        pointsTeam1: item["pointsTeam1"],
        pointsTeam2: item["pointsTeam2"],
        setTeam1: item["setTeam1"],
        setTeam2: item["setTeam2"],
        timeoutsTeam1: item["timeoutsTeam1"],
        timeoutsTeam2: item["timeoutsTeam2"],
        setStart: DateTime.fromMillisecondsSinceEpoch(item["setStart"]),
        setEnd: DateTime.fromMillisecondsSinceEpoch(item["setEnd"]),
        winnerTeam: item["winnerTeam"]);
  }

  static SetData fromScoreData(ScoreData scoreData, int winnerTeam) {
    return SetData(
      matchId: scoreData.matchId,
      pointsTeam1: scoreData.pointsTeam1,
      pointsTeam2: scoreData.pointsTeam2,
      setTeam1: scoreData.setTeam1,
      setTeam2: scoreData.setTeam2,
      timeoutsTeam1: scoreData.timeoutsTeam1,
      timeoutsTeam2: scoreData.timeoutsTeam2,
      setStart: scoreData.setStart,
      setEnd: scoreData.setEnd,
      setNumber: scoreData.setTeam1 + scoreData.setTeam2,
      startTeam: scoreData.startingWithTheServe,
      winnerTeam: winnerTeam
    );
  }
}
