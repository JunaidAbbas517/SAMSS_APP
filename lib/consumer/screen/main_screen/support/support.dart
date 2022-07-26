import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samss/consumer/model/report.dart';
import 'package:samss/consumer/model/user.dart';
import 'package:samss/consumer/screen/main_screen/Home_screen.dart';
import 'package:samss/consumer/screen/main_screen/support/display_report.dart';
import 'package:samss/shared/report.dart';
import 'package:xid/xid.dart';

class ConsumerReport extends StatefulWidget {
  @override
  State<ConsumerReport> createState() => _ConsumerReportState();
}

class _ConsumerReportState extends State<ConsumerReport> {
  final TextEditingController commentTitleController =
      new TextEditingController();
  final TextEditingController commentDesController =
      new TextEditingController();
  List<String> litems = [];
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loginUser = UserModel();
  var xid = Xid();
  // String uniqeId =

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
// report title field
    final titleFireld = Container(
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(183, 63, 81, 181),
            Color.fromARGB(131, 68, 137, 255),
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextFormField(
        maxLines: 1,
        minLines: 1,
        expands: false,
        keyboardType: TextInputType.multiline,
        controller: commentTitleController,
        onSaved: (value) {
          commentTitleController.text = value!;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          hintText: "Query Title.",
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );

    //Description field
    final descriptionField = Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(183, 63, 81, 181),
            Color.fromARGB(131, 68, 137, 255),
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextFormField(
        maxLines: 10,
        minLines: 10,
        expands: false,
        keyboardType: TextInputType.multiline,
        controller: commentDesController,
        onSaved: (value) {
          commentDesController.text = value!;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          hintText: "Query Description.",
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );

//save button
    final saveReportButton = Material(
      elevation: 20,
      color: Color.fromARGB(122, 68, 137, 255),
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.blueAccent),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 12,
        ),
        minWidth: MediaQuery.of(context).size.width - 60,
        onPressed: () {
          if (commentDesController.text.isNotEmpty &&
              commentTitleController.text.isNotEmpty) {
            reportDeatilToFirestore();
            report_Deatil_To_Firestore();
          }

          commentTitleController.clear();
          commentDesController.clear();
        },
        child: const Text(
          "Send Report",
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(220, 239, 242, 248),
          ),
        ),
      ),
    );

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
          title: Text("Support"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                titleFireld,
                descriptionField,
                saveReportButton,
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo,
                              Colors.blueAccent,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        height: 300,
                        width: MediaQuery.of(context).size.width - 60,
                        child: ReportDispaly(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future reportDeatilToFirestore() async {
    UserReport reportDetail = UserReport(
      account: loginUser.account,
      email: loginUser.email,
      firstName: loginUser.firstName,
      uid: loginUser.uid,
      messageTitle: commentTitleController.text,
      messageDescription: commentDesController.text,
      date: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection("user_report")
          .add(reportDetail.toMap());
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future report_Deatil_To_Firestore() async {
    Report report_Detail = Report(
      account: loginUser.account,
      email: loginUser.email,
      firstName: loginUser.firstName,
      uid: loginUser.uid,
      messageTitle: commentTitleController.text,
      messageDescription: commentDesController.text,
      date: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('report')
          .add(report_Detail.toMap());
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
