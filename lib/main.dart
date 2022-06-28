import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:samss/consumer/screen/splash.dart';
import 'package:samss/consumer/screen/splash_screen.dart';
import 'package:samss/consumer/services/notification.dart';
import 'package:samss/shared/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  String value = '';

  String? accountType;

  Future<bool> checkedLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getString('email')!;
    accountType = prefs.getString('account')!;
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        return FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("Something went wrongs");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SpinKitDualRing(
                  color: Colors.blueAccent,
                  size: 50.0,
                ));
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: FutureBuilder(
                    future: checkedLoginStatus(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData == false) {
                        return SplashScreen();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: SpinKitDualRing(
                          color: Colors.blueAccent,
                          size: 50.0,
                        ));
                      }
                      return SplashScreen1();
                    }),
              );
            });
        break;
      case ConnectivityResult.wifi:
        return FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("Something went wrongs");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SpinKitDualRing(
                  color: Colors.blueAccent,
                  size: 50.0,
                ));
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: FutureBuilder(
                    future: checkedLoginStatus(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData == false) {
                        return SplashScreen();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: SpinKitDualRing(
                          color: Colors.blueAccent,
                          size: 50.0,
                        ));
                      }
                      return SplashScreen1();
                    }),
              );
            });
        break;
      case ConnectivityResult.none:
      default:
        string = 'Offline';
    }

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/image/logo3.png",
              height: 300,
              width: 300,
            ),
            SizedBox(
              height: 10,
            ),
            SpinKitDualRing(
              color: Colors.blueAccent,
              size: 60.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
}
