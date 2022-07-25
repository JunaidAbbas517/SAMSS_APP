import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:samss/consumer/screen/main_screen/Home_screen.dart';

import 'package:samss/consumer/services/tanker_notification.dart';
import 'package:samss/shared/consumer_order.dart';
import 'package:samss/shared/supplier_order_Accept.dart';
import 'package:samss/supplier/supplier_model/supplier_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _currentstep = 0;
  String? currentOrderUid;
  String supplierFName = '';
  String supplierSName = '';

  String contact = '';

  int supplierRating = 0;

  bool completeButtonDisable = true;

  bool showButtomDrawer = false;

  SupplierUserModel supplierModel = SupplierUserModel();
  SupplierOrderAccept orderAccept = SupplierOrderAccept();
  ConsumerOrderModel order = ConsumerOrderModel();
  User? user = FirebaseAuth.instance.currentUser;
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderStatusDetail();

    timer = Timer.periodic(Duration(microseconds: 10), (_) {
      setState(() {
        FirebaseFirestore.instance
            .collection('order')
            .doc(currentOrderUid)
            .get()
            .then((value) {
          this.order = ConsumerOrderModel.fromMap(value.data());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var threshold = 100;

    // conform button
    final conformButton = Material(
      elevation: 10,
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: completeButtonDisable == false
            ? () async {
                final prefs = await SharedPreferences.getInstance();

                QuerySnapshot snapshot =
                    await FirebaseFirestore.instance.collection('order').get();
                for (final f in snapshot.docs) {
                  if (f['consumerUid'] == user!.uid) {
                    if (f['status'] == 'complete') {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(
                                  "Feedback",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Please rate supplier.",
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RatingBar.builder(
                                        itemPadding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        updateOnDrag: true,
                                        minRating: 1,
                                        itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.blueAccent,
                                            ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            this.supplierRating =
                                                rating.toInt();
                                          });
                                        }),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Save'),
                                    onPressed: () {
                                      print(
                                          "supplier uid is: ${order.supplierUid}");

                                      FirebaseFirestore.instance
                                          .collection('supplier')
                                          .where('uid',
                                              isEqualTo: order.supplierUid)
                                          .get()
                                          .then((value) {
                                        value.docs.forEach((element) {
                                          print(
                                              "supplier name is from supplier collection: ${element.id}");
                                          FirebaseFirestore.instance
                                              .collection('supplier')
                                              .doc(element.id)
                                              .get()
                                              .then((value) {
                                            this.supplierModel =
                                                SupplierUserModel.fromMap(
                                                    value.data());
                                            print(
                                                "supplier total rating from supplier collection: ${supplierModel.totalRating}");
                                            int rating =
                                                supplierModel.totalRating!;
                                            print("rating $rating");
                                            supplierRating += rating;
                                            final docUser = FirebaseFirestore
                                                .instance
                                                .collection('supplier')
                                                .doc(order.supplierUid);
                                            docUser.update({
                                              'totalRating': supplierRating
                                            });
                                            timer.cancel();
                                          });
                                        });
                                      });

                                      timer.cancel();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                    },
                                  ),
                                ],
                              ));

                      final success1 = await prefs.remove('orderUid');
                      break;
                    } else {
                      Fluttertoast.showToast(msg: "Order is pending.");
                    }
                    break;
                  }
                }
              }
            : null,
        child: const Text(
          "Complete",
          style: TextStyle(fontSize: 22, color: Colors.blueAccent),
        ),
      ),
    );

    // Supplier detail buttom drawer
    final buttomDrawer = ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Column(
            children: [
              const Text(
                "Supplier Detail",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                ),
              ),
              const Text(
                "Swap up for suplier detail",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo,
                        Colors.blueAccent,
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Card(
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Supplier:  ${supplierFName}  ${supplierSName}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Conatact:  ${contact}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    if (order.status == "new") {
      _currentstep = 0;
      TankerNotificationService().cancelAllNotifications();
    } else if (order.status == "pending") {
      _currentstep = 1;
      TankerNotificationService().showNotification();
    } else if (order.status == "complete") {
      _currentstep = 2;
      completeButtonDisable = false;
      timer.cancel;
      TankerNotificationService().cancelAllNotifications();
    }

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onPanEnd: ((details) async {
            if (details.velocity.pixelsPerSecond.dy > threshold) {
              setState(() {
                showButtomDrawer = false;
                supplierDetail();
              });
            } else if (details.velocity.pixelsPerSecond.dy < -threshold) {
              setState(() {
                showButtomDrawer = true;
                supplierDetail();
              });
            }
          }),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo,
                  Colors.blueAccent,
                ],
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: const Text(
                        "Supplier Status",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color.fromARGB(96, 255, 255, 255),
                          ),
                        ),
                        child: Stepper(
                          currentStep: _currentstep,
                          steps: [
                            Step(
                              state: _currentstep <= 0
                                  ? StepState.editing
                                  : StepState.complete,
                              isActive: _currentstep >= 0,
                              title: const Text(
                                'Searching Supplier',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              content: Center(
                                heightFactor: 1,
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                        "assets/anime/lf20_v0v93atd.json",
                                        height: 150),
                                    Text(
                                      'Searching for water tanker supplier.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              state: _currentstep <= 1
                                  ? StepState.editing
                                  : StepState.complete,
                              isActive: _currentstep >= 1,
                              title: const Text(
                                'Accept Order',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              content: Center(
                                heightFactor: 1,
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                        "assets/anime/41058-gasolin-tanker.json",
                                        height: 150),
                                    Text(
                                      'Water Tanker in on way to destination.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              state: _currentstep <= 2
                                  ? StepState.editing
                                  : StepState.complete,
                              isActive: _currentstep >= 2,
                              title: const Text(
                                'Order Complete',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              content: Center(
                                heightFactor: 1,
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                        "assets/anime/24209-house-ou-apartment.json",
                                        height: 150),
                                    Text(
                                      'Water Tanker reach to destination.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                          controlsBuilder: (context, details) {
                            return Row(
                              children: [],
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: conformButton,
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
                Positioned(
                  child: buttomDrawer,
                  left: 0,
                  bottom: (showButtomDrawer) ? 0 : -80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  Future orderStatusDetail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      currentOrderUid = prefs.getString('orderUid')!;
      print(currentOrderUid);
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  Future supplierDetail() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('order')
          .doc(currentOrderUid)
          .collection("supplier_detail")
          .get();
      for (final f in snapshot.docs) {
        supplierFName = f['firstName'];
        supplierSName = f['secondName'];
        contact = f['contact'];
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
