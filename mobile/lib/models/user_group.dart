import 'dart:async';
import './group.dart';
import './user.dart';

class UserGroup {
  int id = 0;
  Group group;
  User user;

  UserGroup({this.id = 0, this.group, this.user});

  UserGroup.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    group = Group.fromJson(json["group"]);
    user = User.fromJson(json["user"]);
  }

  Map<String, dynamic> toJson() => {
        "user_group": {"user_id": user.id, "group_id": group.id}
      };
}

abstract class UserGroupRepository {
  Future<List<UserGroup>> fetch(int userId);
  Future<UserGroup> save(UserGroup usergroup);
  Future<Map> remove(int id);
}
