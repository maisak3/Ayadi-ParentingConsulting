import 'package:ayadi/Components/glassContainer.dart';
import 'package:ayadi/Reg-login/EnterPhone.dart';
import 'Reg-login/OTPpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pinput/pinput.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController phoneController = TextEditingController();

  double welcomeHeight = 1000;
  double welcomeWidth = 1000;
  double welcomeX = 0;
  double welcomeY = 0;
  bool showInfoHome = false;

  //responsive sizes

  void sizeWelcome() {
    setState(() {
      welcomeHeight = 380;
      welcomeWidth = 380;
    });
  }

  void moveWelcome() {
    setState(() {
      welcomeX = -2;
      welcomeY = -2;
      showInfoHome = true;
    });
  }

  void _showModalBottomSheetEnterPhone(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return EnterPhone();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        sizeWelcome();
        moveWelcome();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Stack(
          children: [
            //animation
            Center(
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                height: welcomeHeight,
                width: welcomeWidth,
                alignment: Alignment(welcomeX, welcomeY),
                child: Lottie.network(
                    'https://lottie.host/01f578b2-5f74-4c5c-91c5-1c9bdf30cd3b/4xsTKMHdyZ.json'),
              ),
            ),
            //text in intro
            if (showInfoHome)
              Center(
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  child: Text(
                    'لتخدم عائلتنا عائلتك',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF914BB9),
                    ),
                  ),
                ),
              ),

            //sign in button
            if (showInfoHome)
              Positioned(
                top: 600,
                left: 65,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      child: Text(
                        'ابـــــدأ الآن',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.vazirmatn(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(160, 145, 75, 185))),
                      onPressed: () {
                        _showModalBottomSheetEnterPhone(context);
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
