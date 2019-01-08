import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:locale_scoreboard/helpers/datetime_helpers.dart';
import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/dialog_yes_no_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/board/scoreboard_board.dart';
import 'package:locale_scoreboard/ui/scoreboard/create/scoreboard_create_main.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/dialog_round_button_widget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/match_data.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/score_data.dart';

enum BottomMenuResult { delete, edit }
enum DeleteDialogResult { yes, no }

class Scoreboard extends StatefulWidget {
  static final routeName = "/scoreboard";
  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matches"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  ScoreboardCreate(match: null)));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
          child: FutureBuilder(
        future: DbHelpers.query(DbSql.tableMatches),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> matches) {
          if (!matches.hasData) return Container();
          if (matches.hasData && matches.data.length == 0)
            return Container(child: Text("No matches"));
          if (matches.hasData && matches.data.length != 0) {
            List<MatchData> m =
                matches.data.map<MatchData>((Map<String, dynamic> item) {
              return MatchData.fromMap(item);
            }).toList();
            return ListView.builder(
              itemCount: m.length,
              itemBuilder: (BuildContext context, int position) {
                MatchData match = m[position];
                return Card(
                  child: ListTile(
                      onLongPress: () async {
                        BottomMenuResult result = await _showMenu(context);

                        if (result != null) {
                          switch (result) {
                            case BottomMenuResult.edit:
                              _editMatch(context, match);
                              break;
                            case BottomMenuResult.delete:
                              DeleteDialogResult dialogResult =
                                  await _deleteMatchDialog(context, match);
                              if (dialogResult != null &&
                                  dialogResult == DeleteDialogResult.yes) {
                                int deleteResult = await match.delete();
                                if (deleteResult != 0) {
                                  setState(() {});
                                }
                              }
                              break;
                          }
                        }
                      },
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => ScoreboardBoard(
                                  match: match,
                                )));
                      },
                      title: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.solidCircle,
                              size: 16,
                              color: match.active
                                  ? Colors.green[700]
                                  : Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(match.title),
                          )
                        ],
                      ),
                      subtitle:
                          Text(DateTimeHelpers.ddmmyyyy(match.createdDate))),
                );
              },
            );
          }
        },
      )),
    );
  }

  Future<BottomMenuResult> _showMenu(BuildContext context) {
    return showModalBottomSheet<BottomMenuResult>(
        context: context,
        builder: (BuildContext modalContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit Match"),
                onTap: () {
                  Navigator.of(modalContext).pop(BottomMenuResult.edit);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete Match"),
                onTap: () {
                  Navigator.of(modalContext).pop(BottomMenuResult.delete);
                },
              )
            ],
          );
        });
  }

  void _editMatch(BuildContext context, MatchData match) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ScoreboardCreate(
              match: match,
            )));
  }

  Future<DeleteDialogResult> _deleteMatchDialog(
      BuildContext context, MatchData match) {
    return showDialog<DeleteDialogResult>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
            title: Text("Delete"),
            content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Do you want to Delete the Match?\n\n${match.title}"),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DialogRoundButton(
                      color: Colors.blue,
                      title: "NO",
                      onTap: () {
                        Navigator.of(dialogContext).pop(DeleteDialogResult.no);
                      },
                    ),
                    DialogRoundButton(
                      color: Colors.green[900],
                      title: "YES",
                      onTap: () {
                        Navigator.of(dialogContext).pop(DeleteDialogResult.yes);
                      },
                    ),
                  ],
                )
              ],
            ))));
  }
}
