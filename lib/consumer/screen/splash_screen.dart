import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samss/consumer/screen/main_screen/Home_screen.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    _nagivateState();
  }

  void _nagivateState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('email')!;
      await Future.delayed(const Duration(milliseconds: 1000), () {});
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (final f in snapshot.docs) {
        if (f['uid'] == uid) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SupplierMain()));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset(
            "assets/image/logo3.png",
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }
}
