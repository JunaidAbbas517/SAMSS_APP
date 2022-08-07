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

          var per = data['level'];
          per = per.round();

          var status = data['level'];

          var m1 = "assets/image/tank1.png";
          if (status == null) {
            m1 = "assets/image/tank1.png";
          } else if (status == 0) {
            m1 = "assets/image/tank1.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 2 || status <= 15) {
            m1 = "assets/image/tank2.png";
            NotificationService().showNotification();
          } else if (status == 16 || status <= 28) {
            m1 = "assets/image/tank3.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 29 || status <= 42) {
            m1 = "assets/image/tank4.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 43 || status <= 54) {
            m1 = "assets/image/tank5.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 55 || status <= 70) {
            m1 = "assets/image/tank6.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 71 || status <= 85) {
            m1 = "assets/image/tank7.png";
            NotificationService().cancelAllNotifications();
          } else if (status == 86 || status <= 100) {
            m1 = "assets/image/tank8.png";
            NotificationService().cancelAllNotifications();
          }

          // var per = (data['level'] * 100) / 24;
          // per = per.round();

          // var status = 24 - data['level'];
          // var m1 = "assets/image/tank1.png";
          // if (status == null) {
          //   m1 = "assets/image/tank1.png";
          // } else if (status == 0) {
          //   m1 = "assets/image/tank8.png";
          //   NotificationService().cancelAllNotifications();
          // } else if (status == 1 || status <= 5) {
          //   m1 = "assets/image/tank8.png";
          //   NotificationService().cancelAllNotifications();
          // } else if (status == 6 || status <= 8) {
          //   m1 = "assets/image/tank7.png";
          //   NotificationService().cancelAllNotifications();
          // } else if (status == 9 || status <= 11) {
          //   m1 = "assets/image/tank6.png";
          //   NotificationService().cancelAllNotifications();
          // } else if (status == 12 || status <= 14) {
          //   m1 = "assets/image/tank5.png";
          //   NotificationService().cancelAllNotifications();
          // } else if (status == 15 || status <= 17) {
          //   m1 = "assets/image/tank4.png";
          //   NotificationService().cancelAllNotifications();
          // } else if (status == 18 || status <= 20) {
          //   m1 = "assets/image/tank3.png";
          //   NotificationService().cancelAllNotifications();
          // } else if (status == 21 || status <= 24) {
          //   m1 = "assets/image/tank2.png";
          //   NotificationService().showNotification();
          // }

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
                  // if (data['level'] >= 24) ...[
                  //   Text(
                  //     "100",
                  //     style: TextStyle(fontSize: 30),
                  //   ),
                  //   Icon(Icons.percent_rounded),
                  // ] else ...
                  // [
                  Text(
                    "$per",
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
