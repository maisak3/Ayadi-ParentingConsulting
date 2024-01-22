import 'package:ayadi/NavigationPages/Appointment_Lists.dart';
import 'package:ayadi/NavigationPages/viewAppointmentsSlots.dart';
import 'package:ayadi/NavigationPages/viewSpecialistProfile.dart';
import 'package:ayadi/NavigationPages/SpecialistHomePage.dart';
import 'package:ayadi/Appointments/SetSchedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//import '../NavigationPages/Appointment_Lists.dart';

class navigationBar extends StatelessWidget {
  const navigationBar({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,

      // backgroundColor: Colors.white,
      color: Color.fromRGBO(234, 232, 248, 1),
      animationDuration: Duration(milliseconds: 500),
      height: 75.0.h,
      index: currentIndex,

      items: [
        Icon(
          Icons.person,
          color: Color.fromRGBO(131, 126, 189, 1),
          size: 30,
        ),
        Icon(
          Icons.calendar_today_rounded,
          color: Color.fromRGBO(131, 126, 189, 1),
          size: 30,
        ),
        Icon(
          Icons.access_alarm_rounded,
          color: Color.fromRGBO(131, 126, 189, 1),
          size: 32,
        ),
        Icon(
          Icons.home_rounded,
          color: Color.fromRGBO(131, 126, 189, 1),
          size: 30,
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => viewSpecialistProfile()));
        }

        if (index == 1) {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => viewAppointmentsSlots()));
        }
        if (index == 2) {
          Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (_, __, ___) => AppointmentList()));
        }
        if (index == 3) {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => SpecialistHomePage()));
        }
      },

      // letIndexChange: (index) => true,
    );
  }
}
