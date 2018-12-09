import 'package:flutter/material.dart';
import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
              onPressed: () async {
                DbHelpers db = DbHelpers();
                int value = await db.insert(DbSql.tableMatches, {
                  "id": SystemHelpers.generateUuid(),
                  "title": "test2",
                  "createdDate": 0,
                  "matchDate": 0,
                  "namePlayer1Team1": "anne",
                  "namePlayer2Team1": "irene",
                  "namePlayer1Team2": "bente",
                  "namePlayer2Team2": "lise",
                  "active": 0
                });
                print(value);
              },
            ),
            RaisedButton(
              child: Text("Test2"),
              onPressed: () async {
                DbHelpers db = DbHelpers();
                List<Map<String, dynamic>> values = await db.query(DbSql.tableMatches);
                print(values);
              },
            )
          ],
        ),
      ),
    );
  }
}