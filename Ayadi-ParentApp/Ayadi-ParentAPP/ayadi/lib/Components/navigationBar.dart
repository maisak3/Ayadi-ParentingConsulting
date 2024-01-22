import 'package:ayadi/NavigationPages/account_and_Children.dart';
import 'package:ayadi/NavigationPages/parentHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ayadi/addChild/addChild.dart';

import '../NavigationPages/Appointment_Lists.dart';

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
          Icons.family_restroom,
          color: Color.fromRGBO(131, 126, 189, 1),
          size: 30,
        ),
        Icon(
          Icons.calendar_today_rounded,
          color: Color.fromRGBO(131, 126, 189, 1),
          size: 30,
        ),
        Icon(
          Icons.home_rounded,
          color: Color.fromRGBO(131, 126, 189, 1),
          size: 30,
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (_, __, ___) => accountChildren()));
        }

        if (index == 1) {
          Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (_, __, ___) => AppointmentList()));
        }
        if (index == 2) {
          Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (_, __, ___) => parentHomePage()));
        }
      },

      // letIndexChange: (index) => true,
    );
  }
}
