import 'dart:ui';

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
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:ayadi/Components/navigationBar.dart';
import 'package:flutter/cupertino.dart';

import 'MultiSelectDialog.dart';
import 'package:ayadi/NavigationPages/viewAppointmentsSlots.dart';

class SetSchedule extends StatefulWidget {
  const SetSchedule({super.key});

  @override
  State<SetSchedule> createState() => _SetScheduleState();
}

class _SetScheduleState extends State<SetSchedule> {
//List periods = [];

//DateTime firstDay = DateTime.now();

  String selectedDay = "";
  bool errorMsg = false;
  bool loadSchedule = false;
  //String errorMsg = "";

  int _periodsCount = 0;
  Map<String, List<List<DateTime>>> _scheduleByDay = {
    "sun": [],
    "mon": [],
    "tue": [],
    "wed": [],
    "thu": [],
    "fri": [],
    "sat": [],
  };

  Map<String, List<List<DateTime>>> _scheduleByDay1 = {
    "sun": [],
    "mon": [],
    "tue": [],
    "wed": [],
    "thu": [],
    "fri": [],
    "sat": [],
  };

  var specialistPhoneNo = FirebaseAuth.instance.currentUser!.phoneNumber;
  var specialistFname = "";
  var specialistLname = "";
  var specialistEmail = '';
//String specialistID = '';
  var avgRate = 0;
  var numOfRates = 0;
  int currentIndex = 1;

  String firstDay = "";

  int dayNum = 0;
//DateTime selectedDay = DateTime.now();

// DateTime startTime = DateTime.now();
// DateTime startTime1 = DateTime.now();
// DateTime startTime2 = DateTime.now();

// DateTime endTime = DateTime.now();
// DateTime endTime1 = DateTime.now();
// DateTime endTime2 = DateTime.now();

  bool dateChanged = false;

  bool isChanged = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    selectedDay = "sun";
  }

  List<List<DateTime>> createDeepCopy(List<List<DateTime>> originalList) {
    List<List<DateTime>> copiedList = [];

    for (int i = 0; i < originalList.length; i++) {
      List<DateTime> originalTimeSlot = originalList[i];
      List<DateTime> copiedTimeSlot = [];

      for (int j = 0; j < originalTimeSlot.length; j++) {
        copiedTimeSlot.add(originalTimeSlot[j]);
      }

      copiedList.add(copiedTimeSlot);
    }

    return copiedList;
  }

  void _getdata() async {
    FirebaseFirestore.instance
        .collection("specialist")
        .where("phoneNumber", isEqualTo: specialistPhoneNo)
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
            avgRate = documentSnapshot["avgRate"];
            numOfRates = documentSnapshot["numOfRates"];
            print(specialistFname + "hi");
          });
        } else {
          print('No documents found');
        }
      } else {
        print('No documents found');
      }
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _scheduleByDay.clear();

    firestore
        .collection('weeklySchedule')
        .where('SPphone', isEqualTo: specialistPhoneNo)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          List<List<DateTime>> sunday = [];
          List<Timestamp> sundayPeriods = List<Timestamp>.from(
              (documentSnapshot.data() as Map<String, dynamic>)['sun']);
          for (int i = 0; i < sundayPeriods.length; i += 2) {
            sunday.add(
                [sundayPeriods[i].toDate(), sundayPeriods[i + 1].toDate()]);
          }

          List<List<DateTime>> monday = [];
          List<Timestamp> mondayPeriods = List<Timestamp>.from(
              (documentSnapshot.data() as Map<String, dynamic>)['mon']);
          for (int i = 0; i < mondayPeriods.length; i += 2) {
            monday.add(
                [mondayPeriods[i].toDate(), mondayPeriods[i + 1].toDate()]);
          }

          List<List<DateTime>> tuesday = [];
          List<Timestamp> tuesdayPeriods = List<Timestamp>.from(
              (documentSnapshot.data() as Map<String, dynamic>)['tue']);
          for (int i = 0; i < tuesdayPeriods.length; i += 2) {
            tuesday.add(
                [tuesdayPeriods[i].toDate(), tuesdayPeriods[i + 1].toDate()]);
          }

          List<List<DateTime>> wednesday = [];
          List<Timestamp> wednesdayPeriods = List<Timestamp>.from(
              (documentSnapshot.data() as Map<String, dynamic>)['wed']);
          for (int i = 0; i < wednesdayPeriods.length; i += 2) {
            wednesday.add([
              wednesdayPeriods[i].toDate(),
              wednesdayPeriods[i + 1].toDate()
            ]);
          }

          List<List<DateTime>> thursday = [];
          List<Timestamp> thursdayPeriods = List<Timestamp>.from(
              (documentSnapshot.data() as Map<String, dynamic>)['thu']);
          for (int i = 0; i < thursdayPeriods.length; i += 2) {
            thursday.add(
                [thursdayPeriods[i].toDate(), thursdayPeriods[i + 1].toDate()]);
          }

          List<List<DateTime>> friday = [];
          List<Timestamp> fridayPeriods = List<Timestamp>.from(
              (documentSnapshot.data() as Map<String, dynamic>)['fri']);
          for (int i = 0; i < fridayPeriods.length; i += 2) {
            friday.add(
                [fridayPeriods[i].toDate(), fridayPeriods[i + 1].toDate()]);
          }

          List<List<DateTime>> saturday = [];
          List<Timestamp> saturdayPeriods = List<Timestamp>.from(
              (documentSnapshot.data() as Map<String, dynamic>)['sat']);
          for (int i = 0; i < saturdayPeriods.length; i += 2) {
            saturday.add(
                [saturdayPeriods[i].toDate(), saturdayPeriods[i + 1].toDate()]);
          }

          setState(() {
            _scheduleByDay = {
              'sun': List.from(sunday),
              'mon': List.from(monday),
              'tue': List.from(tuesday),
              'wed': List.from(wednesday),
              'thu': List.from(thursday),
              'fri': List.from(friday),
              'sat': List.from(saturday),
            };
            loadSchedule = true;

            _scheduleByDay1 = {
              'sun': List.from(sunday),
              'mon': List.from(monday),
              'tue': List.from(tuesday),
              'wed': List.from(wednesday),
              'thu': List.from(thursday),
              'fri': List.from(friday),
              'sat': List.from(saturday),
            };

            bool isEqual = mapsAreEqual(_scheduleByDay, _scheduleByDay1);
            print("are both maps are equal? $isEqual");
          });
        });
      } else {
        print('No documents found');
        setState(() {
          _scheduleByDay = {
            "sun": [],
            "mon": [],
            "tue": [],
            "wed": [],
            "thu": [],
            "fri": [],
            "sat": [],
          };
          loadSchedule = true;

          _scheduleByDay1 = {
            "sun": [],
            "mon": [],
            "tue": [],
            "wed": [],
            "thu": [],
            "fri": [],
            "sat": [],
          };
        });
      }

      print('Schedule by day: $_scheduleByDay');
    });
  }

  bool mapsAreEqual(Map<String, List<List<DateTime>>> map1,
      Map<String, List<List<DateTime>>> map2) {
    if (map1.length != map2.length) {
      return false;
    }

    for (var key in map1.keys) {
      if (!map2.containsKey(key)) {
        return false;
      }

      if (map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }

  DateTime nearestQuarter(DateTime val) {
    return DateTime(val.year, val.month, val.day, val.hour,
        [15, 30, 45, 60][(val.minute / 15).floor()]);
  }

  void cantEdit() async {
    AwesomeDialog(
            width: 550,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.noHeader,
            title: "لديك موعد محجوز",
            desc:
                "تم حذف الفترة بنجاح علمًا بأن هناك موعد محجوز خلال هذه الفترة,بإمكانك حذفه ايضا من قائمة المواعيد",
            titleTextStyle: TextStyle(
              fontSize: 20,
            ),
            btnOkOnPress: () {},
            btnOkColor: Color.fromARGB(160, 145, 75, 185),
            btnOkText: "حسنًا")
        .show();
  }

  void cantSave() async {
    AwesomeDialog(
            width: 550,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.warning,
            title: "لا تستطيع حفظ التغييرات",
            desc: "فضلا قم بالتأكد من ان جميع الفترات خالية من الاخطاء",
            titleTextStyle: TextStyle(
              fontSize: 20,
            ),
            btnOkOnPress: () {},
            btnOkColor: Color.fromARGB(160, 145, 75, 185),
            btnOkText: "عودة")
        .show();
  }

  void cantNavigate() async {
    AwesomeDialog(
            width: 550,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.warning,
            title: "تأكد من تعديل الأخطاء أولًا",
            titleTextStyle: TextStyle(
              fontSize: 20,
            ),
            btnOkOnPress: () {},
            btnOkColor: Color.fromARGB(160, 145, 75, 185),
            btnOkText: "عودة")
        .show();
  }

  Widget whiteGlassContainer1() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        width: 400,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(235, 223, 201, 242).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          //color: Color.fromARGB(255, 172, 15, 15),
        ),
        child: Stack(
          children: [
            //blur effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 15,
                sigmaY: 15,
              ),
              child: Container(),
            ),
            //gardient effect
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.2),
                      ])),
            ),
            //slide down indicator
            Positioned(
              left: 165,
              child: Container(
                height: 7,
                width: MediaQuery.of(context).size.width / 6,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 165, 124, 190),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.black26,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    String hour = dateTime.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    //String period = dateTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute';
  }

  Widget getfullContainers(List periods1, String selectedDay) {
    List<List<DateTime>> periods = _scheduleByDay[selectedDay] ?? [];
    _periodsCount = periods.length;
    String warning = "";
    DateTime sTime = nearestQuarter(DateTime.now());
    DateTime eTime = nearestQuarter(DateTime.now());

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        if (periods.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.20,
                left: MediaQuery.of(context).size.width * 0.32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "إلـى",
                  style: TextStyle(
                      fontSize: 18.sp, color: Color.fromARGB(255, 83, 40, 108)),
                ),
                Text(
                  "مـن",
                  style: TextStyle(
                      fontSize: 18.sp, color: Color.fromARGB(255, 83, 40, 108)),
                ),
              ],
            ),
          ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        if (!loadSchedule)
          Center(
              child: CircularProgressIndicator(
            color: Color.fromARGB(160, 145, 75, 185),
          )),
        if (_periodsCount > 0)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            width: MediaQuery.of(context).size.width * 0.82,
            child: ListView.builder(
                itemCount: periods.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.only(
                        top: 3.h, bottom: 3.h, left: 10.w, right: 10.w),
                    height: ((((periods[index][1].hour +
                                    periods[index][1].minute / 60.0) -
                                (periods[index][0].hour +
                                    periods[index][0].minute / 60.0)) <
                            0.75))
                        ? MediaQuery.of(context).size.height * 0.085
                        : ((((periods[index][1].hour +
                                        periods[index][1].minute / 60.0) -
                                    (periods[index][0].hour +
                                        periods[index][0].minute / 60.0)) <
                                0))
                            ? MediaQuery.of(context).size.height * 0.085
                            : ((index > 0) &&
                                    (((periods[index][0].hour +
                                                periods[index][0].minute /
                                                    60.0) -
                                            (periods[index - 1][1].hour +
                                                periods[index - 1][1].minute /
                                                    60.0)) <
                                        0))
                                ? MediaQuery.of(context).size.height * 0.085
                                : MediaQuery.of(context).size.height * 0.068,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: IconButton(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.zero,
                                  iconSize: 25,
                                  onPressed: () async {
                                    setState(() {
                                      _scheduleByDay[selectedDay]
                                          ?.removeAt(index);
                                      _periodsCount--;
                                      isChanged = true;
                                    });
                                  },
                                  icon: Icon(Icons.delete_outline_rounded,
                                      color: Color.fromARGB(255, 83, 40, 108)),
                                ),
                              ),

                              // النهاية
                              TextButton(
                                onPressed: () async {
                                  DateTime newTime = DateTime.now();
                                  bool isSelected = false;
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15),
                                        ),
                                      ),
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      barrierColor: Colors.transparent,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.42,
                                          child: Stack(
                                            children: [
                                              whiteGlassContainer1(),
                                              Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                    topRight:
                                                        Radius.circular(15.0),
                                                  ),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.42,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20.h,
                                                                  right: 15.w),
                                                          child: Text(
                                                            'اختر وقت النهاية',
                                                            style: TextStyle(
                                                                fontSize: 18.sp,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        83,
                                                                        40,
                                                                        108),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          thickness: 1,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.215,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      child:
                                                          CupertinoDatePicker(
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .time,
                                                        initialDateTime:
                                                            DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day,
                                                                periods[index]
                                                                        [1]
                                                                    .hour,
                                                                periods[index]
                                                                        [1]
                                                                    .minute),
                                                        minimumDate: DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day,
                                                            8,
                                                            0),
                                                        maximumDate: DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day,
                                                            23,
                                                            0),
                                                        minuteInterval: 15,
                                                        onDateTimeChanged:
                                                            (DateTime
                                                                newDateTime) {
                                                          setState(() {
                                                            newTime =
                                                                newDateTime;
                                                            isSelected = true;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            if (isSelected) {
                                                              if (periods[index]
                                                                      [1] !=
                                                                  newTime)
                                                                isChanged =
                                                                    true;
                                                              eTime = newTime;
                                                              //(index == 0)?(endTime = eTime):(index == 1)?(endTime1 = eTime):(endTime2 = eTime);
                                                              periods[index]
                                                                  [1] = eTime;
                                                            }

                                                            ((((periods[index][1].hour +
                                                                            periods[index][1].minute /
                                                                                60.0) -
                                                                        (periods[index][0].hour +
                                                                            periods[index][0].minute /
                                                                                60.0)) <
                                                                    0))
                                                                ? errorMsg =
                                                                    true
                                                                : ((((periods[index][1].hour + periods[index][1].minute / 60.0) -
                                                                            (periods[index][0].hour +
                                                                                periods[index][0].minute /
                                                                                    60.0)) <
                                                                        0.75))
                                                                    ? errorMsg =
                                                                        true
                                                                    : ((index > 0) &&
                                                                            (((periods[index][0].hour + periods[index][0].minute / 60.0) - (periods[index - 1][1].hour + periods[index - 1][1].minute / 60.0)) <
                                                                                0))
                                                                        ? errorMsg =
                                                                            true
                                                                        : errorMsg =
                                                                            false;
                                                          });
                                                          print(eTime);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            'تعييــن',
                                                            style: GoogleFonts
                                                                .abel(
                                                              fontSize: 17.sp,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        style: ButtonStyle(
                                                          padding: MaterialStateProperty
                                                              .all<EdgeInsets>(
                                                                  EdgeInsets.only(
                                                                      right:
                                                                          5.w,
                                                                      left: 5.w,
                                                                      top: 10.h,
                                                                      bottom: 10
                                                                          .h)),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Color
                                                                      .fromARGB(
                                                                          160,
                                                                          145,
                                                                          75,
                                                                          185)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Center(
                                  child: Text(
                                    DateFormat('hh:mm a')
                                        .format(periods[index][1]),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      height: 2.0,
                                      color: Color.fromARGB(255, 83, 40, 108),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.only(
                                                right: 23.w, left: 23.w)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffeeeeee)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ))),
                              ),

                              TextButton(
                                onPressed: () {
                                  DateTime newTime = DateTime.now();
                                  bool isSelected = false;
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15),
                                        ),
                                      ),
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      barrierColor: Colors.transparent,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.42,
                                          child: Stack(
                                            children: [
                                              whiteGlassContainer1(),
                                              Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.42,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20.h,
                                                                  right: 15.w),
                                                          child: Text(
                                                            'اختر وقت البداية',
                                                            style: TextStyle(
                                                                fontSize: 18.sp,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        83,
                                                                        40,
                                                                        108),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          thickness: 1,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.215,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      child:
                                                          CupertinoDatePicker(
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .time,
                                                        initialDateTime:
                                                            DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day,
                                                                periods[index]
                                                                        [0]
                                                                    .hour,
                                                                periods[index]
                                                                        [0]
                                                                    .minute),
                                                        minimumDate: DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day,
                                                            8,
                                                            0),
                                                        maximumDate: DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day,
                                                            23,
                                                            0),
                                                        minuteInterval: 15,
                                                        onDateTimeChanged:
                                                            (DateTime
                                                                newDateTime) {
                                                          setState(() {
                                                            newTime =
                                                                newDateTime;
                                                            isSelected = true;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            if (isSelected) {
                                                              if (periods[index]
                                                                      [0] !=
                                                                  newTime)
                                                                isChanged =
                                                                    true;
                                                              sTime = newTime;
                                                              //(index == 0)?(startTime = sTime):(index == 1)?(startTime1 = sTime):(startTime2 = sTime);
                                                              // periods[index][0] = sTime;
                                                              _scheduleByDay[
                                                                      selectedDay]![
                                                                  index][0] = sTime;
                                                            }

                                                            (((((periods[index][1].hour + periods[index][1].minute / 60.0) -
                                                                            (periods[index][0].hour +
                                                                                periods[index][0].minute /
                                                                                    60.0)) <
                                                                        0)) ||
                                                                    ((((periods[index][1].hour + periods[index][1].minute / 60.0) -
                                                                            (periods[index][0].hour +
                                                                                periods[index][0].minute /
                                                                                    60.0)) <
                                                                        0.75)) ||
                                                                    ((index >
                                                                            0) &&
                                                                        (((periods[index][0].hour + periods[index][0].minute / 60.0) - (periods[index - 1][1].hour + periods[index - 1][1].minute / 60.0)) <
                                                                            0)))
                                                                ? errorMsg =
                                                                    true
                                                                : errorMsg =
                                                                    false;
                                                          });
                                                          //print(startTime);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            'تعييــن',
                                                            style: GoogleFonts
                                                                .abel(
                                                              fontSize: 17.sp,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        style: ButtonStyle(
                                                          padding: MaterialStateProperty
                                                              .all<EdgeInsets>(
                                                                  EdgeInsets.only(
                                                                      right:
                                                                          5.w,
                                                                      left: 5.w,
                                                                      top: 10.h,
                                                                      bottom: 10
                                                                          .h)),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Color
                                                                      .fromARGB(
                                                                          160,
                                                                          145,
                                                                          75,
                                                                          185)),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Center(
                                  child: Text(
                                    DateFormat('hh:mm a')
                                        .format(periods[index][0]),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      height: 2.0,
                                      color: Color.fromARGB(255, 83, 40, 108),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.only(
                                                right: 25.w, left: 25.w)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffeeeeee)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ))),
                              ),

                              SizedBox(
                                width: 5.w,
                              ),
                            ]),
                        ((((periods[index][1].hour +
                                        periods[index][1].minute / 60.0) -
                                    (periods[index][0].hour +
                                        periods[index][0].minute / 60.0)) <
                                0))
                            ? Text(
                                "يجب ان تكون النهاية بعد البداية",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.red,
                                    height: 1.0,
                                    fontWeight: FontWeight.w300),
                              )
                            : ((((periods[index][1].hour +
                                            periods[index][1].minute / 60.0) -
                                        (periods[index][0].hour +
                                            periods[index][0].minute / 60.0)) <
                                    0.75))
                                ? Text(
                                    'يجب أن تكون المدة بين البداية والنهاية 45 دقيقة على الأقل',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.red,
                                        height: 1.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                : ((index > 0) &&
                                        (((periods[index][0].hour +
                                                    periods[index][0].minute /
                                                        60.0) -
                                                (periods[index - 1][1].hour +
                                                    periods[index - 1][1]
                                                            .minute /
                                                        60.0)) <
                                            0))
                                    ? Text(
                                        'يجب ان تكون بداية الفترة بعد نهاية الفترة السابقة',
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.red,
                                            height: 1.0,
                                            fontWeight: FontWeight.w300),
                                      )
                                    : Container()
                      ],
                    ),
                  );
                }),
          )
        else if (loadSchedule)
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Text(
                  "لم تقم بإضافة اي فترة لهذا اليوم,\n سيتم تعيين اليوم كإجازة",
                  style: TextStyle(
                    fontSize: 17.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
        SizedBox(height: MediaQuery.of(context).size.height * 0.004),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                // padding: EdgeInsets.only( left: 90.w , right: 90.w ),
                width: MediaQuery.of(context).size.width * 0.33,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: (periods.isEmpty || errorMsg)
                          ? Colors.black54
                          : Color.fromARGB(255, 83, 40, 108),
                      width: 1.0,
                    ),
                  ),
                ),
                child: TextButton(
                  onPressed: (periods.isEmpty || errorMsg)
                      ? null
                      : () async {
                          print(selectedDay);
                          String selectedD = selectedDay;
                          List<String>? selectedOptions =
                              await showDialog<List<String>>(
                            context: context,
                            builder: (BuildContext context) {
                              return MultiSelectDialog(
                                  options: [
                                    'الأحد',
                                    'الإثنين',
                                    'الثلاثاء',
                                    'الأربعاء',
                                    'الخميس',
                                    'الجمعة',
                                    'السبت'
                                  ],
                                  defaultSelectedOption: (selectedDay == "sun")
                                      ? "الأحد"
                                      : (selectedDay == "mon")
                                          ? "الإثنين"
                                          : (selectedDay == "tue")
                                              ? "الثلاثاء"
                                              : (selectedDay == "wed")
                                                  ? "الأربعاء"
                                                  : (selectedDay == "thu")
                                                      ? "الخميس"
                                                      : (selectedDay == "fri")
                                                          ? "الجمعة"
                                                          : (selectedDay ==
                                                                  "sat")
                                                              ? "السبت"
                                                              : "");
                            },
                          );
                          setState(() {
                            if (selectedOptions != null) {
                              copiedSuccessfully();
                              isChanged = true;
                              print(selectedOptions);
                              print(periods);
                              print(selectedDay);
                              for (int i = 0; i < selectedOptions.length; i++) {
                                if ((selectedOptions[i] == "الأحد") &&
                                    (selectedDay != "sun")) {
                                  _scheduleByDay["sun"] = createDeepCopy(
                                      _scheduleByDay[selectedDay]!);
                                }
                                if ((selectedOptions[i] == "الإثنين") &&
                                    (selectedDay != "mon")) {
                                  _scheduleByDay["mon"] = createDeepCopy(
                                      _scheduleByDay[selectedDay]!);
                                }
                                if ((selectedOptions[i] == "الثلاثاء") &&
                                    (selectedDay != "tue")) {
                                  _scheduleByDay["tue"] = createDeepCopy(
                                      _scheduleByDay[selectedDay]!);
                                }
                                if ((selectedOptions[i] == "الأربعاء") &&
                                    (selectedDay != "wed")) {
                                  _scheduleByDay["wed"] = createDeepCopy(
                                      _scheduleByDay[selectedDay]!);
                                }
                                if ((selectedOptions[i] == "الخميس") &&
                                    (selectedDay != "thu")) {
                                  _scheduleByDay["thu"] = createDeepCopy(
                                      _scheduleByDay[selectedDay]!);
                                }
                                if ((selectedOptions[i] == "الجمعة") &&
                                    (selectedDay != "fri")) {
                                  _scheduleByDay["fri"] = createDeepCopy(
                                      _scheduleByDay[selectedDay]!);
                                }
                                if ((selectedOptions[i] == "السبت") &&
                                    (selectedDay != "sat")) {
                                  _scheduleByDay["sat"] = createDeepCopy(
                                      _scheduleByDay[selectedDay]!);
                                }
                              }
                            }
                          });
                        },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "نسخ إلى يوم آخر",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: (periods.isEmpty || errorMsg)
                                  ? Colors.black54
                                  : Color.fromARGB(255, 83, 40, 108)),
                        ),
                        Icon(Icons.copy,
                            color: (periods.isEmpty || errorMsg)
                                ? Colors.black54
                                : Color.fromARGB(255, 83, 40, 108),
                            size: 20),
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  ),
                ),
              ),
              Container(
                // padding: EdgeInsets.only( left: 90.w , right: 90.w ),
                width: MediaQuery.of(context).size.width * 0.26,
                height: MediaQuery.of(context).size.height * 0.045,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 83, 40, 108),
                      width: 1.0,
                    ),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    if (_scheduleByDay[selectedDay]!.isEmpty) {
                      setState(() {
                        isChanged = true;
                        _scheduleByDay[selectedDay]!.add([
                          nearestQuarter(DateTime.now()),
                          nearestQuarter(DateTime.now())
                              .add(Duration(minutes: 45))
                        ]);
                        _periodsCount++;
                        print(_periodsCount);
                      });
                      return;
                    }
                    if (_scheduleByDay[selectedDay]!.isNotEmpty) {
                      setState(() {
                        isChanged = true;
                        //_scheduleByDay[selectedDay.day] ??= [];
                        _scheduleByDay[selectedDay]!.add([
                          periods[_periodsCount - 1][1],
                          periods[_periodsCount - 1][1]
                              .add(Duration(minutes: 45))
                        ]);
                        _periodsCount++;
                      });
                    }
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'إضافة فترة',
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: Color.fromARGB(255, 83, 40, 108)),
                        ),
                        Icon(Icons.add_circle_outline,
                            color: Color.fromARGB(255, 83, 40, 108)),
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.80,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "لتحديد جدول مواعيدك قم باتباع الآتي",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 83, 40, 108),
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 230,
                            child: Text(
                              "حدد ساعات عملك, بامكانك إضافة اكثر من فترة عمل بناءً على رغبتك",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Text(
                            " •",
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(160, 145, 75, 185),
                                height: 1.2),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 230,
                            child: Text(
                              " كل موعد يستغرق 45 دقيقة سيتم تقسيم كل فترة عمل بناءً على ذلك",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Text(
                            " •",
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(160, 145, 75, 185),
                                height: 1.2),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 230,
                            child: Text(
                              "يمكنك نسخ جدول يوم معين إلى أيام اخرى",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Text(
                            " •",
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(160, 145, 75, 185),
                                height: 1.2),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          'حسنًا',
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.only(
                                  right: 5.w,
                                  left: 5.w,
                                  top: 5.h,
                                  bottom: 5.h)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(160, 145, 75, 185)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  void copiedSuccessfully() async {
    AwesomeDialog(
      width: 550,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: "تم النسخ بنجاح",
      titleTextStyle: TextStyle(
        fontSize: 23,
      ),
      // btnOkOnPress: () {},
      //       btnOkColor: Color.fromARGB(160, 145, 75, 185),
      //       btnOkText: "حسنًا"
    ).show();
  }

  void savedDialog() async {
    AwesomeDialog(
      width: 550,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: "تم تثبيت جدولك بنجاح",
      desc:
          "ملاحظة: مدة الموعد هي 45 دقيقة, سيتم تقسيم المواعيد المتاحة بناءً على ذلك ",
      titleTextStyle: TextStyle(
        fontSize: 23,
      ),
      // btnOkOnPress: () {},
    ).show();
  }

  void saveFirst() async {
    AwesomeDialog(
            width: 550,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.question,
            title: "هل انت متأكد من العودة بدون حفظ التغييرات؟",
            titleTextStyle: TextStyle(
              fontSize: 20,
            ),
            btnOkOnPress: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => viewAppointmentsSlots()));
            },
            btnCancelOnPress: () {},
            btnCancelColor: Colors.greenAccent,
            btnOkColor: Colors.redAccent,
            btnCancelText: "لا",
            btnOkText: "نعم")
        .show();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
              //bottomNavigationBar: navigationBar(currentIndex: currentIndex),
              body: SafeArea(
                  child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(children: [
              SizedBox(height: 45.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      showInfo();
                    },
                    icon: Icon(Icons.info_outline,
                        color: Color.fromARGB(255, 83, 40, 108), size: 30),
                  ),
                  Text(
                    'ضبط جدولي',
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 83, 40, 108)),
                  ),
                  IconButton(
                    onPressed: () {
                      (!isChanged)
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => viewAppointmentsSlots()))
                          : saveFirst();
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromARGB(255, 83, 40, 108),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.63,
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            width: MediaQuery.of(context).size.height * 0.058,
                            height: MediaQuery.of(context).size.height * 0.067,
                            decoration: BoxDecoration(
                              color: (selectedDay == "sat")
                                  ? Color.fromARGB(160, 145, 75, 185)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (selectedDay != "sat")
                                    ? Color(0xff7d7d7d)
                                    : Color.fromARGB(160, 145, 75, 185),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDay = "sat";
                                });

                                for (int i = 0;
                                    i < _scheduleByDay[selectedDay]!.length;
                                    i++) {
                                  if (((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0)) ||
                                      ((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0.75))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else if (((i > 0) &&
                                      (((_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0) -
                                              (_scheduleByDay[selectedDay]![i - 1][1].hour +
                                                  _scheduleByDay[selectedDay]![i - 1][1].minute / 60.0)) <
                                          0))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else
                                    setState(() {
                                      errorMsg = false;
                                    });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                              child: Center(
                                child: Text(
                                  "السبت",
                                  style: TextStyle(
                                      color: (selectedDay == "sat")
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.058,
                            height: MediaQuery.of(context).size.height * 0.067,
                            decoration: BoxDecoration(
                              color: (selectedDay == "fri")
                                  ? Color.fromARGB(160, 145, 75, 185)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (selectedDay != "fri")
                                    ? Color(0xff7d7d7d)
                                    : Color.fromARGB(160, 145, 75, 185),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDay = "fri";
                                });

                                for (int i = 0;
                                    i < _scheduleByDay[selectedDay]!.length;
                                    i++) {
                                  if (((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0)) ||
                                      ((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0.75))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else if (((i > 0) &&
                                      (((_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0) -
                                              (_scheduleByDay[selectedDay]![i - 1][1].hour +
                                                  _scheduleByDay[selectedDay]![i - 1][1].minute / 60.0)) <
                                          0))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else
                                    setState(() {
                                      errorMsg = false;
                                    });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                              child: Center(
                                child: Text(
                                  "الجمعة",
                                  style: TextStyle(
                                      color: (selectedDay == "fri")
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 12.sp),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.06,
                            height: MediaQuery.of(context).size.height * 0.067,
                            decoration: BoxDecoration(
                              color: (selectedDay == "thu")
                                  ? Color.fromARGB(160, 145, 75, 185)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (selectedDay != "thu")
                                    ? Color(0xff7d7d7d)
                                    : Color.fromARGB(160, 145, 75, 185),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDay = "thu";
                                });

                                for (int i = 0;
                                    i < _scheduleByDay[selectedDay]!.length;
                                    i++) {
                                  if (((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0)) ||
                                      ((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0.75))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else if (((i > 0) &&
                                      (((_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0) -
                                              (_scheduleByDay[selectedDay]![i - 1][1].hour +
                                                  _scheduleByDay[selectedDay]![i - 1][1].minute / 60.0)) <
                                          0))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else
                                    setState(() {
                                      errorMsg = false;
                                    });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                              child: Center(
                                child: Text(
                                  "الخميس",
                                  style: TextStyle(
                                      color: (selectedDay == "thu")
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 11.sp),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.058,
                            height: MediaQuery.of(context).size.height * 0.067,
                            decoration: BoxDecoration(
                              color: (selectedDay == "wed")
                                  ? Color.fromARGB(160, 145, 75, 185)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (selectedDay != "wed")
                                    ? Color(0xff7d7d7d)
                                    : Color.fromARGB(160, 145, 75, 185),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDay = "wed";
                                });

                                for (int i = 0;
                                    i < _scheduleByDay[selectedDay]!.length;
                                    i++) {
                                  if (((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0)) ||
                                      ((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0.75))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else if (((i > 0) &&
                                      (((_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0) -
                                              (_scheduleByDay[selectedDay]![i - 1][1].hour +
                                                  _scheduleByDay[selectedDay]![i - 1][1].minute / 60.0)) <
                                          0))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else
                                    setState(() {
                                      errorMsg = false;
                                    });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                              child: Center(
                                child: Text(
                                  "الأربعاء",
                                  style: TextStyle(
                                      color: (selectedDay == "wed")
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.058,
                            height: MediaQuery.of(context).size.height * 0.067,
                            decoration: BoxDecoration(
                              color: (selectedDay == "tue")
                                  ? Color.fromARGB(160, 145, 75, 185)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (selectedDay != "tue")
                                    ? Color(0xff7d7d7d)
                                    : Color.fromARGB(160, 145, 75, 185),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDay = "tue";
                                });
                                for (int i = 0;
                                    i < _scheduleByDay[selectedDay]!.length;
                                    i++) {
                                  if (((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0)) ||
                                      ((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0.75))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else if (((i > 0) &&
                                      (((_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0) -
                                              (_scheduleByDay[selectedDay]![i - 1][1].hour +
                                                  _scheduleByDay[selectedDay]![i - 1][1].minute / 60.0)) <
                                          0))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else
                                    setState(() {
                                      errorMsg = false;
                                    });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                              child: Center(
                                child: Text(
                                  "الثلاثاء",
                                  style: TextStyle(
                                      color: (selectedDay == "tue")
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.058,
                            height: MediaQuery.of(context).size.height * 0.067,
                            decoration: BoxDecoration(
                              color: (selectedDay == "mon")
                                  ? Color.fromARGB(160, 145, 75, 185)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (selectedDay != "mon")
                                    ? Color(0xff7d7d7d)
                                    : Color.fromARGB(160, 145, 75, 185),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDay = "mon";
                                });
                                for (int i = 0;
                                    i < _scheduleByDay[selectedDay]!.length;
                                    i++) {
                                  if (((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0)) ||
                                      ((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0.75))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else if (((i > 0) &&
                                      (((_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0) -
                                              (_scheduleByDay[selectedDay]![i - 1][1].hour +
                                                  _scheduleByDay[selectedDay]![i - 1][1].minute / 60.0)) <
                                          0))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else
                                    setState(() {
                                      errorMsg = false;
                                    });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                              child: Center(
                                child: Text(
                                  "الإثنين",
                                  style: TextStyle(
                                      color: (selectedDay == "mon")
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.058,
                            height: MediaQuery.of(context).size.height * 0.067,
                            decoration: BoxDecoration(
                              color: (selectedDay == "sun")
                                  ? Color.fromARGB(160, 145, 75, 185)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (selectedDay != "sun")
                                    ? Color(0xff7d7d7d)
                                    : Color.fromARGB(160, 145, 75, 185),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDay = "sun";
                                });

                                for (int i = 0;
                                    i < _scheduleByDay[selectedDay]!.length;
                                    i++) {
                                  if (((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0)) ||
                                      ((((_scheduleByDay[selectedDay]![i][1].hour + _scheduleByDay[selectedDay]![i][1].minute / 60.0) -
                                              (_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0)) <
                                          0.75))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else if (((i > 0) &&
                                      (((_scheduleByDay[selectedDay]![i][0].hour +
                                                  _scheduleByDay[selectedDay]![i][0].minute /
                                                      60.0) -
                                              (_scheduleByDay[selectedDay]![i - 1][1].hour +
                                                  _scheduleByDay[selectedDay]![i - 1][1].minute / 60.0)) <
                                          0))) {
                                    setState(() {
                                      errorMsg = true;
                                    });
                                  } else
                                    setState(() {
                                      errorMsg = false;
                                    });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                              child: Center(
                                child: Text(
                                  "الأحد",
                                  style: TextStyle(
                                      color: (selectedDay == "sun")
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                        ]),
                    SizedBox(
                      width: 30.h,
                    ),
                    getfullContainers([], selectedDay),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                // padding: EdgeInsets.only( left: 90.w , right: 90.w ),
                width: MediaQuery.of(context).size.width * 0.6,
                // height: MediaQuery.of(context).size.height*0.055,
                child: ElevatedButton(
                  onPressed: (!isChanged)
                      ? null
                      : () {
                          bool shouldExit = false;

                          outerLoop:
                          for (final selectedDay in _scheduleByDay.keys) {
                            final timeSlots = _scheduleByDay[selectedDay]!;

                            for (int i = 0; i < timeSlots.length; i++) {
                              if ((((timeSlots[i][1].hour +
                                              timeSlots[i][1].minute / 60.0) -
                                          (timeSlots[i][0].hour +
                                              timeSlots[i][0].minute / 60.0)) <
                                      0) ||
                                  (((timeSlots[i][1].hour +
                                              timeSlots[i][1].minute / 60.0) -
                                          (timeSlots[i][0].hour +
                                              timeSlots[i][0].minute / 60.0)) <
                                      0.75)) {
                                cantSave();
                                shouldExit = true;
                                break outerLoop;
                              } else if (i > 0 &&
                                  ((timeSlots[i][0].hour +
                                              timeSlots[i][0].minute / 60.0) -
                                          (timeSlots[i - 1][1].hour +
                                              timeSlots[i - 1][1].minute /
                                                  60.0)) <
                                      0) {
                                cantSave();
                                shouldExit = true;
                                break outerLoop;
                              }
                            }
                          }

                          if (shouldExit) {
                            return;
                          }

                          savedDialog();
                          setState(() {
                            isChanged = false;
                          });
                          List<DateTime> sunday = [];
                          for (int i = 0;
                              i < _scheduleByDay["sun"]!.length;
                              i++) {
                            sunday.addAll(_scheduleByDay["sun"]![i]);
                          }

                          List<DateTime> monday = [];
                          for (int i = 0;
                              i < _scheduleByDay["mon"]!.length;
                              i++) monday.addAll(_scheduleByDay["mon"]![i]);

                          List<DateTime> tuesday = [];
                          for (int i = 0;
                              i < _scheduleByDay["tue"]!.length;
                              i++) tuesday.addAll(_scheduleByDay["tue"]![i]);

                          List<DateTime> wednesday = [];
                          for (int i = 0;
                              i < _scheduleByDay["wed"]!.length;
                              i++) wednesday.addAll(_scheduleByDay["wed"]![i]);

                          List<DateTime> thursday = [];
                          for (int i = 0;
                              i < _scheduleByDay["thu"]!.length;
                              i++) thursday.addAll(_scheduleByDay["thu"]![i]);

                          List<DateTime> friday = [];
                          for (int i = 0;
                              i < _scheduleByDay["fri"]!.length;
                              i++) friday.addAll(_scheduleByDay["fri"]![i]);

                          List<DateTime> saturday = [];
                          for (int i = 0;
                              i < _scheduleByDay["sat"]!.length;
                              i++) saturday.addAll(_scheduleByDay["sat"]![i]);

                          final db = FirebaseFirestore.instance
                              .collection("weeklySchedule");

                          db
                              .where("SPphone", isEqualTo: specialistPhoneNo)
                              .get()
                              .then((value) {
                            if (value.size > 0) {
                              value.docs.forEach((value1) {
                                db.doc(value1.id).set({
                                  "SPphone": specialistPhoneNo,
                                  "sun": sunday,
                                  "mon": monday,
                                  "tue": tuesday,
                                  "wed": wednesday,
                                  "thu": thursday,
                                  "fri": friday,
                                  "sat": saturday,
                                }).then((value) {
                                  print("Updated successfully");
                                }).catchError((error) {
                                  print("Error updating document: $error");
                                });
                              });
                            } else {
                              db.add({
                                "sun": sunday,
                                "mon": monday,
                                "tue": tuesday,
                                "wed": wednesday,
                                "thu": thursday,
                                "fri": friday,
                                "sat": saturday,
                                "SPphone": specialistPhoneNo,
                              }).then((value) {
                                print(
                                    "Added successfully with ID: ${value.id}");
                              }).catchError((error) {
                                print("Error adding document: $error");
                              });
                            }
                          });
                          print("done");

                          // saveToFirebase();
                        },
                  child: Center(
                    child: Text(
                      'تأكيد جدولي',
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: (!isChanged)
                            ? Color.fromARGB(255, 83, 40, 108)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.only(
                              right: 5.w, left: 5.w, top: 10.h, bottom: 10.h)),
                      backgroundColor: (!isChanged)
                          ? MaterialStateProperty.all<Color>(Color(0xffd9cce1))
                          : MaterialStateProperty.all<Color>(
                              Color.fromARGB(160, 145, 75, 185)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                ),
              ),
            ]),
          )));
        });
  }
}
