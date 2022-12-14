import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
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

    FirebaseFirestore.instance
        .collection('supplier')
        .doc(user!.uid)
        .get()
        .then((value) {
      this.supplierModel = SupplierUserModel.fromMap(value.data());
      setState(() {});
    });

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      newOrder();
      FirebaseFirestore.instance
          .collection('order')
          .doc(orderUid)
          .get()
          .then((value) {
        this.orderUser = ConsumerOrderModel.fromMap(value.data());
        setState(() {});
      });
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
            child: supplierModel.accountStatus == "active"
                ? Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width - 50,
                    height: 200,
                    color: Color.fromARGB(166, 68, 137, 255),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: 80,
                        //   child: Lottie.asset(
                        //       "assets/anime/106576-water-drop.json"),
                        // ),
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
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        orderAcceptButton,
                        SizedBox(
                          height: 10,
                        ),
                        // orderIgnoreButton
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/anime/lf20_7jjpzooh.json"),
                      Text(
                        "You are inactive",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
          )
        : Center(
            child: supplierModel.accountStatus == "active"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/anime/lf20_odvvjvdp.json"),
                      Text(
                        "No new water tanker orders.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/anime/lf20_7jjpzooh.json"),
                      Text(
                        "You are inactive",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                        ),
                      ),
                    ],
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
