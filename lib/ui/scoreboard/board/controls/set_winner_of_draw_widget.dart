import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:vibrate/vibrate.dart';

class SetWinnerOfDraw extends StatefulWidget {
  final ValueChanged<int> onTapTeam;
  final Color teamAButtonColor;
  final Color teamBButtonColor;

  const SetWinnerOfDraw(
      {Key key, this.onTapTeam, this.teamAButtonColor, this.teamBButtonColor})
      : super(key: key);

  @override
  SetWinnerOfDrawState createState() {
    return new SetWinnerOfDrawState();
  }
}

class SetWinnerOfDrawState extends State<SetWinnerOfDraw> {
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                if (MainInherited.of(context).canVibrate) {
                  Vibrate.feedback(FeedbackType.medium);
                }
                widget.onTapTeam(1);
                setState(() {
                  _selected = 1;
                });
              },
              child: Stack(
                children: <Widget>[
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: widget.teamAButtonColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.0)),
                      child: Center(
                          child: Text("A",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20)))),
                  _selected == 1
                      ? Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Icon(Icons.check_circle,
                              color: Colors.white54, size: 40),
                        )
                      : Container()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("Team won the Draw",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            InkWell(
                onTap: () {
                  if (MainInherited.of(context).canVibrate) {
                    Vibrate.feedback(FeedbackType.medium);
                  }
                  widget.onTapTeam(2);
                  setState(() {
                    _selected = 2;
                  });
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: widget.teamBButtonColor,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 1.0)),
                        child: Center(
                            child: Text("B",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)))),
                    _selected == 2
                        ? Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Icon(Icons.check_circle,
                                color: Colors.white54, size: 40),
                          )
                        : Container()
                  ],
                )),
          ],
        ),
      ],
    );
  }
}
