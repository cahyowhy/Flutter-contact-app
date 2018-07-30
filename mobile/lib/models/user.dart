import 'dart:async';
import './contact.dart';
import 'dart:convert';

class User {
  int id = 0;
  String name;
  String surname;
  String address;
  String dob;
  String about;
  String image_profile = "";
  String created_at = DateTime.now().toString();
  List<Contact> contacts = [];

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    surname = json["surname"];
    address = json["address"];
    dob = json["dob"];
    image_profile = json["image_profile"];
    created_at = json["created_at"];

    if (json.containsKey("contacts")) {
      contacts = (json['contacts'] as List).map((contact) {
        return Contact.fromJson(contact);
      }).toList();
    }
  }

  User(this.name, this.surname, this.dob, this.about, this.image_profile,
      {this.id = 0, this.address, this.contacts});

  String validateName(String name) {
    return name.length < 3 ? 'Isi minimal nama dengan 3 huruf' : null;
  }

  Map<String, dynamic> toJson({bool useparent = false}) {
    List contactJson = [];
    contacts.forEach((item) => contactJson.add(item.toJson()));
    
    Map<String, dynamic> json = {
      "id": id,
      "name": name,
      "address": address,
      "dob": dob,
      "about": about,
      "image_profile": image_profile,
      "contacts": contactJson
    };

    if (useparent) {
      json = {"user": json};
    }

    return json;
  }
}

abstract class UserRepository {
  Future<List<User>> fetchAll(Map param);

  Future<User> fetch(String id);

  Future<User> update(User user);

  Future<User> store(User user);

  Future<Map> remove(int id);
}
