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
import 'package:ayadi/NavigationPages/specialistHomePage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ayadi/Components/navigationBar.dart';
import 'package:intl/intl.dart';

class viewAppointmentsSlots extends StatefulWidget {
  const viewAppointmentsSlots({super.key});

  @override
  State<viewAppointmentsSlots> createState() => _viewAppointmentsSlotsState();
}

class _viewAppointmentsSlotsState extends State<viewAppointmentsSlots> {
  bool isSelected = false;
  bool noAppointments = false;
  String? dropdownValue = '-----';
  final _formKey = GlobalKey<FormState>();
  String weekDay = "sun";
  String dayDate = "";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool appointmentsLoaded = false;
  DateTime appDate = DateTime.now();
  int currentIndex = 1;
  bool showLoading = false;
  bool firstSelect = false;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int numOfWorkingDays = 0;

  int appNum = -1;

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

  Map<String, List<List<DateTime>>> _scheduleByDay = {
    "sun": [],
    "mon": [],
    "tue": [],
    "wed": [],
    "thu": [],
    "fri": [],
    "sat": [],
  };

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var specialistFname = "";
  var specialistLname = "";
  var specialistEmail = '';
//String specialistID = '';
  var specialistPhoneNo = '';
  var avgRate = 0;
  var numOfRates = 0;
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

  void _getdata() async {
    // setState(() {
    //   showLoading = true;
    // });
    User user = _firebaseAuth.currentUser!;
    print("user phone is ${user.phoneNumber}");
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
            //specialistEmail = documentSnapshot['email'];
            //specialistID = userData.data()!['id'];
            specialistPhoneNo = documentSnapshot['phoneNumber'];
            //avgRate = documentSnapshot["avgRate"] * 1.0;
            numOfRates = documentSnapshot["numOfRates"];
            print(specialistFname + "hi");
          });
        } else {
          print('No documents found');
        }
      } else {
        print('No documents found');
      }
      // setState(() {
      //   showLoading = true;
      // });
    });
    print(childrenName);
    //_getAppoimntmentsTimes();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    _getAppoimntmentsTimes();
  }

  void _getAppoimntmentsTimes() {
    // setState(() {
    //   showLoading = true;
    // });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _scheduleByDay.clear();
    print(specialistPhoneNo);

    firestore
        .collection('weeklySchedule')
        .where('SPphone', isEqualTo: _firebaseAuth.currentUser!.phoneNumber)
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

                // Calculate total number of minutes between startTime and endTime
                int startMinutes = startTime.hour * 60 + startTime.minute;
                int endMinutes = endTime.hour * 60 + endTime.minute;
                int totalMinutes = endMinutes - startMinutes;

                // Generate appointment times within the current time period
                while (totalMinutes >= 45) {
                  appointmentTimes[day]!.add(startTime);
                  startTime = startTime.add(Duration(minutes: 45));
                  totalMinutes -= 45;
                }
              }
            });

            print(appointmentTimes);
            // removeReservedAppointment(_selectedDay, () {
            //   appointmentsLoaded = true;
            // });
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

      // setState(() {
      //   showLoading = false;
      // });
    });
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
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(height: 30.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Text(
                              "جدولي",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Text(
                                " جدول مواعيدك كما يظهر للآباء" + " * ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              child: TableCalendar(
                                locale: 'ar_SA',
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now().add(Duration(days: 60)),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) =>
                                    isSameDay(_selectedDay, day),
                                calendarFormat: _calendarFormat,
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
                                  todayTextStyle:
                                      TextStyle(color: Colors.black),
                                  outsideTextStyle:
                                      TextStyle(color: Colors.black),
                                  selectedDecoration: BoxDecoration(
                                    color: Color.fromARGB(160, 145, 75, 185),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                enabledDayPredicate: (day) {
                                  if (appointmentTimes["sun"]!.isEmpty &&
                                      day.weekday == DateTime.sunday)
                                    return false;

                                  if (appointmentTimes["mon"]!.isEmpty &&
                                      day.weekday == DateTime.monday)
                                    return false;

                                  if (appointmentTimes["tue"]!.isEmpty &&
                                      day.weekday == DateTime.tuesday)
                                    return false;

                                  if (appointmentTimes["wed"]!.isEmpty &&
                                      day.weekday == DateTime.wednesday)
                                    return false;

                                  if (appointmentTimes["thu"]!.isEmpty &&
                                      day.weekday == DateTime.thursday)
                                    return false;

                                  if (appointmentTimes["fri"]!.isEmpty &&
                                      day.weekday == DateTime.friday)
                                    return false;

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
                                    if (selectedDay != _selectedDay)
                                      appNum = -1;
                                    // removeReservedAppointment(selectedDay, () {
                                    //   appointmentsLoaded = true;
                                    // });
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
                                                        : (selectedDay
                                                                    .weekday ==
                                                                5)
                                                            ? weekDay = "fri"
                                                            : weekDay = "sat";
                                    print(
                                        "week day is: ${selectedDay.weekday} ");

                                    //    DateTime firstAvailableDay = DateTime.now();
                                    // while (!enabledDayPredicate(firstAvailableDay)) {
                                    //   firstAvailableDay = firstAvailableDay.add(Duration(days: 1));
                                    // }

                                    // _selectedDay = firstAvailableDay;
                                  });
                                },
                              )),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015),

//(appointmentTimes[weekDay]!.isNotEmpty)
                          if (!noAppointments)
                            Container(
                              width: MediaQuery.of(context).size.width * 0.92,
                              height: 155,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Wrap(
                                  children: [
                                    for (int i = 0;
                                        (i < appointmentTimes[weekDay]!.length);
                                        i++)
                                      Container(
                                        padding: EdgeInsets.only(bottom: 0.h),
                                        margin: EdgeInsets.only(left: 5.w),
                                        child: TextButton(
                                          onPressed: null,
                                          child: Text(
                                            '${((appointmentTimes[weekDay]![i].hour) > 12) ? ((appointmentTimes[weekDay]![i].hour) - 12) : (appointmentTimes[weekDay]![i].hour)}:${appointmentTimes[weekDay]![i].minute.toString().padLeft(2, '0')}${((appointmentTimes[weekDay]![i].hour) > 12) ? " PM" : " AM"}',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.black54),
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
                                                      width: 1.0,
                                                      style:
                                                          BorderStyle.solid)),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ))),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          if (noAppointments)
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.92,
                              height:
                                  MediaQuery.of(context).size.height * 0.215,
                              child: Center(
                                child: Text(
                                  "لم تقم بضبط جدولك بعد \n قم بالذهاب إلى *ضبط جدولي* للبدء",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                          // if (!appointmentsLoaded && !noAppointments)
                          //   SizedBox(
                          //     width: MediaQuery.of(context).size.width * 0.92,
                          //     height: MediaQuery.of(context).size.height * 0.15,
                          //   ),

                          // :Column(
                          //   children: [
                          //     //CircularProgressIndicator(color: Colors.deepPurple[100]!),
                          //     SizedBox(
                          //       height: MediaQuery.of(context).size.height * 0.15  ,
                          //       ),

                          //   ],
                          // ),

                          SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SetSchedule()));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'ضبط جدولي',
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.edit_calendar,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.only(
                                              top: 10.h,
                                              bottom: 10.h,
                                              left: 50.w,
                                              right: 45.w)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(160, 145, 75, 185)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    ));
        });
  }
}
