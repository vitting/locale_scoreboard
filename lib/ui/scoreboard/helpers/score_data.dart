class ScoreData {
  String id;
  String matchId;
  DateTime matchStartedAt;
  DateTime matchEndedAt;
  int setTeam1;
  int setTeam2;
  int pointsTeam1;
  int pointsTeam2;
  int timeoutsTeam1;
  int timeoutsTeam2;
  int startTeam;
  int activeTeam;

  ScoreData(
      {this.id,
      this.matchId,
      this.matchStartedAt,
      this.matchEndedAt,
      this.setTeam1,
      this.setTeam2,
      this.pointsTeam1,
      this.pointsTeam2,
      this.timeoutsTeam1,
      this.timeoutsTeam2,
      this.startTeam,
      this.activeTeam});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "matchId": matchId,
      "matchStartedAt": matchStartedAt.millisecondsSinceEpoch,
      "matchEndedAt": matchEndedAt.millisecondsSinceEpoch,
      "setTeam1": setTeam1,
      "setTeam2": setTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2,
      "startTeam": startTeam,
      "activeTeam": activeTeam,
    };
  }

  factory ScoreData.fromMap(Map<String, dynamic> item) {
    return ScoreData(
        id: item["id"],
        matchId: item["matchId"],
        matchStartedAt:
            DateTime.fromMillisecondsSinceEpoch(item["matchStartedAt"]),
        matchEndedAt: DateTime.fromMillisecondsSinceEpoch(item["matchEndedAt"]),
        setTeam1: item["setTeam1"],
        setTeam2: item["setTeam2"],
        pointsTeam1: item["pointsTeam1"],
        pointsTeam2: item["pointsTeam2"],
        timeoutsTeam1: item["timeoutsTeam1"],
        timeoutsTeam2: item["timeoutsTeam2"],
        startTeam: item["startTeam"],
        activeTeam: item["activeTeam"]);
  }
}
