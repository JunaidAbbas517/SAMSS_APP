import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserReport {
  String? messageTitle;
  String? messageDescription;
  String? uid;
  String? email;
  String? firstName;
  String? account;
  DateTime? date;

  UserReport(
      {this.messageTitle,
      this.messageDescription,
      this.uid,
      this.firstName,
      this.email,
      this.account,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      'messageTitle': messageTitle,
      'messageDescription': messageDescription,
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'account': account,
      'date': date,
    };
  }

  factory UserReport.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return UserReport(
      messageTitle: data?['messageTitle'],
      messageDescription: data?['messageDescription'],
      uid: data?['uid'],
      email: data?['email'],
      firstName: data?['firstName'],
      account: data?['account'],
      date: data?['date'],
    );
  }

  factory UserReport.fromMap(map) {
    return UserReport(
      messageTitle: map['messageTitle'],
      messageDescription: map['messageDescription'],
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      account: map['account'],
      date: map['date'],
    );
  }

  final CollectionReference subcollectionRefer = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("user_report");
  Stream<QuerySnapshot> get reports {
    return subcollectionRefer.snapshots();
  }
}
