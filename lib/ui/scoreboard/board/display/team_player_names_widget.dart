import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:vibrate/vibrate.dart';

class TeamServe {
  final int first;
  final int second;

  TeamServe(this.first, this.second);
}

class TeamPlayerNames extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final Color teamColor;
  final Color teamActiveColor;
  final Color playerActiveColor;
  final int playerActive;
  final ValueChanged<TeamServe> onSetServeOrder;

  const TeamPlayerNames(
      {Key key,
      this.player1Name,
      this.player2Name,
      this.teamActiveColor,
      this.playerActive,
      this.teamColor,
      this.playerActiveColor,
      this.onSetServeOrder})
      : super(key: key);

  @override
  TeamPlayerNamesState createState() {
    return new TeamPlayerNamesState();
  }
}

class TeamPlayerNamesState extends State<TeamPlayerNames> {
  GlobalKey _keyPlayer1Name = GlobalKey();
  GlobalKey _keyPlayer2Name = GlobalKey();
  int _player1ServeOrder = 0;
  int _player2ServeOrder = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 85,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: widget.teamActiveColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: widget.teamColor, width: 1.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
                key: _keyPlayer1Name,
                onLongPress: () async {
                  TeamServe teamServe =
                      await setServer(context, _keyPlayer1Name, 1, widget.player1Name);
                  if (widget.onSetServeOrder != null) {
                    widget.onSetServeOrder(teamServe);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _player1ServeOrder != 0
                        ? Container(
                            margin: EdgeInsets.only(right: 5.0),
                            child: Text(
                              _player1ServeOrder.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: widget.playerActive == 1
                                      ? Colors.white
                                      : Colors.blue[600],
                                  fontWeight: FontWeight.bold),
                            ),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.playerActive == 1
                                    ? widget.playerActiveColor
                                    : Colors.white),
                          )
                        : Container(),
                    Expanded(
                      child: Text(widget.player1Name,
                          style: TextStyle(
                              fontSize: 16.0, color: widget.teamColor)),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
            ),
            InkWell(
                key: _keyPlayer2Name,
                onLongPress: () async {
                  TeamServe teamServe =
                      await setServer(context, _keyPlayer2Name, 2, widget.player2Name);
                  if (widget.onSetServeOrder != null) {
                    widget.onSetServeOrder(teamServe);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _player2ServeOrder != 0
                        ? Container(
                            margin: EdgeInsets.only(right: 5.0),
                            child: Text(
                              _player2ServeOrder.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: widget.playerActive == 2
                                      ? Colors.white
                                      : Colors.blue[600],
                                  fontWeight: FontWeight.bold),
                            ),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.playerActive == 2
                                    ? widget.playerActiveColor
                                    : Colors.white),
                          )
                        : Container(),
                    Expanded(
                      child: Text(widget.player2Name,
                          style: TextStyle(
                              fontSize: 16.0, color: widget.teamColor)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<TeamServe> setServer(BuildContext context, GlobalKey playerKey, int player, String playerName) async {
    if (MainInherited.of(context).canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
    final RenderBox renderBox = playerKey.currentContext.findRenderObject();
    var translation = renderBox.getTransformTo(null).getTranslation();
    TeamServe teamServe;
    int result = await showMenu<int>(
        position: RelativeRect.fromLTRB(translation.x + 50, translation.y + 20,
            translation.x + 50, translation.y + 20),
        context: context,
        items: [
          PopupMenuItem(
            value: 1,
            child: Text("Set $playerName as first server"),
          )
        ]);

    if (result != null) {
      setState(() {
        if (player == 1) {
          _player1ServeOrder = 1;
          _player2ServeOrder = 2;
          teamServe = TeamServe(1, 2);
        } else {
          _player2ServeOrder = 1;
          _player1ServeOrder = 2;
          teamServe = TeamServe(2, 1);
        }
      });
    }

    return teamServe;
  }
}
