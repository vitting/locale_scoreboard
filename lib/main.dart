import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:locale_scoreboard/ui/scoreboard/create/scoreboard_create_main.dart';
import 'package:locale_scoreboard/ui/scoreboard/scoreboard_main.dart';
import 'package:vibrate/vibrate.dart';

/// TODO: Add internet when developing

void main() async {
  final bool canVibrate = await Vibrate.canVibrate;

  runApp(MainInherited(
    canVibrate: canVibrate,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => Scoreboard(),
        ScoreboardCreate.routeName: (BuildContext context) => ScoreboardCreate()
      },
    ),
  ));
}
