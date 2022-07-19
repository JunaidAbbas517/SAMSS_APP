import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samss/consumer/screen/main_screen/order_history/order_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../order_screen/order.dart';

class CurrentOrderList extends StatefulWidget {
  CurrentOrderList({Key? key}) : super(key: key);

  @override
  State<CurrentOrderList> createState() => _CurrentOrderListState();
}

class _CurrentOrderListState extends State<CurrentOrderList> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nagivateState();
  }

  void _nagivateState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('orderUid')!;
      print(uid);
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('order').get();
      for (final f in snapshot.docs) {
        if (f["consumerUid"] == FirebaseAuth.instance.currentUser!.uid &&
            f["status"] == "pending" &&
            uid != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OrderScreen()));
          break;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ConsumerOrderList()));
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
      body: Container(),
    );
  }
}
