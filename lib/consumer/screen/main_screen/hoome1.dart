import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samss/consumer/services/notification.dart';

class Status extends StatefulWidget {
  Status({Key? key}) : super(key: key);
  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          } else if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          dynamic data = snapshot.data;

          var status = data['level'];
          var m1 = "assets/image/tank1.png";
          if (status == null) {
            m1 = "assets/image/tank1.png";
          } else if (status == 0) {
            m1 = "assets/image/tank1.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 1 || status <= 14) {
            m1 = "assets/image/tank2.png";
            NotificationService().showNotification();
          } else if (status == 15 || status <= 29) {
            m1 = "assets/image/tank3.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 30 || status <= 44) {
            m1 = "assets/image/tank4.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 45 || status <= 59) {
            m1 = "assets/image/tank5.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 60 || status <= 74) {
            m1 = "assets/image/tank6.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 75 || status <= 89) {
            m1 = "assets/image/tank7.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 90 || status <= 100) {
            m1 = "assets/image/tank8.png";
            NotificationService().cancelAllNotifications();
          }

          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 300,
                height: 300,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Image.asset(
                  m1,
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['level'].toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                  Icon(Icons.percent_rounded),
                  // ],
                ],
              ),
            ],
          );
        });
  }
}
