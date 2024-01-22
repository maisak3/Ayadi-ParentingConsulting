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
import 'package:ayadi/NavigationPages/parentHomePage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ayadi/Components/navigationBar.dart';
import 'package:intl/intl.dart';

import '../Components/whiteGlassContainer.dart';

class EditAppointment extends StatefulWidget {
  final session;
  const EditAppointment({super.key, required this.session});

  @override
  State<EditAppointment> createState() => _EditAppointmentState(session);
}

class _EditAppointmentState extends State<EditAppointment> {
  final session;
  _EditAppointmentState(this.session);

  bool isSelected = false;
  bool noAppointments = false;
  String? dropdownValue = '-----';
  String weekDay = "sun";
  String dayDate = "";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool appointmentsLoaded = false;
  String? childID = "";
  DateTime appDate = DateTime.now();
  int currentIndex = 1;
  bool buttonEnabledD = true;
  var parentPhoneNo = FirebaseAuth.instance.currentUser!.phoneNumber;
  DateTime sessionDate = DateTime.now();
  String parentID = "";
  var parentWallet = 0.0;

  bool firstSelect = false;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool enabledDayPredicate(DateTime day) {
    if (_scheduleByDay["sun"]!.isEmpty && day.weekday == DateTime.sunday)
      return false;

    if (_scheduleByDay["mon"]!.isEmpty && day.weekday == DateTime.monday)
      return false;

    if (_scheduleByDay["tue"]!.isEmpty && day.weekday == DateTime.tuesday)
      return false;

    if (_scheduleByDay["wed"]!.isEmpty && day.weekday == DateTime.wednesday)
      return false;

    if (_scheduleByDay["thu"]!.isEmpty && day.weekday == DateTime.thursday)
      return false;

    if (_scheduleByDay["fri"]!.isEmpty && day.weekday == DateTime.friday)
      return false;

    if (_scheduleByDay["sat"]!.isEmpty && day.weekday == DateTime.saturday)
      return false;

    return true;
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
            btnOkOnPress: () {
              Navigator.of(context).pop();
            },
            btnOkText: "عودة")
        .show();
  }

  void changesSaved() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,

      headerAnimationLoop: false,
      animType: AnimType.rightSlide,

      title: 'تم حفظ التغييرات بنجاح',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {
        Navigator.of(context).pop();
      },

      // btnCancelOnPress: () {},
      btnOkText: "الرجوع",
      // btnCancelText: "لا",

      //btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
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

  int appNum = -1;

  Map<String, List<List<DateTime>>> _scheduleByDay = {
    "sun": [],
    "mon": [],
    "tue": [],
    "wed": [],
    "thu": [],
    "fri": [],
    "sat": [],
  };

  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var parentFname = "";
  var parentLname = "";
  var parentEmail = '';
//String parentID = '';
  // var parentPhoneNo = '';
  Map<String, String> childrenName = {};
  Map<String, List<DateTime>> appointmentTimes = {
    "sun": [],
    "mon": [],
    "tue": [],
    "wed": [],
    "thu": [],
    "fri": [],
    "sat": [],
  };

  Map<String, List<DateTime>> newAppointmentTimes = {
    "sun": [],
    "mon": [],
    "tue": [],
    "wed": [],
    "thu": [],
    "fri": [],
    "sat": [],
  };

  void _getdata() async {
    //User user = _firebaseAuth.currentUser!;
    //print(user.phoneNumber);
    FirebaseFirestore.instance
        .collection('parent')
        .where("phone", isEqualTo: parentPhoneNo)
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
            parentID = documentSnapshot.id;
            parentWallet = documentSnapshot["wallet"];
            //parentPhoneNo = documentSnapshot['phone'];
          });
        } else {
          print('No documents found $parentPhoneNo');
        }
      } else {
        print('No documents found ');
      }
    });
    print(parentPhoneNo);

    sessionDate = session["date"].toDate();
    print("the session date it $sessionDate");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    _getAppoimntmentsTimes();
    formattedDate(session["date"]);
    print("in the edit appointment");
  }

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    DateTime now = DateTime.now();
    Duration difference = dateFromTimeStamp.difference(now);
    if (difference.inHours < 48) {
      buttonEnabledD = false;
    } else {
      buttonEnabledD = true;
    }
    return DateFormat('dd MMM, yyyy').format(dateFromTimeStamp);
  }

  String formattedDay(DateTime dateTime) {
    final format = DateFormat('hh:mm a');
    return format.format(dateTime);
  }

  void _getAppoimntmentsTimes() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _scheduleByDay.clear();

    firestore
        .collection('weeklySchedule')
        .where('SPphone', isEqualTo: session["specialistPhone"])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          //numOfWorkingDays = documentSnapshot["numOfDays"];
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
              'sun': sunday,
              'mon': monday,
              'tue': tuesday,
              'wed': wednesday,
              'thu': thursday,
              'fri': friday,
              'sat': saturday,
            };

            DateTime firstAvailableDay = DateTime.now();
            while (!enabledDayPredicate(firstAvailableDay)) {
              firstAvailableDay = firstAvailableDay.add(Duration(days: 1));
            }
            // Set the initial selected day to the first available day
            _selectedDay = session["date"].toDate();
            DateTime sentDay = firstAvailableDay;
            _focusedDay = session["date"].toDate();
            print("focused day is: $_focusedDay");
            int dayNum = _selectedDay.weekday;
            weekDay = (dayNum == 7)
                ? "sun"
                : (dayNum == 1)
                    ? "mon"
                    : (dayNum == 2)
                        ? "tue"
                        : (dayNum == 3)
                            ? "wed"
                            : (dayNum == 4)
                                ? "thu"
                                : (dayNum == 5)
                                    ? "fri"
                                    : "sat";

            removeReservedAppointment(_selectedDay, () {
              appointmentsLoaded = true;
            });
          });
        });
      } else {
        setState(() {
          _scheduleByDay = {
            'sun': [],
            'mon': [],
            'tue': [],
            'wed': [],
            'thu': [],
            'fri': [],
            'sat': [],
          };
          noAppointments = true;
        });

        print('No documents found');
      }
    });
  }

  void removeReservedAppointment(DateTime selectedDay, VoidCallback callback) {
    Map<String, DateTime> reservedAppointmentTimes =
        {}; // Store reserved appointment times for selected day

    FirebaseFirestore.instance
        .collection("sessions")
        .where("specialistPhone", isEqualTo: session["specialistPhone"])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          DateTime reservedDate = documentSnapshot["date"].toDate();
          if (selectedDay.year == reservedDate.year &&
              selectedDay.month == reservedDate.month &&
              selectedDay.day == reservedDate.day) {
            reservedAppointmentTimes[documentSnapshot.id] = reservedDate;
          }
        });
      }

      setState(() {
        appointmentTimes = {
          'sun': [],
          'mon': [],
          'tue': [],
          'wed': [],
          'thu': [],
          'fri': [],
          'sat': [],
        };

        newAppointmentTimes = {
          'sun': [],
          'mon': [],
          'tue': [],
          'wed': [],
          'thu': [],
          'fri': [],
          'sat': [],
        };

        _scheduleByDay.forEach((day, schedule) {
          for (int i = 0; i < schedule.length; i++) {
            DateTime startTime = schedule[i][0];
            DateTime endTime = schedule[i][1];
            int startMinutes = startTime.hour * 60 + startTime.minute;
            int endMinutes = endTime.hour * 60 + endTime.minute;
            int totalMinutes = endMinutes - startMinutes;

            // Generate appointment times within the current time period if not reserved
            while (totalMinutes >= 45) {
              bool isReservedNew = false;
              bool isReserved = false;
              DateTime appointmentTime1 = DateTime(
                selectedDay.year,
                selectedDay.month,
                selectedDay.day,
                startTime.hour,
                startTime.minute,
              );

              int appointmentTime =
                  (appointmentTime1.hour * 60) + appointmentTime1.minute;

              reservedAppointmentTimes.forEach((documentId, reservedDateTime1) {
                int reservedDateTime =
                    (reservedDateTime1.hour * 60) + appointmentTime1.minute;
                if (((appointmentTime - reservedDateTime).abs() < 45) &&
                    ((appointmentTime - reservedDateTime).abs() == 0) &&
                    (session.id != documentId)) {
                  print("appointment time is $appointmentTime1");
                  print("and reserved appointment is $reservedDateTime1");
                  isReservedNew = true;
                  // break;
                } else if (((appointmentTime - reservedDateTime).abs() == 0) &&
                    (session.id != documentId)) {
                  isReserved = true;
                }
              });

              if (!isReservedNew) {
                newAppointmentTimes[day]!.add(appointmentTime1);
              }

              if (!isReserved) {
                appointmentTimes[day]!.add(appointmentTime1);
              }

              startTime = startTime.add(Duration(minutes: 45));
              totalMinutes -= 45;
            }
          }
        });

        // print (appointmentTimes);
        // print (newAppointmentTimes);
      });

      // Call the callback to indicate that the operation is complete
      callback();
    });
  }

  Widget whiteGlassContainer1() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        width: 400,
        height: 700,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      child: Stack(children: [
        whiteGlassContainer1(),
        Container(
          height: 610,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 40.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Text(
                  "تعديل وقت الموعد",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                        padding:
                            EdgeInsets.only(left: 15.w, right: 30.w, top: 10),
                        child: TableCalendar(
                          locale: 'ar_SA',
                          firstDay: DateTime.now(),
                          lastDay: DateTime.now().add(Duration(days: 60)),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          calendarFormat: _calendarFormat,
                          availableCalendarFormats: const {
                            CalendarFormat.month: 'Month'
                          },
                          rowHeight: 40,
                          daysOfWeekHeight: 20,
                          headerStyle: HeaderStyle(
                            headerPadding: EdgeInsets.zero,
                            formatButtonVisible: false,
                            titleTextStyle: TextStyle(fontSize: 18),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                                color: Colors.purple[400], fontSize: 13),
                            weekendStyle: TextStyle(
                                color: Colors.purple[400], fontSize: 13),
                          ),
                          calendarStyle: CalendarStyle(
                            cellMargin: EdgeInsets.all(2),
                            todayDecoration: BoxDecoration(
                              //border: Border.all(color:Colors.black ),
                              color: Color.fromARGB(159, 209, 198, 215),
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: TextStyle(color: Colors.black),
                            outsideTextStyle: TextStyle(color: Colors.black),
                            selectedDecoration: BoxDecoration(
                              color: Color.fromARGB(160, 145, 75, 185),
                              shape: BoxShape.circle,
                            ),
                          ),
                          enabledDayPredicate: (day) {
                            if (appointmentTimes["sun"]!.isEmpty &&
                                day.weekday == DateTime.sunday) return false;

                            if (appointmentTimes["mon"]!.isEmpty &&
                                day.weekday == DateTime.monday) return false;

                            if (appointmentTimes["tue"]!.isEmpty &&
                                day.weekday == DateTime.tuesday) return false;

                            if (appointmentTimes["wed"]!.isEmpty &&
                                day.weekday == DateTime.wednesday) return false;

                            if (appointmentTimes["thu"]!.isEmpty &&
                                day.weekday == DateTime.thursday) return false;

                            if (appointmentTimes["fri"]!.isEmpty &&
                                day.weekday == DateTime.friday) return false;

                            if (appointmentTimes["sat"]!.isEmpty &&
                                day.weekday == DateTime.saturday) return false;

                            return true;
                          },
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              if (selectedDay != _selectedDay) appNum = -1;
                              appointmentTimes = {
                                'sun': [],
                                'mon': [],
                                'tue': [],
                                'wed': [],
                                'thu': [],
                                'fri': [],
                                'sat': [],
                              };
                              removeReservedAppointment(selectedDay, () {
                                appointmentsLoaded = true;
                              });
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                              (selectedDay.weekday == 7)
                                  ? weekDay = "sun"
                                  : (selectedDay.weekday == 1)
                                      ? weekDay = "mon"
                                      : (selectedDay.weekday == 2)
                                          ? weekDay = "tue"
                                          : (selectedDay.weekday == 3)
                                              ? weekDay = "wed"
                                              : (selectedDay.weekday == 4)
                                                  ? weekDay = "thu"
                                                  : (selectedDay.weekday == 5)
                                                      ? weekDay = "fri"
                                                      : weekDay = "sat";
                              print("week day is: ${selectedDay.weekday} ");

                              //    DateTime firstAvailableDay = DateTime.now();
                              // while (!enabledDayPredicate(firstAvailableDay)) {
                              //   firstAvailableDay = firstAvailableDay.add(Duration(days: 1));
                              // }

                              // _selectedDay = firstAvailableDay;
                            });
                          },
                        )),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                    //(appointmentTimes[weekDay]!.isNotEmpty)
                    if (appointmentsLoaded)
                      (newAppointmentTimes.isNotEmpty)
                          ? Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.92,
                              // height: MediaQuery.of(context).size.height * 0.25,
                              child: Column(
                                children: [
                                  if (!(newAppointmentTimes[weekDay]!.any(
                                      (appointment) =>
                                          appointment.hour ==
                                              sessionDate.hour &&
                                          appointment.minute ==
                                              sessionDate.minute)))
                                    Text(
                                      "قام الأخصائي بتحديث ساعات عمله بعد حجز موعدك*\nاختر وقتًا جديدًا أو قم بالعودة بدون تغيير",
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  Wrap(
                                    spacing: 2,
                                    runSpacing: -10,
                                    children: [
                                      for (int i = 0;
                                          (i <
                                              newAppointmentTimes[weekDay]!
                                                  .length);
                                          i++)
                                        if (!((_selectedDay.year ==
                                                    DateTime.now().year &&
                                                _selectedDay.month ==
                                                    DateTime.now().month &&
                                                _selectedDay.day ==
                                                    DateTime.now().day) &&
                                            ((newAppointmentTimes[weekDay]![i]
                                                            .hour *
                                                        60 +
                                                    newAppointmentTimes[
                                                            weekDay]![i]
                                                        .minute) <=
                                                (DateTime.now().hour * 60 +
                                                    DateTime.now().minute))))
                                          if ((newAppointmentTimes[weekDay]![i]
                                                      .hour ==
                                                  sessionDate.hour) &&
                                              (newAppointmentTimes[weekDay]![i]
                                                      .minute ==
                                                  sessionDate.minute))
                                            Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 5.h),
                                              margin:
                                                  EdgeInsets.only(left: 5.w),
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if ((appNum == i)) {
                                                      appNum = -1;
                                                      isSelected = false;
                                                    } else {
                                                      appNum = i;
                                                      isSelected = false;
                                                      appDate =
                                                          newAppointmentTimes[
                                                              weekDay]![i];
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  '${formattedDay(newAppointmentTimes[weekDay]![i])}',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: (appNum == i)
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: (appNum == i)
                                                        ? Colors.purple
                                                        : Colors.white,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty
                                                      .all<EdgeInsets>(
                                                          EdgeInsets.only(
                                                              top: 5.h,
                                                              bottom: 5.h,
                                                              left: 15.h,
                                                              right: 15.h)),
                                                  //backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                  side: MaterialStateProperty
                                                      .all(BorderSide(
                                                          color: (appNum ==
                                                                  i)
                                                              ? Colors.purple
                                                              : Color.fromARGB(
                                                                  159,
                                                                  191,
                                                                  131,
                                                                  226),
                                                          width: (appNum == i)
                                                              ? 2.0
                                                              : 1.0,
                                                          style: BorderStyle
                                                              .solid)),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  )),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color.fromARGB(159,
                                                              191, 131, 226)),
                                                ),
                                              ),
                                            )
                                          else
                                            Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 5.h),
                                              margin:
                                                  EdgeInsets.only(left: 5.w),
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if ((appNum == i)) {
                                                      appNum = -1;
                                                      isSelected = false;
                                                    } else {
                                                      appNum = i;
                                                      isSelected = true;
                                                      appDate =
                                                          newAppointmentTimes[
                                                              weekDay]![i];
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  '${formattedDay(newAppointmentTimes[weekDay]![i])}',
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: (appNum == i)
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      color: (appNum == i)
                                                          ? Colors.purple
                                                          : Colors.grey),
                                                ),
                                                style: ButtonStyle(
                                                    padding: MaterialStateProperty
                                                        .all<EdgeInsets>(EdgeInsets.only(
                                                            top: 5.h,
                                                            bottom: 5.h,
                                                            left: 15.h,
                                                            right: 15.h)),
                                                    //backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                    side: MaterialStateProperty.all(
                                                        BorderSide(
                                                            color: (appNum == i)
                                                                ? Colors.purple
                                                                : Colors.grey,
                                                            width: (appNum == i)
                                                                ? 2.0
                                                                : 1.0,
                                                            style: BorderStyle
                                                                .solid)),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ))),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ))
                          : Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.92,
                              // height: MediaQuery.of(context).size.height * 0.25,
                              child: Wrap(
                                spacing: 2,
                                runSpacing: -10,
                                children: [
                                  for (int i = 0;
                                      (i < appointmentTimes[weekDay]!.length);
                                      i++)
                                    if (!((_selectedDay.year ==
                                                DateTime.now().year &&
                                            _selectedDay.month ==
                                                DateTime.now().month &&
                                            _selectedDay.day ==
                                                DateTime.now().day) &&
                                        ((appointmentTimes[weekDay]![i].hour *
                                                    60 +
                                                appointmentTimes[weekDay]![i]
                                                    .minute) <=
                                            (DateTime.now().hour * 60 +
                                                DateTime.now().minute))))
                                      if ((appointmentTimes[weekDay]![i].hour ==
                                              sessionDate.hour) &&
                                          (appointmentTimes[weekDay]![i]
                                                  .minute ==
                                              sessionDate.minute))
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5.h),
                                          margin: EdgeInsets.only(left: 5.w),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if ((appNum == i)) {
                                                  appNum = -1;
                                                  isSelected = false;
                                                } else {
                                                  appNum = i;
                                                  isSelected = false;
                                                  appDate = appointmentTimes[
                                                      weekDay]![i];
                                                }
                                              });
                                            },
                                            child: Text(
                                              '${formattedDay(appointmentTimes[weekDay]![i])}',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: (appNum == i)
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: (appNum == i)
                                                    ? Colors.purple
                                                    : Colors.white,
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsets>(
                                                      EdgeInsets.only(
                                                          top: 5.h,
                                                          bottom: 5.h,
                                                          left: 15.h,
                                                          right: 15.h)),
                                              //backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      color: (appNum == i)
                                                          ? Colors.purple
                                                          : Color.fromARGB(159,
                                                              191, 131, 226),
                                                      width: (appNum == i)
                                                          ? 2.0
                                                          : 1.0,
                                                      style:
                                                          BorderStyle.solid)),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              )),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Color.fromARGB(
                                                          159, 191, 131, 226)),
                                            ),
                                          ),
                                        )
                                      else
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5.h),
                                          margin: EdgeInsets.only(left: 5.w),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if ((appNum == i)) {
                                                  appNum = -1;
                                                  isSelected = false;
                                                } else {
                                                  appNum = i;
                                                  isSelected = true;
                                                  appDate = appointmentTimes[
                                                      weekDay]![i];
                                                }
                                              });
                                            },
                                            child: Text(
                                              '${formattedDay(appointmentTimes[weekDay]![i])}',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: (appNum == i)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: (appNum == i)
                                                      ? Colors.purple
                                                      : Colors.grey),
                                            ),
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsets>(
                                                        EdgeInsets.only(
                                                            top: 5.h,
                                                            bottom: 5.h,
                                                            left: 15.h,
                                                            right: 15.h)),
                                                //backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                side: MaterialStateProperty.all(
                                                    BorderSide(
                                                        color: (appNum == i)
                                                            ? Colors.purple
                                                            : Colors.grey,
                                                        width: (appNum == i)
                                                            ? 2.0
                                                            : 1.0,
                                                        style:
                                                            BorderStyle.solid)),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ))),
                                          ),
                                        ),
                                ],
                              ))
                  ]),
                ),
              ),

              // if (noAppointments)
              //   SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.92,
              //     height: MediaQuery.of(context).size.height * 0.05,
              //     child: Center(
              //       child: Text(
              //         "لا يوجد مواعيد",
              //         style: TextStyle(fontSize: 18),
              //       ),
              //     ),
              //   ),
              // if (!appointmentsLoaded && !noAppointments)
              //   SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.92,
              //     height: MediaQuery.of(context).size.height * 0.01,
              //   ),
              // :Column(
              //   children: [
              //     //CircularProgressIndicator(color: Colors.deepPurple[100]!),
              //     SizedBox(
              //       height: MediaQuery.of(context).size.height * 0.15  ,
              //       ),

              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        AwesomeDialog(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          context: context,
                          animType: AnimType.leftSlide,
                          headerAnimationLoop: false,
                          dialogType: DialogType.question,
                          title: 'هل انت متأكد من حذف موعدك؟',
                          desc: (buttonEnabledD)
                              ? "تنبيه: بقي على الموعد أقل من 48 ساعة لذلك لن تتمكن من استرجاع المبلغ"
                              : "",
                          titleTextStyle: TextStyle(
                            fontSize: 23.sp,
                          ),
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            if (buttonEnabledD) {
                              var sessionPrice = session["price"] * 1.0;
                              parentWallet =
                                  (parentWallet + sessionPrice) * 1.0;
                              FirebaseFirestore.instance
                                  .collection("parent")
                                  .doc(parentID)
                                  .update({"wallet": parentWallet});
                            }
                            FirebaseFirestore.instance
                                .collection("sessions")
                                .doc(session.id)
                                .delete();
                            deleted();
                            // Navigator.pop(context, 'YES');
                          },
                          btnOkText: "نعم",
                          btnCancelText: "لا",
                          btnCancelColor: Color(0xFF00CA71),
                          btnOkColor: Color.fromARGB(255, 211, 59, 42),
                        ).show();
                      },
                      child: Text(
                        'حذف الموعد',
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.only(
                                top: 20.h,
                                bottom: 20.h,
                                left: 40.w,
                                right: 40.w)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                        // shape:
                        //     MaterialStateProperty.all<RoundedRectangleBorder>(
                        //         RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12.0),
                        // ))
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (!isSelected)
                          ? null
                          : () {
                              DateTime appointmentDate = DateTime(
                                  _selectedDay.year,
                                  _selectedDay.month,
                                  _selectedDay.day,
                                  appDate.hour,
                                  appDate.minute,
                                  0,
                                  0,
                                  0);
                              FirebaseFirestore.instance
                                  .collection("sessions")
                                  .doc(session.id)
                                  .update({
                                'date': appointmentDate,
                              });

                              changesSaved();
                            },
                      child: Text(
                        'حفظ التغييرات',
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: (isSelected) ? Colors.white : Colors.black),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.only(
                                top: 20.h,
                                bottom: 20.h,
                                left: 40.w,
                                right: 40.w)),
                        backgroundColor: (isSelected)
                            ? MaterialStateProperty.all<Color>(
                                Color.fromARGB(160, 145, 75, 185))
                            : MaterialStateProperty.all<Color>(
                                Color.fromARGB(98, 158, 158, 158)),
                        // shape:
                        //     MaterialStateProperty.all<RoundedRectangleBorder>(
                        //         RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12.0),
                        // ))
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
