import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samss/shared/consumer_order.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierAcception extends StatefulWidget {
  SupplierAcception({Key? key}) : super(key: key);

  @override
  State<SupplierAcception> createState() => _SupplierAcceptionState();
}

class _SupplierAcceptionState extends State<SupplierAcception> {
  User? user = FirebaseAuth.instance.currentUser;
  String? currentOrderUid;
  ConsumerOrderModel order = ConsumerOrderModel();
  late Timer timer;
  void initState() {
    // TODO: implement initState
    super.initState();
    orderStatusDetail();
    setState(() {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          FirebaseFirestore.instance
              .collection('order')
              .doc(currentOrderUid)
              .get()
              .then((value) {
            this.order = ConsumerOrderModel.fromMap(value.data());
            setState(() {});
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //continue button
    final continueButton = Material(
      elevation: 10,
      color: Colors.blueAccent,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width - 200,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            final orderStatusChange = FirebaseFirestore.instance
                .collection('order')
                .doc(order.orderUid);
            orderStatusChange.update({'status': "complete"});
            final docUser = FirebaseFirestore.instance
                .collection('supplier')
                .doc(FirebaseAuth.instance.currentUser!.uid);
            docUser.update({'status': 1});
            final prefs = await SharedPreferences.getInstance();
            final success = await prefs.remove('orderuid');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SupplierMain()));
          },
          child: const Text(
            "Continue",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              },
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              label: Text(
                "Home",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          title: Text("Order Status"),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Order Detail",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Consumer: ${order.firstName} ${order.lastName}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Contact: ${order.contact}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Consumer Address: ${order.homeAddress}, ${order.cityAddress}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              continueButton,
            ],
          )),
        ),
      ),
    );
  }

  Future orderStatusDetail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      currentOrderUid = prefs.getString('orderuid')!;
      print("current order is " + currentOrderUid!);
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }
}
