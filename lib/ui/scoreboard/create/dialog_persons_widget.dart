import 'package:flutter/material.dart';
import 'package:locale_scoreboard/ui/scoreboard/helpers/person_data.dart';

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
                shrinkWrap: true,
                itemCount: _persons.length,
                itemBuilder: (BuildContext context, int position) {
                  PersonData person = _persons[position];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pop(person.name);
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () async {
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