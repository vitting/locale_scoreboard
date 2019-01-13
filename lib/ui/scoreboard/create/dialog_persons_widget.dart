import 'package:flutter/material.dart';
import 'package:locale_scoreboard/main_inheretedwidget.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/person_data.dart';
import 'package:vibrate/vibrate.dart';

class DialogPersons extends StatefulWidget {
  final List<PersonData> persons;

  const DialogPersons({Key key, this.persons}) : super(key: key);
  @override
  _DialogPersonsState createState() => _DialogPersonsState();
}

class _DialogPersonsState extends State<DialogPersons> {
  List<PersonData> _persons = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        _persons = widget.persons;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: _persons.length,
      itemBuilder: (BuildContext context, int position) {
        PersonData person = _persons[position];
        return ListTile(
          leading: IconButton(
            icon: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.blue[700],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.0)),
              child: Center(
                  child: Icon(Icons.person_add, color: Colors.white, size: 20)),
            ),
            onPressed: () {
              if (MainInherited.of(context).canVibrate) {
                Vibrate.feedback(FeedbackType.medium);
              }
              Navigator.of(context).pop(person.name);
            },
          ),
          trailing: IconButton(
            icon: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blue[500],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.0)),
                child: Center(
                    child: Icon(Icons.delete_forever,
                        color: Colors.white, size: 20))),
            onPressed: () async {
              if (MainInherited.of(context).canVibrate) {
                Vibrate.feedback(FeedbackType.medium);
              }
              await person.delete();
              List<PersonData> persons = await PersonData.getPersons();
              setState(() {
                _persons = persons;
              });
            },
          ),
          title: Text(person.name),
        );
      },
    );
  }
}
