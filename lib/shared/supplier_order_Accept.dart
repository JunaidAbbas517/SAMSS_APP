class SupplierOrderAccept {
  String? uid;
  String? firstName;
  String? lastName;
  String? contact;
  String? stataionAdress;
  SupplierOrderAccept({
    this.uid,
    this.firstName,
    this.lastName,
    this.contact,
    this.stataionAdress,
  });

  //data from server
  factory SupplierOrderAccept.fromMap(map) {
    return SupplierOrderAccept(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['secondName'],
      contact: map['contact'],
      stataionAdress: map['stataionAdress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'secondName': lastName,
      'contact': contact,
      'stataionAdress': stataionAdress,
    };
  }
}
