import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:samss/consumer/model/user.dart';
import 'package:samss/consumer/screen/main_screen/hoome1.dart';
import 'package:samss/consumer/screen/main_screen/order_screen/order.dart';
import 'package:samss/consumer/screen/main_screen/slidebar.dart';
import 'package:samss/shared/consumer_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xid/xid.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int tankerQuantity = 0;
  int price = 0;
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController cityController = new TextEditingController();

  String _apartmentAddress = "";
  String _cityAddress = " ";

  UserModel loginUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
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

  Widget build(BuildContext context) {
    final _screenHieght = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;

    //Appartment/Home Address
    final apartmentAddress = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.streetAddress,
      controller: addressController,
      validator: (value) {},
      onSaved: (value) {
        addressController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color.fromARGB(123, 255, 255, 255)),
        prefixIcon: Icon(
          Icons.home_work_outlined,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: "Enter Apertment/Home Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );

    //city address
    final cityAddress = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.streetAddress,
      controller: cityController,
      validator: (value) {},
      onSaved: (value) {
        cityController.text = value!;
      },
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color.fromARGB(119, 255, 255, 255)),
        prefixIcon: Icon(
          Icons.location_city,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        hintText: "Enter City",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );

    // Done button form address
    final doneAddressButton = Material(
      elevation: 10,
      color: Colors.blue,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blueAccent),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (addressController.text.isEmpty ||
              cityController.text.isEmpty ||
              addressController.text == '' ||
              cityController.text == '') {
            Fluttertoast.showToast(
                msg:
                    "Please enter Address e.g. House#10,st#11,sihala,islamabad");
          } else {
            setState(() {
              _apartmentAddress = addressController.text;
              _cityAddress = cityController.text;
              Navigator.pop(context, 'Done');
            });
          }
        },
        child: const Text(
          "Done",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );

//Clear filed button
    final clearAddressButon = Material(
      elevation: 10,
      color: Colors.blue,
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
          vertical: 10,
        ),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            addressController.text = "";
            cityController.text = '';
            _apartmentAddress = addressController.text;
            _cityAddress = cityController.text;
          });
        },
        child: const Text(
          "Clear",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );

//location fieldd

    final locationField = Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(55, 63, 81, 181),
            Color.fromARGB(55, 68, 137, 255),
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: Colors.blueAccent,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                final locationDialogBox = showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                    transform: Matrix4.translationValues(0, 0, 0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo,
                          Colors.blueAccent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(60),
                            padding: EdgeInsets.all(20),
                            child: const Text(
                              "Address",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          apartmentAddress,
                          SizedBox(
                            height: 30,
                          ),
                          cityAddress,
                          SizedBox(
                            height: 80,
                          ),
                          doneAddressButton,
                          SizedBox(
                            height: 20,
                          ),
                          clearAddressButon,
                        ],
                      ),
                    ),
                  ),
                  context: context,
                );
              },
              child: Text(
                "${_apartmentAddress}, ${_cityAddress}",
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final orderButton = Material(
      elevation: 10,
      color: Colors.blue,
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
          vertical: 10,
        ),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          postOrderDetailToFirebase();
        },
        child: const Text(
          "Order",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        drawer: SlideBar(),
        body: Container(
          width: _screenWidth,
          height: _screenHieght,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo,
                Colors.blueAccent,
              ],
            ),
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Status(),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  transform: Matrix4.translationValues(0, 0, 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Water Tanker",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.blue.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            "Number Of Tanker Order.",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue.shade400,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          //margin: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                  child: Icon(
                                    Icons.arrow_left,
                                    size: 40,
                                    color: Colors.blue.shade400,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (tankerQuantity <= 0) {
                                        return;
                                      }
                                      tankerQuantity = tankerQuantity - 1;
                                      price = 1200 * tankerQuantity;
                                    });
                                  }),
                              Text(
                                "$tankerQuantity",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue.shade400,
                                ),
                              ),
                              GestureDetector(
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 40,
                                    color: Colors.blue.shade400,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      tankerQuantity = tankerQuantity + 1;
                                      price = 1200 * tankerQuantity;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          child: Text(
                            'Total Price: $price',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        locationField,
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 250,
                          height: 40,
                          child: orderButton,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future postOrderDetailToFirebase() async {
    var xid = Xid();
    ConsumerOrderModel orderDetail = ConsumerOrderModel();
    orderDetail.email = loginUser.email;
    orderDetail.consumerUid = loginUser.uid;
    orderDetail.firstName = loginUser.firstName;
    orderDetail.lastName = loginUser.lastName;
    orderDetail.contact = loginUser.contact;
    orderDetail.orderUid = xid.toString();
    orderDetail.cityAddress = addressController.text;
    orderDetail.homeAddress = cityController.text;
    orderDetail.status = 'new';
    orderDetail.tankerQuantity = tankerQuantity;
    orderDetail.tankerPrice = price;
    orderDetail.supplierUid = null;
    orderDetail.supplerRate = 0;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (tankerQuantity != 0 &&
          addressController.text.isNotEmpty &&
          cityController.text.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('order')
            .doc("$xid")
            .set(orderDetail.toMap());
        await prefs.setString('orderUid', xid.toString());
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => OrderScreen()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: "Check Tanker Quantity/Address.");
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
