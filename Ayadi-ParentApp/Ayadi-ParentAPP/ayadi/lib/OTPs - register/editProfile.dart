import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/whiteGlassContainer.dart';
import '../NavigationPages/account_and_Children.dart';
import '../WelcomePage.dart';
import 'editOTP.dart';

class editProfile extends StatefulWidget {
  const editProfile(
      {super.key,
      required this.Fname,
      required this.Lname,
      required this.phone});
  final Fname;
  final Lname;
  final phone;
  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  @override
  bool showLoading = false;
  final TextEditingController FnameController = TextEditingController();
  final TextEditingController LnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FnameformKey = GlobalKey<FormState>();
  final LnameformKey = GlobalKey<FormState>();
  final phoneformKey = GlobalKey<FormState>();
  bool FnameActiveButton = false;
  bool LnameActiveButton = false;
  bool phoneActiveButton = false;
  bool isFnameNew = false;
  bool isLnameNew = false;
  bool isPhoneNew = false;
  late String PN;

  // Get the current user
  final user = FirebaseAuth.instance.currentUser;
  Country selectedCountry = Country(
      phoneCode: "966",
      countryCode: "SA",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Saudi Arabia",
      example: "Saudi Arabia",
      displayName: "Saudi Arabia",
      displayNameNoCountryCode: "SA",
      e164Key: "");

  void profileEdited() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: false,
      title: 'تـم تعديل الملف الشخصي بـنـجـاح',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {},
      btnOkText: "الـرجـوع",

      btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  bool isActivated() {
    // Check if at least one of the text fields is new (changed)
    bool isAnyFieldChanged = false;

    if (FnameController.text != widget.Fname ||
        LnameController.text != widget.Lname ||
        phoneController.text != TrimWidgetPhone()) {
      isAnyFieldChanged = true;
    }

    // Check if all the text fields are not empty
    bool areAllFieldsNotEmpty = FnameController.text.isNotEmpty &&
        LnameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;

    // Check if the phone number length is 9
    bool isPhoneLengthValid = phoneController.text.length == 9;

    return isAnyFieldChanged && areAllFieldsNotEmpty && isPhoneLengthValid;
  }

// from textfield add the +966
  String getPhoneNumber() {
    String phoneNumberWO = phoneController.text.trim();
    PN = "+${selectedCountry.phoneCode}$phoneNumberWO";

    return PN;
  }

  //trim the +966

  String TrimPhoneController() {
    String phoneControllerTrimmed =
        phoneController.text.toString().substring(4);
    print(phoneControllerTrimmed);
    return phoneControllerTrimmed;
  }

  String TrimWidgetPhone() {
    String WphoneTrim = widget.phone.toString().substring(4);
    print(WphoneTrim);
    return WphoneTrim;
  }

  String PNErrorMsg = "";
  String verificationID = "";

  Future<void> sendOTP() async {
    setState(() {
      showLoading = true;
    });
////// send phone number /////
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 10),
      phoneNumber: getPhoneNumber(),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          showLoading = false;
          PNErrorMsg = e.message ?? "error";
          print(PNErrorMsg);
        });
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          verificationID = verificationId;
          showLoading = false;
        });

        // Navigator.of(context).pop();
        _showModalBottomSheeteditOTP(context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("time out");
      },
    );
///////////////////

    print(phoneController.text);
    print(getPhoneNumber());
    print(PNErrorMsg);
  }

  void _showModalBottomSheeteditOTP(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return editOTP(
          verificationId: verificationID, // that is sent to phone
          phoneEntered: getPhoneNumber(), // new phone with code +966
          phoneWithoutCode: phoneController.text.trim(),

          Fname: FnameController.text,
          Lname: LnameController.text,
          oldPhone: widget.phone, //new phone without code +966
        );
      },
    );
  }

  Future signUp() async {
    print("inside sign up");
    print(widget.phone);

    setState(() {
      showLoading = true;
    });

    // QuerySnapshot querySnap = await FirebaseFirestore.instance
    //     .collection('parent')
    //     .where('phone', isEqualTo: widget.phone)
    //     .get();

    // QueryDocumentSnapshot doc = querySnap.docs[0];
    // DocumentReference docRef = doc.reference;

    // await docRef.update({
    //   'Fname': FnameController.text.toString(),
    //   'Lname': LnameController.text.toString(),
    //   'phone': getPhoneNumber(),
    // });
    final QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('parent')
        .where('phone', isEqualTo: widget.phone)
        .limit(1)
        .get();

    if (querySnap.docs.isNotEmpty) {
      final DocumentSnapshot doc = querySnap.docs.first;
      final DocumentReference docRef = doc.reference;

      await docRef.update({
        'Fname': FnameController.text,
        'Lname': LnameController.text,
        'phone': getPhoneNumber(),
      });
    }

    setState(() {
      showLoading = false;
    });
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => accountChildren()));
    profileEdited();
    //Navigator.of(context).pop();
  }

  void deleteConfirmed() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      title: 'تـم حـذف الحساب بـنـجـاح',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {},
      btnOkText: "الـرجـوع",

      btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  void deleteAccount() async {
    final collectionRef = FirebaseFirestore.instance.collection('parent');
    final querySnapshot = await collectionRef
        .where('phone', isEqualTo: widget.phone)
        .limit(1) // Retrieve only one document
        .get();

    final batch = FirebaseFirestore.instance.batch();

    querySnapshot.docs.forEach((document) {
      batch.delete(document.reference);
    });

    await batch.commit();
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => WelcomePage()));

    deleteConfirmed();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    FnameController.text = widget.Fname;
    LnameController.text = widget.Lname;
    phoneController.text = TrimWidgetPhone();

    //user = FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        whiteGlassContainer(),
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
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "تعديل الـملـف الـشـخـصـي",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        // text field of Fname

                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              "الأســم الأول",
                              style: GoogleFonts.vazirmatn(
                                fontSize: 18,
                                color: Color.fromARGB(255, 83, 40, 108),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          width: 340,
                          child: Form(
                            key: FnameformKey,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.purple,
                              controller: FnameController,

                              ///
                              textAlign: TextAlign.right,
                              //keyboardType: TextInputType.name,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z\u0621-\u064A]+")),
                              ],

                              ///
                              maxLength: 20,
                              validator: (value) {
                                ///
                                if (value!.isEmpty || value == null) {
                                  FnameActiveButton = false;
                                  print("Fname Empty");
                                  return "الـرجـاء إدخـال الاسم الأول";
                                } else {
                                  FnameActiveButton = true;
                                  print("Fname not Empty");
                                  print("Fname new");
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  FnameActiveButton =
                                      FnameformKey.currentState!.validate();

                                  ///
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "أدخل اسمك الأول هنا",

                                ///
                                counterText: '',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black38),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // text field of Lname
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              "الأســم الأخـير",
                              style: GoogleFonts.vazirmatn(
                                fontSize: 18,
                                color: Color.fromARGB(255, 83, 40, 108),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          width: 340,
                          child: Form(
                            key: LnameformKey,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.purple,
                              controller: LnameController,

                              ///
                              textAlign: TextAlign.right,
                              //keyboardType: TextInputType.name,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z\u0621-\u064A]+")),
                              ],

                              ///
                              maxLength: 20,
                              validator: (value) {
                                ///
                                if (value!.isEmpty || value == null) {
                                  LnameActiveButton = false;
                                  print("Lname Empty");
                                  return "الـرجـاء إدخـال الاسم الأخير";

                                  ///
                                } else {
                                  LnameActiveButton = true;
                                  print("Lname not Empty");

                                  print("Lname new");
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  LnameActiveButton =
                                      LnameformKey.currentState!.validate();

                                  ///
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "أدخل اسمك الأخير هنا",

                                ///

                                ///
                                counterText: '',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black38),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // text field of phone number
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              "رقــم الــجــوال",
                              style: GoogleFonts.vazirmatn(
                                fontSize: 18,
                                color: Color.fromARGB(255, 83, 40, 108),
                              ),
                            ),
                          ),
                        ),
                        // text field of phone number
                        Center(
                          child: Container(
                            width: 340,
                            child: Form(
                              key: phoneformKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.purple,
                                controller: phoneController,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 9,
                                validator: (value) {
                                  if (value!.isEmpty || value == null) {
                                    bool validated = false;
                                    print(validated);
                                    print("phone Empty");
                                    phoneActiveButton = false;

                                    return "الـرجـاء إدخـال رقـم الجوال";
                                  } else if (value.length < 9) {
                                    bool validated = false;
                                    //print(validated);
                                    print("phone wrong");
                                    phoneActiveButton = false;

                                    print(phoneActiveButton);

                                    return "الـرجـاء إدخـال رقـم جوال صـحـيـح";
                                  } else {
                                    bool validated = true;
                                    print("phone not Empty");
                                    //print(validated);

                                    phoneActiveButton = true;
                                    print("phone new");

                                    print(phoneActiveButton);
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    phoneActiveButton =
                                        phoneformKey.currentState!.validate();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "أدخل رقم الجوال هنا",
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.black12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.black38),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                  ),
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                CountryListThemeData(
                                                    bottomSheetHeight: 550),
                                            onSelect: (value) {
                                              setState(() {
                                                selectedCountry = value;
                                              });
                                            });
                                      },
                                      child: Text(
                                        "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              child: Text(
                                'تـعـديـل',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5);
                                    } else if (states
                                        .contains(MaterialState.disabled))
                                      return Colors.grey;
                                    return const Color.fromARGB(160, 145, 75,
                                        185); // Use the component's default.
                                  },
                                ),
                              ),
                              /*ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(160, 145, 75, 185),
                            ),
                            
                            
                          ),*/

                              onPressed: isActivated()
                                  ? () {
                                      if (phoneController.text.isNotEmpty &&
                                          phoneController.text !=
                                              TrimWidgetPhone()) {
                                        sendOTP();
                                      } else
                                        signUp();

                                      // Perform action when button is pressed
                                    }
                                  : null,
                            ),
                          ),
                        ),

                        SizedBox(
                      height: 20,
                    ),

                    TextButton(
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          headerAnimationLoop: false,
                          animType: AnimType.rightSlide,
                          title: 'هـل انـت مـتأكد مـن حـذف حسابك؟',
                          desc:
                              'سيتم حذف جميع المعلومات الخاصة بك، هذه عملية لا يمكن التراجع عنها بعد تنفيذها',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            deleteAccount();
                          },
                          btnOkText: "نـعـم",
                          btnCancelText: "الـرجـوع",
                          btnOkColor: Color.fromARGB(193, 246, 7, 7),
                          btnCancelColor: Colors.black26,
                        )..show();
                      },
                      child: Text(
                        'حذف الحساب',
                        style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                      ],
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
