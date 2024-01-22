import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ayadi/payment/paymentContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:intl/intl.dart';

import '../NavigationPages/account_and_Children.dart';

class PaymentInfo extends StatefulWidget {
  const PaymentInfo(
      {super.key,
      required this.childID,
      required this.childName,
      required this.specialistPhone,
      required this.date});
  final String? childID;
  final String? childName;
  final String specialistPhone;
  final DateTime date;

  @override
  State<PaymentInfo> createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {
  @override
  bool showLoading = false;
  String SPFname = "";
  String SPLname = "";
  String childFname = "";
  String childLname = "";
  var sessionPrice = 0;
  var wallet = 0.0;
  var total = 0.0;
  var totalUSD = 0.0;
  var updatedWallet = 0.0;

  void initState() {
    // TODO: implement initState
    super.initState();

    _getdata();

    //user = FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  User user = FirebaseAuth.instance.currentUser!;

  void _getdata() async {
    setState(() {
      showLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('parent')
        .where("phone", isEqualTo: user.phoneNumber)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          setState(() {
            wallet = documentSnapshot['wallet'] * 1.0;
          });
        } else {
          print('No documents found $widget.specialistPhone');
        }
      } else {
        print('No documents found ');
      }
    });
    // User user = _firebaseAuth.currentUser!;
    //print(user.phoneNumber);
    await FirebaseFirestore.instance
        .collection('specialist')
        .where("phoneNumber", isEqualTo: widget.specialistPhone)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          setState(() {
            SPFname = documentSnapshot['Fname'];
            SPLname = documentSnapshot['Lname'];
            sessionPrice = documentSnapshot['sessionPrice'];
          });
        } else {
          print('No documents found $widget.specialistPhone');
        }
      } else {
        print('No documents found ');
      }
    });
    //print(parentPhoneNo);

    await FirebaseFirestore.instance
        .collection('children')
        .where("id", isEqualTo: widget.childID)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          setState(() {
            childFname = documentSnapshot['Fname'];
            childLname = documentSnapshot['Lname'];
          });
        } else {
          print('No documents found $widget.childID');
        }
      } else {
        print('No documents found ');
      }
    });

    setState(() {
      if (wallet < sessionPrice) {
        total = sessionPrice - wallet;
        updatedWallet = 0.0;
      } else if (wallet == sessionPrice) {
        total = 0.0;
        updatedWallet = 0.0;
      } else if (wallet > sessionPrice) {
        total = 0.0;
        updatedWallet = wallet - sessionPrice;
        updatedWallet = double.parse(updatedWallet.toStringAsFixed(2));
        updatedWallet = updatedWallet * 1.0;
      }

      total = double.parse(total.toStringAsFixed(2));
      if (total != 0.0) {
        totalUSD = total / 3.75;
        totalUSD = double.parse(totalUSD.toStringAsFixed(2));
        print(totalUSD);
      } else {
        totalUSD = 1;
      }
      showLoading = false;
    });
  }

  Future<void> whenPaid() async {
    //update wallet

    final QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('parent')
        .where('phone', isEqualTo: user.phoneNumber)
        .limit(1)
        .get();

    if (querySnap.docs.isNotEmpty) {
      final DocumentSnapshot doc = querySnap.docs.first;
      final DocumentReference docRef = doc.reference;

      await docRef.update({
        'wallet': updatedWallet,
      });
      print("updated wallet $updatedWallet");
    }

    //book session
    final CollectionReference sessions =
        FirebaseFirestore.instance.collection('sessions');

    final DocumentReference newDocRef = sessions
        .doc(); // Create a new document reference without specifying the ID

    final String newDocId =
        newDocRef.id; // Retrieve the automatically generated document ID

    await newDocRef.set({
      'childID': widget.childID, // Include the ID in the document
      'date': widget.date,
      'isReported': false,
      'parentPhone': user.phoneNumber.toString(),
      'price': sessionPrice,
      'rate': 0,
      'report': "",
      'review': "",
      'specialistPhone': widget.specialistPhone,
      'time': "upcoming",
      'notification': "new"
    });

    print('Generated Document ID: $newDocId');

    setState(() {
      showLoading = false;
    });

    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => accountChildren()));

    //show confirmation
    sessionBooked();
  }

  void sessionBooked() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      //dismissOnTouchOutside: false,
      title: 'تـم حجز الجلسة بـنـجـاح',
      desc: 'يمكنك الاطلاع على تفاصيل الجلسة من جدول المواعيد',

      btnOkOnPress: () {},
      btnOkText: "الـرجـوع",

      btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        PaymentContainer(),
        showLoading
            ? const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(160, 145, 75, 185))),
              )
            : Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),

                    //text
                    Text(
                      'الـدفـع',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 83, 40, 108),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        'الاخصائي',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 83, 40, 108),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 50,
                          ),
                        ),
                        Text(
                          "$SPFname $SPLname",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 30),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(247, 230, 206, 1),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 35,
                              ),
                            ),
                            radius: 25.0,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        'الطفل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 83, 40, 108),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 50,
                          ),
                        ),
                        Text(
                          "$childFname $childLname",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 30),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(247, 230, 206, 1),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Image.asset(
                                "assets/kids.png",
                                height: 35,
                                width: 35,
                              ),
                            ),
                            radius: 25.0,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        'موعد الحجز',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 83, 40, 108),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        DateFormat('yyyy-MM-dd  :التاريخ\n     hh:mm a  :الوقت')
                            .format(widget.date),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        'تفاصيل الفاتورة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 83, 40, 108),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 30, left: 30),
                      child: Column(children: [
                        //text
                        Row(
                          children: [
                            Text(
                              'رس $sessionPrice',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 50,
                              ),
                            ),
                            Text(
                              'التكلفة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 83, 40, 108),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        //text
                        Row(
                          children: [
                            Text(
                              'رس $wallet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 50,
                              ),
                            ),
                            Text(
                              'المحفظة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 83, 40, 108),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        Row(
                          children: [
                            Text(
                              'رس $total',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 50,
                              ),
                            ),
                            Text(
                              'الاجمالي',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 83, 40, 108),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => PaypalCheckout(
                                sandboxMode: true,
                                clientId:
                                    "AcoJJlLaaX9Aff1Nl8rwQnwlaFFMpiOWhB9x454pGBjMgv4aLrLKewIwEss6d7btF59bdUfdBzzwbWBt",
                                secretKey:
                                    "EAzkgqnIO_LEQCP_ZL1x9hObnL1r4_08nBQxuiTIZMfF3Qj4ykgWNxroDCMCns1C5n1cLVfwWz-VIw8C",
                                returnURL: "success.snippetcoder.com",
                                cancelURL: "cancel.snippetcoder.com",
                                transactions: [
                                  {
                                    "amount": {
                                      "total": totalUSD.toString(),
                                      "currency": "USD",
                                      "details": {
                                        "subtotal": totalUSD.toString(),
                                        "shipping": '0',
                                        "shipping_discount": 0
                                      }
                                    },
                                    "description":
                                        "The payment transaction description.",
                                  }
                                ],
                                note:
                                    "Contact us for any questions on your order.",
                                onSuccess: (Map params) async {
                                  whenPaid();
                                  print("onSuccess: $params");
                                },
                                onError: (error) {
                                  print("onError: $error");
                                  Navigator.pop(context);
                                },
                                onCancel: () {
                                  print('cancelled:');
                                },
                              ),
                            ));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/paypal (1).png",
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'إكمال الدفع',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
