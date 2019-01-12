import 'package:locale_scoreboard/helpers/db_helpers.dart';
import 'package:locale_scoreboard/helpers/db_sql_create.dart';
import 'package:locale_scoreboard/helpers/system_helpers.dart';

class PersonData {
  String id;
  String name;

  PersonData({this.id, this.name});

  Future<int> save() async {
    int returnValue = 0;
    List<Map<String, dynamic>> list = await DbHelpers.query(DbSql.tablePersons, where: "name = ?", whereArgs: [name]);

    if (list.length == 0) {
      id = SystemHelpers.generateUuid();
      returnValue = await DbHelpers.insert(DbSql.tablePersons, this.toMap());
    }
    
    return returnValue;
  }

  Future<int> delete() {
    return DbHelpers.deleteById(DbSql.tablePersons, id);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }

  factory PersonData.fromMap(Map<String, dynamic> item) {
    return PersonData(id: item["id"], name: item["name"]);
  }

  factory PersonData.create(String name) {
    return PersonData(name: name);
  }

  static Future<List<PersonData>> getPersons() async {
    List<Map<String, dynamic>> items = await DbHelpers.query(DbSql.tablePersons, orderBy: "name");
    return items.map<PersonData>((Map<String, dynamic> item) {
      return PersonData.fromMap(item);
    }).toList();
  }
}
