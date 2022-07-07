import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samss/shared/consumer_order.dart';
import 'package:samss/shared/supplier_order_Accept.dart';
import 'package:samss/supplier/supplier_model/supplier_user.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_orders/supplier_AcceptOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierHome extends StatefulWidget {
  SupplierHome({Key? key}) : super(key: key);

  @override
  State<SupplierHome> createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierHome> {
  User? user = FirebaseAuth.instance.currentUser;

  ConsumerOrderModel orderUser = ConsumerOrderModel();
  SupplierUserModel supplierModel = SupplierUserModel();
  late Timer timer;
  String? orderUid;
  String? status;
  @override
  void initState() {
    super.initState();
    newOrder();
    setState(() {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          FirebaseFirestore.instance
              .collection('order')
              .doc(orderUid)
              .get()
              .then((value) {
            this.orderUser = ConsumerOrderModel.fromMap(value.data());
            setState(() {});
          });
        });
      });
    });

    FirebaseFirestore.instance
        .collection('supplier')
        .doc(user!.uid)
        .get()
        .then((value) {
      this.supplierModel = SupplierUserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    // order Accept button
    final orderAcceptButton = Material(
      elevation: 10,
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: Container(
        height: 40,
        width: _screenWidth - 200,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            supplierDeatilToFirestore();
            timer.cancel();
            final docUser = FirebaseFirestore.instance
                .collection('supplier')
                .doc(FirebaseAuth.instance.currentUser!.uid);
            docUser.update({'status': 0});
            final orderStatusChange =
                FirebaseFirestore.instance.collection('order').doc(orderUid);
            orderStatusChange.update({'status': "pending"});
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SupplierAcception()));
          },
          child: const Text(
            "Accept",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );

    // ignor button
    final orderIgnoreButton = Material(
      elevation: 10,
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: Container(
        height: 40,
        width: _screenWidth - 200,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {},
          child: const Text(
            "Ignore",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );

    return orderUser.status == "new"
        ? Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width - 50,
              height: 200,
              color: Colors.blueAccent,
              child: Column(
                children: [
                  Text(
                    "Consumer: ${orderUser.firstName} ${orderUser.lastName}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Location: ${orderUser.homeAddress}, ${orderUser.cityAddress}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  orderAcceptButton,
                  SizedBox(
                    height: 10,
                  ),
                  orderIgnoreButton
                ],
              ),
            ),
          )
        : Center(
            child: Text(
              "No new water tanker orders to supply",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
              ),
            ),
          );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  Future newOrder() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('order').get();
      for (final f in snapshot.docs) {
        if (f['status'] == "new") {
          orderUid = f['orderUid'];
          print(orderUid);
          break;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future supplierDeatilToFirestore() async {
    SupplierOrderAccept supplierDetail = SupplierOrderAccept(
      firstName: supplierModel.firstName,
      uid: supplierModel.uid,
      lastName: supplierModel.lastName,
      contact: supplierModel.contact,
      stataionAdress: supplierModel.stataionAdress,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance
          .collection('order')
          .doc(orderUid)
          .collection("supplier_detail")
          .add(supplierDetail.toMap());
      await prefs.setString('orderuid', orderUid!);
      print("order Id is " + orderUid!);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
