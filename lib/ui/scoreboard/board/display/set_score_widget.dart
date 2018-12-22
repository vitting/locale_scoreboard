import 'package:flutter/material.dart';

class SetScore extends StatelessWidget {
  final int teamAPoints;
  final int teamBPoints;
  final int setNumber;
  final int setTime;
  final int winnerTeam;

  const SetScore({Key key, this.teamAPoints, this.teamBPoints, this.setNumber, this.setTime, this.winnerTeam}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(teamAPoints.toString(),
            style: TextStyle(color: Colors.white, fontWeight: winnerTeam == 1 ? FontWeight.bold : FontWeight.normal)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child:
              Text("(${setNumber.toString()}. set - ${setTime.toString()} min.)", style: TextStyle(color: Colors.white)),
        ),
        Text(teamBPoints.toString(), style: TextStyle(color: Colors.white, fontWeight: winnerTeam == 2 ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
