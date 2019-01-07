import 'dart:async';
import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/dialog_yes_no_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/controls_container_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/results_container_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/setup_set_container_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/dialog_round_button_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/match_data.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/score_data.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/set_data.dart';
import 'package:vibrate/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/help_set_player_order_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/team_control_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/set_time_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_player_names_widget.dart';
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
  StreamController<TeamServe> _serveOrderTeam1Controller =
      StreamController<TeamServe>.broadcast();
  StreamController<TeamServe> _serveOrderTeam2Controller =
      StreamController<TeamServe>.broadcast();
  StreamController<int> _numberOfPointsInSetController =
      StreamController<int>.broadcast();
  StreamController<int> _winnerOfDrawSelectedButtonController =
      StreamController<int>.broadcast();
  StreamController<int> _startWithServeSelectedButtonController =
      StreamController<int>.broadcast();
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
  int _setNumber = 0;
  String _teamAPlayer1 = "Christian Vitting Nicolaisen";
  String _teamAPlayer2 = "Irene Hansen";
  String _teamBPlayer1 = "Martin Jensen";
  String _teamBPlayer2 = "Allan Pedersen";
  int _teamAPoints = 0;
  int _teamBPoints = 0;
  int _teamATimeouts = 0;
  int _teamBTimeouts = 0;
  int _pointsInSet = 21;
  int _winnerOfDraw = 0;
  int _setStartWithServe = 0;
  int _controlStep = 0;
  bool _showBox1 = false;
  int _elapsedTime = 0;
  ScoreData _scoreData;
  List<SetData> _sets = [];
  CrossFadeState _mainControlsDisplay = CrossFadeState.showFirst;
  CrossFadeState _mainDisplay = CrossFadeState.showFirst;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _scoreData = await widget.match.getScore();
    _sets = await widget.match.getSets();

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
        _setNumber = _scoreData.setTeam1 + _scoreData.setTeam2;
        _teamATimeouts = _scoreData.timeoutsTeam1;
        _teamBTimeouts = _scoreData.timeoutsTeam2;
        _elapsedTime = _scoreData.elapsedTime.inSeconds;
        _pointsInSet = _scoreData.setPointsFirstTo;
        _winnerOfDraw = _scoreData.winnerOfDraw;
        _setStartWithServe = _scoreData.startingWithTheServe;
      });

      _numberOfPointsInSetController.add(_scoreData.setPointsFirstTo);

      if (_scoreData.orderOfServePlayer1Team1 != 0 &&
          _scoreData.orderOfServePlayer2Team1 != 0) {
        _serveOrderTeam1Controller.add(TeamServe(
            _scoreData.orderOfServePlayer1Team1,
            _scoreData.orderOfServePlayer2Team1));
      }
      if (_scoreData.orderOfServePlayer1Team2 != 0 &&
          _scoreData.orderOfServePlayer2Team2 != 0) {
        _serveOrderTeam2Controller.add(TeamServe(
            _scoreData.orderOfServePlayer1Team2,
            _scoreData.orderOfServePlayer2Team2));
      }

      if (_scoreData.winnerOfDraw != 0) {
        _winnerOfDrawSelectedButtonController.add(_scoreData.winnerOfDraw);
        _setWinnerOfDraw(_scoreData.winnerOfDraw);
      }

      if (_scoreData.startingWithTheServe != 0) {
        _startWithServeSelectedButtonController
            .add(_scoreData.startingWithTheServe);
        _startWithServe(_scoreData.startingWithTheServe);
      }

      if (widget.match.active) {
        _showControls(true);
      }
    }
  }

  @override
  void dispose() {
    _scoreData.updateElapsedTime(_elapsedTime);
    _timeController.close();
    _numberOfPointsInSetController.close();
    _serveOrderTeam1Controller.close();
    _serveOrderTeam2Controller.close();
    _startWithServeSelectedButtonController.close();
    _winnerOfDrawSelectedButtonController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _main());
  }

  Widget _main() {
    return Stack(
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
              RaisedButton(
                child: Text("TEST"),
                onPressed: () async {
                  List<Map<String, dynamic>> list = await DbHelpers.query(
                      DbSql.tableScores,
                      where: "matchId = ?",
                      whereArgs: [widget.match.id]);
                  debugPrint(list.toString());

                  List<Map<String, dynamic>> list2 = await DbHelpers.query(
                      DbSql.tableMatches,
                      where: "id = ?",
                      whereArgs: [widget.match.id]);
                  debugPrint(list2.toString());

                  // List<Map<String, dynamic>> list3 = await DbHelpers.query(
                  //     DbSql.tableSets,
                  //     where: "matchId = ?",
                  //     whereArgs: [widget.match.id]);
                  // debugPrint(list3.toString());


                  // _showControls(false);
                  // setState(() {
                  //   if (_mainDisplay == CrossFadeState.showFirst) {
                  //     _mainDisplay = CrossFadeState.showSecond;
                  //   } else {
                  //     _mainDisplay = CrossFadeState.showFirst;
                  //   }
                  // });
                  // List<SetData> sets = await widget.match.getSets();
                  // print(sets);
                },
              ),
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
                        SetTime(
                          timeStream: _timeController.stream,
                          onTimeChange: (int time) {
                            _elapsedTime = time;
                          },
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
                          teamOrderOfServeStream:
                              _serveOrderTeam1Controller.stream,
                          player1Name: _teamAPlayer1,
                          player2Name: _teamAPlayer2,
                          teamColor: _teamAColor,
                          teamActiveColor: _teamAColorActive,
                          playerActiveColor: _teamAColorDefault,
                          playerActive: 0,
                          onSetServeOrder: (teamServe) {
                            if (teamServe != null) {
                              _saveServeOrder(1, teamServe);
                            }
                          },
                        ),
                        TeamPlayerNames(
                          teamOrderOfServeStream:
                              _serveOrderTeam2Controller.stream,
                          player1Name: _teamBPlayer1,
                          player2Name: _teamBPlayer2,
                          teamColor: _teamBColor,
                          teamActiveColor: _teamBColorActive,
                          playerActiveColor: _teamBColorDefault,
                          playerActive: 0,
                          onSetServeOrder: (teamServe) {
                            if (teamServe != null) {
                              _saveServeOrder(2, teamServe);
                            }
                          },
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                    AnimatedCrossFade(
                      crossFadeState: _mainDisplay,
                      duration: Duration(milliseconds: 400),
                      firstChild: Container(),
                      secondChild: _results(),
                    )
                  ],
                ),
              ),
              AnimatedCrossFade(
                sizeCurve: Curves.easeIn,
                duration: Duration(milliseconds: 400),
                crossFadeState: _mainControlsDisplay,
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
    );
  }

  Widget _setupSet() {
    return SetupSetContainer(
        teamAButtonColor: _teamAColorDefault,
        teamBButtonColor: _teamBColorDefault,
        pointsInSet: _pointsInSet,
        numberOfPointsInSetStream: _numberOfPointsInSetController.stream,
        onTapSetNumberOfPointsForSet: (int points) {
          _pointsInSet = points;
          _scoreData.updateSetPointsFirstTo(points);
        },
        winnerOfDraw: _winnerOfDraw,
        winnerOfDrawSelectedButtonStream:
            _winnerOfDrawSelectedButtonController.stream,
        onTapSetWinnerOfDraw: (int team) {
          _setWinnerOfDraw(team);
        },
        onTapSetOrderOfServe: (_) {
          setState(() {
            _showBox1 = true;
          });
        },
        setStartWithServe: _setStartWithServe,
        startWithServeSelectedButtonStream:
            _startWithServeSelectedButtonController.stream,
        onTapSetStartWithServe: (int team) {
          _startWithServe(team);
        },
        onTapStartMatch: (_) async {
          DateTime time = DateTime.now();
          _showControls(true);
          await widget.match.updateMatchStarted(time);
          await _scoreData.updateSetStart(time);
        });
  }

  Widget _controls() {
    return ControlsContainer(
        teamAColorActive: _teamAColorActive,
        teamBColorActive: _teamBColorActive,
        teamAColorControls: _teamAColorControls,
        teamBColorControls: _teamBColorControls,
        onTapAddPoints: _addPoints,
        onTapRemovePoints: _removePoints,
        onTapAddTimeouts: _addTimeouts,
        onTapRemoveTimeouts: _removeTimeouts);
  }

  Widget _results() {
    return ResultsContainer(
      sets: _sets,
      teamAColor: _teamAColor,
      teamBColor: _teamBColor,
      teamAColorActive: _teamAColorActive,
      teamBColorActive: _teamBColorActive,
      teamASets: _teamASets,
      teamBSets: _teamBSets,
      teamAPoints: _teamAPoints,
      teamBPoints: _teamBPoints,
      teamATimeouts: _teamATimeouts,
      teamBTimeouts: _teamBTimeouts,
      pointsOnLongPress: _pointsOnLongPress,
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
      if (_teamATimeouts + 1 <= 2) {
        setState(() {
          _teamATimeouts++;
          _scoreData.updateTimeouts(
              _teamATimeouts, _teamBTimeouts, _elapsedTime);
        });
      }
    } else {
      if (_teamBTimeouts + 1 <= 2) {
        setState(() {
          _teamBTimeouts++;
          _scoreData.updateTimeouts(
              _teamATimeouts, _teamBTimeouts, _elapsedTime);
        });
      }
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
      int team = teamWon == Team.a ? 1 : 2;
      _showSetWon(context, team);
    }

    if (teamWon == null && _checkIfSideChange(pointsA, pointsB)) {
      if (MainInherited.of(context).canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
      _showSideChange(context);
    }

    if (_pointsInSet == 21) {
      if (teamWon == null && _checkIfTechnicalTimeout(pointsA, pointsB)) {
        if (MainInherited.of(context).canVibrate) {
          Vibrate.feedback(FeedbackType.success);
        }
        _showTechnicalTimeout(context);
      }
    }
  }

  bool _checkIfSideChange(int pointsA, int pointsB) {
    int totalPoints = pointsA + pointsB;
    bool changeSides = false;
    if (_pointsInSet == 21) {
      if (totalPoints > 0 && totalPoints % 7 == 0) {
        changeSides = true;
      }
    } else {
      if (totalPoints > 0 && totalPoints % 5 == 0) {
        changeSides = true;
      }
    }

    return changeSides;
  }

  bool _checkIfTechnicalTimeout(int pointsA, int pointsB) {
    return pointsA + pointsB == 21;
  }

  Team _checkIfSetIsWon(int pointsA, int pointsB) {
    Team value;
    if (pointsA >= _pointsInSet || pointsB >= _pointsInSet) {
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("Teams has Technical Timeout!"),
                  ),
                  InkWell(
                    onTap: () {
                      if (MainInherited.of(context).canVibrate) {
                        Vibrate.feedback(FeedbackType.medium);
                      }
                      Navigator.of(dialogContext).pop(true);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      child: Center(
                          child: Text("Ok",
                              style: TextStyle(color: Colors.white))),
                      decoration: BoxDecoration(
                          color: Colors.green[900],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1.0)),
                    ),
                  )
                ],
              ));
        });
  }

  Future<void> _showContinueMatch(BuildContext context, int team) async {
    bool result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: Text("Continue match?"),
              content: DialogYesNo(
                team: team,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Press"),
                        Text(" YES", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" to play more sets.")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Press"),
                        Text(" NO", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" to end the match."),
                      ],
                    )
                  ],
                ),
                onTap: (bool value) {
                  if (MainInherited.of(context).canVibrate) {
                    Vibrate.feedback(FeedbackType.medium);
                  }
                  Navigator.of(dialogContext).pop(value);
                },
              ));
        });

    if (result != null && result == true) {
      _showControls(false);
    } else if (result != null && result == false) {
      _timeController.add(TimerValues(TimerState.cancel, 0));
      await _scoreData.updateState(3);
      await widget.match.updateMatchEnded(DateTime.now());
      setState(() {
              _controlStep = 0;
            });
    }
  }

  void _showSetWon(BuildContext context, int team) async {
    bool result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Set won"),
            content: DialogYesNo(
              team: team,
              content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Team ${team == 1 ? "A" : "B"}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" "),
                        Expanded(child:Text("won the set?"))
                      ],
                    ),
              onTap: (bool value) {
                if (MainInherited.of(context).canVibrate) {
                  Vibrate.feedback(FeedbackType.medium);
                }
                Navigator.of(dialogContext).pop(value);
              },
            ),
          );
        });

    if (result != null && result == true) {
      await _setWon(team);
      await _showContinueMatch(context, team);
    }
  }

  Future<void> _setWon(int team) async {
    setState(() {
      if (team == 1) {
        _teamASets++;
      } else if (team == 2) {
        _teamBSets++;
      }
    });

    await _scoreData.updateSetEnd(DateTime.now());
    await _scoreData.updateSets(_teamASets, _teamBSets, _elapsedTime);

    SetData setData = SetData.fromScoreData(_scoreData, team);
    await setData.save();
    //TODO: Vi skal opdatere sets
    await _scoreData.resetScore();

    setState(() {
      _teamAPoints = _scoreData.pointsTeam1;
      _teamBPoints = _scoreData.pointsTeam2;
      _teamASets = _scoreData.setTeam1;
      _teamBSets = _scoreData.setTeam2;
      _setNumber = _scoreData.setTeam1 + _scoreData.setTeam2;
      _teamATimeouts = _scoreData.timeoutsTeam1;
      _teamBTimeouts = _scoreData.timeoutsTeam2;
      _pointsInSet = _scoreData.setPointsFirstTo;
      _winnerOfDraw = _scoreData.winnerOfDraw;
      _setStartWithServe = _scoreData.startingWithTheServe;
    });
  }

  void _showSideChange(BuildContext context) async {
    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: Text("Side Change"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("Teams have to change sides!"),
                  ),
                  DialogRoundButton(
                    title: "OK",
                    color: Colors.green[900],
                    onTap: () {
                      if (MainInherited.of(context).canVibrate) {
                        Vibrate.feedback(FeedbackType.medium);
                      }
                      Navigator.of(dialogContext).pop(true);
                    },
                  )
                ],
              ));
        });
  }

  void _setActiveTeam(int team) {
    _scoreData.updateActiveTeam(team);

    switch (team) {
      case 0:
        _teamAColorActive = _teamAColorDefault;
        _teamBColorActive = _teamBColorDefault;
        break;
      case 1:
        _teamAColorActive = _teamActiveColor;
        _teamBColorActive = _teamBColorDefault;
        break;
      case 2:
        _teamAColorActive = _teamAColorDefault;
        _teamBColorActive = _teamActiveColor;
        break;
    }
  }

  void _setWinnerOfDraw(int team) {
    _scoreData.updateWinnerOfDraw(team);

    setState(() {
      switch (team) {
        case 0:
          _teamAWinnerOfServe = false;
          _teamBWinnerOfServe = false;
          break;
        case 1:
          _teamAWinnerOfServe = true;
          _teamBWinnerOfServe = false;
          break;
        case 2:
          _teamBWinnerOfServe = true;
          _teamAWinnerOfServe = false;
          break;
      }
    });
  }

  void _startWithServe(int team) {
    _scoreData.updateStartingWithTheServe(team);

    setState(() {
      switch (team) {
        case 0:
          _teamAActive = false;
          _teamBActive = false;
          break;
        case 1:
          _teamAActive = true;
          _teamBActive = false;
          break;
        case 2:
          _teamAActive = false;
          _teamBActive = true;
          break;
      }

      _setActiveTeam(team);
    });
  }

  void _showControls(bool show) {
    setState(() {
      if (show) {
        _mainControlsDisplay = CrossFadeState.showSecond;
        _mainDisplay = CrossFadeState.showSecond;
        _controlStep = 1;
        _timeController.add(TimerValues(TimerState.start, _elapsedTime));
      } else {
        _mainControlsDisplay = CrossFadeState.showFirst;
        _mainDisplay = CrossFadeState.showFirst;
        _controlStep = 0;
      }
    });
  }

  void _pointsOnLongPress(int team) async {
    int result = await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext bottomModalContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("Set Team ${team == 1 ? "A" : "B"} as set winner"),
                onTap: () {
                  Navigator.of(bottomModalContext).pop(1);
                },
              ),
              ListTile(
                title:
                    Text("Set Team ${team == 1 ? "A" : "B"} as match winner"),
                onTap: () {
                  Navigator.of(bottomModalContext).pop(2);
                },
              )
            ],
          );
        });

    if (result != null) {
      switch (result) {
        case 1:
          _showSetWon(context, team);
          break;
        case 2:
          _showContinueMatch(context, team);
          break;
      }
    }
  }

  void _saveServeOrder(int team, TeamServe serve) {
    _scoreData.updateOrderOfServe(team, serve);
  }
}
