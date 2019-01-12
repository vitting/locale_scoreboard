import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamTitle extends StatelessWidget {
  final Color color;
  final String text;
  final bool active;
  final bool winnerOfServe;
  final int team;

  const TeamTitle(
      {Key key,
      this.color,
      this.text,
      this.active,
      this.team,
      this.winnerOfServe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        height: 55,
        message: "Underline = won the draw\nVolleyball = started with the serve",
              child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            active
                ? Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(FontAwesomeIcons.volleyballBall,
                        color: color, size: 16.0),
                  )
                : Container(),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: color,
                    fontWeight: FontWeight.bold,
                    decoration: winnerOfServe
                        ? TextDecoration.underline
                        : TextDecoration.none)),
          ],
        ),
      ),
    );
  }
}
