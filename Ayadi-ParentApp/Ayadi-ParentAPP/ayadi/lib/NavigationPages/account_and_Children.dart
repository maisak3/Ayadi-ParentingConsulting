//import 'dart:html';

import 'package:ayadi/addChild/editChild.dart';
import 'package:ayadi/addChild/viewChildProfile.dart';
import 'package:ayadi/OTPs%20-%20register/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ayadi/NavigationPages/parentHomePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../Components/navigationBar.dart';
import '../WelcomePage.dart';
import '../addChild/addChild.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class accountChildren extends StatefulWidget {
  const accountChildren({super.key});

  @override
  State<accountChildren> createState() => _accountChildrenState();
}

class _accountChildrenState extends State<accountChildren> {
  int currentIndex = 0;
  // Get the current user
  final user = FirebaseAuth.instance.currentUser;
  String parentID = "";
  String parentFname = "";
  String parentLname = "";
  String parentPhone = "";
  double wallet = 0.0;
  bool showLoading = false;

  void logoutConfirm() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,

      headerAnimationLoop: false,
      animType: AnimType.rightSlide,

      title: 'هل انت متأكد من تسجيل الخروج؟',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {
        Navigator.of(context)
            .push(PageRouteBuilder(pageBuilder: (_, __, ___) => WelcomePage()));
      },

      btnCancelOnPress: () {},
      btnOkText: "نعم",
      btnCancelText: "لا",

      //btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  FindID() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('parent')
        .where('phone', isEqualTo: user!.phoneNumber)
        .get();

    final DocumentSnapshot doc = snapshot.docs.first;
    setState(() {
      parentID = doc.get('id').toString();
    });
  }

// Get the user's data
  void _getdata() async {
    setState(() {
      showLoading = true;
    });
    FirebaseFirestore.instance
        .collection('parent')
        .where("phone", isEqualTo: user!.phoneNumber)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          setState(() {
            parentFname = documentSnapshot['Fname'];
            parentLname = documentSnapshot['Lname'];
            parentPhone = documentSnapshot['phone'];
            wallet = documentSnapshot['wallet'] * 1.0;
            print(documentSnapshot['wallet']);
          });
        } else {
          print('No documents found');
        }
      } else {
        print('No documents found');
      }
      setState(() {
        showLoading = false;
      });
    });
  }

  void _showModalBottomSheetaddChild(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return addChild();
      },
    );
  }

  void _showModalBottomSheeteditProfile(BuildContext context) {
    _getdata();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return editProfile(
          Fname: parentFname,
          Lname: parentLname,
          phone: parentPhone,
        );
      },
    );
  }

  // void _showModalBottomSheeteditChild(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     barrierColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return editChild();
  //     },
  //   );
  // }

  void deleteConfirmed() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      title: 'تـم حـذف الـطـفـل بـنـجـاح',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {},
      btnOkText: "الـرجـوع",

      btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    //user = FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navigationBar(currentIndex: currentIndex),
      body: showLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(160, 145, 75, 185))),
            )
          : Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _showModalBottomSheeteditProfile(context);
                        },
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "الـملـف الـشـخـصـي",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    // Expanded(
                    //   child: SizedBox(
                    //     width: 10,
                    //   ),
                    // ),
                    TextButton(
                      onPressed: () {
                        logoutConfirm();
                      },
                      child: Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.deepPurple[400],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      //photo
                      //icon

                      Container(
                        alignment: Alignment.center,
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
                              size: 75,
                            ),
                          ),
                          radius: 60.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "${parentFname + " " + parentLname}",
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 23,
                              height: 1.5,
                              color: Color.fromARGB(170, 0, 0, 0)),
                        ),
                      ),

                      // phone
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          user!.phoneNumber!,
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 23,
                              height: 1.5,
                              color: Color.fromARGB(170, 0, 0, 0)),
                        ),
                      ),

                      // wallet
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wallet),
                          Text(
                            "$wallet",
                            style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 23,
                                height: 1.5,
                                color: Color.fromARGB(170, 0, 0, 0)),
                          ),
                        ],
                      )

                      // SizedBox(
                      //   height: 5,
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _showModalBottomSheetaddChild(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 3, left: 8, right: 4),
                        child: Icon(
                          Icons.add_circle,
                          size: 30,
                          color: Color.fromARGB(147, 124, 71, 203),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 22.0),
                        child: Text(
                          "أطـفـالـي",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("children")
                        .where("parentPhone", isEqualTo: user!.phoneNumber)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final children = snapshot.data!;
                        int count = children.size;

                        if (children.docs.isNotEmpty)
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 30.0),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: false,
                              itemCount: children.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool deleted = false;
                                String childFName =
                                    children.docs[index]['Fname'];
                                String childID = children.docs[index]['id'];
                                final DocumentSnapshot document =
                                    snapshot.data!.docs[index];

                                return Dismissible(
                                  key: Key(document.id),

                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.question,
                                      headerAnimationLoop: false,

                                      animType: AnimType.rightSlide,
                                      title:
                                          'هـل انـت مـتأكد مـن حـذف هـذا الـطـفل؟',
                                      //desc: 'Dialog description here.............',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () async {
                                        FirebaseFirestore.instance
                                            .collection('children')
                                            .doc(document.id)
                                            .delete();

                                        final QuerySnapshot querySnap =
                                            await FirebaseFirestore.instance
                                                .collection('sessions')
                                                .where('childID',
                                                    isEqualTo: document.id)
                                                .get();

                                        if (querySnap.docs.isNotEmpty) {
                                          final DocumentSnapshot doc =
                                              querySnap.docs.first;
                                          final DocumentReference docRef =
                                              doc.reference;

                                          await docRef.delete();
                                        }

                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    accountChildren()));
                                        deleteConfirmed();
                                        print("delete confirmation");
                                      },
                                      btnOkText: "نـعـم",
                                      btnCancelText: "الـرجـوع",
                                      btnOkColor:
                                          Color.fromARGB(193, 246, 7, 7),
                                      btnCancelColor: Colors.black26,
                                    )..show();
                                  },

                                  direction: DismissDirection
                                      .endToStart, // Set swipe direction to right only
                                  background: Container(
                                    color: Colors.red,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    margin: (index != count)
                                        ? EdgeInsets.only(bottom: 15)
                                        : EdgeInsets.only(bottom: 0),
                                    height: 80,

                                    padding: EdgeInsets.all(3),
                                    //margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      //color: Color.fromARGB(100, 209, 196, 233),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        print(childID);
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    viewChildProfile(
                                                      id: childID,
                                                    )));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          //arrow
                                          Icon(
                                            Icons.arrow_back_ios,
                                            color: Color.fromARGB(170, 0, 0, 0),
                                            size: 20,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: 180,
                                            ),
                                          ),
                                          // name
                                          Text(
                                            "${children.docs[index]['Fname'] + " " + children.docs[index]['Lname']}",
                                            style: TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                height: 1.5,
                                                color: Color.fromARGB(
                                                    170, 0, 0, 0)),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 3, left: 16, right: 4),
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color.fromRGBO(
                                                          247, 230, 206, 1),
                                                      width: 3,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60.0),
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
                                          ),
                                          // SizedBox(
                                          //   height: 5,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        else
                          return Container(
                              padding: EdgeInsets.only(top: 40),
                              child: Text("لايوجد أطفال مضافين"));
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
