import 'package:flutter/material.dart';

class DialogRoundButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onTap;

  const DialogRoundButton({Key key, this.title, this.color, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        child: Center(child: Text(title, style: TextStyle(color: Colors.white))),
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.0)),
      ),
    );
  }
}
