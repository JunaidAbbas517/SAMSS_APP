import 'package:flutter/material.dart';
import 'package:samss/consumer/screen/main_screen/Home_screen.dart';
import 'package:samss/consumer/screen/main_screen/order_history/current_order.dart';
import 'package:samss/consumer/screen/main_screen/order_history/previous_order.dart';

class ConsumerOrderList extends StatefulWidget {
  ConsumerOrderList({Key? key}) : super(key: key);

  @override
  State<ConsumerOrderList> createState() => _ConsumerOrderListState();
}

class _ConsumerOrderListState extends State<ConsumerOrderList> {
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
//current order page button
    final currentOrderButton = Material(
      elevation: 10,
      color: Colors.blueAccent,
      borderRadius: const BorderRadius.all(
        Radius.circular(18),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        minWidth: 100,
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CurrentOrderList()));
        },
        child: const Text(
          "Current Order",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );

    //previous order page button
    final previousOrderButton = Material(
      elevation: 10,
      color: Colors.blueAccent,
      borderRadius: const BorderRadius.all(
        Radius.circular(18),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        minWidth: 100,
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PreviousOrderList()));
        },
        child: const Text(
          "Previous Orders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );

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
      body: Container(
        width: _width,
        height: _height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            currentOrderButton,
            SizedBox(
              height: 20,
            ),
            previousOrderButton,
          ],
        ),
      ),
    );
  }
}
