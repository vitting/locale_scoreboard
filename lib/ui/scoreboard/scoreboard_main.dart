import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/create/scoreboard_create_main.dart';

class Scoreboard extends StatefulWidget {
  static final routeName = "/scoreboard";
  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ScoreboardCreate.routeName);
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: Text("Scoreboard"),
      ),
    );
  }
}