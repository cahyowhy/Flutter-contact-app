import '../models/user.dart';
import './proxy.dart';
import 'dart:async';
import '../config/env.dart';

class UserService extends ProxyService implements UserRepository {
  String url = env.baseUrl + "users/";

  Future<List<User>> fetchAll(Map param) {
    return this.find(param).then((response) {
      List<User> users = [];
      (response['data'] as List).forEach((item) {
        users.add(new User(item['name'], item['surname'], item['dob'],
            item['about'], item['image_profile'],
            id: item['id'], address: item['address']));
      });

      return users;
    });
  }

  Future<User> fetch(String id) {
    return this.find(id).then((response) {
      return new User(response['name'], response['surname'], response['dob'],
          response['about'], response['image_profile'], address: response['address']);
    });
  }

  Future<User> update(User user) {}

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
