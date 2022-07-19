import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SupplierOrder extends StatefulWidget {
  SupplierOrder({Key? key}) : super(key: key);

  @override
  State<SupplierOrder> createState() => _SupplierOrderState();
}

class _SupplierOrderState extends State<SupplierOrder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('order').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("There is no expense");
          return ListView(
            children: getOrder(snapshot),
          );
        });
  }

  getOrder(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => doc["supplierUid"] == FirebaseAuth.instance.currentUser!.uid
              ? Card(
                  child: ListTile(
                    title: Text("Consumer: " +
                        doc["firstName"] +
                        " " +
                        doc["secondName"] +
                        "  | Order Status: " +
                        doc["status"]),
                    subtitle: Text(
                      "Quantity: " +
                          doc["tankerQuantity"].toString() +
                          " | Price: " +
                          doc["tankerPrice"].toString() +
                          " | Address: " +
                          doc["cityAddress"] +
                          ", " +
                          doc["homeAddress"],
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Wrap(),
        )
        .toList();
  }
}
