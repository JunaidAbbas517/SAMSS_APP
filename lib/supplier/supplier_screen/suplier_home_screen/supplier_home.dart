import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samss/supplier/supplier_model/supplier_user.dart';

class SupplierHome extends StatefulWidget {
  SupplierHome({Key? key}) : super(key: key);

  @override
  State<SupplierHome> createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierHome> {
  User? user = FirebaseAuth.instance.currentUser;

  SupplierUserModel loginUser = SupplierUserModel();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('supplier')
        .doc(user!.uid)
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          this.loginUser = SupplierUserModel.fromMap(value.data());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Text(
              "${loginUser.firstName}  ${loginUser.lastName}",
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "${loginUser.email}",
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
