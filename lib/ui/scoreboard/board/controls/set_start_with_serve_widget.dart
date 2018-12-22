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
            InkWell(
              onTap: () {
                onTapTeam(1);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: teamAButtonColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.0)),
                child: Center(child: Text("A", style: TextStyle(color: Colors.white)))
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("Set starting with the serve", style: TextStyle(color: Colors.white)),
            ),
            InkWell(
              onTap: () {
                onTapTeam(2);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: teamBButtonColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.0)),
                child: Center(child: Text("B", style: TextStyle(color: Colors.white)))
              ),
            ),
          ],
        ),
      ],
    );
  }
}