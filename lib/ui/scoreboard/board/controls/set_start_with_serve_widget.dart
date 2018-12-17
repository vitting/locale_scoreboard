import 'package:flutter/material.dart';

class SetStartWithServe extends StatelessWidget {
  final ValueChanged<int> onTapTeam;
  final Color teamAButtonColor;
  final Color teamBButtonColor;

  const SetStartWithServe({Key key, this.onTapTeam, this.teamAButtonColor, this.teamBButtonColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Set Team starting with the Serve", style: TextStyle(color: Colors.white))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                color: teamAButtonColor,
                onPressed: () {
                  onTapTeam(1);
                },
                child: Text("Team A", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: RaisedButton(
                color: teamBButtonColor,
                onPressed: () {
                  onTapTeam(2);
                },
                child: Text("Team B", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}