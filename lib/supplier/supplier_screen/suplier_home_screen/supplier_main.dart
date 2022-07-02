import 'package:flutter/material.dart';
import 'package:samss/consumer/services/auth.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_home.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_order.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_setting/supplier_setting.dart';
import 'package:samss/supplier/supplier_screen/supplier_login_screen/supplier_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierMain extends StatefulWidget {
  SupplierMain({Key? key}) : super(key: key);

  @override
  State<SupplierMain> createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierMain> {
  final AuthServices _auth = AuthServices();

  int index = 0;
  String? _pageTitle;
  final screen = [
    SupplierHome(),
    SupplierOrder(),
    SupplierSetting(),
  ];

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      _pageTitle = "Home";
    } else if (index == 1) {
      _pageTitle = "Order History";
    } else if (index == 2) {
      _pageTitle = "Setting";
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("$_pageTitle"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
                final prefs = await SharedPreferences.getInstance();
                final success = await prefs.remove('email');
                final success1 = await prefs.remove('account');
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SupplierLogin()));
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: screen[index],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.white12,
              labelTextStyle:
                  MaterialStateProperty.all(TextStyle(color: Colors.white))),
          child: NavigationBar(
            selectedIndex: index,
            backgroundColor: Colors.blueAccent,
            height: 60,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home, color: Colors.white),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt, color: Colors.white),
                label: "Order Histroy",
              ),
              NavigationDestination(
                icon: Icon(Icons.settings, color: Colors.white),
                label: "Setting",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
