import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/set_score_container_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_points_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_sets_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/team_timeouts_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/set_data.dart';

class ResultsContainer extends StatelessWidget {
  final List<SetData> sets;
  final Color teamAColor;
  final Color teamBColor;
  final Color teamAColorActive;
  final Color teamBColorActive;
  final int teamASets;
  final int teamBSets;
  final int teamAPoints;
  final int teamBPoints;
  final int teamATimeouts;
  final int teamBTimeouts;
  final ValueChanged<int> pointsOnLongPress;

  const ResultsContainer({Key key, this.sets, this.teamAColor, this.teamBColor, this.teamAColorActive, this.teamBColorActive, this.teamASets, this.teamBSets, this.teamAPoints, this.teamBPoints, this.teamATimeouts, this.teamBTimeouts, this.pointsOnLongPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TeamSets(
              teamAColor: teamAColor,
              teamBColor: teamBColor,
              teamAColorActive: teamAColorActive,
              teamBColorActive: teamBColorActive,
              teamASets: teamASets,
              teamBSets: teamBSets),
          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Row(
            children: <Widget>[
              TeamPoints(
                team: 1,
                activeColor: teamAColorActive,
                color: teamAColor,
                points: teamAPoints,
                onLongPress: pointsOnLongPress,
              ),
              TeamPoints(
                team: 2,
                activeColor: teamBColorActive,
                color: teamBColor,
                points: teamBPoints,
                onLongPress: pointsOnLongPress,
              )
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          TeamTimeouts(
              teamAColor: teamAColor,
              teamBColor: teamBColor,
              teamAColorActive: teamAColorActive,
              teamBColorActive: teamBColorActive,
              teamATimeouts: teamATimeouts,
              teamBTimeouts: teamBTimeouts),
          SetScoreContainer(
            sets: sets,
          ),
          // Divider(
          //   color: Colors.white,
          // ),
        ],
      ),
    );
  }
}