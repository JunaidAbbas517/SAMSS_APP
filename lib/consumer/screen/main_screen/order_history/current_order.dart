import 'package:flutter/material.dart';
import 'package:samss/consumer/screen/main_screen/order_history/order_list.dart';

class CurrentOrderList extends StatefulWidget {
  CurrentOrderList({Key? key}) : super(key: key);

  @override
  State<CurrentOrderList> createState() => _CurrentOrderListState();
}

class _CurrentOrderListState extends State<CurrentOrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ConsumerOrderList()));
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            label: Text(
              "Back",
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
      body: Container(
        child: Center(
          child: Text("Current order"),
        ),
      ),
    );
  }
}
