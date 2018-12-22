import 'dart:async';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:vibrate/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/help_set_player_order_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/set_order_of_serve_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/set_start_with_serve_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/set_winner_of_draw_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/start_match_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/team_control_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/set_score_container_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/set_time_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_player_names_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_points_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_sets_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_timeouts_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_title_widget.dart';

class ScoreboardBoard extends StatefulWidget {
  @override
  _ScoreboardBoardState createState() => _ScoreboardBoardState();
}

class _ScoreboardBoardState extends State<ScoreboardBoard>
    with TickerProviderStateMixin {
  StreamController<TimerState> _timeController =
      StreamController<TimerState>.broadcast();
  Color teamAColor = Colors.white;
  Color teamBColor = Colors.white;
  Color teamAColorControls = Colors.white;
  Color teamBColorControls = Colors.white;
  Color teamActiveColor = Colors.deepOrange[900];
  Color teamAColorDefault = Colors.blue[900];
  Color teamBColorDefault = Colors.blue[500];
  Color teamAColorActive = Colors.blue[900];
  Color teamBColorActive = Colors.blue[500];
  bool teamAActive = false;
  bool teamBActive = false;
  bool teamAWinnerOfServe = false;
  bool teamBWinnerOfServe = false;
  int teamASets = 0;
  int teamBSets = 0;
  String teamAPlayer1 = "Christian Vitting Nicolaisen";
  String teamAPlayer2 = "Irene Hansen";
  String teamBPlayer1 = "Martin Jensen";
  String teamBPlayer2 = "Allan Pedersen";
  int teamAPoints = 0;
  int teamBPoints = 0;
  int teamATimeouts = 0;
  int teamBTimeouts = 0;
  int _controlStep = 0;
  bool _showBox1 = false;
  int _elapsedTime = 0;
  CrossFadeState _mainDisplay = CrossFadeState.showFirst;

  @override
  void dispose() {
    _timeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
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
                  padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          TeamTitle(
                            color: teamAColor,
                            text: "Team A",
                            active: teamAActive,
                            winnerOfServe: teamAWinnerOfServe,
                            team: 1,
                          ),
                          InkWell(
                            onLongPress: () {
                              _timeController.add(TimerState.cancel);
                            },
                            onDoubleTap: () {
                              _timeController.add(TimerState.reset);
                            },
                            onTap: () {
                              _timeController.add(TimerState.start);
                            },
                            child: SetTime(
                              timeStream: _timeController.stream,
                              onTimeChange: (int time) {
                                _elapsedTime = time;
                              },
                            ),
                          ),
                          TeamTitle(
                            color: teamBColor,
                            text: "Team B",
                            active: teamBActive,
                            winnerOfServe: teamBWinnerOfServe,
                            team: 2,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      Row(
                        children: <Widget>[
                          TeamPlayerNames(
                            player1Name: teamAPlayer1,
                            player2Name: teamAPlayer2,
                            teamColor: teamAColor,
                            teamActiveColor: teamAColorActive,
                            playerActiveColor: teamAColorDefault,
                            playerActive: 0,
                          ),
                          TeamPlayerNames(
                            player1Name: teamBPlayer1,
                            player2Name: teamBPlayer2,
                            teamColor: teamBColor,
                            teamActiveColor: teamBColorActive,
                            playerActiveColor: teamBColorDefault,
                            playerActive: 0,
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      results(),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                AnimatedCrossFade(
                  sizeCurve: Curves.easeIn,
                  duration: Duration(milliseconds: 500),
                  crossFadeState: _mainDisplay,
                  firstChild: _controlStep == 0 ? setupSet() : Container(),
                  secondChild: _controlStep == 1 ? controls() : Container(),
                ),
              ],
            ),
          ),
          HelpSetPlayerOrder(
            show: _showBox1,
            onTap: (_) {
              setState(() {
                _showBox1 = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget setupSet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          SetWinnerOfDraw(
            onTapTeam: (int team) {
              if (team == 1) {
                setState(() {
                  teamAWinnerOfServe = true;
                  teamBWinnerOfServe = false;
                });
              } else if (team == 2) {
                setState(() {
                  teamBWinnerOfServe = true;
                  teamAWinnerOfServe = false;
                });
              }
            },
            teamAButtonColor: teamAColorDefault,
            teamBButtonColor: teamBColorDefault,
          ),
          SetOrderOfServe(
            onTap: (_) {
              setState(() {
                _showBox1 = true;
              });
            },
          ),
          SetStartWithServe(
            onTapTeam: (int team) {
              if (team == 1) {
                setState(() {
                  teamAActive = true;
                  teamBActive = false;
                  setActiveTeam(1);
                });
              } else if (team == 2) {
                setState(() {
                  teamAActive = false;
                  teamBActive = true;
                  setActiveTeam(2);
                });
              }
            },
            teamAButtonColor: teamAColorDefault,
            teamBButtonColor: teamBColorDefault,
          ),
          StartMatch(
            onTap: (_) {
              setState(() {
                _mainDisplay = CrossFadeState.showSecond;
                _controlStep = 1;
                _timeController.add(TimerState.start);
              });
            },
          )
        ],
      ),
    );
  }

  Widget controls() {
    return Container(
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
    );
  }

  Widget results() {
    return Container(
      child: Column(
        children: <Widget>[
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
          SetScoreContainer()
        ],
      ),
    );
  }

  void addPoints(Team team) {
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }

    if (team == Team.a) {
      setState(() {
        teamAPoints++;
        setActiveTeam(1);
      });
    } else {
      setState(() {
        teamBPoints++;
        setActiveTeam(2);
      });
    }

    checkPointsStatus(teamAPoints, teamBPoints);
  }

  void removePoints(Team team) {
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
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
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
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
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
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

  void checkPointsStatus(int pointsA, int pointsB) {
    Team teamWon = checkIfSetIsWon(pointsA, pointsB);

    if (teamWon != null) {
      if (MainInherited.of(context).canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      String team = teamWon == Team.a ? "A" : "B";
      showSetWon(context, team);
    }

    if (teamWon == null && checkIfSideChange(pointsA, pointsB)) {
      if (MainInherited.of(context).canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      showSideChange(context);
    }

    if (teamWon == null && checkIfTechnicalTimeout(pointsA, pointsB)) {
      if (MainInherited.of(context).canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      showTechnicalTimeout(context);
    }
  }

  bool checkIfSideChange(int pointsA, int pointsB) {
    int totalPoints = pointsA + pointsB;
    bool changeSides = false;
    if (totalPoints > 0 && totalPoints % 7 == 0) {
      changeSides = true;
    }
    return changeSides;
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

  void showTechnicalTimeout(BuildContext context) async {
    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Technical Timeout"),
            content: Text("Teams has Technical Timeout"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
              )
            ],
          );
        });
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
        });
  }

  void showSideChange(BuildContext context) async {
    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
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
        });
  }

  void setActiveTeam(int team) {
    if (team == 1) {
      teamAColorActive = teamActiveColor;
      teamBColorActive = teamBColorDefault;
    } else {
      teamAColorActive = teamAColorDefault;
      teamBColorActive = teamActiveColor;
    }
  }
}
