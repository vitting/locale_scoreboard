import 'package:flutter/material.dart';

class ScoreboardCreate extends StatefulWidget {
  static final routeName = "/scoreboardcreate";
  @override
  _ScoreboardCreateState createState() => _ScoreboardCreateState();
}

class _ScoreboardCreateState extends State<ScoreboardCreate> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Form(
                key: _formState,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Team A", style: TextStyle(fontSize: 20))
                          ],
                        ),
                        TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) return "Please fill out name for player 1";
                          },
                          onSaved: (String value) {

                          },
                          decoration:
                              InputDecoration(labelText: "Player 1"),
                        ),
                        TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) return "Please fill out name for player 2";
                          },
                          onSaved: (String value) {

                          },
                          decoration:
                              InputDecoration(labelText: "Player 2"),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Team B", style: TextStyle(fontSize: 20))
                          ],
                        ),
                        TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) return "Please fill out name for player 1";
                          },
                          onSaved: (String value) {

                          },
                          decoration:
                              InputDecoration(labelText: "Player 1"),
                        ),
                        TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) return "Please fill out name for player 2";
                          },
                          onSaved: (String value) {

                          },
                          decoration:
                              InputDecoration(labelText: "Player 2"),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.check),
                      label: Text("Save"),
                      onPressed: () {
                        if (_formState.currentState.validate()) {
                          _formState.currentState.save();
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
