import 'dart:async';
import './proxy.dart';
import '../config/env.dart';

import '../models/user_group.dart';

class UserGroupService extends ProxyService implements UserGroupRepository {
  String url = env.baseUrl + "user_groups/";

  Future<List<UserGroup>> fetch(int userId) {
    Map param = {"user_id": userId};

    return this.find(param).then((response) {
      List<UserGroup> userGroups = (response['data'] as List).map((item) {
        return UserGroup.fromJson(item);
      }).toList();

      return userGroups;
    });
  }

  Future<UserGroup> save(UserGroup usergroup) {
    return this.post(usergroup.toJson()).then((response) {
      return UserGroup.fromJson(response['data']);
    });
  }

  Future<Map> remove(int id) {
    return this.delete(id.toString());
  }

  static final UserGroupService instance = UserGroupService._private();
  UserGroupService._private();
  factory UserGroupService() => instance;
}
