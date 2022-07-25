import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:samss/consumer/screen/main_screen/order_history/order_list.dart';

class PreviousOrderList extends StatefulWidget {
  PreviousOrderList({Key? key}) : super(key: key);

  @override
  State<PreviousOrderList> createState() => _PreviousOrderListState();
}

class _PreviousOrderListState extends State<PreviousOrderList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ConsumerOrderList()));
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              label: Text(
                "Back",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          title: Text("Order History"),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('order').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Column(
                  children: [
                    Lottie.asset("assets/anime/94539-order-history.json"),
                  ],
                );
              return ListView(
                children: getExpenseItems(snapshot),
              );
            }),
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => doc["consumerUid"] == FirebaseAuth.instance.currentUser!.uid
              ? Card(
                  child: ListTile(
                    title: Text("Order Status: " + doc["status"]),
                    subtitle: Text(
                      "Quantity: " +
                          doc["tankerQuantity"].toString() +
                          ",        Price: " +
                          doc["tankerPrice"].toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Wrap(),
        )
        .toList();
  }
}
