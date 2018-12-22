import 'package:flutter/material.dart';

class StartMatch extends StatelessWidget {
  final ValueChanged<bool> onTap;

  const StartMatch({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      textColor: Colors.white,
      icon: Icon(Icons.play_circle_outline, size: 26),
      label: Text("Start match", style: TextStyle(color: Colors.white)),
      onPressed: () {
        onTap(true);
      },
    );
  }
}
