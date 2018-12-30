import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';
import 'package:meta/meta.dart';

class ScoreData {
  String id;
  String matchId;
  Duration matchDuration;
  int setTeam1;
  int setTeam2;
  int pointsTeam1;
  int pointsTeam2;
  int timeoutsTeam1;
  int timeoutsTeam2;
  int startTeam;
  int activeTeam;

  ScoreData(
      {this.id,
      @required this.matchId,
      @required this.matchDuration,
      this.setTeam1 = 0,
      this.setTeam2 = 0,
      this.pointsTeam1 = 0,
      this.pointsTeam2 = 0,
      this.timeoutsTeam1 = 0,
      this.timeoutsTeam2 = 0,
      this.startTeam = 0,
      this.activeTeam = 0});

  // save -> save statistic
  // save set
  // delete set
  
  Future<int> updateMatchElapsed(int elapsedTime) {
    matchDuration = Duration(seconds: elapsedTime);
    return DbHelpers.updateMatchDuration(elapsedTime, id);
  }

  Future<int> updateSets(int team1Set, int team2Set, int duration) {
    setTeam1 = team1Set;
    setTeam2 = team2Set;
    matchDuration = Duration(seconds: duration);
    return DbHelpers.updateSets(team1Set, team2Set, duration, id);
  }

  Future<int> updatePoints(int team1Points, int team2Points, int duration) {
    pointsTeam1 = team1Points;
    pointsTeam2 = team2Points;
    matchDuration = Duration(seconds: duration);
    return DbHelpers.updatePoints(team1Points, team2Points, duration, id);
  }

  Future<int> updateTimeouts(int team1Timeouts, int team2Timeouts, int duration) {
    timeoutsTeam1 = team1Timeouts;
    timeoutsTeam2 = team2Timeouts;
    matchDuration = Duration(seconds: duration);
    return DbHelpers.updateTimeouts(team1Timeouts, team2Timeouts, duration, id);
  }

  Future<int> updateStartTeam(int teamWithStart) {
    startTeam = teamWithStart;
    return DbHelpers.updateStartTeam(teamWithStart, id);
  }

  Future<int> updateActiveTeam(int teamThatActive) {
    activeTeam = teamThatActive;
    return DbHelpers.updateActiveTeam(teamThatActive, id);
  }

  Future<int> initScores() async {
    int returnValue = 0;
    if (id == null && matchId != null) {
      id = SystemHelpers.generateUuid();
      returnValue = await DbHelpers.insert(DbSql.tableScores, this.toMap());
    }

    return returnValue;
  }

  Future<int> delete() {
    return DbHelpers.delete(DbSql.tableScores, id);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "matchId": matchId,
      "matchDuration": matchDuration.inSeconds,
      "setTeam1": setTeam1,
      "setTeam2": setTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2,
      "startTeam": startTeam,
      "activeTeam": activeTeam,
    };
  }

  factory ScoreData.fromMap(Map<String, dynamic> item) {
    return ScoreData(
        id: item["id"],
        matchId: item["matchId"],
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
}
