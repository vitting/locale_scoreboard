import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  static final routeName = "/test";
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Test"),
              onPressed: () {

              },
            )
          ],
        ),
      ),
    );
  }
}