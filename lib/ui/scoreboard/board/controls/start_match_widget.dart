import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:vibrate/vibrate.dart';

class StartMatch extends StatelessWidget {
  final ValueChanged<bool> onTap;

  const StartMatch({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      textColor: Colors.white,
      icon: Icon(Icons.play_circle_outline, size: 40),
      label: Text("Start match",
          style: TextStyle(color: Colors.white, fontSize: 22)),
      onPressed: () {
        if (MainInherited.of(context).canVibrate) {
          Vibrate.feedback(FeedbackType.medium);
        }
        onTap(true);
      },
    );
  }
}
