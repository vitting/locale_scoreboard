import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:vibrate/vibrate.dart';

class HelpSetPlayerOrder extends StatelessWidget {
  final bool show;
  final ValueChanged<bool> onTap;

  const HelpSetPlayerOrder({Key key, this.show, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 130,
      left: (MediaQuery.of(context).size.width / 2) - 100,
      width: 200,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: show ? 1.0 : 0.0,
        child: InkWell(
          onTap: () {
            if (MainInherited.of(context).canVibrate) {
              Vibrate.feedback(FeedbackType.medium);
            }
            onTap(true);
          },
          child: show
              ? Container(
                  padding: EdgeInsets.all(10),
                  height: 160,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.deepPurple[800],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.white, width: 1.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          "Long press names of players to set order of serve\n\nTab the box to hide",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
