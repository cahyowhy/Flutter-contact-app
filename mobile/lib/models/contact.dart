import './phone_number.dart';

class Contact {
  int id;
  String website;
  String email;
  List<PhoneNumber> phone_numbers = [];

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

  Contact({this.website, this.email, this.phone_numbers});
}
