import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samss/consumer/model/user.dart';
import 'package:samss/consumer/model/user_tanki.dart';
import 'package:samss/consumer/screen/log_screen/sign_screen.dart';
import 'package:samss/consumer/screen/log_screen/verifying_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registeration extends StatefulWidget {
  Registeration({Key? key}) : super(key: key);

  @override
  State<Registeration> createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  late final String uid;
  bool _obscureText = true;
  bool _obscureText1 = true;

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final TextEditingController conformPasswordController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _screenHieght = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;

    final firstNameField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.name,
      controller: firstNameController,
      validator: (value) {
        RegExp regex = new RegExp(r'^[a-zA-Z]{3,}$');
        if (value!.isEmpty) {
          return ("Please Enter your First Name");
        } else if (!regex.hasMatch(value)) {
          return ("Please Enter Name of Atleast 3 Alphbets.");
        } else {
          return null;
        }
      },
      onSaved: (value) {
        firstNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );

    final lastNameField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.name,
      controller: lastNameController,
      validator: (value) {
        RegExp regex = new RegExp(r'^[a-zA-Z]{3,}$');
        if (value!.isEmpty) {
          return ("Please Enter your Last Name");
        } else if (!regex.hasMatch(value)) {
          return ("Please Enter name of 3 character or more");
        } else {
          return null;
        }
      },
      onSaved: (value) {
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: "Last Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );

    // contact filed
    final contactField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.phone,
      controller: contactController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{11,}$');
        if (value!.isEmpty) {
          return ("Please Enter your Contact.");
        } else if (!regex.hasMatch(value)) {
          return ("Please Enter name of 11 character or more");
        } else {
          return null;
        }
      },
      onSaved: (value) {
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.phone_android),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: "Contact",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );

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
        prefixIcon: Icon(Icons.mail),
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
      obscureText: _obscureText,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        suffixIcon: GestureDetector(
          onTap: (() {
            setState(() {
              _obscureText = !_obscureText;
            });
          }),
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue,
          ),
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

    final conformPasswordField = TextFormField(
      autofocus: false,
      controller: conformPasswordController,
      validator: (value) {
        if (conformPasswordController.text != passwordController.text) {
          return "Password do not match";
        }
        return null;
      },
      obscureText: _obscureText1,
      onSaved: (value) {
        conformPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        suffixIcon: GestureDetector(
          onTap: (() {
            setState(() {
              _obscureText1 = !_obscureText1;
            });
          }),
          child: Icon(
            _obscureText1 ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: "Conform Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );

    final registerButton = Material(
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
            registerWithEmailAndPassword(
                emailController.text, passwordController.text);
          }
        },
        child: const Text(
          "Create",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
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
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: EdgeInsets.all(10),
                      child: const Text(
                        "New Account",
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
                    const SizedBox(
                      height: 20,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: double.infinity,
                      height: _screenHieght - 245,
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
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 300,
                            height: 60,
                            child: firstNameField,
                          ),
                          Container(
                            width: 300,
                            height: 60,
                            child: lastNameField,
                          ),
                          Container(
                            width: 300,
                            height: 60,
                            child: contactField,
                          ),
                          Container(
                            width: 300,
                            height: 60,
                            child: emailField,
                          ),
                          Container(
                            width: 300,
                            height: 60,
                            child: passwordField,
                          ),
                          Container(
                            width: 300,
                            height: 60,
                            child: conformPasswordField,
                          ),
                          Container(
                            width: 250,
                            height: 40,
                            child: registerButton,
                          ),
                          const SizedBox(
                            height: 10,
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
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 62, 73, 78),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          )
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

  void registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailToFirebase()});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future postDetailToFirebase() async {
    User? user = _auth.currentUser;
    // for firestore
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.lastName = lastNameController.text;
    userModel.password = passwordController.text;
    userModel.contact = contactController.text;
    userModel.level = 0;
    userModel.account = 'consumer';

    try {
      // //create refrence in realtime
      // final DatabaseReference ref = FirebaseDatabase.instance.ref(
      //     "https://samss1-default-rtdb.asia-southeast1.firebasedatabase.app/");

      //create collection in firestor
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      // save data in firestore
      await userCollection
          .doc(user.uid)
          .set(userModel.toMap())
          .then((value) async {
        final prefs = await SharedPreferences.getInstance();

        // save data in realtime
        // ref.child(user.uid).set(userTankiModel.toMap());
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => VerifyScreen()),
            (route) => false);
        await prefs.setString('email', user.uid);
      });
      Fluttertoast.showToast(msg: "Account created sucessfully");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
