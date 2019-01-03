import 'package:flutter/material.dart';

class TeamPoints extends StatelessWidget {
  final Color color;
  final Color activeColor;
  final int points;
  final int team;
  final ValueChanged<int> onLongPress;

  const TeamPoints({Key key, this.color, this.activeColor, this.points, this.onLongPress, this.team})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
              onLongPress: () {
                if (onLongPress != null) {
                  onLongPress(team);
                }
              },
              child: Container(
          height: 70.0,
          decoration: BoxDecoration(
              border: Border.all(color: color, width: 1.0),
              color: activeColor,
              shape: BoxShape.circle),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(points.toString(),
                  style: TextStyle(fontSize: 30.0, color: color))
            ],
          ),
        ),
      ),
    );
  }
}
