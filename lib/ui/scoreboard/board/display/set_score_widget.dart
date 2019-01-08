import 'package:flutter/material.dart';

class SetScore extends StatelessWidget {
  final int teamAPoints;
  final int teamBPoints;
  final int setNumber;
  final int setTime;
  final int winnerTeam;
  final bool lastItem;

  const SetScore(
      {Key key,
      this.teamAPoints,
      this.teamBPoints,
      this.setNumber,
      this.setTime,
      this.winnerTeam,
      this.lastItem = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[900],
                  border: Border.all(
                      width: winnerTeam == 1 ? 2 : 1, color: Colors.white, style: BorderStyle.solid)),
              child: Center(
                child: Text(
                    teamAPoints >= 10
                        ? teamAPoints.toString()
                        : '0' + teamAPoints.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: winnerTeam == 1
                            ? FontWeight.w900
                            : FontWeight.normal)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                  "(${setNumber.toString()}. set - ${setTime.toString()} min.)",
                  style: TextStyle(color: Colors.white)),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[500],
                  border: Border.all(
                      width: winnerTeam == 2 ? 2 : 1, color: Colors.white, style: BorderStyle.solid)),
                child: Center(
                  child: Text(
                      teamBPoints >= 10
                          ? teamBPoints.toString()
                          : '0' + teamBPoints.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: winnerTeam == 2
                              ? FontWeight.w900
                              : FontWeight.normal)),
                ))
          ],
        ),
        !lastItem
            ? SizedBox(
                height: 6,
              )
            : Container()
      ],
    );
  }
}
