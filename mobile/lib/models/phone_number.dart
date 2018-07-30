class PhoneNumber {
  int id;
  String phone_number;

  String validatePhoneNumber(String phone) {
    return phone.length < 5 ? 'Isi dengan valid nomor telp' : null;
  }

  PhoneNumber.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    phone_number = json["phone_number"];
  }

  PhoneNumber(this.phone_number);
}
