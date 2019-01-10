import 'package:flutter/material.dart';
import 'package:locale_scoreboard/helpers/controller_data.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/set_number_of_point_for_set.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/set_order_of_serve_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/set_start_with_serve_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/set_winner_of_draw_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/controls/start_match_widget.dart';

class SetupSetContainer extends StatelessWidget {
  final Color teamAButtonColor;
  final Color teamBButtonColor;
  final Stream<ControllerData> stream;
  final ValueChanged<int> onTapSetNumberOfPointsForSet;
  final ValueChanged<bool> onTapSetOrderOfServe;
  final ValueChanged<int> onTapSetStartWithServe;
  final ValueChanged<int> onTapSetWinnerOfDraw;
  final ValueChanged<bool> onTapStartMatch;
  final int pointsInSet;
  final int winnerOfDraw;
  final int setStartWithServe;
  final bool matchButton;

  const SetupSetContainer({Key key, this.teamAButtonColor, this.teamBButtonColor, this.stream, this.onTapSetNumberOfPointsForSet, this.onTapSetOrderOfServe, this.onTapSetStartWithServe, this.onTapSetWinnerOfDraw, this.onTapStartMatch, this.pointsInSet, this.setStartWithServe, this.winnerOfDraw, this.matchButton = true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SetNumberOfPointsForSet(
            pointsInSet: pointsInSet,
            pointsInSetStream: stream,
            onTapPoints: onTapSetNumberOfPointsForSet,
          ),
          SizedBox(
            height: 20,
          ),
          SetWinnerOfDraw(
            winnerOfDraw: winnerOfDraw,
            selectedButtonStream: stream,
            onTapTeam: onTapSetWinnerOfDraw,
            teamAButtonColor: teamAButtonColor,
            teamBButtonColor: teamAButtonColor,
          ),
          SizedBox(
            height: 20,
          ),
          SetOrderOfServe(
            onTap: onTapSetOrderOfServe,
          ),
          SizedBox(
            height: 20,
          ),
          SetStartWithServe(
            setStartWithServe: setStartWithServe,
            selectedButtonStream: stream,
            onTapTeam: onTapSetStartWithServe,
            teamAButtonColor: teamAButtonColor,
            teamBButtonColor: teamAButtonColor,
          ),
          SizedBox(
            height: 20,
          ),
          StartMatch(
            matchButton: matchButton,
            onTap: onTapStartMatch,
          )
        ],
      ),
    );
  }
}