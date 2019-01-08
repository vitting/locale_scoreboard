import 'package:flutter/material.dart';

class SetScore extends StatelessWidget {
  final int teamAPoints;
  final int teamBPoints;
  final int setNumber;
  final int setTime;
  final int winnerTeam;
  final bool lastItem;

  const SetScore({Key key, this.teamAPoints, this.teamBPoints, this.setNumber, this.setTime, this.winnerTeam, this.lastItem = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(teamAPoints >= 10 ? teamAPoints.toString() : '0' + teamAPoints.toString(),
                style: TextStyle(color: Colors.white, fontWeight: winnerTeam == 1 ? FontWeight.bold : FontWeight.normal)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:
                  Text("(${setNumber.toString()}. set - ${setTime.toString()} min.)", style: TextStyle(color: Colors.white)),
            ),
            Text(teamBPoints >= 10 ? teamBPoints.toString() : '0' + teamBPoints.toString(), style: TextStyle(color: Colors.white, fontWeight: winnerTeam == 2 ? FontWeight.bold : FontWeight.normal))
          ],
        ),
        !lastItem ? SizedBox(
          height: 5,
        ) : Container()
      ],
    );
  }
}
