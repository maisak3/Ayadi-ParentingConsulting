import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:readmore/readmore.dart';
import 'package:ayadi/Components/navigationBar.dart';

//import 'Appointment_Lists.dart';

class viewChildProfile extends StatefulWidget {
  const viewChildProfile({
    super.key,
    required this.childId,
  });
  final childId;

  @override
  State<viewChildProfile> createState() => _viewChildProfileState(
        childId,
      );
}

class _viewChildProfileState extends State<viewChildProfile> {
  String childId;
  _viewChildProfileState(
    this.childId,
  );
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int currentIndex = 2;

  var childAge = 0;
  var childGender = "";
  var childDOB = "";
  var SpecialistReport = "";
  var childFname = "";
  var childLname = "";
  bool loadImage = false;
  var childParentPhone = "";
  int count = 0;
  List reports = [];
  bool isReportEmpty = false;
  bool showLoading = false;

  int calculateAge(String dateOfBirth) {
    DateTime now = DateTime.now();
    List<String> parts = dateOfBirth.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    DateTime dob = DateTime(year, month, day);
    int age = now.year - dob.year;

    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }

  void _getdata() async {
    setState(() {
      showLoading = true;
    });
    FirebaseFirestore.instance
        .collection('children')
        .where('id', isEqualTo: childId)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.length > 0) {
          var documentSnapshot = querySnapshot.docs.first;
          if (documentSnapshot.exists) {
            setState(() {
              childFname = documentSnapshot['Fname'];
              childLname = documentSnapshot['Lname'];
              childGender = documentSnapshot['gender'];
              childDOB = documentSnapshot['DOB'];
              childAge = calculateAge(childDOB);
            });
          }
        }
        print("no doc found");
        setState(() {
          showLoading = false;
        });
      },
    );
  }

  void sessionReport(String SpecialistReport) async {
    //final String? text = await getTextFromFirebase();
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      showCloseIcon: true,
      customHeader: Icon(
        Icons.assignment_rounded,
        size: 60,
        color: Colors.purple,
      ),
      body: Center(
          child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'تقرير الجلسة',
              style: GoogleFonts.vazirmatn(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF914BB9),
              ),
              textAlign: TextAlign.center,
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Text(
            SpecialistReport,
            style: GoogleFonts.vazirmatn(
              fontSize: 15,
              //fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          )
        ],
      )),
    )..show();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
  }

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMM, yyyy').format(dateFromTimeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: navigationBar(currentIndex: currentIndex),
      body: showLoading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(160, 145, 75, 185))),
            )
          : SingleChildScrollView(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      height: 180,
                      color: Color.fromRGBO(174, 194, 179, 1),
                      //Color.fromRGBO(247, 230, 206, 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //back button
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 75,
                            right: 30,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop(context);
                            },
                            child: Container(
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(174, 194, 179, 1),
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
                    Column(
                      children: [
                        //icon
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 110),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(174, 194, 179, 1),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Image.asset(
                                "assets/kids.png",
                                height: 60,
                                width: 60,
                              ),
                            ),
                            radius: 60.0,
                          ),
                        ),
                        //child name
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: SizedBox(
                              child: Text(
                                textAlign: TextAlign.center,
                                "${childFname}" + " " + "${childLname}",
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${childGender}",
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                ': ' + 'الجنس' + '  ',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(247, 230, 206, 1),
                                radius: 7,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (childAge == 1 || childAge > 10)
                                Text(
                                  "سنة",
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              if (childAge == 2)
                                Text(
                                  "سنتين",
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              if (childAge > 2 && childAge < 11)
                                Text(
                                  "سنوات",
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              Text(
                                childAge > 2 ? "  ${childAge} " : " ",
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                ': ' + 'العمر' + '  ',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(247, 230, 206, 1),
                                radius: 7,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "  ${childDOB} ",
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                ': ' + 'تاريخ الميلاد' + '  ',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(247, 230, 206, 1),
                                radius: 7,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'تقارير الجلسات' + ' ',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
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
                        //report
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("sessions")
                              .orderBy('date', descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              final reports1 = snapshot.data!.docs;
                              isReportEmpty = false;
                              List reports = [];
                              for (int i = 0; i < reports1.length; i++) {
                                if ((reports1[i]['parentPhone'] ==
                                        childParentPhone) &&
                                    (reports1[i]['childID'] == childId) &&
                                    (reports1[i]["report"] != "")) {
                                  reports.add(reports1[i]);
                                }
                              }
                              if (!reports.isEmpty)
                                return ListView.builder(
                                  padding: EdgeInsets.only(
                                      left: 25, top: 15, right: 25),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: reports.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String SpecialistName = "";
                                    String specialization = "";
                                    // String sessionChildId = "";
                                    // //sessionParentPhone = reports[index]['parentPhone'];
                                    // sessionChildId = reports[index]['childID'];

                                    // if (sessionChildId == childId) {
                                    //   SpecialistReport = reports[index]['report'];
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("specialist")
                                          .where('phoneNumber',
                                              isEqualTo: reports[index]
                                                  ['specialistPhone'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          final specialist =
                                              snapshot.data!.docs.first;
                                          // for (var n = 0;
                                          //     n < specialist.length;
                                          //     n++) {
                                          //   SpecialistName = specialist[n]['Fname'] +
                                          //       " " +
                                          //       specialist[n]['Lname'];
                                          //   specialization =
                                          //       specialist[n]['specialization'];
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
                                            child: TextButton(
                                              onPressed: () {
                                                sessionReport(
                                                    reports[index]["report"]);
                                              },
                                              child: Row(
                                                children: [
                                                  Column(
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
                                                          color: const Color(
                                                              0xFFFFFF),
                                                          borderRadius:
                                                              new BorderRadius
                                                                  .all(new Radius
                                                                      .circular(
                                                                  32.0)),
                                                        ),
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
                                                            Text(
                                                              formattedDate(
                                                                  reports[index]
                                                                      ['date']),
                                                              style: GoogleFonts
                                                                  .vazirmatn(
                                                                fontSize: 13,
                                                                color: Color(
                                                                    0xff555555),
                                                              ),
                                                            ),
                                                            Text(
                                                              specialist[
                                                                      'Fname'] +
                                                                  " " +
                                                                  specialist[
                                                                      'Lname'],
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
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .arrow_back_ios,
                                                              color: Color
                                                                  .fromARGB(170,
                                                                      0, 0, 0),
                                                              size: 20,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right: 6,
                                                              ),
                                                              child: Text(
                                                                specialist[
                                                                    'specialization'],
                                                                style: GoogleFonts
                                                                    .vazirmatn(
                                                                  fontSize: 13,
                                                                  color: Color(
                                                                      0xff555555),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // child: Row(
                                            //   children: [
                                            //     Column(
                                            //       children: [
                                            //         Container(
                                            //           padding: EdgeInsets.only(
                                            //             top: 10,
                                            //             bottom: 10,
                                            //           ),
                                            //           decoration: new BoxDecoration(
                                            //             shape: BoxShape.rectangle,
                                            //             color: const Color(0xFFFFFF),
                                            //             borderRadius:
                                            //                 new BorderRadius.all(
                                            //                     new Radius.circular(
                                            //                         32.0)),
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //     SizedBox(
                                            //       width: 20,
                                            //     ),
                                            //     Expanded(
                                            //       child: Column(
                                            //         mainAxisAlignment:
                                            //             MainAxisAlignment.start,
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment.end,
                                            //         children: [
                                            //           Row(
                                            //             mainAxisAlignment:
                                            //                 MainAxisAlignment
                                            //                     .spaceBetween,
                                            //             crossAxisAlignment:
                                            //                 CrossAxisAlignment.start,
                                            //             children: [
                                            //               Text(
                                            //                 formattedDate(
                                            //                     reports[index]
                                            //                         ['date']),
                                            //                 style:
                                            //                     GoogleFonts.vazirmatn(
                                            //                   fontSize: 13,
                                            //                   color:
                                            //                       Color(0xff555555),
                                            //                 ),
                                            //               ),
                                            //               Text(
                                            //                 SpecialistName,
                                            //                 style:
                                            //                     GoogleFonts.vazirmatn(
                                            //                   color:
                                            //                       Color(0xFF914BB9),
                                            //                   fontSize: 18,
                                            //                   fontWeight:
                                            //                       FontWeight.bold,
                                            //                 ),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //           SizedBox(
                                            //             height: 2,
                                            //           ),
                                            //           Row(
                                            //             mainAxisAlignment:
                                            //                 MainAxisAlignment
                                            //                     .spaceBetween,
                                            //             crossAxisAlignment:
                                            //                 CrossAxisAlignment.center,
                                            //             children: [
                                            //               IconButton(
                                            //                 onPressed: () {
                                            //                   sessionReport();
                                            //                 },
                                            //                 icon: Icon(
                                            //                   Icons.arrow_back_ios,
                                            //                   color: Color.fromARGB(
                                            //                       170, 0, 0, 0),
                                            //                   size: 20,
                                            //                 ),
                                            //               ),
                                            //               Padding(
                                            //                 padding: EdgeInsets.only(
                                            //                   right: 6,
                                            //                 ),
                                            //                 child: Text(
                                            //                   specialization,
                                            //                   style: GoogleFonts
                                            //                       .vazirmatn(
                                            //                     fontSize: 13,
                                            //                     color:
                                            //                         Color(0xff555555),
                                            //                   ),
                                            //                   textAlign:
                                            //                       TextAlign.right,
                                            //                 ),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          );
                                          // }
                                        } else {
                                          return Container();
                                        }
                                      },
                                    );
                                    // }
                                  },
                                ); //(!reports.isEmpty)
                              else
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Image.asset(
                                    //   "assets/noReport.png",
                                    //   height: 120,
                                    //   width: 180,
                                    // ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text(
                                        "لا توجد أي تقارير",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromRGBO(71, 55, 164, 1)),
                                      ),
                                    ),
                                  ],
                                );
                            }
                            return Container();
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
