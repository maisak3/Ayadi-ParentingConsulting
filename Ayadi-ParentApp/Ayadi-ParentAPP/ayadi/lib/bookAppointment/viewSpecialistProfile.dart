import 'package:ayadi/addChild/editChild.dart';
import 'package:ayadi/bookAppointment/BookAppointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:readmore/readmore.dart';

class viewSpecialistProfile extends StatefulWidget {
  const viewSpecialistProfile({super.key, required this.specialistPhone});
  final specialistPhone;

  @override
  State<viewSpecialistProfile> createState() =>
      _viewSpecialistProfileState(specialistPhone);
}

class _viewSpecialistProfileState extends State<viewSpecialistProfile> {
  String specialistPhone1;
  _viewSpecialistProfileState(this.specialistPhone1);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var specialistFname = "";
  var specialistLname = "";
  var specialization = "";
  var specialistBio = "";
  var experience = 0;
  var sessionPrice = 0;
  var numOfRates = 0;
  var rate = 0;
  double avgRate = 0.0;
  bool showLoading = true;

  int count = 0;

  void initState() {
    // TODO: implement initState
    super.initState();
    showLoading = true;
    _getdata();
    //user = FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  void _getdata() async {
    setState(() {
      showLoading = true;
      print(showLoading);
    });
    FirebaseFirestore.instance
        .collection("specialist")
        .where("phoneNumber", isEqualTo: specialistPhone1)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          //var date = documentSnapshot.data();
          setState(() {
            specialistFname = documentSnapshot['Fname'];
            specialistLname = documentSnapshot['Lname'];
            specialization = documentSnapshot['specialization'];
            specialistBio = documentSnapshot['bio'];
            sessionPrice = documentSnapshot['sessionPrice'];
            avgRate = documentSnapshot['avgRate'] * 1.0;
            //specialistPhone = documentSnapshot['phoneNumber'];
          });
        }
      }
      setState(() {
        showLoading = false;
        print(showLoading);
      });
    });

    // setState(() {
    //   showLoading = false;
    //   print(showLoading);
    // });
  }

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMM, yyyy').format(dateFromTimeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 15,
              ),
              child: Container(
                height: 110,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(217, 204, 225, 1),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BookAppointment(specialistID: specialistPhone1)));
                  },
                  child: Text(
                    'حجز موعد جديد',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF914BB9),
                    ),
                  ),
                  //style: ButtonStyle(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 14,
                right: 30,
              ),
              child: Row(
                children: [
                  Text(
                    "دقيقة",
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "  45",
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "  / ",
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    " ر.س",
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "  ${sessionPrice}",
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: showLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(160, 145, 75, 185))),
            )
          : SingleChildScrollView(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      color: Color.fromRGBO(247, 230, 206, 1),
                    ),
                    //back button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 52,
                            right: 30,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(247, 230, 206, 1),
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Color(0xFF914BB9),
                                  size: 25,
                                  weight: 2,
                                  textDirection: ui.TextDirection.rtl,
                                ),
                                radius: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //icon

                    Column(
                      children: [
                        //icon
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 80),
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
                                "${specialistFname}" +
                                    " " +
                                    "${specialistLname}",
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
                          width: 350,
                          child: ReadMoreText(
                            "${specialistBio}",
                            style: GoogleFonts.vazirmatn(
                              fontSize: 15,
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey,
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

                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (experience == 1 || experience > 10)
                                Text(
                                  "سنة",
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              if (experience == 2)
                                Text(
                                  "سنتين",
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              if (experience > 2 && experience < 11)
                                Text(
                                  "سنوات",
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              // Text(
                              //   experience > 2 ? "${experience} " : " ",
                              //   style: GoogleFonts.vazirmatn(
                              //     fontSize: 15,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              // Text(
                              //   ': ' + 'الخبرة' + ' ',
                              //   style: GoogleFonts.vazirmatn(
                              //     fontSize: 15,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              // Icon(
                              //   Icons.hotel_class_rounded,
                              //   size: 30,
                              //   color: Color.fromRGBO(174, 194, 179, 0.78),
                              // ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
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
                        // SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Row(
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
                              Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: const Color(0xFFFFFF),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(32.0)),
                                ),
                                child: RatingBarIndicator(
                                  rating: avgRate,
                                  itemSize: 20,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 0,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 0.0, color: Colors.black),
                            ),
                          ),
                        ),

                        //reviwe
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("sessions")
                              .orderBy("date", descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              final Allreviews = snapshot.data!.docs;
                              List<QueryDocumentSnapshot<Object?>> reviews = [];
                              for (int i = 0; i < Allreviews.length; i++) {
                                if ((Allreviews[i]["specialistPhone"] ==
                                        specialistPhone1) &&
                                    (Allreviews[i]["review"] != "")) {
                                  reviews.add(Allreviews[i]);
                                }
                              }
                              print("num of reviews are ${reviews.length}");
                              if (reviews.isNotEmpty) {
                                return ListView.builder(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 10, right: 15),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: reviews.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String parentName = "";
                                    //String parentID = "";
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("parent")
                                          .where('phone',
                                              isEqualTo: reviews[index]
                                                  ['parentPhone'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          final parent = snapshot.data!.docs;
                                          //parentID = parent[index]['parentPhone'];
                                          parentName = parent[0]['Fname'] +
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
                                            margin:
                                                new EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x3f000000),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                              color: Color(0xfff5f5f5),
                                            ),
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 10,
                                                      ),
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        color: const Color(
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
                                                  child: Row(
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
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                              // width: MediaQuery.of(context)
                                                              //         .size
                                                              //         .width *
                                                              //     .20,
                                                              // height: 20.0,
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
                                                              child: Center(
                                                                child:
                                                                    RatingBarIndicator(
                                                                  rating: reviews[
                                                                              index]
                                                                          [
                                                                          'rate'] *
                                                                      1.0,
                                                                  itemSize: 15,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  itemCount: 5,
                                                                  itemPadding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              0),
                                                                  itemBuilder:
                                                                      (context,
                                                                              _) =>
                                                                          Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              formattedDate(
                                                                  reviews[index]
                                                                      ['date']),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ]),
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
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            parentName,
                                                            style: GoogleFonts
                                                                .vazirmatn(
                                                              color: Color(
                                                                  0xFF914BB9),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "${reviews[index]['review']}",
                                                            style: GoogleFonts
                                                                .vazirmatn(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              height: 1.5,
                                                            ),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ],
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
                                  },
                                );
                              } else
                                return Container(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Text("لايوجد تقييمات"));
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
