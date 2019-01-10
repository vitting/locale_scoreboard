import 'package:flutter/material.dart';
import 'package:locale_scoreboard/helpers/board_theme.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/dialog_round_button_widget.dart';

class DialogTeamWon extends StatelessWidget {
  final String title;
  final Widget content;
  final ValueChanged<int> onTap;
  
  const DialogTeamWon({Key key, this.title, this.content, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: content
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      DialogRoundButton(
                        title: "A",
                        color: BoardTheme.teamADefaultColor,
                        onTap: () {
                          onTap(1);
                        },
                      ),
                      DialogRoundButton(
                        title: "B",
                        color: BoardTheme.teamBDefaultColor,
                        onTap: () {
                          onTap(2);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
