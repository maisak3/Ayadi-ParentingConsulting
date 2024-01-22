import 'dart:ui';
import 'registerPageSP.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ayadi/Components/glassContainer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../NavigationPages/SpecialistHomePage.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

class OTPpage extends StatefulWidget {
  OTPpage(
      {required this.verificationId,
      required this.phoneEntered,
      required this.phoneWithoutCode});
  final String verificationId;
  final String phoneEntered;
  final String phoneWithoutCode;

  @override
  State<OTPpage> createState() => _OTPpageState();
}

class _OTPpageState extends State<OTPpage> {
  String otpCode = "";
  String verifyErrorMsg = "";
  String errorMsg = "";
  Color ColorOfBorderOTP = Color.fromARGB(149, 71, 69, 72);
  bool showLoading = false;
  bool newUser = false;
  bool acceptedUser = true;
  bool validOTP = true;
  final TextEditingController OTPController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void isnewUser() async {
    final QuerySnapshot<Map<String, dynamic>> readparents =
        await FirebaseFirestore.instance.collection("specialist").get();
    int count = readparents.size;
    for (var i = 0; i < count; i++) {
      if (widget.phoneEntered ==
          readparents.docs[i]['phoneNumber'].toString()) {
        setState(() {
          newUser = false;
        });

        break;
      } else {
        setState(() {
          newUser = true;
        });
      }
    }
  }

  void isAccepted() async {
    final QuerySnapshot<Map<String, dynamic>> readRequest =
        await FirebaseFirestore.instance
            .collection("specialist")
            .where('status', isEqualTo: false)
            .get();
    int count = readRequest.size;
    for (var i = 0; i < count; i++) {
      if (widget.phoneEntered ==
          readRequest.docs[i]['phoneNumber'].toString()) {
        acceptedUser = false;
        //print(validDriver);
        break;
      }
    }
  }

  Future signIn() async {
    setState(() {
      showLoading = true;
      validOTP = true;
      newUser = false;
      isnewUser();
      acceptedUser = true;
      isAccepted();
    });
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId /* the sent one*/,
          smsCode: OTPController.text /*the entered one*/);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setState(() {
        verifyErrorMsg = e.toString();
        print(verifyErrorMsg);
      });
      if (e.code == "invalid-verification-code") {
        setState(() {
          showLoading = false;
          validOTP = false;
          errorMsg = "رمز تحقق خاطئ";
          ColorOfBorderOTP = Color.fromARGB(223, 215, 23, 23);
        });
      }
    } //catch

    if (auth.currentUser != null && newUser && validOTP) {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              RegisterSP(phoneWithoutCode: widget.phoneWithoutCode)));
      showLoading = false;
    }

    if (auth.currentUser != null && !newUser && validOTP && acceptedUser) {
      Navigator.of(context).push(
          PageRouteBuilder(pageBuilder: (_, __, ___) => SpecialistHomePage()));
      showLoading = false;
    }

    if (!acceptedUser) {
      AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.warning,
              //showCloseIcon: true,
              body: Column(
                children: [
                  Text(
                    'طلبك مازال قيد المراجعة',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 83, 40, 108),
                    ),
                  ),
                  Text(
                    'تستطيع البدء في العمل كمختص في ايادي حين يتم قبول طلبك',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      //fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 83, 40, 108),
                    ),
                  ),
                ],
              ),
              btnOkOnPress: () {},
              btnOkText: "الـرجـوع")
          .show();
      setState(() {
        showLoading = false;
      });
      print("in not accepted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        glasscontainer(),
        showLoading
            ? const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(160, 145, 75, 185))),
              )
            : Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),

                    Text(
                      ' التحقق من رقم الجوال',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 83, 40, 108),
                      ),
                    ),
                    // photo
                    Image.asset(
                      "assets/image3OTP.png",
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      ' أدخل رمز التحقق المرسل اليك   ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(224, 100, 90, 106),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Pinput(
                      length: 6,
                      showCursor: true,
                      controller: OTPController,
                      defaultPinTheme: PinTheme(
                        width: 50,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: ColorOfBorderOTP,
                          ),
                        ),
                        textStyle: GoogleFonts.vazirmatn(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 137, 70, 160),
                        ),
                      ),
                      onCompleted: (value) {
                        setState(() {
                          otpCode = value;
                        });
                        print(otpCode);
                        print(OTPController.text);
                        signIn();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      errorMsg,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 15,
                        //fontWeight: FontWeight.bold,
                        color: Color.fromARGB(223, 215, 23, 23),
                      ),
                    ),

                    /*Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            child: Text(
                              'الـتـحــقـق',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.vazirmatn(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(160, 145, 75, 185))),
                            onPressed: () async {
                              signIn();
                            }),
                      ),
                    ),*/
                    SizedBox(
                      height: 20,
                    ),

                    // Text(
                    //   'لم تستلم رمز التحقق؟',
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.vazirmatn(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color.fromARGB(224, 100, 90, 106),
                    //   ),
                    // ),

                    // Text(
                    //   'إعادة إرسال رمز جديد',
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.vazirmatn(
                    //     fontSize: 17,
                    //     fontWeight: FontWeight.w900,
                    //     color: Color.fromARGB(208, 116, 55, 151),
                    //   ),
                    // ),
                  ],
                ),
              ),
      ],
    );
  }
}
