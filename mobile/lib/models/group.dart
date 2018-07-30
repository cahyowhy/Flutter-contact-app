import 'dart:async';

class Group {
  int id;
  String name;
  bool checked = true;

  Group(this.id, this.name);

  Group.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}

abstract class GroupRepository {
  
  Future<List<Group>> fetchAll();
}