import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamTitle extends StatelessWidget {
  final Color color;
  final String text;

  const TeamTitle({Key key, this.color, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Icon(FontAwesomeIcons.volleyballBall,
                color: color, size: 12.0),
          ),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: color)),
        ],
      ),
    );
  }
}