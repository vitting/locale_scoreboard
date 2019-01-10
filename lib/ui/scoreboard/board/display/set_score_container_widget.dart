import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/set_score_total_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/set_score_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/set_data.dart';

class SetScoreContainer extends StatelessWidget {
  final List<SetData> sets;
  final bool matchEnded;
  final int winnerTeam;

  const SetScoreContainer({Key key, this.sets, this.matchEnded = false, this.winnerTeam = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: Colors.black26,
        shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white, width: 1.0)
      ),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: sets.length,
            itemBuilder: (BuildContext context, int position) {
              SetData item = sets[position];
              return SetScore(
                setNumber: item.setNumber,
                teamAPoints: item.pointsTeam1,
                teamBPoints: item.pointsTeam2,
                winnerTeam: item.winnerTeam,
                setTime: item.getSetTime(),
                lastItem: sets.length - 1  == position,
              );
            },
          ),
          matchEnded ? SetScoreTotal(
            winnerTeam: winnerTeam,
            sets: sets,
          ) : Container()
        ],
      )
    );
  }
}