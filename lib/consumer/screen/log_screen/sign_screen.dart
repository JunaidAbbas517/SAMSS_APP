import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samss/consumer/screen/log_screen/reset_page.dart';
import 'package:samss/consumer/screen/main_screen/Home_screen.dart';
import 'package:samss/consumer/screen/log_screen/register_screen.dart';
import 'package:samss/supplier/supplier_screen/supplier_login_screen/supplier_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  String? email;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final _screenHieght = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;

    widget.email = emailController.text;

//email field
    final emailField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your Email");
        } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter valid email");
        } else {
          return null;
        }
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.mail,
          color: Colors.blue,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );

//password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter your password");
        } else if (!regex.hasMatch(value)) {
          return ("Please Enter password of 6 character");
        } else {
          return null;
        }
      },
      obscureText: true,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Colors.blue,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );

// Login Button
    final loginButton = Material(
      elevation: 10,
      // color: Colors.blue,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blue),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            signInWithEmailAndPassword(
                emailController.text, passwordController.text);
          }
        },
        child: const Text(
          "Login",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );

    //registeration Button
    final registeration = Material(
      elevation: 10,
      // color: Colors.blue,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blue),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Registeration()));
        },
        child: const Text(
          "Create Account",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );

    final resetPassword = Material(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ResetScreen()));
        },
        child: const Text(
          "Forget Password?",
          style: TextStyle(
              color: Color.fromARGB(255, 62, 73, 78),
              fontWeight: FontWeight.w700),
        ),
      ),
    );

    // Toggle button
    final toggle = Container(
      margin: const EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(2),
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.home,
                color: Colors.blue,
              ), // <-- Icon
              Text("Consumer",
                  style: TextStyle(
                    color: Colors.blue,
                  )), // <-- Text
            ],
          ),
          const SizedBox(width: 10),
          const Text(
            "|",
            style: TextStyle(
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SupplierLogin()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.directions_bus,
                  color: Colors.grey,
                ), // <-- Icon
                Text("Supplier"), // <-- Text
              ],
            ),
          ),
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo,
                Colors.blueAccent,
              ],
            ),
          ),
          width: _screenWidth,
          height: _screenHieght,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      padding: EdgeInsets.all(10),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(
                      "Consumer",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    AnimatedContainer(
                      margin: const EdgeInsets.only(top: 40),
                      duration: const Duration(milliseconds: 500),
                      width: double.infinity,
                      height: 480,
                      transform: Matrix4.translationValues(0, 0, 0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          toggle,
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 300,
                            child: emailField,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 300,
                            child: passwordField,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 300,
                            child: resetPassword,
                            alignment: FractionalOffset(0.1, 0),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 150,
                            height: 40,
                            child: loginButton,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Expanded(
                                child: Divider(
                                  indent: 20.0,
                                  endIndent: 10.0,
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                "OR",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              Expanded(
                                child: Divider(
                                  indent: 10.0,
                                  endIndent: 20.0,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 10),
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 250,
                            height: 40,
                            child: registeration,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (final f in snapshot.docs) {
        if (f['email'] == email) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          await prefs.setString('email', userCredential.user!.uid);
          await prefs.setString('account', f['account']);
          break;
        } else {
          Fluttertoast.showToast(msg: "You are not consumer");
        }
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";

          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage);
    }
  }
}
