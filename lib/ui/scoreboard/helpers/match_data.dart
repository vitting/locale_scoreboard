class MatchData {
  String id;
  String title;
  DateTime createdDate;
  DateTime matchDate;
  String namePlayer1Team1;
  String namePlayer2Team1;
  String namePlayer1Team2;
  String namePlayer2Team2;
  bool active;

  MatchData(
      {this.id,
      this.title,
      this.createdDate,
      this.matchDate,
      this.namePlayer1Team1,
      this.namePlayer2Team1,
      this.namePlayer1Team2,
      this.namePlayer2Team2,
      this.active});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "createdDate": createdDate.millisecondsSinceEpoch,
      "matchDate": matchDate.millisecondsSinceEpoch,
      "namePlayer1Team1": namePlayer1Team1,
      "namePlayer2Team1": namePlayer2Team1,
      "namePlayer1Team2": namePlayer1Team2,
      "namePlayer2Team2": namePlayer2Team2,
      "active": active
    };
  }

  factory MatchData.fromMap(Map<String, dynamic> item) {
    return MatchData(
        id: item["id"],
        title: item["title"],
        createdDate: DateTime.fromMillisecondsSinceEpoch(item["createdDate"]),
        matchDate: DateTime.fromMillisecondsSinceEpoch(item["matchDate"]),
        namePlayer1Team1: item["namePlayer1Team1"],
        namePlayer2Team1: item["namePlayer2Team1"],
        namePlayer1Team2: item["namePlayer1Team2"],
        namePlayer2Team2: item["namePlayer2Team2"],
        active: item["active"] == 1);
  }
}
