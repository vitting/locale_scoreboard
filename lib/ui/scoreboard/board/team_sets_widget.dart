import 'package:flutter/material.dart';

class TeamSets extends StatelessWidget {
  final Color teamAColor;
  final Color teamAColorActive;
  final Color teamBColor;
  final Color teamBColorActive;
  final int teamASets;
  final int teamBSets;
  

  const TeamSets({Key key, this.teamAColor, this.teamAColorActive, this.teamBColor, this.teamBColorActive, this.teamASets, this.teamBSets}) : super(key: key);@override
  Widget build(BuildContext context) {
    return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: teamAColor, width: 1.0),
                            color: teamAColorActive,
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(teamASets.toString(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16.0, color: teamAColor)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("sets",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: teamBColor, width: 1.0),
                            color: teamBColorActive,
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(teamASets.toString(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16.0, color: teamBColor)),
                        ),
                      )
                    ],
                  );
  }
}