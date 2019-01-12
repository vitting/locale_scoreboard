import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locale_scoreboard/helpers/board_theme.dart';
import 'package:locale_scoreboard/ui/scoreboard/create/dialog_persons_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/match_data.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/person_data.dart';

class ScoreboardCreate extends StatefulWidget {
  static final routeName = "/scoreboardcreate";
  final MatchData match;

  const ScoreboardCreate({Key key, this.match}) : super(key: key);
  @override
  _ScoreboardCreateState createState() => _ScoreboardCreateState();
}

class _ScoreboardCreateState extends State<ScoreboardCreate> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  TextEditingController _namePlayer1Team1Controller =
      TextEditingController(text: "");
  TextEditingController _namePlayer2Team1Controller =
      TextEditingController(text: "");
  TextEditingController _namePlayer1Team2Controller =
      TextEditingController(text: "");
  TextEditingController _namePlayer2Team2Controller =
      TextEditingController(text: "");

  String _title = "";
  MatchData _match;

  @override
  void initState() {
    super.initState();

    if (widget.match != null) {
      _title = "Update Match";
      _match = widget.match;
      _namePlayer1Team1Controller.text = _match.namePlayer1Team1;
      _namePlayer2Team1Controller.text = _match.namePlayer2Team1;
      _namePlayer1Team2Controller.text = _match.namePlayer1Team2;
      _namePlayer2Team2Controller.text = _match.namePlayer2Team2;
    } else {
      _title = "Create Match";
      _match = MatchData(
          namePlayer1Team1: "",
          namePlayer2Team1: "",
          namePlayer1Team2: "",
          namePlayer2Team2: "");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _namePlayer1Team1Controller.dispose();
    _namePlayer1Team2Controller.dispose();
    _namePlayer2Team1Controller.dispose();
    _namePlayer2Team2Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
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
                          controller: _namePlayer1Team1Controller,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please fill out name for player 1";
                          },
                          onSaved: (String value) {
                            _match.namePlayer1Team1 = value.trim();
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  color: Colors.blue[500],
                                  icon: Icon(Icons.person),
                                  onPressed: () async {
                                    String name = await _showPersons(context);
                                    if (name != null) {
                                      _namePlayer1Team1Controller.text = name;
                                    }
                                  }),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[500])),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Player 1 name",
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          controller: _namePlayer2Team1Controller,
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please fill out name for player 2";
                          },
                          onSaved: (String value) {
                            _match.namePlayer2Team1 = value.trim();
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  color: Colors.blue[500],
                                  icon: Icon(Icons.person),
                                  onPressed: () async {
                                    String name = await _showPersons(context);
                                    if (name != null) {
                                      _namePlayer2Team1Controller.text = name;
                                    }
                                  }),
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
                    color: Colors.blueGrey,
                    height: 20,
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          controller: _namePlayer1Team2Controller,
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please fill out name for player 1";
                          },
                          onSaved: (String value) {
                            _match.namePlayer1Team2 = value.trim();
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  color: Colors.blue[900],
                                  icon: Icon(Icons.person),
                                  onPressed: () async {
                                    String name = await _showPersons(context);
                                    if (name != null) {
                                      _namePlayer1Team2Controller.text = name;
                                    }
                                  }),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[900])),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Player 1 name",
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          controller: _namePlayer2Team2Controller,
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            if (value.isEmpty)
                              return "Please fill out name for player 2";
                          },
                          onSaved: (String value) {
                            _match.namePlayer2Team2 = value.trim();
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  color: Colors.blue[900],
                                  icon: Icon(Icons.person),
                                  onPressed: () async {
                                    String name = await _showPersons(context);
                                    if (name != null) {
                                      _namePlayer2Team2Controller.text = name;
                                    }
                                  }),
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
                        await PersonData.create(_match.namePlayer1Team1.trim())
                            .save();
                        await PersonData.create(_match.namePlayer2Team1.trim())
                            .save();
                        await PersonData.create(_match.namePlayer1Team2.trim())
                            .save();
                        await PersonData.create(_match.namePlayer2Team2.trim())
                            .save();
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

  Future<String> _showPersons(BuildContext context) async {
    List<PersonData> persons = await PersonData.getPersons();
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
            title: Text("Persons"),
            children: <Widget>[
              DialogPersons(
                persons: persons,
              )
            ],
          );
        });
  }
}
