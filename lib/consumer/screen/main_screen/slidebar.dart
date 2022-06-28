import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samss/consumer/model/user.dart';
import 'package:samss/consumer/screen/log_screen/sign_screen.dart';
import 'package:samss/consumer/screen/main_screen/order_history/order_list.dart';
import 'package:samss/consumer/screen/main_screen/setting/setting.dart';
import 'package:samss/consumer/screen/main_screen/support/support.dart';
import 'package:samss/consumer/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlideBar extends StatefulWidget {
  SlideBar({Key? key}) : super(key: key);

  @override
  State<SlideBar> createState() => _SlideBarState();
}

class _SlideBarState extends State<SlideBar> {
  final AuthServices _auth = AuthServices();
  User? user = FirebaseAuth.instance.currentUser;

  UserModel loginUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loginUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

// signOut button
    final signOutButton = Material(
      elevation: 20,
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        minWidth: _screenWidth - 50,
        onPressed: () async {
          await _auth.signOut();
          final prefs = await SharedPreferences.getInstance();
          final success = await prefs.remove('email');
          final success1 = await prefs.remove('account');
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login()));
        },
        child: const Text(
          "SignOut",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );

    return Container(
      width: _screenWidth - 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo,
            Colors.blueAccent,
          ],
        ),
      ),
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "${loginUser.firstName}  ${loginUser.lastName}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            accountEmail: Text("${loginUser.email}"),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo,
                    Colors.blueAccent,
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                  ),
                )),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 40,
              color: Colors.white,
            ),
            title: Text(
              "Settings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Setting(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              size: 40,
              color: Colors.white,
            ),
            title: Text(
              "Order History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsumerOrderList(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.support_agent,
              size: 40,
              color: Colors.white,
            ),
            title: Text(
              "Support",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsumerReport(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 100,
          ),
          const Divider(
            color: Colors.white,
            indent: 20.0,
            endIndent: 10.0,
            thickness: 1,
          ),
          signOutButton,
        ],
      ),
    );
  }
}
