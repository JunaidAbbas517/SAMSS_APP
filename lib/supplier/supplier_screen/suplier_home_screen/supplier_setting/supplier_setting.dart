import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:samss/consumer/services/auth.dart';
import 'package:samss/supplier/supplier_model/supplier_user.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_setting/suppiler_support.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_setting/supplier_profile.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SupplierSetting extends StatefulWidget {
  SupplierSetting({Key? key}) : super(key: key);

  @override
  State<SupplierSetting> createState() => _SupplierSettingState();
}

class _SupplierSettingState extends State<SupplierSetting> {
  final AuthServices _auth = AuthServices();
  User? user = FirebaseAuth.instance.currentUser;
  SupplierUserModel loginUser = SupplierUserModel();

  int _initialLabelIndex = 0;
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
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    //Active or inactive Toggle button
    final activeButton = Material(
      child: ToggleSwitch(
        minWidth: 100.0,
        initialLabelIndex: _initialLabelIndex,
        cornerRadius: 20.0,
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.grey,
        inactiveFgColor: Colors.white,
        totalSwitches: 2,
        labels: ['Active', 'Inactive'],
        icons: [Icons.person_outline, Icons.person_off_outlined],
        activeBgColors: [
          [Colors.blueAccent],
          [Colors.blueAccent]
        ],
        onToggle: (index) {
          print('switched to: $index');

          if (index == 0) {
            final docUser = FirebaseFirestore.instance
                .collection('supplier')
                .doc(FirebaseAuth.instance.currentUser!.uid);
            docUser.update({'accountStatus': "active"});
          } else {
            final docUser = FirebaseFirestore.instance
                .collection('supplier')
                .doc(FirebaseAuth.instance.currentUser!.uid);
            docUser.update({'accountStatus': "inactive"});
          }
        },
      ),
    );

//profil button
    final profileButton = Material(
      elevation: 20,
      color: Color.fromARGB(230, 68, 137, 255),
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.all(10),
          height: 30,
          width: _screenWidth - 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list_alt_sharp,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SupplierProfile()));
        },
      ),
    );

    // suport button
    final supportButton = Material(
      elevation: 20,
      color: Color.fromARGB(230, 68, 137, 255),
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.all(10),
          height: 30,
          width: _screenWidth - 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Support",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SupplierReportMain()));
        },
      ),
    );

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("supplier")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold();
          }

          dynamic data = snapshot.data;

          var per = data['accountStatus'];
          if (per == "active") {
            _initialLabelIndex = 0;
          }
          if (per == "inactive") {
            _initialLabelIndex = 1;
          }

          return Container(
            width: _screenWidth,
            height: _screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 170,
                  child:
                      Lottie.asset("assets/anime/10450-icon-set-setting.json"),
                ),
                activeButton,
                SizedBox(
                  height: 40,
                ),
                profileButton,
                SizedBox(
                  height: 40,
                ),
                supportButton
              ],
            ),
          );
        });
  }
}
