import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locale_scoreboard/helpers/board_theme.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/match_data.dart';

class ScoreboardCreate extends StatefulWidget {
  static final routeName = "/scoreboardcreate";
  final MatchData match;

  const ScoreboardCreate({Key key, this.match}) : super(key: key);
  @override
  _ScoreboardCreateState createState() => _ScoreboardCreateState();
}

class _ScoreboardCreateState extends State<ScoreboardCreate> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  MatchData _match;

  @override
  void initState() {
    super.initState();

    if (widget.match != null) {
      _match = widget.match;
    } else {
      _match = MatchData(
          namePlayer1Team1: "",
          namePlayer2Team1: "",
          namePlayer1Team2: "",
          namePlayer2Team2: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Match")),
      body: Container(
        child: ListView(
          children: <Widget>[
            Form(
              key: _formState,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    color: BoardTheme.teamADefaultColor,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text("Team A",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            )
                          ],
                        ),
                        TextFormField(
                          autofocus: true,
                          inputFormatters: [LengthLimitingTextInputFormatter(50)],
                          initialValue: _match.namePlayer1Team1,
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please fill out name for player 1";
                          },
                          onSaved: (String value) {
                            _match.namePlayer1Team1 = value;
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[500])),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Player 1 name",
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                          inputFormatters: [LengthLimitingTextInputFormatter(50)],
                          initialValue: _match.namePlayer1Team2,
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please fill out name for player 2";
                          },
                          onSaved: (String value) {
                            _match.namePlayer2Team1 = value;
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[500])),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Player 2 name",
                              labelStyle: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    color: BoardTheme.teamBDefaultColor,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text("Team B",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            )
                          ],
                        ),
                        TextFormField(
                          inputFormatters: [LengthLimitingTextInputFormatter(50)],
                          initialValue: _match.namePlayer1Team2,
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please fill out name for player 1";
                          },
                          onSaved: (String value) {
                            _match.namePlayer1Team2 = value;
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[900])),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Player 1 name",
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                          inputFormatters: [LengthLimitingTextInputFormatter(50)],
                          initialValue: _match.namePlayer2Team2,
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please fill out name for player 2";
                          },
                          onSaved: (String value) {
                            _match.namePlayer2Team2 = value;
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[900])),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Player 2 name",
                              labelStyle: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton.icon(
                    textColor: BoardTheme.buttonColor,
                    icon: Icon(Icons.check_circle),
                    label: Text("Save"),
                    onPressed: () async {
                      if (_formState.currentState.validate()) {
                        _formState.currentState.save();
                        if (_match.id == null) {
                          await _match.save();
                        } else {
                          await _match.update();
                        }
                        
                        Navigator.of(context).pop(_match);
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
