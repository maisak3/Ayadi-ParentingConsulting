import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../Components/navigationBar.dart';
import '../VideoCall/RatingAndRev.dart';
import '../bookAppointment/EditAppointment.dart';
import '../chating/BadgeIcon.dart';
import '../chating/chating.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  State<AppointmentList> createState() => AppointmentListState();
}

class AppointmentListState extends State<AppointmentList>
    with TickerProviderStateMixin {
  // var user = FirebaseAuth.instance.currentUser;
  //late Stream<QuerySnapshot> upcomingStream;
  var parentPhoneNo = FirebaseAuth.instance.currentUser!.phoneNumber;
  String parentID = "";
  final int maxCacheSize = 50; // Maximum number of child names to cache
  final Map<String, String> childNames = {}; // Map to store child names
  final List<String> cacheOrder = []; // Order of keys in the cache
  Map<String, String> specialistNames = {}; // Map to store specialist names
  List<String> childCacheOrder = [];
  List<String> specialistCacheOrder = [];
  //bool buttonDisabled = false;
  int currentIndex = 1;
  bool showLoading = false;
  int loadingNumD = 0;
  int loadingNumU = 0;
  // bool rateUploaded = false;

  late TabController tabController =
      TabController(length: 2, vsync: this, initialIndex: 1);

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
      // _addToCache(childCacheOrder, childNames, childID, childName);
      // _addToCache(childID, childName); // Add to cache

      return childName;
    } else {
      print('No documents found1');

      return "حساب محذوف";
    }
  }

  Future<String> getSpecialistName(String specialistPhone) async {
    // if (specialistNames.containsKey(specialistPhone)) {
    //   // If the specialist name is already stored in the map, return it directly
    //   return specialistNames[specialistPhone]!;
    // }

    String specialistName = "";

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('specialist')
        .where('phoneNumber', isEqualTo: specialistPhone)
        .limit(1)
        .get();

    if (querySnapshot.docs.length > 0) {
      var documentSnapshot = querySnapshot.docs.first;
      if (documentSnapshot.exists) {
        specialistName =
            documentSnapshot['Fname'] + " " + documentSnapshot['Lname'];

        // _addToCache(specialistCacheOrder, specialistNames, specialistPhone,
        //     specialistName);
        return specialistName;
      } else {
        print('حساب محذوف');
        return "";
      }
    } else {
      print('No documents found3');
      return "حساب محذوف";
    }
  }

  @override
  void initState() {
    super.initState();
    //user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('parent')
        .where('phone', isEqualTo: parentPhoneNo)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.length > 0) {
          var documentSnapshot = querySnapshot.docs.first;
          if (documentSnapshot.exists) {
            setState(() {
              parentID = documentSnapshot.id;
              ;
            });
          }
        }
      },
    );
  }

  bool isButtonDisabled(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateFromTimeStamp);
    print("is button disabled? ${difference.inDays > 14}");
    return difference.inDays > 14;
  }

  String formattedDate(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMM, yyyy').format(dateFromTimeStamp);
  }

  String formattedDay(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate().toLocal();
    final format = DateFormat('hh:mm a');
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: navigationBar(currentIndex: currentIndex),
      body: showLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(160, 145, 75, 185))),
            )
          : Column(
              children: [
                SizedBox(height: 50),
                Text(
                  " المواعيد",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(234, 232, 248, 1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Color.fromARGB(160, 145, 75, 185),
                        ),
                        indicatorColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        controller: tabController,
                        isScrollable: true,
                        labelPadding: EdgeInsets.symmetric(horizontal: 70),
                        onTap: (value) {
                          loadingNumD = 0;
                          loadingNumU = 0;
                        },
                        tabs: [
                          Tab(
                            child: Text("المنتهية",
                                style: TextStyle(fontSize: 17)),
                          ),
                          Tab(
                            child:
                                Text("القادمة", style: TextStyle(fontSize: 17)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("sessions")
                        .orderBy("date", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final allSessions = snapshot.data!.docs;
                        print(
                            "the num of all sessions is: ${allSessions.length}");
                        List doneList = [];
                        List upcomingList = [];
                        for (int i = 0; i < allSessions.length; i++) {
                          if ((allSessions[i]["parentPhone"] ==
                                  parentPhoneNo) &&
                              (allSessions[i]["time"] == "done"))
                            doneList.add(allSessions[i]);
                          else if ((allSessions[i]["parentPhone"] ==
                                  parentPhoneNo) &&
                              (allSessions[i]["time"] == "upcoming"))
                            upcomingList.add(allSessions[i]);
                        }
                        print(doneList.length);

                        doneList = doneList.reversed.toList();

                        return TabBarView(
                          controller: tabController,
                          children: [
                            SizedBox(
                              child: (doneList.isEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 100),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/done.jpg",
                                            height: 250,
                                            width: 250,
                                          ),
                                          Text(
                                            "ليس لديك مواعيد منتهية",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromRGBO(
                                                    71, 55, 164, 1)),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30, horizontal: 20),
                                      physics: BouncingScrollPhysics(),
                                      itemCount: doneList.length,
                                      itemBuilder: (context, index) {
                                        var session = doneList[index];
                                        String childID = session["childID"];
                                        String specialistPhone =
                                            session["specialistPhone"];
                                        bool rateUploaded = false;
                                        print(childID);
                                        bool buttonDisabled =
                                            isButtonDisabled(session["date"]);
                                        if (session["review"] != "") {
                                          rateUploaded = true;
                                          //review = session["review"];
                                        } else {
                                          rateUploaded = false;
                                        }
                                        return FutureBuilder<String>(
                                          future: _getChildName(childID),
                                          builder:
                                              (context, childNameSnapshot) {
                                            if (childNameSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return Container();
                                              //return CircularProgressIndicator();
                                            }

                                            if (childNameSnapshot.hasData) {
                                              String childName =
                                                  childNameSnapshot.data!;
                                              print(childName);

                                              return FutureBuilder<String>(
                                                future: getSpecialistName(
                                                    specialistPhone),
                                                builder: (context,
                                                    specialistNameSnapshot) {
                                                  if (specialistNameSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container();
                                                    //return CircularProgressIndicator();
                                                  }

                                                  if (specialistNameSnapshot
                                                      .hasData) {
                                                    String specialistName =
                                                        specialistNameSnapshot
                                                            .data!;
                                                    print(specialistName);

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
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            loadingNumD++;
                                                            print(
                                                                "loading num is $loadingNumD");
                                                            if (loadingNumD ==
                                                                1)
                                                              return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                color: Color
                                                                    .fromARGB(
                                                                        160,
                                                                        145,
                                                                        75,
                                                                        185),
                                                              ));
                                                          }
                                                          if (snapshot
                                                              .hasData) {
                                                            // loadingNumD ++;
                                                            final mes = snapshot
                                                                .data!.docs;
                                                            int countNew =
                                                                mes.length;
                                                            return Container(
                                                                height: 220,
                                                                //width: 100,
                                                                margin:
                                                                    new EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10,
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 15,
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        bottom:
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border
                                                                      .all(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            234,
                                                                            232,
                                                                            248,
                                                                            1),
                                                                    width: 1,
                                                                  ),
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          234,
                                                                          232,
                                                                          248,
                                                                          1),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      'اسم الطفل' +
                                                                          ' : ' +
                                                                          '$childName',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                    Text(
                                                                      'اسم الأخصائي : $specialistName',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 35,
                                                                            ),
                                                                            Text(
                                                                              formattedDay(session["date"]),
                                                                              style: TextStyle(fontSize: 17),
                                                                            ),
                                                                            Icon(
                                                                              Icons.timer_outlined,
                                                                              size: 20,
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              formattedDate(session["date"]),
                                                                              style: TextStyle(fontSize: 17),
                                                                            ),
                                                                            Icon(
                                                                              Icons.date_range_outlined,
                                                                              size: 20,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),

                                                                    //Message call
                                                                    TextButton(
                                                                      onPressed: buttonDisabled
                                                                          ? null
                                                                          : () {
                                                                              for (int i = 0; i < countNew; i++) {
                                                                                mes[i].reference.update({
                                                                                  'unread': false
                                                                                });
                                                                              }
                                                                              //globals.inChat = true;
                                                                              // Navigator.pushNamed(
                                                                              //     context, 'chating');
                                                                              Navigator.of(context).push(PageRouteBuilder(
                                                                                  pageBuilder: (_, __, ___) => chating(
                                                                                        session: session,
                                                                                      )));
                                                                            },
                                                                      style:
                                                                          ButtonStyle(
                                                                        padding:
                                                                            MaterialStateProperty.all(EdgeInsets.zero),
                                                                      ),
                                                                      child:
                                                                          BadgeIcon(
                                                                        icon:
                                                                            Stack(
                                                                          children: [
                                                                            Opacity(
                                                                              opacity: buttonDisabled ? 0.5 : 1.0,
                                                                              child: Container(
                                                                                //width: 400,
                                                                                height: 38,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  color: Color.fromARGB(255, 255, 255, 255),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Color(0x3f000000),
                                                                                      blurRadius: 4,
                                                                                      offset: Offset(0, 4),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 7, top: 8),
                                                                                  child: Text(
                                                                                    "المحادثة",
                                                                                    style: TextStyle(
                                                                                      color: buttonDisabled ? Colors.black45 : Colors.black,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 10, top: 7),
                                                                                  child: Icon(
                                                                                    Icons.chat_outlined,
                                                                                    color: buttonDisabled ? Colors.black45 : Colors.black,
                                                                                    size: 25,
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

                                                                    //عرض ملف الطفل
                                                                    TextButton(
                                                                      onPressed: rateUploaded
                                                                          ? null
                                                                          : () {
                                                                              showRateDialog(context, session);
                                                                              //uploadRate(session);
                                                                            },
                                                                      style:
                                                                          ButtonStyle(
                                                                        padding:
                                                                            MaterialStateProperty.all(EdgeInsets.zero),
                                                                      ),
                                                                      child: Container(
                                                                          height: 38,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Color(0x3f000000),
                                                                                blurRadius: 4,
                                                                                offset: Offset(0, 4),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 5),
                                                                                child: Text(
                                                                                  rateUploaded ? "تم تقييم الجلسة" : "تقييم الجلسة",
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 6),
                                                                                child: Icon(
                                                                                  rateUploaded ? Icons.done : Icons.star_border_purple500_outlined,
                                                                                  color: rateUploaded ? Colors.black54 : Colors.black,
                                                                                  size: 25,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                    )
                                                                  ],
                                                                ));
                                                          } else
                                                            return Container();
                                                        });
                                                  }

                                                  return Container();
                                                },
                                              );
                                            }

                                            return Container();
                                          },
                                        );
                                      },
                                    ),
                            ),
                            (upcomingList.isEmpty)
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.only(top: 100),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/upcoming.jpg",
                                          height: 250,
                                          width: 250,
                                        ),
                                        Text(
                                          "ليس لديك مواعيد قادمة",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  71, 55, 164, 1)),
                                        ),
                                      ],
                                    ),
                                  ))
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 40, horizontal: 20),
                                    physics: BouncingScrollPhysics(),
                                    itemCount: upcomingList.length,
                                    itemBuilder: (context, index) {
                                      var session = upcomingList[index];
                                      String childID = session["childID"];
                                      String specialistPhone =
                                          session["specialistPhone"];
                                      print(childID);

                                      return FutureBuilder<String>(
                                        future: _getChildName(childID),
                                        builder: (context, childNameSnapshot) {
                                          if (childNameSnapshot
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                            //return CircularProgressIndicator();
                                          }

                                          if (childNameSnapshot.hasData) {
                                            String childName =
                                                childNameSnapshot.data!;
                                            print(childName);

                                            return FutureBuilder<String>(
                                              future: getSpecialistName(
                                                  specialistPhone),
                                              builder: (context,
                                                  specialistNameSnapshot) {
                                                if (specialistNameSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container();
                                                  //return CircularProgressIndicator();
                                                }

                                                if (specialistNameSnapshot
                                                    .hasData) {
                                                  String specialistName =
                                                      specialistNameSnapshot
                                                          .data!;
                                                  print(specialistName);

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
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          loadingNumU++;
                                                          if (loadingNumU == 1)
                                                            return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color: Color
                                                                  .fromARGB(
                                                                      160,
                                                                      145,
                                                                      75,
                                                                      185),
                                                            ));
                                                        }
                                                        if (snapshot.hasData) {
                                                          final mes = snapshot
                                                              .data!.docs;
                                                          int countNew =
                                                              mes.length;
                                                          return Container(
                                                              height: 210,
                                                              //width: 100,
                                                              margin:
                                                                  new EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10,
                                                                      left: 5,
                                                                      right: 5),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      left: 15,
                                                                      right: 15,
                                                                      bottom:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border:
                                                                    Border.all(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          234,
                                                                          232,
                                                                          248,
                                                                          1),
                                                                  width: 1,
                                                                ),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        234,
                                                                        232,
                                                                        248,
                                                                        1),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    'اسم الطفل : $childName',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    'اسم الأخصائي : $specialistName',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                30,
                                                                          ),
                                                                          Text(
                                                                            formattedDay(session["date"]),
                                                                            style:
                                                                                TextStyle(fontSize: 17),
                                                                          ),
                                                                          Icon(
                                                                            Icons.timer_outlined,
                                                                            size:
                                                                                20,
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            formattedDate(session["date"]),
                                                                            style:
                                                                                TextStyle(fontSize: 17),
                                                                          ),
                                                                          Icon(
                                                                            Icons.date_range_outlined,
                                                                            size:
                                                                                20,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),

                                                                  //Message call
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
                                                                      //globals.inChat = true;
                                                                      // Navigator.pushNamed(
                                                                      //     context, 'chating');
                                                                      Navigator.of(context).push(PageRouteBuilder(
                                                                          pageBuilder: (_, __, ___) => chating(
                                                                                session: session,
                                                                              )));
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      padding: MaterialStateProperty.all(
                                                                          EdgeInsets
                                                                              .zero),
                                                                    ),
                                                                    child:
                                                                        BadgeIcon(
                                                                      icon:
                                                                          Stack(
                                                                        children: [
                                                                          Container(
                                                                            //width: 400,
                                                                            height:
                                                                                38,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Color.fromARGB(255, 255, 255, 255),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color(0x3f000000),
                                                                                  blurRadius: 4,
                                                                                  offset: Offset(0, 4),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 7, top: 8),
                                                                                child: Text(
                                                                                  "المحادثة",
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10, top: 7),
                                                                                child: Icon(
                                                                                  Icons.chat_outlined,
                                                                                  color: Colors.black,
                                                                                  size: 25,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      badgeCount:
                                                                          countNew,
                                                                    ),
                                                                  ),

                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      print(
                                                                          "edit button pressed!!!");
                                                                      showModalBottomSheet(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.vertical(
                                                                            top:
                                                                                Radius.circular(15),
                                                                          ),
                                                                        ),
                                                                        context:
                                                                            context,
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        barrierColor:
                                                                            Colors.transparent,
                                                                        builder:
                                                                            (context) {
                                                                          print(
                                                                              "to appointment list");
                                                                          return EditAppointment(
                                                                              session: session);
                                                                        },
                                                                      );
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      padding: MaterialStateProperty.all(
                                                                          EdgeInsets
                                                                              .zero),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          38,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Color(0x3f000000),
                                                                            blurRadius:
                                                                                4,
                                                                            offset:
                                                                                Offset(0, 4),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 18),
                                                                            child:
                                                                                Text(
                                                                              "تعديل ",
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 6),
                                                                            child:
                                                                                Icon(
                                                                              Icons.edit_calendar_outlined,
                                                                              color: Colors.black,
                                                                              size: 25,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ));
                                                        } else
                                                          return Container();
                                                      });
                                                }

                                                return Container();
                                              },
                                            );
                                          }

                                          return Container();
                                        },
                                      );
                                    },
                                  ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'حدث خطأ أثناء جلب المواعيد',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                              color: Color.fromARGB(160, 145, 75, 185)),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
