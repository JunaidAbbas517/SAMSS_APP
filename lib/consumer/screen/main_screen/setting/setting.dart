import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samss/consumer/model/user.dart';
import 'package:samss/consumer/screen/log_screen/sign_screen.dart';
import 'package:samss/consumer/screen/main_screen/Home_screen.dart';
import 'package:samss/consumer/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final AuthServices _auth = AuthServices();
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController contactController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
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
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    contactController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // first name field
    Future updateFirstName() async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Your First Name"),
              content: TextFormField(
                keyboardType: TextInputType.name,
                controller: firstNameController,
                validator: (value) {},
                onSaved: (value) {
                  firstNameController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  hintText: "Enter your first name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (firstNameController.text.isNotEmpty) {
                      if (firstNameController.text.length >= 3) {
                        final docUser = FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        docUser.update({'firstName': firstNameController.text});
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Setting()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please enter atleast 3 character.");
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please enter first name.");
                    }
                  },
                  child: Text("Save"),
                )
              ],
            ));

    final firstName = Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(55, 63, 81, 181),
            Color.fromARGB(55, 68, 137, 255),
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${loginUser.firstName}",
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: true,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              updateFirstName();
            },
            child: Icon(
              Icons.edit,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );

    // last name field
    Future updateLastName() async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Your Last Name"),
              content: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.name,
                controller: lastNameController,
                validator: (value) {},
                onSaved: (value) {
                  lastNameController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  hintText: "Enter your Last name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (lastNameController.text.isNotEmpty) {
                      if (lastNameController.text.length >= 3) {
                        final docUser = FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        docUser.update({'secondName': lastNameController.text});
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Setting()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please enter atleast 3 character.");
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please enter last name.");
                    }
                  },
                  child: Text("Save"),
                )
              ],
            ));

    final lasttName = Container(
      height: 50,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(55, 63, 81, 181),
              Color.fromARGB(55, 68, 137, 255),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${loginUser.lastName}",
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              updateLastName();
            },
            child: Icon(
              Icons.edit,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );

// contact filed
    Future updateContact() async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Your Contact Number"),
              content: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.phone,
                controller: contactController,
                validator: (value) {},
                onSaved: (value) {
                  lastNameController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  hintText: "Enter your contact number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (contactController.text.isNotEmpty) {
                      if (contactController.text.length == 11) {
                        final docUser = FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        docUser.update({'contact': contactController.text});
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Setting()));
                      } else {
                        Fluttertoast.showToast(msg: "Please enter 11 digits.");
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please enter contact.");
                    }
                  },
                  child: Text("Save"),
                )
              ],
            ));

    final contact = Container(
      height: 50,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(55, 63, 81, 181),
              Color.fromARGB(55, 68, 137, 255),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${loginUser.contact}",
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              updateContact();
            },
            child: Icon(
              Icons.edit,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );

// password field
    Future updatePassword() async => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Your Password"),
            content: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              controller: passwordController,
              validator: (value) {},
              obscureText: true,
              onSaved: (value) {
                passwordController.text = value!;
              },
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                hintText: "Enter your password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (passwordController.text.isNotEmpty) {
                    if (passwordController.text.length >= 6) {
                      final docUser = FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid);
                      docUser.update({'password': passwordController.text});
                      final passwordUpdate = await FirebaseAuth
                          .instance.currentUser
                          ?.updatePassword(passwordController.text);
                      await _auth.signOut();
                      final prefs = await SharedPreferences.getInstance();
                      final success = await prefs.remove('email');
                      final success1 = await prefs.remove('account');
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Login()));
                      Fluttertoast.showToast(
                          msg: "Password Change Successfully.");
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please enter atlest 6 character.");
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please enter password.");
                  }
                },
                child: Text("Save"),
              )
            ],
          ),
        );

    final passwordField = Container(
      height: 50,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(55, 63, 81, 181),
              Color.fromARGB(55, 68, 137, 255),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${loginUser.password}",
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              updatePassword();
            },
            child: Icon(
              Icons.edit,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );

//display
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              label: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          title: Text("Setting"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                  child: const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60),
                  padding: EdgeInsets.only(top: 10),
                  height: 40,
                  child: Text(
                    "First Name",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                firstName,
                Container(
                  margin: EdgeInsets.only(left: 60, top: 10),
                  padding: EdgeInsets.only(top: 10),
                  height: 40,
                  child: Text(
                    "Last Name",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                lasttName,
                Container(
                  margin: EdgeInsets.only(left: 60, top: 10),
                  padding: EdgeInsets.only(top: 10),
                  height: 40,
                  child: Text(
                    "Contact",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                contact,
                Container(
                  margin: EdgeInsets.only(left: 60, top: 10),
                  padding: EdgeInsets.only(top: 10),
                  height: 40,
                  child: Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                passwordField,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
