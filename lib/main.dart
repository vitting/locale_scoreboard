import 'package:flutter/material.dart';
import 'package:locale_scoreboard/test.dart';
import 'package:locale_scoreboard/ui/scoreboard/create/scoreboard_create_main.dart';
import 'package:locale_scoreboard/ui/scoreboard/scoreboard_main.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/",
  routes: <String, WidgetBuilder> {
    // "/": (BuildContext context) => Scoreboard(),
    "/": (BuildContext context) => TestWidget(),
    ScoreboardCreate.routeName: (BuildContext context) => ScoreboardCreate()
  },
));
