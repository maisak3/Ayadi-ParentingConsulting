import 'package:ayadi/Components/navigationBar.dart';
import 'package:ayadi/addChild/addChild.dart';
import 'package:ayadi/bookAppointment/BookAppointment.dart';
import 'package:ayadi/bookAppointment/DescribeProblem.dart';
import 'package:ayadi/bookAppointment/searchSpecialist.dart';
import 'package:ayadi/bookAppointment/viewSpecialistProfile.dart';
import 'package:ayadi/chating/BadgeIcon.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../WelcomePage.dart';
import '../addChild/viewChildProfile.dart';
import '../chating/chating.dart';

class parentHomePage extends StatefulWidget {
  const parentHomePage({super.key});

  @override
  State<parentHomePage> createState() => _parentHomePageState();
}

class _parentHomePageState extends State<parentHomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var parentFname = "";
  var parentLname = "";
  var parentEmail = '';
//String parentID = '';
  var parentPhoneNo = '';
  int currentIndex = 2;
  bool showLoading = false;
  var parentID = '';

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

  void _getdata() async {
    setState(() {
      showLoading = true;
    });
    User user = _firebaseAuth.currentUser!;
    FirebaseFirestore.instance
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
            parentFname = documentSnapshot['Fname'];
            parentLname = documentSnapshot['Lname'];
            parentEmail = documentSnapshot['email'];
            //parentID = userData.data()!['id'];
            parentPhoneNo = documentSnapshot['phone'];
            parentID = documentSnapshot.id;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    //user = FirebaseAuth.instance.currentUser!.phoneNumber;
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
                : SafeArea(
                    child: Column(
                      children: [
                        //app bar
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // parent name
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end, //start
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // SizedBox(height: 20),
                                  Text(
                                    'مرحبًا',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),

                                  // StreamBuilder<QuerySnapshot>(
                                  //   stream: FirebaseFirestore.instance.collection("parent").where("phone", isEqualTo: parentPhoneNo).snapshots(),
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.hasData){
                                  //       final parent = snapshot.data!;

                                  //     return
                                  Text(
                                    "$parentFname $parentLname",
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      //fontWeight: FontWeight.bold,
                                      height: 1.5.h,
                                    ),
                                  ),
                                  //     );
                                  //     }
                                  //     else{
                                  //       return Container();
                                  //     }
                                  //   }
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment(-0.6, 0),
                        //   child: Transform(
                        //     transform: Matrix4.rotationY(math.pi),
                        //     child: IconButton(
                        //       icon: Icon(
                        //         Icons.logout,
                        //       ),
                        //       iconSize: 30,
                        //       color: Colors.deepPurple[400],
                        //       splashColor: Colors.white,
                        //       onPressed: () {
                        //         Navigator.of(context).push(PageRouteBuilder(
                        //             pageBuilder: (_, __, ___) => WelcomePage()));
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 10.h),

                        //search bar
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              autofocus: false,
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        searchSpecialist(
                                          sessionType: "",
                                        )));
                              },
                              textDirection: TextDirection.rtl,
                              cursorColor: Colors.deepPurple,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.deepPurple,
                                ),
                                //suffixIconColor: Colors.deepPurple,
                                border: InputBorder.none,
                                hintText: "ابدأ البحث عن أخصائي",
                                hintTextDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 30, top: 0, bottom: 5),
                            child: Text(
                              "موعدي القادم",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),

                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("sessions")
                                .orderBy("date", descending: false)
                                .snapshots(),
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
                                var session;
                                for (int i = 0; i < times.length; i++) {
                                  if ((times[i]["parentPhone"] ==
                                          parentPhoneNo) &&
                                      (times[i]["time"] == "upcoming")) {
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
                                                    .collection("specialist")
                                                    .where("phoneNumber",
                                                        isEqualTo: session[
                                                            "specialistPhone"])
                                                    .limit(1)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    final specialist =
                                                        snapshot.data!.docs;
                                                    String specialistID =
                                                        specialist[0].id;
                                                    String specialistName =
                                                        specialist[0]["Fname"] +
                                                            " " +
                                                            specialist[0]
                                                                ["Lname"];
                                                    return StreamBuilder(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'messages')
                                                            .where('receiver',
                                                                isEqualTo:
                                                                    parentID)
                                                            .where("sessionID",
                                                                isEqualTo:
                                                                    session.id)
                                                            .where('unread',
                                                                isEqualTo: true)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            final mes = snapshot
                                                                .data!.docs;
                                                            int countNew =
                                                                mes.length;
                                                            return Container(
                                                              height: 150,
                                                              // width: 3,
                                                              padding:
                                                                  new EdgeInsets
                                                                      .all(15),
                                                              margin:
                                                                  new EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10,
                                                                      left: 25,
                                                                      right:
                                                                          25),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                color: Color
                                                                    .fromARGB(
                                                                        160,
                                                                        145,
                                                                        75,
                                                                        185),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Center(
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/calendar.png",
                                                                      height:
                                                                          60,
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
                                                                        "اسم الأخصائي" +
                                                                            " : " +
                                                                            specialistName,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "اسم الطفل" +
                                                                            " : " +
                                                                            childName,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                      // SizedBox(
                                                                      //   height: 5,
                                                                      // ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          CountdownTimer(
                                                                            endTime:
                                                                                nearestTime.millisecondsSinceEpoch,
                                                                            widgetBuilder:
                                                                                (_, time) {
                                                                              //if (time?.days ==null)
                                                                              if (time == null) {
                                                                                // timer has ended
                                                                                return Text("بـدأ الموعد", style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 47, 132, 49)));
                                                                              }
                                                                              return Text(
                                                                                '${(time.days == null) ? 0 : time.days}:${(time.hours == null) ? 0 : time.hours}:${(time.min == null) ? 0 : time.min}:${(time.sec == null) ? 0 : time.sec}',
                                                                                style: GoogleFonts.vazirmatn(
                                                                                  fontSize: 15,
                                                                                  color: Colors.redAccent,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),

                                                                          Text(
                                                                            " : " +
                                                                                "الوقت المتبقي للموعد",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
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
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            150,
                                                                        child:
                                                                            TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            for (int i = 0;
                                                                                i < countNew;
                                                                                i++) {
                                                                              mes[i].reference.update({
                                                                                'unread': false
                                                                              });
                                                                            }
                                                                            Navigator.of(context).push(PageRouteBuilder(
                                                                                pageBuilder: (_, __, ___) => chating(
                                                                                      session: session,
                                                                                    )));
                                                                          },
                                                                          style:
                                                                              ButtonStyle(
                                                                            padding:
                                                                                MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 22)),
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all<Color>(Colors.white),
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              BadgeIcon(
                                                                            icon:
                                                                                Stack(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      "المحادثة",
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 13,
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 12),
                                                                                      child: Icon(
                                                                                        Icons.chat_outlined,
                                                                                        color: Colors.black,
                                                                                        size: 18,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            badgeCount:
                                                                                countNew,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          } else
                                                            return Container();
                                                        });
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
                                              Color.fromRGBO(234, 232, 248, 1),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "لا توجد لديك مواعيد قادمة",
                                          style: TextStyle(fontSize: 18),
                                        )));
                              } else
                                return Container();
                            }),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 30, top: 0, bottom: 5),
                            child: Text(
                              "تصفح حسب التخصص",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.grey[600],
                                  height: 1.0),
                            ),
                          ),
                        ),

                        // // card >
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                        //   child: Container(
                        //     padding: EdgeInsets.all(20.r),
                        //     decoration: BoxDecoration(
                        //       color: Colors.pink[100],
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         // help you
                        //         Expanded(
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.end,
                        //             children: [
                        //               Text(
                        //                 'ما هي مشكلتك؟',
                        //                 style: TextStyle(
                        //                   fontSize: 16.sp,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //               SizedBox(height: 12.h),
                        //               Text(
                        //                 'عبّر عنها، حتى نساعدك في الوصول إلى الأخصائي المناسب',
                        //                 maxLines: 2,
                        //                 textAlign: TextAlign.right,
                        //                 style: TextStyle(
                        //                   fontSize: 14.sp,
                        //                 ),
                        //               ),
                        //               SizedBox(height: 10.h),
                        //               TextButton(
                        //                 onPressed: () {
                        //                   Navigator.of(context).push(
                        //                       PageRouteBuilder(
                        //                           pageBuilder: (_, __, ___) =>
                        //                               DescribeProblem()));
                        //                 },
                        //                 child: Center(
                        //                   child: Text(
                        //                     'لنبدأ',
                        //                     style: TextStyle(
                        //                       fontSize: 16.sp,
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.bold,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 style: ButtonStyle(
                        //                     padding: MaterialStateProperty.all<
                        //                             EdgeInsets>(
                        //                         EdgeInsets.all(10.r)),
                        //                     backgroundColor:
                        //                         MaterialStateProperty.all<
                        //                                 Color>(
                        //                             Colors.deepPurple[300]!),
                        //                     shape: MaterialStateProperty.all<
                        //                             RoundedRectangleBorder>(
                        //                         RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(12.0),
                        //                     ))),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           width: 20.w,
                        //         ),
                        //         //animation
                        //         Container(
                        //           // height: 100,
                        //           // width: 100,
                        //           child: Lottie.network(
                        //             'https://assets8.lottiefiles.com/packages/lf20_sxrzmxih.json',
                        //             width: 110.w,
                        //             height: 150.h,
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 15.h),

                        // // list of specialization
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                          child: Container(
                            //height: 80.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  searchSpecialist(
                                                    sessionType: "behavioral",
                                                  )));
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/havioral.png",
                                          height: 60,
                                          width: 60,
                                        ),
                                        Text(
                                          'سلوكي',
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromRGBO(
                                                    247, 230, 206, 1)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ))),
                                  ),
                                ),
                                //
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  searchSpecialist(
                                                    sessionType: "educational",
                                                  )));
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/educational.png",
                                          height: 60,
                                          width: 60,
                                        ),
                                        Text(
                                          'تربوي',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromRGBO(
                                                    247, 230, 206, 1)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ))),
                                  ),
                                ),
                                //
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  searchSpecialist(
                                                    sessionType: "speech",
                                                  )));
                                    },
                                    //   width:  MediaQuery.of(context).size.width * .3,
                                    //  padding: EdgeInsets.only(top: 23.h, bottom: 23.h),
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(12),
                                    //     color: Colors.deepPurple[100],
                                    //   ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/speech.png",
                                          height: 60,
                                          width: 60,
                                        ),
                                        Text(
                                          'نطق و تخاطب',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromRGBO(
                                                    247, 230, 206, 1)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //SizedBox(height: 10.h),

                        // //specialist list
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          searchSpecialist(
                                            sessionType: "none",
                                          )));
                                },
                                child: Text(
                                  'إظهار الكل',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                              Text(
                                'الأخصائيين',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 180,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("specialist")
                                  .where("status", isEqualTo: true)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  final specialists = snapshot.data!;
                                  int count = specialists.size;
                                  return ListView.builder(
                                    padding: EdgeInsets.only(bottom: 30.0.h),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: false,
                                    reverse: true,
                                    itemCount: specialists.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: (index != count)
                                            ? EdgeInsets.only(left: 15.w)
                                            : EdgeInsets.only(left: 0),
                                        height: 140,
                                        width: 120,
                                        padding: EdgeInsets.all(3),
                                        //margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        viewSpecialistProfile(
                                                            specialistPhone:
                                                                specialists.docs[
                                                                        index][
                                                                    "phoneNumber"])));

                                            print(specialists.docs[index]
                                                ["phoneNumber"]);
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 3.h),
                                                child: Container(
                                                  width: 50.w,
                                                  height: 50.w,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        160, 145, 75, 185),
                                                    //color: Colors.deepPurple[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),

                                              // specialist rate
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow[600],
                                                    size: 15.sp,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    '${specialists.docs[index]["avgRate"]}',
                                                    style: TextStyle(
                                                        //fontWeight: FontWeight.bold,
                                                        fontSize: 15.sp,
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),

                                              //specialist name
                                              Text(
                                                "${specialists.docs[index]['Fname'] + " " + specialists.docs[index]['Lname']}",
                                                style: TextStyle(
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                    height: 1.5.h,
                                                    color: Colors.black),
                                              ),
                                              // SizedBox(
                                              //   height: 5,
                                              // ),

                                              // specialist catogry
                                              Text(
                                                "${specialists.docs[index]['specialization']}",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    height: 1.h,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ),

                        // SizedBox(height: 15,),
                      ],
                    ),
                  ),
          );
        });
  }
}
