import 'package:cloud_firestore/cloud_firestore.dart';

class ConsumerOrderModel {
  String? consumerUid;
  String? orderUid;
  String? email;
  String? firstName;
  String? lastName;
  String? status;
  String? contact;
  String? cityAddress;
  String? homeAddress;
  int? tankerQuantity;
  int? tankerPrice;

  ConsumerOrderModel(
      {this.consumerUid,
      this.orderUid,
      this.email,
      this.firstName,
      this.lastName,
      this.contact,
      this.status,
      this.cityAddress,
      this.homeAddress,
      this.tankerQuantity,
      this.tankerPrice});

//data from server
  factory ConsumerOrderModel.fromMap(map) {
    return ConsumerOrderModel(
        consumerUid: map['consumerUid'],
        orderUid: map['orderUid'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['secondName'],
        contact: map['contact'],
        status: map['status'],
        cityAddress: map['cityAddress'],
        homeAddress: map['homeAddress'],
        tankerQuantity: map['tankerQuantity'],
        tankerPrice: map['tankerPrice']);
  }

  factory ConsumerOrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return ConsumerOrderModel(
        consumerUid: data?['consumerUid'],
        orderUid: data?['orderUid'],
        email: data?['email'],
        firstName: data?['firstName'],
        lastName: data?['secondName'],
        contact: data?['contact'],
        status: data?['status'],
        cityAddress: data?['cityAddress'],
        homeAddress: data?['homeAddress'],
        tankerQuantity: data?['tankerQuantity'],
        tankerPrice: data?['tankerPrice']);
  }

  Map<String, dynamic> toMap() {
    return {
      'consumerUid': consumerUid,
      'orderUid': orderUid,
      'email': email,
      'firstName': firstName,
      'secondName': lastName,
      'contact': contact,
      'status': status,
      'cityAddress': cityAddress,
      'homeAddress': homeAddress,
      'tankerQuantity': tankerQuantity,
      'tankerPrice': tankerPrice,
    };
  }
}
