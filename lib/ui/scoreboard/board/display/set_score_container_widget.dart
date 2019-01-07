import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/display/set_score_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/set_data.dart';

class SetScoreContainer extends StatelessWidget {
  final List<SetData> sets;

  const SetScoreContainer({Key key, this.sets}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white, width: 1.0)
      ),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      // child: ListView.builder(
      //   itemCount: sets.length,
      //   itemBuilder: (BuildContext context, int position) {
      //     print("VI WE ARE er Here");
      //     return Column(
      //       children: <Widget>[
      //         Container()
      //       ],
      //     );
      //   },
      // ),
      child: Column(
        children: <Widget>[
          SetScore(
            setNumber: 1,
            setTime: 23,
            teamAPoints: 21,
            teamBPoints: 18,
            winnerTeam: 1,
          ),
          SetScore(
            setNumber: 1,
            setTime: 23,
            teamAPoints: 21,
            teamBPoints: 18,
            winnerTeam: 1,
          ),
          SetScore(
            setNumber: 1,
            setTime: 23,
            teamAPoints: 21,
            teamBPoints: 18,
            winnerTeam: 1,
          )
        ],
      ),
    );
  }
}