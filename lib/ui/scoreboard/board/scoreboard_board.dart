import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/team_control_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/team_player_names_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/team_points_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/team_sets_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/team_timeouts_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/team_title_widget.dart';

class ScoreboardBoard extends StatefulWidget {
  @override
  _ScoreboardBoardState createState() => _ScoreboardBoardState();
}

class _ScoreboardBoardState extends State<ScoreboardBoard> {
  Color teamAColor = Colors.white;
  Color teamBColor = Colors.white;
  Color teamAColorControls = Colors.white;
  Color teamBColorControls = Colors.white;
  Color teamAColorActive = Colors.blue[900];
  Color teamBColorActive = Colors.blue[500];
  bool teamAActive = true;
  bool teamBActive = false;
  int teamASets = 1;
  int teamBSets = 0;
  String teamAPlayer1 = "Christian Vitting Nicolaisen";
  String teamAPlayer2 = "Irene Hansen";
  String teamBPlayer1 = "Martin Jensen";
  String teamBPlayer2 = "Allan Pedersen";
  int teamAPoints = 0;
  int teamBPoints = 0;
  int teamATimeouts = 1;
  int teamBTimeouts = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.black,
            Colors.blue[900],
            Colors.blue[900],
            Colors.black
          ],
        )),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      TeamTitle(color: teamAColor, text: "Team A"),
                      TeamTitle(color: teamBColor, text: "Team B")
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  Row(
                    children: <Widget>[
                      TeamPlayerNames(
                        player1Name: teamAPlayer1,
                        player2Name: teamAPlayer2,
                        teamColor: teamAColor,
                        teamActiveColor: teamAColorActive,
                        playerActive: 2,
                      ),
                      TeamPlayerNames(
                        player1Name: teamBPlayer1,
                        player2Name: teamBPlayer2,
                        teamColor: teamBColor,
                        teamActiveColor: teamBColorActive,
                        playerActive: 0,
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  TeamSets(
                      teamAColor: teamAColor,
                      teamBColor: teamBColor,
                      teamAColorActive: teamAColorActive,
                      teamBColorActive: teamBColorActive,
                      teamASets: teamASets,
                      teamBSets: teamBSets),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Row(
                    children: <Widget>[
                      TeamPoints(
                          activeColor: teamAColorActive,
                          color: teamAColor,
                          points: teamAPoints),
                      TeamPoints(
                          activeColor: teamBColorActive,
                          color: teamBColor,
                          points: teamBPoints)
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  TeamTimeouts(
                      teamAColor: teamAColor,
                      teamBColor: teamBColor,
                      teamAColorActive: teamAColorActive,
                      teamBColorActive: teamBColorActive,
                      teamATimeouts: teamATimeouts,
                      teamBTimeouts: teamBTimeouts),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      TeamControl(
                        team: Team.a,
                        title: "points",
                        teamActiveColor: teamAColorActive,
                        teamControlsColor: teamAColorControls,
                        onTapAdd: addPoints,
                        onTapRemove: removePoints,
                      ),
                      TeamControl(
                        team: Team.b,
                        title: "points",
                        teamActiveColor: teamBColorActive,
                        teamControlsColor: teamBColorControls,
                        onTapAdd: addPoints,
                        onTapRemove: removePoints,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  Row(
                    children: <Widget>[
                      TeamControl(
                        team: Team.a,
                        title: "timeouts",
                        teamActiveColor: teamAColorActive,
                        teamControlsColor: teamAColorControls,
                        onTapAdd: addTimeouts,
                        onTapRemove: removeTimeouts,
                      ),
                      TeamControl(
                        team: Team.b,
                        title: "timeouts",
                        teamActiveColor: teamBColorActive,
                        teamControlsColor: teamBColorControls,
                        onTapAdd: addTimeouts,
                        onTapRemove: removeTimeouts,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addPoints(Team team) {
    if (team == Team.a) {
      setState(() {
        teamAPoints++;
      });
    } else {
      setState(() {
        teamBPoints++;
      });
    }

    checkPointsStatus(teamAPoints, teamBPoints);
  }

  void removePoints(Team team) {
    if (team == Team.a) {
      if (teamAPoints > 0) {
        setState(() {
          teamAPoints--;
        });
      }
    } else {
      if (teamBPoints > 0) {
        setState(() {
          teamBPoints--;
        });
      }
    }

    checkPointsStatus(teamAPoints, teamBPoints);
  }

  void addTimeouts(Team team) {
    if (team == Team.a) {
      setState(() {
        teamATimeouts++;
      });
    } else {
      setState(() {
        teamBTimeouts++;
      });
    }
  }

  void removeTimeouts(Team team) {
    if (team == Team.a) {
      if (teamATimeouts > 0) {
        setState(() {
          teamATimeouts--;
        });
      }
    } else {
      if (teamBTimeouts > 0) {
        setState(() {
          teamBTimeouts--;
        });
      }
    }
  }

  checkPointsStatus(int pointsA, int pointsB) {
    if (checkIfSideChange(pointsA, pointsB)) {
      showSideChange(context);
    }

    if (checkIfTechnicalTimeout(pointsA, pointsB)) {
      print("***********Technical Timeout************");
    }

    Team teamWon = checkIfSetIsWon(pointsA, pointsB);

    if (teamWon != null) {
      String team = teamWon == Team.a ? "A": "B";
      showSetWon(context, team);
    }
  }

  bool checkIfSideChange(int pointsA, int pointsB) {
    return (pointsA + pointsB) % 7 == 0;
  }

  bool checkIfTechnicalTimeout(int pointsA, int pointsB) {
    return pointsA + pointsB == 21;
  }

  Team checkIfSetIsWon(int pointsA, int pointsB) {
    Team value;
    if (pointsA >= 21 || pointsB >= 21) {
      /// Team A won
      if (pointsA - pointsB >= 2) {
        value = Team.a;
      }

      /// Team B won
      if (pointsB - pointsA >= 2) {
        value = Team.b;
      }
    }

    return value;
  }

  void showSetWon(BuildContext context, String team) async {
    bool result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Set won"),
          content: Text("Team $team won the set?"),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            )
          ],
        );
      }
    );
  }

  void showSideChange(BuildContext context) async {
    bool result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Side Change"),
          content: Text("Teams have to change sides"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            )
          ],
        );
      }
    );
  }
}
