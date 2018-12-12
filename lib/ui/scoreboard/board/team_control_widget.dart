import 'package:flutter/material.dart';

enum Team {
  a,
  b
}

class TeamControl extends StatelessWidget {
  final Color teamControlsColor;
  final Color teamActiveColor;
  final String title;
  final ValueChanged<Team> onTapAdd;
  final ValueChanged<Team> onTapRemove;
  final Team team;

  const TeamControl(
      {Key key,
      this.title,
      this.teamControlsColor,
      this.teamActiveColor,
      this.onTapAdd,
      this.onTapRemove, this.team})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: teamControlsColor),
                color: teamActiveColor,
                shape: BoxShape.circle),
            child: IconButton(
              color: teamControlsColor,
              icon: Icon(Icons.add),
              onPressed: () {
                onTapAdd(team);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(title,
                style: TextStyle(color: teamControlsColor, fontSize: 10.0)),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: teamControlsColor),
                color: teamActiveColor,
                shape: BoxShape.circle),
            child: IconButton(
              color: teamControlsColor,
              icon: Icon(Icons.remove),
              onPressed: () {
                onTapRemove(team);
              },
            ),
          )
        ],
      ),
    );
  }
}
