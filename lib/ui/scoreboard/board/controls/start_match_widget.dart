import 'package:flutter/material.dart';

class StartMatch extends StatelessWidget {
  final ValueChanged<bool> onTap;
  final Color color;

  const StartMatch({Key key, this.onTap, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      color: color,
      textColor: Colors.white,
      icon: Icon(Icons.play_circle_outline, size: 26),
      label: Text("Start match", style: TextStyle(color: Colors.white)),
      onPressed: () {
        onTap(true);
      },
    );
  }
}
