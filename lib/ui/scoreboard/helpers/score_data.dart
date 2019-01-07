import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_player_names_widget.dart';
import 'package:meta/meta.dart';

class ScoreData {
  String id;
  String matchId;
  Duration elapsedTime;
  DateTime setStart;
  DateTime setEnd;
  int winnerOfDraw;
  int startingWithTheServe;
  int orderOfServePlayer1Team1;
  int orderOfServePlayer2Team1;
  int orderOfServePlayer1Team2;
  int orderOfServePlayer2Team2;
  int setTeam1;
  int setTeam2;
  int setPointsFirstTo;
  int pointsTeam1;
  int pointsTeam2;
  int timeoutsTeam1;
  int timeoutsTeam2;
  int activeTeam;

  /// 0 = match is not started
  /// 1 = match is started but set is not active
  /// 2 = match is started and set is active
  /// 3 = match is ended
  int state;

  ScoreData(
      {this.id,
      @required this.matchId,
      @required this.elapsedTime,
      this.setStart,
      this.setEnd,
      this.winnerOfDraw = 0,
      this.startingWithTheServe = 0,
      this.orderOfServePlayer1Team1 = 0,
      this.orderOfServePlayer2Team1 = 0,
      this.orderOfServePlayer1Team2 = 0,
      this.orderOfServePlayer2Team2 = 0,
      this.setTeam1 = 0,
      this.setTeam2 = 0,
      this.pointsTeam1 = 0,
      this.setPointsFirstTo = 21,
      this.pointsTeam2 = 0,
      this.timeoutsTeam1 = 0,
      this.timeoutsTeam2 = 0,
      this.activeTeam = 0,
      this.state = 0});

  // save -> save statistic
  // save set
  // delete set

  Future<int> updateState(int state) {
    this.state = state;
    return DbHelpers.updateScoreState(state, id);
  }

  Future<int> updateSetPointsFirstTo(int points) {
    setPointsFirstTo = points;
    return DbHelpers.updateSetPointsFirstTo(points, id);
  }

  Future<int> updateSetStart(DateTime time) {
    state = 2;
    setStart = time;
    return DbHelpers.updateSetStart(setStart.millisecondsSinceEpoch, state, id);
  }

  Future<int> updateSetEnd(DateTime time) {
    state = 1;
    setEnd = time;
    return DbHelpers.updateSetEnd(setEnd.millisecondsSinceEpoch, state, id);
  }

  Future<int> updateStartingWithTheServe(int team) {
    startingWithTheServe = team;
    return DbHelpers.updateStartingWithTheServe(team, id);
  }

  Future<int> updateWinnerOfDraw(int team) {
    winnerOfDraw = team;
    return DbHelpers.updateWinnerOfDraw(team, id);
  }

  Future<int> updateOrderOfServe(int team, TeamServe serve) {
    if (team == 1) {
      orderOfServePlayer1Team1 = serve.first;
      orderOfServePlayer2Team1 = serve.second;
    } else if (team == 2) {
      orderOfServePlayer1Team2 = serve.first;
      orderOfServePlayer2Team2 = serve.second;
    }

    return DbHelpers.updateOrderOfServe(team, serve.first, serve.second, id);
  }

  Future<int> updateElapsedTime(int elapsedTime) {
    this.elapsedTime = Duration(seconds: elapsedTime);
    return DbHelpers.updateElapsedTime(elapsedTime, id);
  }

  Future<int> updateSets(int team1Set, int team2Set, int duration) {
    setTeam1 = team1Set;
    setTeam2 = team2Set;
    this.elapsedTime = Duration(seconds: duration);
    return DbHelpers.updateSets(team1Set, team2Set, duration, id);
  }

  Future<int> updatePoints(int team1Points, int team2Points, int duration) {
    pointsTeam1 = team1Points;
    pointsTeam2 = team2Points;
    this.elapsedTime = Duration(seconds: duration);
    return DbHelpers.updatePoints(team1Points, team2Points, duration, id);
  }

  Future<int> updateTimeouts(
      int team1Timeouts, int team2Timeouts, int duration) {
    timeoutsTeam1 = team1Timeouts;
    timeoutsTeam2 = team2Timeouts;
    this.elapsedTime = Duration(seconds: duration);
    return DbHelpers.updateTimeouts(team1Timeouts, team2Timeouts, duration, id);
  }

  Future<int> updateActiveTeam(int teamThatActive) {
    activeTeam = teamThatActive;
    return DbHelpers.updateActiveTeam(teamThatActive, id);
  }

  Future<int> initScores() async {
    int returnValue = 0;
    if (id == null && matchId != null) {
      id = SystemHelpers.generateUuid();
      setStart = DateTime.now();
      setEnd = DateTime.now();
      returnValue = await DbHelpers.insert(DbSql.tableScores, this.toMap());
    }

    return returnValue;
  }

  Future<int> resetScore() {
    setStart = DateTime.now();
    setEnd = DateTime.now();
    orderOfServePlayer1Team1 = 0;
    orderOfServePlayer2Team1 = 0;
    orderOfServePlayer2Team1 = 0;
    orderOfServePlayer2Team2 = 0;
    pointsTeam1 = 0;
    pointsTeam2 = 0;
    timeoutsTeam1 = 0;
    timeoutsTeam2 = 0;
    activeTeam = 0;
    setPointsFirstTo = 21;
    state = 1;

    return DbHelpers.update(DbSql.tableScores, this.toMap(), "id = ?", [id]);
  }

  Future<int> delete() {
    return DbHelpers.delete(DbSql.tableScores, id);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "matchId": matchId,
      "elapsedTime": elapsedTime.inSeconds,
      "setStart": setStart.millisecondsSinceEpoch,
      "setEnd": setEnd.millisecondsSinceEpoch,
      "winnerOfDraw": winnerOfDraw,
      "orderOfServePlayer1Team1": orderOfServePlayer1Team1,
      "orderOfServePlayer2Team1": orderOfServePlayer2Team1,
      "orderOfServePlayer1Team2": orderOfServePlayer1Team2,
      "orderOfServePlayer2Team2": orderOfServePlayer2Team2,
      "startingWithTheServe": startingWithTheServe,
      "setPointsFirstTo": setPointsFirstTo,
      "pointsTeam1": pointsTeam1,
      "pointsTeam2": pointsTeam2,
      "setTeam1": setTeam1,
      "setTeam2": setTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2,
      "activeTeam": activeTeam,
      "state": state
    };
  }

  factory ScoreData.fromMap(Map<String, dynamic> item) {
    return ScoreData(
        id: item["id"],
        matchId: item["matchId"],
        elapsedTime: Duration(seconds: item["elapsedTime"]),
        setStart: DateTime.fromMillisecondsSinceEpoch(item["setStart"]),
        setEnd: DateTime.fromMillisecondsSinceEpoch(item["setEnd"]),
        winnerOfDraw: item["winnerOfDraw"],
        orderOfServePlayer1Team1: item["orderOfServePlayer1Team1"],
        orderOfServePlayer2Team1: item["orderOfServePlayer2Team1"],
        orderOfServePlayer1Team2: item["orderOfServePlayer1Team2"],
        orderOfServePlayer2Team2: item["orderOfServePlayer2Team2"],
        setTeam1: item["setTeam1"],
        setTeam2: item["setTeam2"],
        setPointsFirstTo: item["setPointsFirstTo"],
        pointsTeam1: item["pointsTeam1"],
        pointsTeam2: item["pointsTeam2"],
        timeoutsTeam1: item["timeoutsTeam1"],
        timeoutsTeam2: item["timeoutsTeam2"],
        startingWithTheServe: item["startingWithTheServe"],
        activeTeam: item["activeTeam"],
        state: item["state"]);
  }
}
