import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamTitle extends StatelessWidget {
  final Color color;
  final String text;
  final bool active;
  final bool winnerOfServe;
  final int team;
  final ValueChanged<int> onActiveTeam;

  const TeamTitle({Key key, this.color, this.text, this.active, this.onActiveTeam, this.team, this.winnerOfServe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          active
              ? Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(FontAwesomeIcons.solidCircle, color: color, size: 16.0),
                )
              : Container(),
          InkWell(
            enableFeedback: true,
            onLongPress: () {
              if (onActiveTeam != null) {
                onActiveTeam(team);
              }
            },
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: color, fontWeight: FontWeight.bold, decoration: winnerOfServe ? TextDecoration.underline : TextDecoration.none)),
          ),
        ],
      ),
    );
  }
}
