import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_main.dart';

class SupplierVerifyScreen extends StatefulWidget {
  @override
  _SupplierVerifyScreenState createState() => _SupplierVerifyScreenState();
}

class _SupplierVerifyScreenState extends State<SupplierVerifyScreen> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser!;
    user!.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Verification"),
        ),
        body: Center(
          child: Text(
            'An email has been sent to ${user!.email} please verify',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user!.reload();
    if (user!.emailVerified) {
      timer!.cancel();
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SupplierMain()));
      });
    }
  }
}
