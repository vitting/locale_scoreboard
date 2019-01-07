import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:vibrate/vibrate.dart';

class SetNumberOfPointsForSet extends StatefulWidget {
  final ValueChanged<int> onTapPoints;
  final Stream<int> pointsInSetStream;
  final int pointsInSet;

  const SetNumberOfPointsForSet(
      {Key key, this.onTapPoints, this.pointsInSetStream, this.pointsInSet})
      : super(key: key);

  @override
  SetNumberOfPointsForSetState createState() {
    return new SetNumberOfPointsForSetState();
  }
}

class SetNumberOfPointsForSetState extends State<SetNumberOfPointsForSet> {
  int _numberOfPointsInSet;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _numberOfPointsInSet = widget.pointsInSet;
      });
    }
    widget.pointsInSetStream.listen((int points) {
      if (mounted) {
        setState(() {
          print(points);
          _numberOfPointsInSet = points;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text("Set points in set",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          InkWell(
            onTap: () async {
              if (MainInherited.of(context).canVibrate) {
                Vibrate.feedback(FeedbackType.medium);
              }
              int result = await _showChooseNumberOfPoints(context);
              if (result != null) {
                setState(() {
                  _numberOfPointsInSet = result;
                });

                widget.onTapPoints(_numberOfPointsInSet);
              }
            },
            child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blue[700],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.0)),
                child: Center(
                    child: Text(_numberOfPointsInSet.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 20)))),
          )
        ])
      ],
    );
  }

  Future<int> _showChooseNumberOfPoints(BuildContext context) async {
    return showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Points in set"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Select number of points in set?")
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          if (MainInherited.of(context).canVibrate) {
                            Vibrate.feedback(FeedbackType.medium);
                          }
                          Navigator.of(dialogContext).pop(21);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          child: Center(
                              child: Text("21",
                                  style: TextStyle(color: Colors.white))),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (MainInherited.of(context).canVibrate) {
                            Vibrate.feedback(FeedbackType.medium);
                          }
                          Navigator.of(dialogContext).pop(15);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          child: Center(
                              child: Text("15",
                                  style: TextStyle(color: Colors.white))),
                          decoration: BoxDecoration(
                              color: Colors.green[900],
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
