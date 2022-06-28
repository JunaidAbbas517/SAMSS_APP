class SupplierUserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  int? status;
  String? contact;
  String? stataionAdress;
  String? account;

  SupplierUserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.password,
      this.status,
      this.contact,
      this.stataionAdress,
      this.account});

//data from server
  factory SupplierUserModel.fromMap(map) {
    return SupplierUserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['secondName'],
        password: map['password'],
        status: map['status'],
        contact: map['contact'],
        stataionAdress: map['stataionAdress'],
        account: map['account']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': lastName,
      'password': password,
      'contact': contact,
      'status': status,
      'stataionAdress': stataionAdress,
      'account': account,
    };
  }
}
