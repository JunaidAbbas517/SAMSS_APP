import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samss/supplier/supplier_model/supplier_report.dart';
import 'package:samss/supplier/supplier_model/supplier_user.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_main.dart';
import 'package:samss/supplier/supplier_screen/suplier_home_screen/supplier_setting/display_supplier_report.dart';
import 'package:xid/xid.dart';

class SupplierReportMain extends StatefulWidget {
  @override
  State<SupplierReportMain> createState() => _ConsumerReportState();
}

class _ConsumerReportState extends State<SupplierReportMain> {
  final TextEditingController commentTitleController =
      new TextEditingController();
  final TextEditingController commentDesController =
      new TextEditingController();
  List<String> litems = [];
  User? user = FirebaseAuth.instance.currentUser;
  SupplierUserModel supplierModel = SupplierUserModel();

  var xid = Xid();
  // String uniqeId =

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('supplier')
        .doc(user!.uid)
        .get()
        .then((value) {
      this.supplierModel = SupplierUserModel.fromMap(value.data());
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
                    MaterialPageRoute(builder: (context) => SupplierMain()));
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
                        child: SupplierReportDisplay(),
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
    SupplierReport reportDetail = SupplierReport(
      account: supplierModel.account,
      email: supplierModel.email,
      firstName: supplierModel.firstName,
      uid: supplierModel.uid,
      messageTitle: commentTitleController.text,
      messageDescription: commentDesController.text,
      date: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('supplier')
          .doc(user!.uid)
          .collection("supplier_report")
          .add(reportDetail.toMap());
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
