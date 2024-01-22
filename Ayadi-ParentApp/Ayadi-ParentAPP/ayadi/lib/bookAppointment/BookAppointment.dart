import 'package:ayadi/bookAppointment/searchSpecialist.dart';
import 'package:ayadi/payment/paymentInfo.dart';
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

class BookAppointment extends StatefulWidget {
  final specialistID;
  const BookAppointment({super.key, required this.specialistID});

  @override
  State<BookAppointment> createState() => _BookAppointmentState(specialistID);
}

class _BookAppointmentState extends State<BookAppointment> {
  String specialistID;
  _BookAppointmentState(this.specialistID);

  var parentPhoneNo = FirebaseAuth.instance.currentUser!.phoneNumber;

  bool isSelected = false;
  bool noAppointments = false;
  String? dropdownValue = '-----';
  final _formKey = GlobalKey<FormState>();
  String weekDay = "sun";
  String dayDate = "";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool appointmentsLoaded = false;
  String? childID = "";
  DateTime appDate = DateTime.now();
  int currentIndex = 1;
  late DateTime appointmentDate;

  bool firstSelect = false;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int numOfWorkingDays = 0;

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

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var parentFname = "";
  var parentLname = "";
  var parentEmail = '';
//String parentID = '';
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

  String formattedDay(DateTime dateTime) {
    final format = DateFormat('hh:mm a');
    return format.format(dateTime);
  }

  void _getdata() async {
    // User user = _firebaseAuth.currentUser!;
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
            //parentID = userData.data()!['id'];
            parentPhoneNo = documentSnapshot['phone'];
          });
        } else {
          print('No documents found $parentPhoneNo');
        }
      } else {
        print('No documents found ');
      }
    });
    //print(parentPhoneNo);
    getChildrenName();
    print(childrenName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    _getAppoimntmentsTimes();
  }

  void getChildrenName() {
    childrenName = {};
    String fullName = "";
    childrenName["-----"] = ('-----');
    FirebaseFirestore.instance
        .collection("children")
        .where("parentPhone", isEqualTo: parentPhoneNo)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((element) {
          if (element.exists) {
            var data = element.data();
            String child_id = element["id"];
            String childFname = element['Fname'];
            String childLname = element['Lname'];
            fullName = childFname + " " + childLname;
            setState(() {
              childrenName[fullName] = child_id;
            });
          } else {
            print('No documents found in children');
          }
        });
      } else {
        print('No documents found in children1');
      }
    });
  }

  void SelectChildOrTime() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      //dismissOnTouchOutside: false,
      title: 'الرجاء اختيار الطفل و وقت الموعد   ',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {},
      btnOkText: "الـرجـوع",

      btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  void _getAppoimntmentsTimes() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _scheduleByDay.clear();

    firestore
        .collection('weeklySchedule')
        .where('SPphone', isEqualTo: specialistID)
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
            _selectedDay = firstAvailableDay;
            DateTime sentDay = firstAvailableDay;
            _focusedDay = firstAvailableDay;
            print("focused day is: $_focusedDay");
            int dayNum = firstAvailableDay.weekday;
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

            print(firstAvailableDay);

            _getAppointments(_selectedDay, () {
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

      print('Schedule by day: $_scheduleByDay');
    });
  }

  void _getAppointments(DateTime selectedDay, VoidCallback callback) {
    Map<String, DateTime> reservedAppointmentTimes =
        {}; // Store reserved appointment times for selected day

    FirebaseFirestore.instance
        .collection("sessions")
        .where("specialistPhone", isEqualTo: specialistID)
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

        _scheduleByDay.forEach((day, schedule) {
          for (int i = 0; i < schedule.length; i++) {
            DateTime startTime = schedule[i][0];
            DateTime endTime = schedule[i][1];
            int startMinutes = startTime.hour * 60 + startTime.minute;
            int endMinutes = endTime.hour * 60 + endTime.minute;
            int totalMinutes = endMinutes - startMinutes;

            // Generate appointment times within the current time period if not reserved
            while (totalMinutes >= 45) {
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
                if (((appointmentTime - reservedDateTime).abs() < 45)) {
                  isReserved = true;
                  // break;
                }
              });

              if (!isReserved) {
                appointmentTimes[day]!.add(appointmentTime1);
              }

              startTime = startTime.add(Duration(minutes: 45));
              totalMinutes -= 45;
            }
          }
        });
      });

      // Call the callback to indicate that the operation is complete
      callback();
    });
  }

  void PaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return PaymentInfo(
            childID: childID,
            childName: dropdownValue,
            specialistPhone: specialistID,
            date: appointmentDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
              // bottomNavigationBar: navigationBar(currentIndex: currentIndex),
              body: SafeArea(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'حجز موعد جديد',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop(context);
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    'اسم الطفل',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w100,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                //search bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        // Step 3.

                        value: dropdownValue,

                        items: childrenName.keys
                            .toList()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            alignment: AlignmentDirectional.centerEnd,
                          );
                        }).toList(),
                        // Step 5.
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            //if (newValue != '-----') {
                            //isSelected = true;
                            childID = childrenName[dropdownValue];
                            //}
                            //isSelected = false;
                          });
                        },
                      )),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.027),

                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: Text(
                    'التاريخ و الوقت',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w100,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  margin: EdgeInsets.only(bottom: 10),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.only(left: 15.w, right: 30.w),
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
                                  day.weekday == DateTime.wednesday)
                                return false;

                              if (appointmentTimes["thu"]!.isEmpty &&
                                  day.weekday == DateTime.thursday)
                                return false;

                              if (appointmentTimes["fri"]!.isEmpty &&
                                  day.weekday == DateTime.friday) return false;

                              if (appointmentTimes["sat"]!.isEmpty &&
                                  day.weekday == DateTime.saturday)
                                return false;

                              return true;
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                if (selectedDay != _selectedDay) {
                                  isSelected = false;
                                  appNum = -1;
                                }
                                appointmentTimes = {
                                  'sun': [],
                                  'mon': [],
                                  'tue': [],
                                  'wed': [],
                                  'thu': [],
                                  'fri': [],
                                  'sat': [],
                                };
                                _getAppointments(selectedDay, () {
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

                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),

                      //(appointmentTimes[weekDay]!.isNotEmpty)
                      if (appointmentsLoaded)
                        Container(
                            width: MediaQuery.of(context).size.width * 0.92,
                            child: Wrap(
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
                                    Container(
                                      // padding: EdgeInsets.only(bottom: 5.h),
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
                                              appDate =
                                                  appointmentTimes[weekDay]![i];
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
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsets>(
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
                                                    style: BorderStyle.solid)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ))),
                                      ),
                                    ),
                              ],
                            )),
                    ]),
                  ),
                ),
                if (noAppointments)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.92,
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Center(
                      child: Text(
                        "لا يوجد مواعيد",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                ElevatedButton(
                  onPressed: () {
                    if ((!isSelected || (dropdownValue == '-----'))) {
                      SelectChildOrTime();
                    } else {
                      setState(() {
                        appointmentDate = DateTime(
                            _selectedDay.year,
                            _selectedDay.month,
                            _selectedDay.day,
                            appDate.hour,
                            appDate.minute,
                            0,
                            0,
                            0);
                      });

                      print(appointmentDate);
                      print("child id is: $childID");

                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentPage(childID: childID , childName: dropdownValue, specialistPhone: specialistID, date:appointmentDate )));
                      PaymentSheet(context);
                    }
                  },
                  child: Text(
                    'تـأكـيـد',
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: ((isSelected && (dropdownValue != '-----')))
                            ? Colors.white
                            : Colors.black),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.only(
                              top: 10.h,
                              bottom: 10.h,
                              left: 70.w,
                              right: 70.w)),
                      backgroundColor:
                          ((isSelected && (dropdownValue != '-----')))
                              ? MaterialStateProperty.all<Color>(
                                  Color.fromARGB(160, 145, 75, 185))
                              : MaterialStateProperty.all<Color>(
                                  Color.fromARGB(98, 158, 158, 158)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ))),
                ),
              ],
            ),
          ));
        });
  }
}
