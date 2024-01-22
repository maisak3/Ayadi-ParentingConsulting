import 'package:ayadi/Appointments/SetSchedule.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ayadi/Components/navigationBar.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import 'package:ayadi/Appointments/viewChildProfile.dart';

import '../chating/BadgeIcon.dart';
import '../chating/chating.dart';

class SpecialistHomePage extends StatefulWidget {
  const SpecialistHomePage({super.key});

  @override
  State<SpecialistHomePage> createState() => _SpecialistHomePageState();
}

class _SpecialistHomePageState extends State<SpecialistHomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var specialistFname = "";
  var specialistLname = "";
  var specialistEmail = '';
  var specialistID = '';
//String specialistID = '';
  var specialistPhoneNo = '';
  double avgRate1 = 0;
  String avgRate = "";
  var numOfRates = 0;
  int currentIndex = 3;
  bool showLoading = false;
  late Stream<QuerySnapshot> _stream;

  void _getdata() async {
    setState(() {
      showLoading = true;
    });

    User user = _firebaseAuth.currentUser!;
    FirebaseFirestore.instance
        .collection("specialist")
        .where("phoneNumber", isEqualTo: user.phoneNumber)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          setState(() {
            specialistFname = documentSnapshot['Fname'];
            specialistLname = documentSnapshot['Lname'];
            specialistPhoneNo = documentSnapshot['phoneNumber'];
            avgRate1 = documentSnapshot["avgRate"] * 1.0;
            numOfRates = documentSnapshot["numOfRates"];
            specialistID = documentSnapshot.id;

            print(specialistFname + "hi");
            avgRate = avgRate1.toStringAsFixed(1);
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

  Future<String> _getChildName(String childID) async {
    // if (childNames.containsKey(childID)) {
    //   // If the child name is already in the cache, return it directly
    //   return childNames[childID]!;
    // }

    String childFname = "";
    String childLname = "";

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('children')
        .doc(childID)
        .get();

    if (documentSnapshot.exists) {
      childFname = documentSnapshot['Fname'];
      childLname = documentSnapshot['Lname'];
      String childName = childFname + " " + childLname;
      //_addToCache(childID, childName);
      // _addToCache(childID, childName); // Add to cache
      return childName;
    } else {
      print('No documents found1');
      return "حساب محذوف";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    _stream = FirebaseFirestore.instance
        .collection("sessions")
        .orderBy("date", descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            bottomNavigationBar: navigationBar(currentIndex: currentIndex),
            body: showLoading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(160, 145, 75, 185))),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        //app bar

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              ' $specialistFname',
                              style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff5e5a99)),
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Text(
                              "مرحبا ",
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "إليك آخر احصائياتك",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //SizedBox(height: 15.h),

                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.19,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.13,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(0xb5d9cce1),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FutureBuilder<QuerySnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection("sessions")
                                                    .where("specialistPhone",
                                                        isEqualTo:
                                                            specialistPhoneNo)
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    final users =
                                                        snapshot.data!.docs;
                                                    int count = users.length;
                                                    double profit = 0.0;
                                                    for (var i = 0;
                                                        i < count;
                                                        i++) {
                                                      profit = profit +
                                                          double.parse(((users[
                                                                          i][
                                                                      "price"]) *
                                                                  0.7)
                                                              .toStringAsFixed(
                                                                  1));
                                                    }
                                                    return Text(
                                                      "$profit",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff4e4a8c),
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1.0),
                                                    );
                                                  } else
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                }),
                                            Text(
                                              "مجموع الأرباح",
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Color(0xff555555),
                                                  height: 1.0),
                                            ),
                                          ],
                                        )),

                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),

                                    ////////////////////////
                                    ///
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.19,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.13,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(0xfff8e6ce),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FutureBuilder<QuerySnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection("sessions")
                                                    .where("specialistPhone",
                                                        isEqualTo:
                                                            specialistPhoneNo)
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    final users =
                                                        snapshot.data!.docs;
                                                    int count = users.length;
                                                    return Text(
                                                      "$count",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff4e4a8c),
                                                          fontSize: 32.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1.0),
                                                    );
                                                  } else
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                }),
                                            Text(
                                              "عدد الجلسات",
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Color(0xff555555),
                                                  height: 1.0),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.41,
                                  height:
                                      MediaQuery.of(context).size.height * 0.27,
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Color(0xfff0dee2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // SizedBox(width: 5.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${avgRate}",
                                            style: TextStyle(
                                              color: Color(0xff4e4a8c),
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          // SizedBox(width: 20.w,),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: RatingBarIndicator(
                                              rating: avgRate1 * 1.0,
                                              itemSize: 16.sp,
                                              direction: Axis.horizontal,
                                              itemCount: 5,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ),

                                          // sessions num
                                        ],
                                      ),
                                      Text(
                                        "($numOfRates)",
                                        style: TextStyle(
                                          color: Color(0xff555555),
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "متوسط التقييمات",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Color(0xff555555),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, top: 0, bottom: 0),
                          child: Text(
                            "موعدي القادم",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        StreamBuilder<QuerySnapshot>(
                            stream: _stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("حصل خطأ خلال ايجاد البيانات"),
                                );
                              } else if (snapshot.hasData) {
                                final times = snapshot.data!.docs;
                                print(times.length);
                                DateTime nearestTime = DateTime.now();
                                QueryDocumentSnapshot nextAppointment =
                                    times.first;
                                bool hasAppointment = false;
                                var session = times[0];
                                for (int i = 0; i < times.length; i++) {
                                  if ((times[i]["specialistPhone"] ==
                                          specialistPhoneNo) &&
                                      (times[i]["time"] == "upcoming") &&
                                      (nearestTime.isBefore(
                                          times[i]["date"].toDate()))) {
                                    nearestTime = times[i]["date"].toDate();
                                    nextAppointment = times[i];
                                    hasAppointment = true;
                                    session = times[i];
                                    break;
                                  }
                                }

                                return (hasAppointment)
                                    ? FutureBuilder<String>(
                                        future: _getChildName(
                                            nextAppointment["childID"]),
                                        builder: (context, childNameSnapshot) {
                                          if (childNameSnapshot
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }
                                          if (childNameSnapshot.hasData) {
                                            String childName =
                                                childNameSnapshot.data!;
                                            return StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('messages')
                                                    .where('receiver',
                                                        isEqualTo: specialistID)
                                                    .where("sessionID",
                                                        isEqualTo: session.id)
                                                    .where('unread',
                                                        isEqualTo: true)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    final mes =
                                                        snapshot.data!.docs;
                                                    int countNew = mes.length;
                                                    return Container(
                                                      height: 140,
                                                      // width: 3,
                                                      padding:
                                                          new EdgeInsets.all(
                                                              15),
                                                      margin:
                                                          new EdgeInsets.only(
                                                        bottom: 10,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Color.fromARGB(
                                                            160, 145, 75, 185),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Center(
                                                            child: Image.asset(
                                                              "assets/calendar.png",
                                                              height: 60,
                                                              width: 60,
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                "اسم الطفل" +
                                                                    " : " +
                                                                    childName,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                              // SizedBox(
                                                              //   height: 5,
                                                              // ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  CountdownTimer(
                                                                    endTime:
                                                                        nearestTime
                                                                            .millisecondsSinceEpoch,
                                                                    widgetBuilder:
                                                                        (_, time) {
                                                                      //if (time?.days ==null)
                                                                      if (time ==
                                                                          null) {
                                                                        // timer has ended
                                                                        return Text(
                                                                            "بـدأ الموعد",
                                                                            style:
                                                                                TextStyle(fontSize: 15, color: Color.fromARGB(255, 47, 132, 49)));
                                                                      }
                                                                      return Text(
                                                                        '${(time.days == null) ? 0 : time.days}:${(time.hours == null) ? 0 : time.hours}:${(time.min == null) ? 0 : time.min}:${(time.sec == null) ? 0 : time.sec}',
                                                                        style: GoogleFonts
                                                                            .vazirmatn(
                                                                          fontSize:
                                                                              15,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              247,
                                                                              5,
                                                                              5),
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),

                                                                  Text(
                                                                    " : " +
                                                                        "الوقت المتبقي للموعد",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),

                                                                  //  Icon(
                                                                  //                   Icons.date_range_outlined,
                                                                  //                   color: Colors.black,
                                                                  //                   size: 23,
                                                                  //                 ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                                width: 150,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    for (int i =
                                                                            0;
                                                                        i < countNew;
                                                                        i++) {
                                                                      mes[i]
                                                                          .reference
                                                                          .update({
                                                                        'unread':
                                                                            false
                                                                      });
                                                                    }
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(PageRouteBuilder(
                                                                            pageBuilder: (_, __, ___) => chating(
                                                                                  session: session,
                                                                                )));
                                                                  },
                                                                  style:
                                                                      ButtonStyle(
                                                                    padding: MaterialStateProperty.all<
                                                                            EdgeInsets>(
                                                                        EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                22)),
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                    shape: MaterialStateProperty
                                                                        .all<
                                                                            RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      //     BadgeIcon(
                                                                      //   icon:
                                                                      Stack(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "المحادثة",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 13,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 12),
                                                                            child:
                                                                                Icon(
                                                                              Icons.chat_outlined,
                                                                              color: Colors.black,
                                                                              size: 18,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  //   badgeCount:
                                                                  //       countNew,
                                                                  // ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                });
                                          } else {
                                            return Container();
                                          }
                                        })
                                    : Container(
                                        height: 100,
                                        width: 325,
                                        padding: new EdgeInsets.all(30),
                                        margin: new EdgeInsets.only(
                                            bottom: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color:
                                              Color.fromARGB(160, 145, 75, 185),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "لا توجد لديك مواعيد قادمة",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        )));
                              } else
                                return Container();
                            }),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
