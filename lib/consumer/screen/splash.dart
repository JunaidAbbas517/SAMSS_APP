import 'package:flutter/material.dart';
import 'package:samss/consumer/screen/log_screen/sign_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _nagivateState();
      });
    }
  }

  void _nagivateState() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000), () {});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
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
