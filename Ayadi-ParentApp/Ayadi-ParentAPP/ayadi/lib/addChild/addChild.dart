import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ayadi/Components/whiteGlassContainer.dart';
import 'package:ayadi/Components/glassContainer.dart';
import 'package:ayadi/NavigationPages/account_and_Children.dart';
import 'package:ayadi/NavigationPages/parentHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/state_manager.dart';
import '../Components/navigationBar.dart';

class addChild extends StatefulWidget {
  const addChild({super.key});

  @override
  State<addChild> createState() => _addChildState();
}

class _addChildState extends State<addChild> {
  // Get the current user
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  String gender = "";
  String DOB = "أدخل تاريخ الميلاد";
  final FnameformKey = GlobalKey<FormState>();
  final LnameformKey = GlobalKey<FormState>();
  final DOBformKey = GlobalKey<FormState>();
  final genderformKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showLoading = false;
  bool FnameActiveButton = false;
  bool LnameActiveButton = false;
  bool DOBActiveButton = false;
  bool genderActiveButton = false;
  bool isFirstButtonPressed = false;
  bool isSecondButtonPressed = false;

  late String id;

  late DateTime selectedDate;
  bool isActivated() {
    if (FnameActiveButton &&
        LnameActiveButton &&
        DOBActiveButton &&
        genderActiveButton)
      return true;
    else
      return false;
  }

  void childAdded() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      //dismissOnTouchOutside: false,
      title: 'تـمت إضافة الـطـفـل بـنـجـاح',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {},
      btnOkText: "الـرجـوع",

      btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  Future signUp() async {
    setState(() {
      showLoading = true;
    });
    final CollectionReference children =
        FirebaseFirestore.instance.collection('children');

    final DocumentReference newDocRef = children
        .doc(); // Create a new document reference without specifying the ID

    final String newDocId =
        newDocRef.id; // Retrieve the automatically generated document ID

    await newDocRef.set({
      'id': newDocId, // Include the ID in the document
      'Fname': fnameController.text.trim(),
      'Lname': lnameController.text.trim(),
      'parentPhone': user!.phoneNumber.toString(),
      'gender': gender,
      'DOB': DOB,
    });

    print('Generated Document ID: $newDocId');

    // final DocumentReference newDocRef = await children.add({
    //   'Fname': fnameController.text.trim(),
    //   'Lname': lnameController.text.trim(),
    //   'parentPhone': user!.phoneNumber.toString(),
    //   'gender': gender,
    //   'DOB': DOB,
    //   //'age': "",

    // });

    // final String newDocId = newDocRef.id;
    // // Update the document with the generated document ID
    // await newDocRef.update({'id': newDocId});

    // print('Generated Document ID: $newDocId');

    setState(() {
      showLoading = false;
    });

    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => accountChildren()));
    childAdded();
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().subtract(Duration(days: 365 * 18)),
      maxTime: DateTime.now().subtract(Duration(days: 365 * 1)),
      onConfirm: (date) {
        setState(() {
          DOB = DateFormat('yyyy-MM-dd').format(date);
          DOBActiveButton = true;
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.ar,
      theme: DatePickerTheme(
        doneStyle:
            TextStyle(color: Colors.purple), // Change to your desired color
      ),
    );
  }

  @override
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

                    //text
                    Text(
                      'أخـبـرنـا عـن طـفـلـك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 83, 40, 108),
                      ),
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    Column(
                      children: [
// text field of Fname

                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              "الأســم الأول",
                              style: TextStyle(
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
                              controller: fnameController,

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

                                  return "الـرجـاء إدخـال الاسم الأول";
                                } else {
                                  FnameActiveButton = true;
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
                                hintText: "أدخل اسم طفلك الأول هنا",

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
                              style: TextStyle(
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
                              controller: lnameController,

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

                                  return "الـرجـاء إدخـال الاسم الأخير";

                                  ///
                                } else {
                                  LnameActiveButton = true;
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
                                hintText: "أدخل اسم طفلك الأخير هنا",

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

                        // text field of gender
                        SizedBox(
                          height: 20,
                        ),

                        // text field of Lname
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              "الـجـنـس",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 83, 40, 108),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isFirstButtonPressed
                                    ? Color.fromARGB(212, 253, 182, 82)
                                    : Color.fromARGB(155, 183, 181, 181),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isFirstButtonPressed = true;
                                    isSecondButtonPressed = false;
                                    genderActiveButton = true;
                                    gender = "أنثى";
                                    print(gender);
                                  });
                                },
                                child: Text(
                                  "انثى",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 40,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isSecondButtonPressed
                                    ? Color.fromARGB(212, 253, 182, 82)
                                    : Color.fromARGB(155, 183, 181, 181),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isFirstButtonPressed = false;
                                    isSecondButtonPressed = true;
                                    genderActiveButton = true;
                                    gender = "ذكر";
                                    print(gender);
                                  });
                                },
                                child: Text(
                                  "ذكر",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

// text field of DOB

                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              "تـاريـخ المـيـلاد",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 83, 40, 108),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                            child: Text(
                              DOB,
                              style: TextStyle(
                                  color: DOB == "أدخل تاريخ الميلاد"
                                      ? Colors.black45
                                      : Color.fromARGB(226, 177, 43, 255),
                                  fontSize: 17),
                            ),
                            onPressed: _showDatePicker,
                          ),
                        ),
                      ],
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
                            'حـفـظ الـطـفـل',
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
                                if (states.contains(MaterialState.pressed)) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5);
                                } else if (states.contains(
                                    MaterialState.disabled)) return Colors.grey;
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
                                  signUp();

                                  // Perform action when button is pressed
                                }
                              : null,
                        ),
                      ),
                    ),
                    //Text(PNErrorMsg),
                  ],
                ),
              ),
      ],
    );
  }
}
