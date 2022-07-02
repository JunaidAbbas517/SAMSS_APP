import 'package:flutter/material.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_main.dart';

class SupplierSplash extends StatefulWidget {
  SupplierSplash({Key? key}) : super(key: key);

  @override
  State<SupplierSplash> createState() => _SupplierSplashState();
}

class _SupplierSplashState extends State<SupplierSplash> {
  @override
  void initState() {
    super.initState();
    _nagivateState();
  }

  void _nagivateState() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000), () {});
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SupplierMain()));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Image.asset(
              "assets/image/logo3.png",
              height: 300,
              width: 300,
            ),
          ),
        ),
      ),
    );
  }
}
