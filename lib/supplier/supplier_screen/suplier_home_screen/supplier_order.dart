import 'package:flutter/material.dart';

class SupplierOrder extends StatefulWidget {
  SupplierOrder({Key? key}) : super(key: key);

  @override
  State<SupplierOrder> createState() => _SupplierOrderState();
}

class _SupplierOrderState extends State<SupplierOrder> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('order History'),
      ),
    );
  }
}
