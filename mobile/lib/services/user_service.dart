import './proxy.dart';
import 'dart:async';
import '../config/env.dart';

import '../models/user.dart';

class UserService extends ProxyService implements UserRepository {
  String url = env.baseUrl + "users/";

  Future<List<User>> fetchAll(Map param) {
    return this.find(param).then((response) {
      List<User> users = (response['data'] as List).map((item) {
        return User.fromJson(item);
      }).toList();

      return users;
    });
  }

  Future<User> fetch(String id) {
    Map param = {"id": id, "offset": 0, "limit": 1};

    return this.find(param).then((responses) {
      return User.fromJson(responses["data"]);
    });
  }

  Future<User> update(User user) {
    return this.put(user.toJson(), user.id).then((response) {
      return User.fromJson(response);
    });
  }

  Future<User> store(User user) {}

  Future<Map> remove(int id) {
    return this.delete(id.toString()).then((response) {
      return response;
    });
  }

  static final UserService instance = UserService._private();
  UserService._private();
  factory UserService() => instance;
}
