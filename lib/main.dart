import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:locale_scoreboard/test.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/scoreboard_board.dart';
import 'package:locale_scoreboard/ui/scoreboard/create/scoreboard_create_main.dart';
import 'package:locale_scoreboard/ui/scoreboard/scoreboard_main.dart';
import 'package:vibrate/vibrate.dart';

void main() async {
  final bool canVibrate = await Vibrate.canVibrate;

  runApp(MainInherited(
    canVibrate: canVibrate,
    child: MaterialApp(
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        // "/": (BuildContext context) => Scoreboard(),
        // "/": (BuildContext context) => TestWidget(),
        "/": (BuildContext context) => ScoreboardBoard(),
        ScoreboardCreate.routeName: (BuildContext context) => ScoreboardCreate()
      },
    ),
  ));
}
