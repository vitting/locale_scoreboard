import 'dart:async';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/match_data.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/score_data.dart';
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
  final MatchData match;

  const ScoreboardBoard({Key key, this.match}) : super(key: key);
  @override
  _ScoreboardBoardState createState() => _ScoreboardBoardState();
}

class _ScoreboardBoardState extends State<ScoreboardBoard>
    with TickerProviderStateMixin {
  StreamController<TimerValues> _timeController =
      StreamController<TimerValues>.broadcast();
  Color _teamAColor = Colors.white;
  Color _teamBColor = Colors.white;
  Color _teamAColorControls = Colors.white;
  Color _teamBColorControls = Colors.white;
  Color _teamActiveColor = Colors.deepOrange[900];
  Color _teamAColorDefault = Colors.blue[900];
  Color _teamBColorDefault = Colors.blue[500];
  Color _teamAColorActive = Colors.blue[900];
  Color _teamBColorActive = Colors.blue[500];
  bool _teamAActive = false;
  bool _teamBActive = false;
  bool _teamAWinnerOfServe = false;
  bool _teamBWinnerOfServe = false;
  int _teamASets = 0;
  int _teamBSets = 0;
  String _teamAPlayer1 = "Christian Vitting Nicolaisen";
  String _teamAPlayer2 = "Irene Hansen";
  String _teamBPlayer1 = "Martin Jensen";
  String _teamBPlayer2 = "Allan Pedersen";
  int _teamAPoints = 0;
  int _teamBPoints = 0;
  int _teamATimeouts = 0;
  int _teamBTimeouts = 0;
  int _controlStep = 0;
  bool _showBox1 = false;
  int _elapsedTime = 0;
  ScoreData _scoreData;
  CrossFadeState _mainDisplay = CrossFadeState.showFirst;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _scoreData = await widget.match.getScore();

    if (mounted) {
      setState(() {
        _teamAPlayer1 = widget.match.namePlayer1Team1;
        _teamAPlayer2 = widget.match.namePlayer2Team1;
        _teamBPlayer1 = widget.match.namePlayer1Team2;
        _teamBPlayer2 = widget.match.namePlayer2Team2;
        _teamAPoints = _scoreData.pointsTeam1;
        _teamBPoints = _scoreData.pointsTeam2;
        _teamASets = _scoreData.setTeam1;
        _teamBSets = _scoreData.setTeam2;
        _teamATimeouts = _scoreData.timeoutsTeam1;
        _teamBTimeouts = _scoreData.timeoutsTeam2;
        _elapsedTime = _scoreData.matchDuration.inSeconds;
      });

      if (widget.match.active) {
        _setWinnerOfDraw(_scoreData.startTeam);
        _setActiveTeam(_scoreData.activeTeam);
        _showControls();
      }
    }
  }

  @override
  void dispose() {
    _scoreData.updateMatchElapsed(_elapsedTime);
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
                            color: _teamAColor,
                            text: "Team A",
                            active: _teamAActive,
                            winnerOfServe: _teamAWinnerOfServe,
                            team: 1,
                          ),
                          InkWell(
                            onLongPress: () {
                              _timeController.add(
                                  TimerValues(TimerState.cancel, _elapsedTime));
                            },
                            onDoubleTap: () {
                              _timeController.add(
                                  TimerValues(TimerState.reset, _elapsedTime));
                            },
                            onTap: () {
                              _timeController.add(
                                  TimerValues(TimerState.start, _elapsedTime));
                            },
                            child: SetTime(
                              timeStream: _timeController.stream,
                              onTimeChange: (int time) {
                                _elapsedTime = time;
                              },
                            ),
                          ),
                          TeamTitle(
                            color: _teamBColor,
                            text: "Team B",
                            active: _teamBActive,
                            winnerOfServe: _teamBWinnerOfServe,
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
                            player1Name: _teamAPlayer1,
                            player2Name: _teamAPlayer2,
                            teamColor: _teamAColor,
                            teamActiveColor: _teamAColorActive,
                            playerActiveColor: _teamAColorDefault,
                            playerActive: 0,
                          ),
                          TeamPlayerNames(
                            player1Name: _teamBPlayer1,
                            player2Name: _teamBPlayer2,
                            teamColor: _teamBColor,
                            teamActiveColor: _teamBColorActive,
                            playerActiveColor: _teamBColorDefault,
                            playerActive: 0,
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      _results(),
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
                  firstChild: _controlStep == 0 ? _setupSet() : Container(),
                  secondChild: _controlStep == 1 ? _controls() : Container(),
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

  Widget _setupSet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          SetWinnerOfDraw(
            onTapTeam: (int team) {
              _setWinnerOfDraw(team);
            },
            teamAButtonColor: _teamAColorDefault,
            teamBButtonColor: _teamBColorDefault,
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
              _setStartWithServe(team);
            },
            teamAButtonColor: _teamAColorDefault,
            teamBButtonColor: _teamBColorDefault,
          ),
          StartMatch(
            onTap: (_) {
              _showControls();
              widget.match.updateMatchStarted();
            },
          )
        ],
      ),
    );
  }

  Widget _controls() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              TeamControl(
                team: Team.a,
                title: "points",
                teamActiveColor: _teamAColorActive,
                teamControlsColor: _teamAColorControls,
                onTapAdd: _addPoints,
                onTapRemove: _removePoints,
              ),
              TeamControl(
                team: Team.b,
                title: "points",
                teamActiveColor: _teamBColorActive,
                teamControlsColor: _teamBColorControls,
                onTapAdd: _addPoints,
                onTapRemove: _removePoints,
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
                teamActiveColor: _teamAColorActive,
                teamControlsColor: _teamAColorControls,
                onTapAdd: _addTimeouts,
                onTapRemove: _removeTimeouts,
              ),
              TeamControl(
                team: Team.b,
                title: "timeouts",
                teamActiveColor: _teamBColorActive,
                teamControlsColor: _teamBColorControls,
                onTapAdd: _addTimeouts,
                onTapRemove: _removeTimeouts,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _results() {
    return Container(
      child: Column(
        children: <Widget>[
          TeamSets(
              teamAColor: _teamAColor,
              teamBColor: _teamBColor,
              teamAColorActive: _teamAColorActive,
              teamBColorActive: _teamBColorActive,
              teamASets: _teamASets,
              teamBSets: _teamBSets),
          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Row(
            children: <Widget>[
              TeamPoints(
                  activeColor: _teamAColorActive,
                  color: _teamAColor,
                  points: _teamAPoints),
              TeamPoints(
                  activeColor: _teamBColorActive,
                  color: _teamBColor,
                  points: _teamBPoints)
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          TeamTimeouts(
              teamAColor: _teamAColor,
              teamBColor: _teamBColor,
              teamAColorActive: _teamAColorActive,
              teamBColorActive: _teamBColorActive,
              teamATimeouts: _teamATimeouts,
              teamBTimeouts: _teamBTimeouts),
          SetScoreContainer()
        ],
      ),
    );
  }

  void _addPoints(Team team) {
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }

    if (team == Team.a) {
      setState(() {
        _teamAPoints++;
        _setActiveTeam(1);
        _scoreData.updatePoints(_teamAPoints, _teamBPoints, _elapsedTime);
      });
    } else {
      setState(() {
        _teamBPoints++;
        _setActiveTeam(2);
        _scoreData.updatePoints(_teamAPoints, _teamBPoints, _elapsedTime);
      });
    }

    _checkPointsStatus(_teamAPoints, _teamBPoints);
  }

  void _removePoints(Team team) {
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
    if (team == Team.a) {
      if (_teamAPoints > 0) {
        setState(() {
          _teamAPoints--;
          _scoreData.updatePoints(_teamAPoints, _teamBPoints, _elapsedTime);
        });
      }
    } else {
      if (_teamBPoints > 0) {
        setState(() {
          _teamBPoints--;
          _scoreData.updatePoints(_teamAPoints, _teamBPoints, _elapsedTime);
        });
      }
    }

    _checkPointsStatus(_teamAPoints, _teamBPoints);
  }

  void _addTimeouts(Team team) {
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
    if (team == Team.a) {
      setState(() {
        _teamATimeouts++;
        _scoreData.updateTimeouts(_teamATimeouts, _teamBTimeouts, _elapsedTime);
      });
    } else {
      setState(() {
        _teamBTimeouts++;
        _scoreData.updateTimeouts(_teamATimeouts, _teamBTimeouts, _elapsedTime);
      });
    }
  }

  void _removeTimeouts(Team team) {
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
    if (team == Team.a) {
      if (_teamATimeouts > 0) {
        setState(() {
          _teamATimeouts--;
          _scoreData.updateTimeouts(
              _teamATimeouts, _teamBTimeouts, _elapsedTime);
        });
      }
    } else {
      if (_teamBTimeouts > 0) {
        setState(() {
          _teamBTimeouts--;
          _scoreData.updateTimeouts(
              _teamATimeouts, _teamBTimeouts, _elapsedTime);
        });
      }
    }
  }

  void _checkPointsStatus(int pointsA, int pointsB) {
    Team teamWon = _checkIfSetIsWon(pointsA, pointsB);

    if (teamWon != null) {
      if (MainInherited.of(context).canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      String team = teamWon == Team.a ? "A" : "B";
      _showSetWon(context, team);
    }

    if (teamWon == null && _checkIfSideChange(pointsA, pointsB)) {
      if (MainInherited.of(context).canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      _showSideChange(context);
    }

    if (teamWon == null && _checkIfTechnicalTimeout(pointsA, pointsB)) {
      if (MainInherited.of(context).canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      _showTechnicalTimeout(context);
    }
  }

  bool _checkIfSideChange(int pointsA, int pointsB) {
    int totalPoints = pointsA + pointsB;
    bool changeSides = false;
    if (totalPoints > 0 && totalPoints % 7 == 0) {
      changeSides = true;
    }
    return changeSides;
  }

  bool _checkIfTechnicalTimeout(int pointsA, int pointsB) {
    return pointsA + pointsB == 21;
  }

  Team _checkIfSetIsWon(int pointsA, int pointsB) {
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

  void _showTechnicalTimeout(BuildContext context) async {
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

  void _showSetWon(BuildContext context, String team) async {
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

  void _showSideChange(BuildContext context) async {
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

  void _setActiveTeam(int team) {
    _scoreData.updateActiveTeam(team);

    if (team == 1) {
      _teamAColorActive = _teamActiveColor;
      _teamBColorActive = _teamBColorDefault;
    } else {
      _teamAColorActive = _teamAColorDefault;
      _teamBColorActive = _teamActiveColor;
    }
  }

  void _setWinnerOfDraw(int team) {
    _scoreData.updateStartTeam(team);

    if (team == 1) {
      setState(() {
        _teamAWinnerOfServe = true;
        _teamBWinnerOfServe = false;
      });
    } else if (team == 2) {
      setState(() {
        _teamBWinnerOfServe = true;
        _teamAWinnerOfServe = false;
      });
    }
  }

  void _setStartWithServe(int team) {
    _scoreData.updateActiveTeam(team);

    if (team == 1) {
      setState(() {
        _teamAActive = true;
        _teamBActive = false;
        _setActiveTeam(1);
      });
    } else if (team == 2) {
      setState(() {
        _teamAActive = false;
        _teamBActive = true;
        _setActiveTeam(2);
      });
    }
  }

  void _showControls() {
    setState(() {
      _mainDisplay = CrossFadeState.showSecond;
      _controlStep = 1;
      _timeController.add(TimerValues(TimerState.start, _elapsedTime));
    });
  }
}
