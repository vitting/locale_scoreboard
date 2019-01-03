import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:vibrate/vibrate.dart';

class SetOrderOfServe extends StatelessWidget {
  final ValueChanged<bool> onTap;

  const SetOrderOfServe({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      textColor: Colors.white,
      icon: Icon(Icons.help, size: 30),
      onPressed: () {
        if (MainInherited.of(context).canVibrate) {
          Vibrate.feedback(FeedbackType.medium);
        }
        onTap(true);
      },
      label: Text("Set order of Serve", style: TextStyle(fontSize: 16)),
    );
  }
}
