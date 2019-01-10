import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/set_data.dart';

class SetScoreTotal extends StatefulWidget {
  final List<SetData> sets;
  final int winnerTeam;

  const SetScoreTotal({Key key, this.sets, this.winnerTeam = 0})
      : super(key: key);

  @override
  SetScoreTotalState createState() {
    return new SetScoreTotalState();
  }
}

class SetScoreTotalState extends State<SetScoreTotal> {
  int _pointsTeamA = 0;
  int _pointsTeamB = 0;
  int _totalTime = 0;

  @override
  void initState() {
    super.initState();

    int pointsTeamA = 0;
    int pointsTeamB = 0;
    int totalTime = 0;

    widget.sets.forEach((SetData s) {
      pointsTeamA += s.pointsTeam1;
      pointsTeamB += s.pointsTeam2;
      totalTime += s.getSetTime();
    });

    if (mounted) {
      setState(() {
        _pointsTeamA = pointsTeamA;
        _pointsTeamB = pointsTeamB;
        _totalTime = totalTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  "${_pointsTeamA < 10 ? '0' + _pointsTeamA.toString() : _pointsTeamA.toString()}",
                  style: TextStyle(color: Colors.white, fontWeight: widget.winnerTeam == 1 ? FontWeight.w900 : FontWeight.normal)),
              Text("${_totalTime.toString()} min.",
                  style: TextStyle(color: Colors.white)),
              Text(
                  "${_pointsTeamB < 10 ? '0' + _pointsTeamB.toString() : _pointsTeamB.toString()}",
                  style: TextStyle(color: Colors.white, fontWeight: widget.winnerTeam == 2 ? FontWeight.w900 : FontWeight.normal))
            ],
          ),
        ],
      ),
    );
  }
}
