import 'package:flutter/material.dart';

class SetOrderOfServe extends StatelessWidget {
  final ValueChanged<bool> onTap;
  final Color color;

  const SetOrderOfServe({Key key, this.onTap, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      color: color,
      textColor: Colors.white,
      icon: Icon(Icons.help),
      onPressed: () {
        onTap(true);
      },
      label: Text("Set order of Serve"),
    );
  }
}