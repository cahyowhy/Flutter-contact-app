import './base.dart';
import 'dart:async';

class User implements BaseEntity {
  int id;
  String name;
  String surname;
  String address;
  String dob;
  String about;
  String image_profile = "";
  String created_at = DateTime.now().toString(); 

  hasSuccess() {
    return name.isNotEmpty && surname.isNotEmpty && dob.isNotEmpty;
  }

  User(this.name, this.surname, this.dob, this.about, this.image_profile,{this.id = 0, this.address});
}

abstract class UserRepository {

  Future<List<User>> fetchAll(Map param);

  Future<User> fetch(String id);

  Future<User> update(User user);

  Future<User> store(User user);

  Future<Map> remove(int id);
}