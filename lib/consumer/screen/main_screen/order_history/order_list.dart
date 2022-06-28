import 'package:flutter/material.dart';
import 'package:samss/consumer/screen/main_screen/Home_screen.dart';

class ConsumerOrderList extends StatefulWidget {
  ConsumerOrderList({Key? key}) : super(key: key);

  @override
  State<ConsumerOrderList> createState() => _ConsumerOrderListState();
}

class _ConsumerOrderListState extends State<ConsumerOrderList> {
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text("Order History"),
        centerTitle: true,
      ),
    );
  }
}
