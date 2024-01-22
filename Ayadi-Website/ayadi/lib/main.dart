
import 'package:ayadi/firebase_options.dart';
import 'package:ayadi/parents.dart';
import 'package:ayadi/specialists.dart';
import 'package:ayadi/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ayadi/adminHP.dart';
import 'package:ayadi/applicants.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root
  // of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) { 
        return MaterialApp(
        title: 'Ayadi',
        theme:ThemeData( textTheme: GoogleFonts.vazirmatnTextTheme(
      Theme.of(context).textTheme,
    ),),
        debugShowCheckedModeBanner: false,
        home: AdminHP(),
      );
      },
      designSize:const Size(1512, 982),
    );
  }
}