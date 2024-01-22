import 'package:ayadi/NavigationPages/Appointment_Lists.dart';
import 'package:ayadi/NavigationPages/SpecialistHomePage.dart';
import 'package:ayadi/NavigationPages/viewAppointmentsSlots.dart';
import 'package:ayadi/NavigationPages/viewSpecialistProfile.dart';
import 'Appointments/SetSchedule.dart';
import 'package:ayadi/chating/chating.dart';
import 'package:ayadi/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SessionUpdateServiceStream.dart';
import 'WelcomePage.dart';
import 'package:intl/date_symbol_data_local.dart';

// the final version of SP App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar_SA');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //Notifications.init();
  runApp(const MyApp());
}

// void listenNotifications(BuildContext context) {
//   Notifications.onNotifications.stream.listen((payload) {
//     onClickedNotification(context, payload);
//   });
// }

// void onClickedNotification(BuildContext context, dynamic payload) {
//   String? payloadString = payload as String?;
//   Navigator.of(context)
//       .push(MaterialPageRoute(builder: (context) => SpecialistHomePage()));
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  final SessionUpdateService _sessionUpdateService = SessionUpdateService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessionUpdateService.start();
  }

  @override
  void dispose() {
    _sessionUpdateService.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sessionUpdateService.start();
    } else if (state == AppLifecycleState.paused) {
      _sessionUpdateService.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayadi',
      home: WelcomePage(),
      locale: Locale('ar', 'SA'),
      theme: ThemeData(
        textTheme: GoogleFonts.vazirmatnTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
