import 'package:flutter/material.dart';

class SetOrderOfServe extends StatelessWidget {
  final ValueChanged<bool> onTap;
  
  const SetOrderOfServe({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      textColor: Colors.white,
      icon: Icon(Icons.help),
      onPressed: () {
        onTap(true);
      },
      label: Text("Set order of Serve"),
    );
  }
}