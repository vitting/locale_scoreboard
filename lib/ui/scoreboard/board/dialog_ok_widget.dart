import 'package:flutter/material.dart';

class DialogOk extends StatelessWidget {
  final String title;
  final String body;
  final Function onTap;

  const DialogOk({Key key, this.title, this.body, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(body),
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                width: 60,
                height: 60,
                child: Center(
                    child: Text("Ok", style: TextStyle(color: Colors.white))),
                decoration: BoxDecoration(
                    color: Colors.green[900],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.0)),
              ),
            )
          ],
        ));
  }
}
