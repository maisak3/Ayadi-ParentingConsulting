import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ayadi/chating/BadgeIcon.dart';
import '../Components/navigationBar.dart';
import 'package:ayadi/chating/chating.dart';
import 'package:ayadi/Appointments/viewChildProfile.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); //Notifications

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList>
    with TickerProviderStateMixin {
  // var user = FirebaseAuth.instance.currentUser;
  //late Stream<QuerySnapshot> upcomingStream;
  var specialistPhoneNo = FirebaseAuth.instance.currentUser!.phoneNumber;
  //var specialistPhoneNo = "+966555706340";
  String specialistID = "";
  final int maxCacheSize = 50; // Maximum number of child names to cache
  final Map<String, String> childNames = {}; // Map to store child names
  final List<String> cacheOrder = []; // Order of keys in the cache
  //bool buttonDisabled = false;
  int currentIndex = 2;
  //bool reportUploaded = false;
  bool validated = false;
  var _textController = TextEditingController();
  String reportOrder = "";
  String idOfOrder = "";
  String oldReport = "";
  int loadingNumD = 0;
  int loadingNumU = 0;
  bool notificationSent = false;

  late TabController tabController =
      TabController(length: 2, vsync: this, initialIndex: 1);

  // void listenNotifications() =>
  //     Notifications.onNotifications.stream.listen(onClickedNotification);

  // void onClickedNotification(String? payload) => Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => AppointmentList(),
  //       ),
  //     );

  // Future<void> checkAndUpdateNotification() async {
  //   try {
  //     // Query the Firestore collection for documents with notification field equal to "new"
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('sessions')
  //         .where('notification', isEqualTo: 'new')
  //         .get();

  //     // Iterate over the query results
  //     for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //       // Get the document ID
  //       String docId = documentSnapshot.id;

  //       // Get the value of the notification field
  //       String notificationStatus = documentSnapshot['notification'];

  //       // Check if the notification field is still set to "new"
  //       if (notificationStatus == 'new') {
  //         // Send a notification
  //         Notifications.showNotification(
  //           title: 'لديك موعد جديد',
  //           body: 'لقد تم حجز موعد جديد لديك ',
  //           //payload: 'sarah.abs',
  //         );

  //         // Update the Firestore document to mark the notification as "done"
  //         await FirebaseFirestore.instance
  //             .collection('sessions')
  //             .doc(docId)
  //             .update({'notification': 'received'});
  //       }
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

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

  uploadReport(String sessionID) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      //dismissOnTouchOutside: false,
      customHeader: Icon(
        Icons.assignment_rounded,
        size: 60,
        color: Colors.purple,
      ),
      //dialogType: DialogType.warning,
      //showCloseIcon: true,
      //title: 'Report an issue',
      body: //Text("Report an issue"),
          Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "ادخل معلومات التقرير هنا",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                  maxLength: 2000,
                  maxLines: 3,
                  textAlign: TextAlign.end,
                  cursorColor: Color(0xFF914BB9),
                  inputFormatters: [
                    //FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z \u0621-\u064A]+")),
                  ],
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      validated = false;
                      print(validated);

                      return "الوصف لايمكن ان يكون خالي";
                    } else if (value.length < 2) {
                      validated = false;
                      print(validated);

                      return "لايمكن اقل من حرفين";
                    } else {
                      validated = true;

                      print(validated);
                    }
                  },
                  controller: _textController,
                  //autofocus: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      //contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                      hintText: "اكتب هنا")),
            ),
          ],
        ),
      ),

      // btnOkColor: Color.fromARGB(160, 145, 75, 185),

      btnOk: ElevatedButton(
          child: Text("ارسال"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(160, 145, 75, 185),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          onPressed: () {
            if (validated && _textController.text.isNotEmpty) {
              print(validated);

              reportOrder = _textController.text;
              print(reportOrder);
              addReport(sessionID, reportOrder);
              Navigator.pop(context);
              ReportSent(reportOrder);
              _textController.clear();

              // ValidatedDialog();
            } else {
              print(validated);
              ValidatedDialog();
            }
          }),

      btnOkOnPress: () {},
      btnCancelOnPress: () {
        _textController.clear();
      },

      btnCancelText: "الغاء",
      btnCancelColor: Color.fromARGB(255, 243, 86, 86),

      //btnOkIcon: Icons.check_circle,
      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
    ).show();

    //});
  }

  addReport(String id, String report) async {
    // change status to ignore after the timer //better to delete
    /*for (var i = 0; i < userOrders.length; i++) {
        if (userOrders[i].data()['status'] == "waiting") {
          //userOrders[i].data()['status'].set("Ignored");
        }*/
    try {
      FirebaseFirestore.instance.collection('sessions').doc(id).update({
        'report': report,
        'isReported': true,
      });
    } catch (err) {
      print(err);
    }
  }

  ValidatedDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.topSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.error,
      width: 350,

      //showCloseIcon: true,

      title: "Please write the descreption as noted to submit",
      desc: "",

      body: Text(
        "لطفا ادخل معلومات التقرير كما هو موضح",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
      ),

      btnOkOnPress: () {},

      btnOkText: "حسنا",
      btnOkColor: Color.fromARGB(160, 145, 75, 185),

      //btnOkIcon: Icons.check_circle,
      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
    ).show();
  }

  ReportSent(String oldR) {
    //Future.delayed(const Duration(seconds: 60), () {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,

      //showCloseIcon: true,

      body: //Text("Report an issue"),
          Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "تم رفع التقرير \n",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
            Text(
              "\"$oldR\" \n",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color.fromARGB(255, 32, 119, 162)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "شكرا لتعاونك",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
                Center(
                  child: Icon(
                    Icons.favorite,
                    color: Color.fromARGB(255, 236, 206, 58),
                    size: 22,
                  ),
                ),
              ],
            ),
            /*SizedBox(
              height: 15,
            ),
            Text(
              "We take your words very seriously\n The appropriate actions will be taken in case of a problem",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),*/
          ],
        ),
      ),

      // btnOkOnPress: () {},

      // btnOkText: "حسنا",
      // btnOkColor: Color(0xFF00CA71),

      //btnOkIcon: Icons.check_circle,
      /*onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },*/
    ).show();

    //});
  }

  @override
  void initState() {
    super.initState();
    //user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('specialist')
        .where('phoneNumber', isEqualTo: specialistPhoneNo)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.length > 0) {
          var documentSnapshot = querySnapshot.docs.first;
          if (documentSnapshot.exists) {
            setState(() {
              specialistID = documentSnapshot.id;
              ;
            });
          }
        }
      },
    );
  }

  void deleted() async {
    AwesomeDialog(
      width: 550,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: "تم حذف الموعد بنجاح",
      titleTextStyle: TextStyle(
        fontSize: 23,
      ),
    ).show();
  }

  void viewReport(String report) async {
    AwesomeDialog(
            width: 550,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.noHeader,
            title: "تقرير الجلسة",
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            desc: "$report",
            btnOkOnPress: () {
              //Navigator.of(context).pop();
            },
            btnOkText: "عودة",
            btnOkColor: Color.fromARGB(160, 145, 75, 185))
        .show();
  }

  void cantDelete() async {
    AwesomeDialog(
            width: 550,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.warning,
            title: "لا يمكن حذف الموعد",
            desc:
                "نأسف لذلك, بقي على موعدك أقل من 48 ساعة, لا يمكنك حذف الموعد خلال هذه المدة",
            titleTextStyle: TextStyle(
              fontSize: 23,
            ),
            btnOkOnPress: () {},
            btnOkColor: Color.fromARGB(160, 145, 75, 185),
            btnOkText: "حسنًا")
        .show();
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
      bottomNavigationBar: navigationBar(currentIndex: currentIndex),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 80),
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
                  onTap: (value) {
                    loadingNumD = 0;
                    loadingNumU = 0;
                  },
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 70),
                  tabs: [
                    Tab(
                      child: Text("السابقة", style: TextStyle(fontSize: 17)),
                    ),
                    Tab(
                      child: Text("القادمة", style: TextStyle(fontSize: 17)),
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
                if (snapshot.connectionState == ConnectionState.waiting) {}
                if (snapshot.hasData) {
                  final allSessions = snapshot.data!.docs;
                  print("the num of all sessions is: ${allSessions.length}");
                  List doneList = [];
                  List upcomingList = [];
                  for (int i = 0; i < allSessions.length; i++) {
                    if ((allSessions[i]["specialistPhone"] ==
                            specialistPhoneNo) &&
                        (allSessions[i]["time"] == "done"))
                      doneList.add(allSessions[i]);
                    else if ((allSessions[i]["specialistPhone"] ==
                            specialistPhoneNo) &&
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                          color:
                                              Color.fromRGBO(71, 55, 164, 1)),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.66,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30, horizontal: 20),
                                        physics: BouncingScrollPhysics(),
                                        itemCount: doneList.length,
                                        itemBuilder: (context, index) {
                                          var session = doneList[index];
                                          String childID = session["childID"];
                                          bool reportUploaded = false;
                                          String report = "";
                                          print(childID);
                                          bool buttonDisabled =
                                              isButtonDisabled(session["date"]);
                                          if (session["isReported"] == true) {
                                            reportUploaded = true;
                                            report = session["report"];
                                          } else {
                                            reportUploaded = false;
                                          }

                                          return FutureBuilder<String>(
                                            future: _getChildName(childID),
                                            builder:
                                                (context, childNameSnapshot) {
                                              if (childNameSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                              } else if (childNameSnapshot
                                                  .hasData) {
                                                //loadingNumD++;
                                                String childName =
                                                    childNameSnapshot.data!;
                                                print(childName);
                                                return StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('messages')
                                                        .where('receiver',
                                                            isEqualTo:
                                                                specialistID)
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
                                                        loadingNumD++;
                                                        //print("loading num is $loadingNumD");
                                                        if (loadingNumD == 1)
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // SizedBox(
                                                              //   height: 30,
                                                              // ),
                                                              Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                color: Color
                                                                    .fromARGB(
                                                                        160,
                                                                        145,
                                                                        75,
                                                                        185),
                                                              )),
                                                            ],
                                                          );
                                                      }
                                                      if (snapshot.hasData) {
                                                        // loadingNumD ++;
                                                        final mes =
                                                            snapshot.data!.docs;
                                                        int countNew =
                                                            mes.length;
                                                        return Container(
                                                            height: 200,
                                                            //width: 100,
                                                            margin:
                                                                new EdgeInsets
                                                                        .only(
                                                                    bottom: 10,
                                                                    left: 5,
                                                                    right: 5),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 15,
                                                                    left: 15,
                                                                    right: 15,
                                                                    bottom: 10),
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
                                                                  'اسم الطفل' +
                                                                      ' : ' +
                                                                      '$childName',
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
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              35,
                                                                        ),
                                                                        Text(
                                                                          formattedDay(
                                                                              session["date"]),
                                                                          style:
                                                                              TextStyle(fontSize: 17),
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .timer_outlined,
                                                                          size:
                                                                              20,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          formattedDate(
                                                                              session["date"]),
                                                                          style:
                                                                              TextStyle(fontSize: 17),
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .date_range_outlined,
                                                                          size:
                                                                              20,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),

                                                                SizedBox(
                                                                  height: 10,
                                                                ),

                                                                //Message call
                                                                TextButton(
                                                                  onPressed:
                                                                      buttonDisabled
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
                                                                    padding: MaterialStateProperty.all(
                                                                        EdgeInsets
                                                                            .zero),
                                                                  ),
                                                                  child:
                                                                      BadgeIcon(
                                                                    icon: Stack(
                                                                      children: [
                                                                        Opacity(
                                                                          opacity: buttonDisabled
                                                                              ? 0.5
                                                                              : 1.0,
                                                                          child:
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
                                                                        )
                                                                      ],
                                                                    ),
                                                                    badgeCount:
                                                                        countNew,
                                                                  ),
                                                                ),

                                                                //عرض ملف الطفل
                                                                TextButton(
                                                                  onPressed:
                                                                      reportUploaded
                                                                          ? () {
                                                                              viewReport(report);
                                                                            }
                                                                          : () {
                                                                              uploadReport(session.id);
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
                                                                                color: Color(0x3f000000),
                                                                                blurRadius: 4,
                                                                                offset: Offset(0, 4),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 5),
                                                                                child: Text(
                                                                                  reportUploaded ? "عرض تقرير الجلسة" : "رفع تقرير الجلسة",
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 6),
                                                                                child: Icon(
                                                                                  reportUploaded ? Icons.insert_drive_file_rounded : Icons.file_upload_outlined,
                                                                                  color: reportUploaded ? Colors.black54 : Colors.black,
                                                                                  size: 25,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                ),
                                                              ],
                                                            ));
                                                      } else
                                                        return Container();
                                                    });
                                              }

                                              return Container();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      (upcomingList.isEmpty)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/upcoming.jpg",
                                      height: 250,
                                      width: 250,
                                    ),
                                    Text(
                                      'ليس لديك مواعيد قادمة',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromRGBO(71, 55, 164, 1)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                // if (loadingNumU ) Center(child: CircularProgressIndicator( color:Color.fromARGB(160, 145, 75, 185) ,)),

                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.66,
                                  child: ListView.builder(
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
                                            // loadingNumU++;
                                            // if (loadingNumU ==1)
                                            //return Center(child: CircularProgressIndicator( color:Color.fromARGB(160, 145, 75, 185) ,));
                                          }
                                          //checkAndUpdateNotification();

                                          if (childNameSnapshot.hasData) {
                                            String childName =
                                                childNameSnapshot.data!;
                                            print(childName);
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
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    loadingNumU++;
                                                    if (loadingNumU == 1)
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          // SizedBox(
                                                          //   height: 30,
                                                          // ),
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                            color:
                                                                Color.fromARGB(
                                                                    160,
                                                                    145,
                                                                    75,
                                                                    185),
                                                          )),
                                                        ],
                                                      );
                                                  }
                                                  if (snapshot.hasData) {
                                                    final mes =
                                                        snapshot.data!.docs;
                                                    int countNew = mes.length;
                                                    return Container(
                                                        height: 200,
                                                        //width: 100,
                                                        margin:
                                                            new EdgeInsets.only(
                                                                bottom: 10,
                                                                left: 5,
                                                                right: 5),
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15,
                                                                left: 15,
                                                                right: 20,
                                                                bottom: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color:
                                                                Color.fromRGBO(
                                                                    234,
                                                                    232,
                                                                    248,
                                                                    1),
                                                            width: 1,
                                                          ),
                                                          color: Color.fromRGBO(
                                                              234, 232, 248, 1),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              'اسم الطفل : $childName',
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 30,
                                                                    ),
                                                                    Text(
                                                                      formattedDay(
                                                                          session[
                                                                              "date"]),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .timer_outlined,
                                                                      size: 20,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      formattedDate(
                                                                          session[
                                                                              "date"]),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .date_range_outlined,
                                                                      size: 20,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            //Message call
                                                            // StreamBuilder(
                                                            //   stream: FirebaseFirestore
                                                            //       .instance
                                                            //       .collection('messages')
                                                            //       .where('receiver',
                                                            //           isEqualTo: specialistID)
                                                            //       .where("sessionID",
                                                            //           isEqualTo: session.id)
                                                            //       .where('unread',
                                                            //           isEqualTo: true)
                                                            //       .snapshots(),
                                                            //   builder: (context, snapshot) {
                                                            //     loadingNumU++;
                                                            //     if (snapshot.hasData) {
                                                            //       final mes =
                                                            //           snapshot.data!.docs;
                                                            //       int countNew = mes.length;
                                                            //       print(
                                                            //           "count new is $countNew");
                                                            //       return
                                                            TextButton(
                                                              onPressed: () {
                                                                for (int i = 0;
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
                                                                Navigator.of(context).push(
                                                                    PageRouteBuilder(
                                                                        pageBuilder: (_,
                                                                                __,
                                                                                ___) =>
                                                                            chating(
                                                                              session: session,
                                                                            )));
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                padding: MaterialStateProperty
                                                                    .all(EdgeInsets
                                                                        .zero),
                                                              ),
                                                              child: BadgeIcon(
                                                                icon: Stack(
                                                                  children: [
                                                                    Container(
                                                                      //width: 400,
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
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 7,
                                                                              top: 8),
                                                                          child:
                                                                              Text(
                                                                            "المحادثة",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 10,
                                                                              top: 7),
                                                                          child:
                                                                              Icon(
                                                                            Icons.chat_outlined,
                                                                            color:
                                                                                Colors.black,
                                                                            size:
                                                                                25,
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
                                                            //;
                                                            //     } else
                                                            //       return Container();
                                                            //   },
                                                            // ),

                                                            SizedBox(
                                                              height: 2,
                                                            ),

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    AwesomeDialog(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10,
                                                                          horizontal:
                                                                              20),
                                                                      context:
                                                                          context,
                                                                      animType:
                                                                          AnimType
                                                                              .leftSlide,
                                                                      headerAnimationLoop:
                                                                          false,
                                                                      dialogType:
                                                                          DialogType
                                                                              .question,
                                                                      title:
                                                                          'هل انت متأكد من حذف موعدك؟',
                                                                      titleTextStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            23,
                                                                      ),
                                                                      btnCancelOnPress:
                                                                          () {},
                                                                      btnOkOnPress:
                                                                          () {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                "parent")
                                                                            .where("phone",
                                                                                isEqualTo: session["parentPhone"])
                                                                            .limit(1)
                                                                            .get()
                                                                            .then((querySnapshot) {
                                                                          var parentDocRef = querySnapshot
                                                                              .docs
                                                                              .first
                                                                              .reference;
                                                                          var wallet = querySnapshot
                                                                              .docs
                                                                              .first
                                                                              .data()["wallet"];
                                                                          wallet +=
                                                                              session["price"];
                                                                          parentDocRef
                                                                              .update({
                                                                            "wallet":
                                                                                wallet
                                                                          });
                                                                          print(
                                                                              "Wallet updated successfully");
                                                                        }).catchError((error) => print("Failed to update wallet: $error"));

                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection("sessions")
                                                                            .doc(session.id)
                                                                            .delete();

                                                                        //                                                               FirebaseFirestore.instance
                                                                        //     .collection("parent")
                                                                        //     .where("phone", isEqualTo: session["parentPhone"])
                                                                        //     .get()
                                                                        //     .then((querySnapshot) {
                                                                        //   querySnapshot.docs.forEach((doc) {
                                                                        //     doc.reference.update({"wallet": });
                                                                        //   });
                                                                        // });

                                                                        deleted();
                                                                        // Navigator.pop(context, 'YES');
                                                                      },
                                                                      btnOkText:
                                                                          "نعم",
                                                                      btnCancelText:
                                                                          "لا",
                                                                      btnCancelColor:
                                                                          Color(
                                                                              0xFF00CA71),
                                                                      btnOkColor: Color.fromARGB(
                                                                          255,
                                                                          211,
                                                                          59,
                                                                          42),
                                                                    ).show();
                                                                  },
                                                                  style:
                                                                      ButtonStyle(
                                                                    padding: MaterialStateProperty.all(
                                                                        EdgeInsets
                                                                            .zero),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    height: 38,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .redAccent,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Color(0x3f000000),
                                                                          blurRadius:
                                                                              4,
                                                                          offset: Offset(
                                                                              0,
                                                                              4),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 15),
                                                                          child:
                                                                              Text(
                                                                            "حذف الموعد",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 5,
                                                                              right: 15),
                                                                          child:
                                                                              Icon(
                                                                            Icons.edit_calendar_outlined,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                25,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    //child profile
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                viewChildProfile(
                                                                          childId:
                                                                              session["childID"],
                                                                        ),
                                                                      ),
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
                                                                                color: Color(0x3f000000),
                                                                                blurRadius: 4,
                                                                                offset: Offset(0, 4),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Text(
                                                                                  "عرض ملف الطفل",
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 15,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 5, right: 10),
                                                                                child: Icon(
                                                                                  Icons.account_box_outlined,
                                                                                  color: Colors.black,
                                                                                  size: 25,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ));
                                                  } else {
                                                    return Container();
                                                  }
                                                });
                                          }

                                          return Container();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
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
                      //child: CircularProgressIndicator(),
                      );
                }
              },
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .where('receiver', isEqualTo: specialistID)
                .where('status', isEqualTo: "new")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final m = snapshot.data!.docs;
                int count = 0;
                if (m.isNotEmpty) {
                  print("$count messages");
                  String messageText = "";
                  String sName = "child Name";
                  List messages = [];

                  for (int i = 0; i < m.length; i++) {
                    messages.add(m[i]);
                    messageText = m[i]['text'];
                    m[i].reference.update({'status': "old"});
                  }
                  print("$m.length length of messages");
                  // sendMessageNotification(sName, messageText);
                  // if (count == 0 && !notificationSent) {
                  //   Notifications.showNotification(
                  //     title: sName,
                  //     body: messageText,
                  //   );
                  //   notificationSent = true;
                  //   print("$messageText sent");
                  //   //notificationSent = true;
                  // }
                  count++;
                  notificationSent = false;
                }
              }

              return Container();
            },
          )
        ],
      ),
    );
  }
}
