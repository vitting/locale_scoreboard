import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/team_control_widget.dart';

class ControlsContainer extends StatelessWidget {
  final Color teamAColorActive;
  final Color teamBColorActive;
  final Color teamAColorControls;
  final Color teamBColorControls;
  final ValueChanged<Team> onTapAddPoints;
  final ValueChanged<Team> onTapRemovePoints;
  final ValueChanged<Team> onTapAddTimeouts;
  final ValueChanged<Team> onTapRemoveTimeouts;

  const ControlsContainer({Key key, this.teamAColorActive, this.teamBColorActive, this.teamAColorControls, this.teamBColorControls, this.onTapAddPoints, this.onTapRemovePoints, this.onTapAddTimeouts, this.onTapRemoveTimeouts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              TeamControl(
                team: Team.a,
                title: "points",
                teamActiveColor: teamAColorActive,
                teamControlsColor: teamAColorControls,
                onTapAdd: onTapAddPoints,
                onTapRemove: onTapRemovePoints,
              ),
              TeamControl(
                team: Team.b,
                title: "points",
                teamActiveColor: teamBColorActive,
                teamControlsColor: teamBColorControls,
                onTapAdd: onTapAddPoints,
                onTapRemove: onTapRemovePoints,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
          Row(
            children: <Widget>[
              TeamControl(
                team: Team.a,
                title: "timeouts",
                teamActiveColor: teamAColorActive,
                teamControlsColor: teamAColorControls,
                onTapAdd: onTapAddTimeouts,
                onTapRemove:onTapRemoveTimeouts,
              ),
              TeamControl(
                team: Team.b,
                title: "timeouts",
                teamActiveColor: teamBColorActive,
                teamControlsColor: teamBColorControls,
                onTapAdd: onTapAddTimeouts,
                onTapRemove: onTapRemoveTimeouts,
              ),
            ],
          )
        ],
      ),
    );
  }
}