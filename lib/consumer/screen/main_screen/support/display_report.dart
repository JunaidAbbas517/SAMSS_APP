import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samss/consumer/model/report.dart';

class ReportDispaly extends StatefulWidget {
  @override
  _SubCategoryClassState createState() => _SubCategoryClassState();
}

class _SubCategoryClassState extends State<ReportDispaly> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("user_report")
      .snapshots();
  UserReport reportDetail = UserReport();

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            //dialog Box for detail of the query
            Future<void> _showDetail() async {
              return showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(data['messageTitle']),
                    content: Text(data['messageDescription']),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Back'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }

            Timestamp? date = data['date'];
            DateTime myDateTime = date!.toDate();
            print(myDateTime.toString());
            return Card(
              margin: const EdgeInsets.fromLTRB(10, 6, 10, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showDetail();
                    },
                    child: Container(
                      width: 230,
                      child: ListTile(
                        title: Text(data['messageTitle']),
                        subtitle: Text(myDateTime.toString()),
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: (() {
                  //     // FirebaseFirestore.instance
                  //     //     .collection('users')
                  //     //     .doc(FirebaseAuth.instance.currentUser!.uid)
                  //     //     .collection('user_orders')
                  //     //     .doc(document.id)
                  //     //     .delete();
                  //     // setState(() {});
                  //   }),
                  //   child: Icon(
                  //     Icons.delete_forever_outlined,
                  //     color: Colors.blueAccent,
                  //   ),
                  // )
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
