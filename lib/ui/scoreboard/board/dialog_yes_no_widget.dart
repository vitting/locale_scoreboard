import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/dialog_round_button_widget.dart';

class DialogYesNo extends StatelessWidget {
  final String title;
  final Widget content;
  final ValueChanged<bool> onTap;
  
  const DialogYesNo({Key key, this.title, this.content, this.onTap}) : super(key: key);

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
                        title: "NO",
                        color: Colors.blue,
                        onTap: () {
                          onTap(false);
                        },
                      ),
                      DialogRoundButton(
                        title: "YES",
                        color: Colors.green[900],
                        onTap: () {
                          onTap(true);
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
