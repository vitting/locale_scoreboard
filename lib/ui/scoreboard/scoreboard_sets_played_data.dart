import 'package:meta/meta.dart';

class ScoreSetsPlayedData {
  final int setNumber;
  final int pointsTeam1;
  final int pointsTeam2;
  final int setTeam1;
  final int setTeam2;
  final int timeoutsTeam1;
  final int timeoutsTeam2;
  DateTime timestampSet;

  ScoreSetsPlayedData(
      {@required this.setNumber,
      @required this.pointsTeam1,
      @required this.pointsTeam2,
      @required this.setTeam1,
      @required this.setTeam2,
      @required this.timeoutsTeam1,
      @required this.timeoutsTeam2,
      this.timestampSet});

  factory ScoreSetsPlayedData.fromMap(Map<dynamic, dynamic> item) {
    return ScoreSetsPlayedData(
        setNumber: item["setNumber"],
        pointsTeam1: item["pointsTeam1"],
        pointsTeam2: item["pointsTeam2"],
        setTeam1: item["setTeam1"],
        setTeam2: item["setTeam2"],
        timeoutsTeam1: item["timeoutsTeam1"],
        timeoutsTeam2: item["timeoutsTeam2"],
        timestampSet: DateTime.fromMillisecondsSinceEpoch(item["timestampSet"]) 
        );
  }

  Map<String, dynamic> toMap() {
    return {
      "setNumber": setNumber,
      "pointsTeam1": pointsTeam1,
      "pointsTeam2": pointsTeam2,
      "setTeam1": setTeam1,
      "setTeam2": setTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2,
      "timestampSet": timestampSet == null ? DateTime.now().millisecondsSinceEpoch : timestampSet.millisecondsSinceEpoch
    };
  }
}
