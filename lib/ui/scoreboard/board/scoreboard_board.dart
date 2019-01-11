import 'dart:async';
import 'package:locale_scoreboard/helpers/board_theme.dart';
import 'package:locale_scoreboard/helpers/controller_data.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/dialog_ok_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/dialog_team_won.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/dialog_yes_no_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/controls_container_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/results_container_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/set_score_container_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/setup_set_container_widget.dart';
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
  StreamController<ControllerData> _boardController =
      StreamController<ControllerData>.broadcast();
  Color _teamAColorActive = Colors.blue[900];
  Color _teamBColorActive = Colors.blue[500];
  bool _teamAActive = false;
  bool _teamBActive = false;
  bool _teamAWinnerOfServe = false;
  bool _teamBWinnerOfServe = false;
  int _teamASets = 0;
  int _teamBSets = 0;
  String _teamAPlayer1 = "";
  String _teamAPlayer2 = "";
  String _teamBPlayer1 = "";
  String _teamBPlayer2 = "";
  int _teamAPoints = 0;
  int _teamBPoints = 0;
  int _teamATimeouts = 0;
  int _teamBTimeouts = 0;
  int _pointsInSet = 21;
  int _winnerOfDraw = 0;
  int _setStartWithServe = 0;
  int _controlStep = 0;
  bool _showBox1 = false;
  bool _canLongPressNames = true;
  int _elapsedTime = 0;
  int _state = 0;
  int _winnerTeam = 0;
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
    SystemHelpers.setScreenOn();
    _scoreData = await widget.match.getScore();
    List<SetData> sets = await widget.match.getSets();

    if (mounted) {
      setState(() {
        _teamAPlayer1 = widget.match.namePlayer1Team1;
        _teamAPlayer2 = widget.match.namePlayer2Team1;
        _teamBPlayer1 = widget.match.namePlayer1Team2;
        _teamBPlayer2 = widget.match.namePlayer2Team2;
        _state = _scoreData.state;
        _winnerTeam = widget.match.winnerTeam;
        
        if (_scoreData.state != 3) {
          _teamAPoints = _scoreData.pointsTeam1;
          _teamBPoints = _scoreData.pointsTeam2;
          _teamASets = _scoreData.setTeam1;
          _teamBSets = _scoreData.setTeam2;
          _teamATimeouts = _scoreData.timeoutsTeam1;
          _teamBTimeouts = _scoreData.timeoutsTeam2;
          _elapsedTime = _scoreData.elapsedTime.inSeconds;
          _pointsInSet = _scoreData.setPointsFirstTo;
          _winnerOfDraw = _scoreData.winnerOfDraw;
          _setStartWithServe = _scoreData.startingWithTheServe;
        } else {
          _canLongPressNames = false;
          _controlStep = 2;
        }

        if (sets.length != 0) {
          _sets = sets;
        }
      });

      if (_scoreData.state >= 1 && _scoreData.state <= 2) {
        _boardController.add(ControllerData(
            ControllerType.time, TimerValues(TimerState.start, _elapsedTime)));
      }

      if (_scoreData.state != 3) {
        _boardController.add(ControllerData(
            ControllerType.numberOfPointsInSet, _scoreData.setPointsFirstTo));

        if (_scoreData.orderOfServePlayer1Team1 != 0 &&
            _scoreData.orderOfServePlayer2Team1 != 0) {
          _boardController.add(ControllerData(
              ControllerType.serveOrderTeam1,
              TeamServe(_scoreData.orderOfServePlayer1Team1,
                  _scoreData.orderOfServePlayer2Team1)));
        }
        if (_scoreData.orderOfServePlayer1Team2 != 0 &&
            _scoreData.orderOfServePlayer2Team2 != 0) {
          _boardController.add(ControllerData(
              ControllerType.serveOrderTeam2,
              TeamServe(_scoreData.orderOfServePlayer1Team2,
                  _scoreData.orderOfServePlayer2Team2)));
        }

        if (_scoreData.winnerOfDraw != 0) {
          _boardController.add(ControllerData(
              ControllerType.winnerOfDraw, _scoreData.winnerOfDraw));
          _setWinnerOfDraw(_scoreData.winnerOfDraw);
        }

        if (_scoreData.startingWithTheServe != 0) {
          _boardController.add(ControllerData(
              ControllerType.startWithServe, _scoreData.startingWithTheServe));
          _startWithServe(_scoreData.startingWithTheServe);
        }

        if (widget.match.active && _scoreData.state == 2) {
          _showControls(true);
        }
      }
    }
  }

  @override
  void dispose() {
    _scoreData.updateElapsedTime(_elapsedTime);
    _boardController.close();
    SystemHelpers.setScreenOff();
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
          decoration: BoardTheme.background,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        TeamTitle(
                          color: BoardTheme.teamATextColor,
                          text: "Team A",
                          active: _teamAActive,
                          winnerOfServe: _teamAWinnerOfServe,
                          team: 1,
                        ),
                        SetTime(
                          timeStream: _boardController.stream,
                          onTimeChange: (int time) {
                            _elapsedTime = time;
                          },
                        ),
                        TeamTitle(
                          color: BoardTheme.teamBTextColor,
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
                          showWinner: _winnerTeam == 1,
                          canLongPress: _canLongPressNames,
                          team: 1,
                          teamOrderOfServeStream: _boardController.stream,
                          player1Name: _teamAPlayer1,
                          player2Name: _teamAPlayer2,
                          teamColor: BoardTheme.teamATextColor,
                          teamActiveColor: _teamAColorActive,
                          playerActiveColor: BoardTheme.teamADefaultColor,
                          playerActive: 0,
                          onSetServeOrder: (teamServe) {
                            if (teamServe != null) {
                              _saveServeOrder(1, teamServe);
                            }
                          },
                        ),
                        TeamPlayerNames(
                          showWinner: _winnerTeam == 2,
                          canLongPress: _canLongPressNames,
                          team: 2,
                          teamOrderOfServeStream: _boardController.stream,
                          player1Name: _teamBPlayer1,
                          player2Name: _teamBPlayer2,
                          teamColor: BoardTheme.teamBTextColor,
                          teamActiveColor: _teamBColorActive,
                          playerActiveColor: BoardTheme.teamBDefaultColor,
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _sets.length != 0
                          ? SetScoreContainer(
                              matchEnded: _scoreData.state == 3,
                              sets: _sets,
                              winnerTeam: 1,
                            )
                          : Container(),
                    ),
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
        matchButton: _state != 1,
        teamAButtonColor: BoardTheme.teamADefaultColor,
        teamBButtonColor: BoardTheme.teamBDefaultColor,
        pointsInSet: _pointsInSet,
        stream: _boardController.stream,
        onTapSetNumberOfPointsForSet: (int points) {
          _pointsInSet = points;
          _scoreData.updateSetPointsFirstTo(points);
        },
        winnerOfDraw: _winnerOfDraw,
        onTapSetWinnerOfDraw: (int team) {
          _setWinnerOfDraw(team);
        },
        onTapSetOrderOfServe: (_) {
          setState(() {
            _showBox1 = true;
          });
        },
        setStartWithServe: _setStartWithServe,
        onTapSetStartWithServe: (int team) {
          _startWithServe(team);
        },
        onTapStartMatch: (_) async {
          DateTime time = DateTime.now();
          _showControls(true);
          await widget.match.updateMatchStarted(time);
          await _scoreData.updateSetStart(time);
          _boardController.add(ControllerData(ControllerType.time,
              TimerValues(TimerState.start, _elapsedTime)));
        });
  }

  Widget _controls() {
    return ControlsContainer(
        teamAColorActive: _teamAColorActive,
        teamBColorActive: _teamBColorActive,
        teamAColorControls: BoardTheme.teamAControlsColor,
        teamBColorControls: BoardTheme.teamBControlsColor,
        onTapAddPoints: _addPoints,
        onTapRemovePoints: _removePoints,
        onTapAddTimeouts: _addTimeouts,
        onTapRemoveTimeouts: _removeTimeouts);
  }

  Widget _results() {
    return ResultsContainer(
      teamAColor: BoardTheme.teamATextColor,
      teamBColor: BoardTheme.teamBTextColor,
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
      } else {
        _showNoTimeoutsLeft(context, 1);
      }
    } else {
      if (_teamBTimeouts + 1 <= 2) {
        setState(() {
          _teamBTimeouts++;
          _scoreData.updateTimeouts(
              _teamATimeouts, _teamBTimeouts, _elapsedTime);
        });
      } else {
        _showNoTimeoutsLeft(context, 2);
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

  Future<void> _showNoTimeoutsLeft(BuildContext context, int team) async {
    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return DialogOk(
            title: "No more Timeouts",
            body: "Team ${team == 1 ? "A" : "B"} has no Timeouts left!",
            onTap: () {
              if (MainInherited.of(context).canVibrate) {
                Vibrate.feedback(FeedbackType.medium);
              }
              Navigator.of(dialogContext).pop(true);
            },
          );
        });
  }

  Future<void> _showTechnicalTimeout(BuildContext context) async {
    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return DialogOk(
            title: "Technical Timeout",
            body: "Teams has Technical Timeout!",
            onTap: () {
              if (MainInherited.of(context).canVibrate) {
                Vibrate.feedback(FeedbackType.medium);
              }
              Navigator.of(dialogContext).pop(true);
            },
          );
        });
  }

  Future<void> _showContinueMatch(BuildContext context, int team) async {
    bool result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return DialogYesNo(
            title: "Continue match?",
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
          );
        });

    if (result != null && result == true) {
      _showControls(false);
    } else if (result != null && result == false) {
      _showWinnerOfMatch(context);
    }
  }

  Future<void> _showWinnerOfMatch(BuildContext context) async {
    int result = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return DialogTeamWon(
            title: "Winner of match",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Select Team that won the match:"),
                    )
                  ],
                )
              ],
            ),
            onTap: (int value) {
              if (MainInherited.of(context).canVibrate) {
                Vibrate.feedback(FeedbackType.medium);
              }
              Navigator.of(dialogContext).pop(value);
            },
          );
        });

    if (result != null) {
      _matchWon(result);
    }
  }

  Future<void> _showSetWon(BuildContext context, int team) async {
    bool result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return DialogYesNo(
              title: "Set won",
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Team ${team == 1 ? "A" : "B"}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(" "),
                  Expanded(child: Text("won the set?"))
                ],
              ),
              onTap: (bool value) {
                if (MainInherited.of(context).canVibrate) {
                  Vibrate.feedback(FeedbackType.medium);
                }
                Navigator.of(dialogContext).pop(value);
              });
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
    await _scoreData.resetScore();
    List<SetData> sets = await widget.match.getSets();

    setState(() {
      _state = _scoreData.state;
      _sets = sets;
      _teamAPoints = _scoreData.pointsTeam1;
      _teamBPoints = _scoreData.pointsTeam2;
      _teamASets = _scoreData.setTeam1;
      _teamBSets = _scoreData.setTeam2;
      _teamATimeouts = _scoreData.timeoutsTeam1;
      _teamBTimeouts = _scoreData.timeoutsTeam2;
      _pointsInSet = _scoreData.setPointsFirstTo;
      _winnerOfDraw = _scoreData.winnerOfDraw;
      _setStartWithServe = _scoreData.startingWithTheServe;
    });
  }

  Future<void> _matchWon(int winnerTeam) async {
    _boardController.add(
        ControllerData(ControllerType.time, TimerValues(TimerState.cancel, 0)));
    await _scoreData.updateState(3);
    await widget.match.updateMatchEnded(DateTime.now());
    await widget.match.updateMatchWinnerTeam(winnerTeam);
    _startWithServe(0);
    _setWinnerOfDraw(0);
    _setActiveTeam(0);
    _boardController
        .add(ControllerData(ControllerType.serveOrderTeam1, TeamServe(0, 0)));
    _boardController
        .add(ControllerData(ControllerType.serveOrderTeam2, TeamServe(0, 0)));

    _canLongPressNames = false;
    
    _showControls(false, showNone: true);
  }

  Future<void> _showSideChange(BuildContext context) async {
    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return DialogOk(
              title: "Side Change",
              body: "Teams have to change sides!",
              onTap: () {
                if (MainInherited.of(context).canVibrate) {
                  Vibrate.feedback(FeedbackType.medium);
                }
                Navigator.of(dialogContext).pop(true);
              });
        });
  }

  void _setActiveTeam(int team) {
    _scoreData.updateActiveTeam(team);

    switch (team) {
      case 0:
        _teamAColorActive = BoardTheme.teamADefaultColor;
        _teamBColorActive = BoardTheme.teamBDefaultColor;
        break;
      case 1:
        _teamAColorActive = BoardTheme.teamActiveColor;
        _teamBColorActive = BoardTheme.teamBDefaultColor;
        break;
      case 2:
        _teamAColorActive = BoardTheme.teamADefaultColor;
        _teamBColorActive = BoardTheme.teamActiveColor;
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

  void _showControls(bool show, {bool showNone = false}) {
    setState(() {
      if (showNone) {
        _mainControlsDisplay = CrossFadeState.showFirst;
        _mainDisplay = CrossFadeState.showFirst;
        _controlStep = 2;
      } else {
        if (show) {
          _mainControlsDisplay = CrossFadeState.showSecond;
          _mainDisplay = CrossFadeState.showSecond;
          _controlStep = 1;
        } else {
          _mainControlsDisplay = CrossFadeState.showFirst;
          _mainDisplay = CrossFadeState.showFirst;
          _controlStep = 0;
        }
      }
    });
  }

  Future<void> _pointsOnLongPress(int team) async {
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
