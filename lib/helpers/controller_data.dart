enum ControllerType {
  time,
  serveOrderTeam1,
  serveOrderTeam2,
  numberOfPointsInSet,
  winnerOfDraw,
  startWithServe
}

class ControllerData {
  final ControllerType type;
  final dynamic data;

  ControllerData(this.type, this.data);
}