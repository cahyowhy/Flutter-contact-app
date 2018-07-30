import './phone_number.dart';

class Contact {
  int id = 0;
  String website;
  String email;
  List<PhoneNumber> phone_numbers = [];

  Contact({this.website, this.email, this.phone_numbers});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    website = json["website"];
    email = json["email"];

    if (json.containsKey("phone_numbers")) {
      phone_numbers = (json['phone_numbers'] as List).map((phone_number) {
        return PhoneNumber.fromJson(phone_number);
      }).toList();
    }
  }

  Map<String, dynamic> toJson({bool useparent = false}) {
    Map<String, dynamic> json = {"website": website, "email": email, "id": id};

    if (useparent) {
      json = {"contact": json};
    }

    return json;
  }
}
