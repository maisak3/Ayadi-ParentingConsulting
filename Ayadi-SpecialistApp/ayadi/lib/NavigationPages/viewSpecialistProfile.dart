import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ayadi/Reg-login/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:ayadi/Components/navigationBar.dart';

import 'package:readmore/readmore.dart';

import '../WelcomePage.dart';

class viewSpecialistProfile extends StatefulWidget {
  const viewSpecialistProfile({super.key});

  @override
  State<viewSpecialistProfile> createState() => _viewSpecialistProfileState();
}

class _viewSpecialistProfileState extends State<viewSpecialistProfile> {
  final user = FirebaseAuth.instance.currentUser!.phoneNumber;

  // final Stream<QuerySnapshot> readProfile = FirebaseFirestore.instance
  //     .collection("specialist")
  //     .where("email", isEqualTo: user)
  //     .snapshots();

  List<DocumentSnapshot> profile = [];
  int count = 0;
  String specialistFname = "";
  String specialistLname = "";
  String specialization = "";
  String specialistBio = "";
  String specialistPhone = "";
  String specialistIban = "";
  String language = "";
  int experience = 0;
  var sessionPrice = 0;
  var numOfRates = 0;
  var rate = 0 * 1.0;
  double avgRate = 0.0;
  int currentIndex = 0;
  bool loadImage = true;
  bool noReviews = false;

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMM, yyyy').format(dateFromTimeStamp);
  }

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

  void _showModalBottomSheeteditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return editProfile(
          Fname: specialistFname,
          Lname: specialistLname,
          phone: specialistPhone,
          IBAN: specialistIban,
          bio: specialistBio,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navigationBar(currentIndex: currentIndex),
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Container(
              height: 180, //+30
              color: Color.fromRGBO(247, 230, 206, 1),
            ),
            // button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //edit button
                Padding(
                  padding: const EdgeInsets.only(
                    top: 85, //55
                    left: 30,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _showModalBottomSheeteditProfile(context);
                    },
                    child: Container(
                      // child: CircleAvatar(
                      // backgroundColor: Color.fromRGBO(217, 204, 225, 1),
                      child: Icon(
                        Icons.edit,
                        color: Color(0xFF914BB9),
                        size: 30,
                        weight: 2,
                        //textDirection: ui.TextDirection.rtl,
                      ),
                      //radius: 20.0,
                      // ),
                    ),
                  ),
                ),

                Expanded(child: SizedBox()),

                Padding(
                  padding: const EdgeInsets.only(top: 65.0), //75
                  child: TextButton(
                    onPressed: () {
                      logoutConfirm();
                    },
                    child: Icon(
                      Icons.logout,
                      size: 30,
                      color: Color(0xFF914BB9),
                    ),
                  ),
                ),
              ],
            ),
            //icon

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("specialist")
                  .where("phoneNumber", isEqualTo: user)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final profile = snapshot.data!.docs;
                  count = profile.length;

                  for (var n = 0; n < profile.length; n++) {
                    specialistFname = profile[n]['Fname'];
                    specialistLname = profile[n]['Lname'];
                    specialization = profile[n]['specialization'];
                    specialistBio = profile[n]['bio'];
                    sessionPrice = profile[n]['sessionPrice'];
                    numOfRates = profile[n]['numOfRates'];
                    specialistPhone = profile[n]['phoneNumber'];
                    specialistIban = profile[n]['IBAN'];

                    // experience = profile[n]['experience'];
                    // avgRate = profile[n]['avgRate'] as double;
                  }
                  return Column(
                    children: [
                      //icon
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 110), //80
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

                      //
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: SizedBox(
                            child: Text(
                              textAlign: TextAlign.center,
                              "${specialistFname}" + " " + "${specialistLname}",
                              style: GoogleFonts.vazirmatn(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xaa53a6b8),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: SizedBox(
                            child: Text(
                              textAlign: TextAlign.center,
                              "${specialization}",
                              style: GoogleFonts.vazirmatn(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF914BB9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //bio
                      Container(
                        padding: EdgeInsets.only(
                          right: 5,
                          left: 5,
                        ),
                        width: 360,
                        child: ReadMoreText(
                          "${specialistBio}",
                          style: GoogleFonts.vazirmatn(
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 99, 99, 99),
                          ),
                          textAlign: TextAlign.right,
                          trimLength: 100,
                          trimMode: TrimMode.Length,
                          trimCollapsedText: "أكثر ",
                          trimExpandedText: "  أقل",
                          moreStyle: GoogleFonts.vazirmatn(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF914BB9),
                            decoration: TextDecoration.underline,
                          ),
                          lessStyle: GoogleFonts.vazirmatn(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF914BB9),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(right: 30, top: 20),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       if (experience == 1 || experience > 10)
                      //         Text(
                      //           "سنة",
                      //           style: GoogleFonts.vazirmatn(
                      //             fontSize: 15,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       if (experience == 2)
                      //         Text(
                      //           "سنتين",
                      //           style: GoogleFonts.vazirmatn(
                      //             fontSize: 15,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       if (experience > 2 && experience < 11)
                      //         Text(
                      //           "سنوات",
                      //           style: GoogleFonts.vazirmatn(
                      //             fontSize: 15,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       Text(
                      //         experience > 2 ? "${experience} " : " ",
                      //         style: GoogleFonts.vazirmatn(
                      //           fontSize: 15,
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //       // Text(
                      //       //   ': ' + 'الخبرة' + ' ',
                      //       //   style: GoogleFonts.vazirmatn(
                      //       //     fontSize: 15,
                      //       //     color: Colors.grey,
                      //       //   ),
                      //       // ),
                      //       // Icon(
                      //       //   Icons.hotel_class_rounded,
                      //       //   size: 30,
                      //       //   color: Color.fromRGBO(174, 194, 179, 0.78),
                      //       // ),
                      //     ],
                      //   ),
                      // ),

                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'التقييمات' + ' ',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //ratings

                      // Container(
                      //   decoration: new BoxDecoration(
                      //     shape: BoxShape.rectangle,
                      //     color: const Color(0xFFFFFF),
                      //     borderRadius:
                      //         new BorderRadius.all(new Radius.circular(32.0)),
                      //   ),
                      //   child: RatingBarIndicator(
                      //     rating: avgRate,
                      //     itemSize: 20,
                      //     direction: Axis.horizontal,
                      //     itemCount: 5,
                      //     itemPadding: EdgeInsets.symmetric(horizontal: 0),
                      //     itemBuilder: (context, _) => Icon(
                      //       Icons.star,
                      //       color: Colors.amber,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(width: 5),

                      // Text(
                      //   avgRate.toStringAsFixed(1),
                      //   style: TextStyle(
                      //     color: Color(0xff4e4a8c),
                      //     fontSize: 25,
                      //     fontFamily: 'Alice',
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 10, right: 5),
                          //   child: Text(
                          //     textAlign: TextAlign.right,
                          //     "( تقييمًا",
                          //     style: GoogleFonts.vazirmatn(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.grey,
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.only(top: 10, right: 10),
                          //   child: Text(
                          //     textAlign: TextAlign.right,
                          //     " ${numOfRates}" + " )",
                          //     style: GoogleFonts.vazirmatn(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.grey,
                          //     ),
                          //   ),
                          // ),

                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('sessions')
                                .where('specialistPhone', isEqualTo: user)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Stack(
                                  children: [
                                    Container(
                                      child: RatingBarIndicator(
                                        rating: 0,
                                        itemSize: 25,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              //
                              final _data = snapshot.data?.docs;
                              double total = 0, length = 0;
                              for (var data in _data!) {
                                if (data.get("rate") * 1.0 != 0) {
                                  length++;
                                  total += data.get("rate") * 1.0;
                                }
                              }
                              rate = length == 0 ? 0.0 : (total / length);
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, right: 30),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: const Color(0xFFFFFF),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(32.0)),
                                      ),
                                      child: RatingBarIndicator(
                                        rating: length == 0
                                            ? 0.0
                                            : (total / length),
                                        itemSize: 25,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Text(
                                  //   _data.isEmpty
                                  //       ? "0"
                                  //       : "(" +
                                  //           length.toStringAsFixed(0) +
                                  //           "تقيمًا)",
                                  //   style: GoogleFonts.vazirmatn(
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Color(0xFF914BB9),
                                  //   ),
                                  // ),
                                ],
                              );
                            },
                          ),

//                             // Text(
//                             //   textAlign: TextAlign.right,
//                             //   "${numOfRates}",
//                             //   style: GoogleFonts.vazirmatn(
//                             //     fontSize: 15,
//                             //     //fontWeight: FontWeight.bold,
//                             //     color: Colors.grey,
//                             //   ),
//                             // ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 350,
                        height: 0,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 0.0, color: Colors.black),
                          ),
                        ),
                      ),

                      //reviwe
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("sessions")
                            .orderBy('date', descending: false)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            final reviews1 = snapshot.data!.docs;
                            loadImage = true;
                            List reviews = [];
                            for (int i = 0; i < reviews1.length; i++) {
                              if ((reviews1[i]["specialistPhone"] ==
                                      specialistPhone) &&
                                  (reviews1[i]["review"] != "")) {
                                loadImage = false;
                                reviews.add(reviews1[i]);
                                print("review added");
                              }
                            }
                            if (!loadImage)
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 10, right: 15),
                                  physics: BouncingScrollPhysics(),

                                  ///
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,

                                  itemCount: reviews.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String parentName = "";
                                    String parentID = "";
                                    // if ((reviews[index]['specialistPhone'] ==
                                    //         specialistPhone) &&
                                    //     reviews[index]['review'] != "") {
                                    //   //loadImage = true;
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("children")
                                          .where('id',
                                              isEqualTo: reviews[index]
                                                  ['childID'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          final children = snapshot.data!.docs;
                                          parentID = children[0]['parentPhone'];
                                          return StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("parent")
                                                .where('phone',
                                                    isEqualTo: children[0]
                                                        ['parentPhone'])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final parent =
                                                    snapshot.data!.docs;
                                                if (parent.length == 0)
                                                  noReviews = true;
                                                else
                                                  noReviews = false;
                                                parentName = parent[0]
                                                        ['Fname'] +
                                                    " " +
                                                    parent[0]['Lname'];
                                                parentName = "****" +
                                                    parentName.substring(0, 3);
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 0,
                                                      right: 20),
                                                  margin: new EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            Color(0x3f000000),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                    color: Color(0xfff5f5f5),
                                                  ),
                                                  child: Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment
                                                    //         .spaceBetween,
                                                    children: [
                                                      Column(
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment
                                                        //         .start,
                                                        // crossAxisAlignment:
                                                        //     CrossAxisAlignment
                                                        //         .end,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10,
                                                            ),
                                                            decoration:
                                                                new BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              color:
                                                                  const Color(
                                                                      0xFFFFFF),
                                                              borderRadius:
                                                                  new BorderRadius
                                                                      .all(new Radius
                                                                          .circular(
                                                                      32.0)),
                                                            ),
                                                            // child: Center(
                                                            //   child:
                                                            //       RatingBarIndicator(
                                                            //     rating: reviews[
                                                            //             index]
                                                            //         ['rate'],
                                                            //     itemSize: 22,
                                                            //     direction: Axis
                                                            //         .horizontal,
                                                            //     itemCount: 5,
                                                            //     itemPadding: EdgeInsets
                                                            //         .symmetric(
                                                            //             horizontal:
                                                            //                 0),
                                                            //     itemBuilder:
                                                            //         (context,
                                                            //                 _) =>
                                                            //             Icon(
                                                            //       Icons.star,
                                                            //       color: Colors
                                                            //           .amber,
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                5),
                                                                        // width: MediaQuery.of(context)
                                                                        //         .size
                                                                        //         .width *
                                                                        //     .20,
                                                                        // height: 20.0,
                                                                        decoration:
                                                                            new BoxDecoration(
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          color:
                                                                              const Color(0xFFFFFF),
                                                                          borderRadius:
                                                                              new BorderRadius.all(new Radius.circular(32.0)),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              RatingBarIndicator(
                                                                            rating:
                                                                                (reviews[index]['rate']) * 1.0,
                                                                            itemSize:
                                                                                15,
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            itemCount:
                                                                                5,
                                                                            itemPadding:
                                                                                EdgeInsets.symmetric(horizontal: 0),
                                                                            itemBuilder: (context, _) =>
                                                                                Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        formattedDate(reviews[index]
                                                                            [
                                                                            'date']),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black54,
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                      ),
                                                                    ]),
                                                                Text(
                                                                  parentName,
                                                                  style: GoogleFonts
                                                                      .vazirmatn(
                                                                    color: Color(
                                                                        0xFF914BB9),
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            // Text(
                                                            //   parentName,
                                                            //   style: TextStyle(
                                                            //     color: Color(
                                                            //         0xff4e4a8c),
                                                            //     fontSize: 22,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .bold,
                                                            //     // height: 1.5.h,
                                                            //   ),
                                                            // ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "${reviews[index]['review']}",
                                                              style: GoogleFonts
                                                                  .vazirmatn(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                height: 1.5,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            else
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Image.asset(
                                    "assets/reviews.jpg",
                                    height: 120,
                                    width: 180,
                                  ),
                                  Text(
                                    "لا توجد مراجعات",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromRGBO(71, 55, 164, 1)),
                                  ),
                                ],
                              );
                          } else {
                            return Container();
                          }
                        },
                      ),

                      //reviwe
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
