import 'package:flutter/material.dart';

class BoardTheme {
  static final Color gold = Color.fromRGBO(255, 215, 0, 1);
  static final Color teamATextColor = Colors.white;
  static final Color teamBTextColor = Colors.white;
  static final Color teamAControlsColor = Colors.white;
  static final Color teamBControlsColor = Colors.white;
  static final Color teamADefaultColor = Colors.blue[900];
  static final Color teamBDefaultColor = Colors.blue[500];
  static final Color teamActiveColor = Colors.deepOrange[900];
  static final Color buttonColor = Colors.deepOrange[900];
  static final BoxDecoration background = BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.5, 0.7, 0.9],
    colors: [Colors.black, Colors.blue[900], Colors.blue[900], Colors.black],
  ));
}
