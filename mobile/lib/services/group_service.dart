import 'dart:async';
import './proxy.dart';
import '../config/env.dart';

import '../models/group.dart';

class GroupService extends ProxyService implements GroupRepository {
  String url = env.baseUrl + "groups/";

  Future<List<Group>> fetchAll() {
    return this.find("").then((response) {
      List<Group> groups = (response['data'] as List).map((item) {
        return new Group(item["id"], item["name"]);
      }).toList();

      return groups;
    });
  }

  static final GroupService instance = GroupService._private();
  GroupService._private();
  factory GroupService() => instance;
}
