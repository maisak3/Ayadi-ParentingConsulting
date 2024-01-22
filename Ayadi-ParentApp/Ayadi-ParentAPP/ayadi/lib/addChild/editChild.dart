import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ayadi/Components/whiteGlassContainer.dart';
import 'package:ayadi/NavigationPages/account_and_Children.dart';
import 'package:ayadi/NavigationPages/parentHomePage.dart';
import 'package:ayadi/addChild/viewChildProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../Components/navigationBar.dart';

class editChild extends StatefulWidget {
  const editChild(
      {super.key,
      required this.Fname,
      required this.Lname,
      required this.gender,
      required this.DOB,
      required this.id});

  final String Fname;
  final String Lname;
  final String gender;
  final String DOB;
  final String id;

  @override
  State<editChild> createState() => _editChildState();
}

class _editChildState extends State<editChild> {
  bool showLoading = false;
  // Get the current user
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  late String gender;
  late String DOB;
  final FnameformKey = GlobalKey<FormState>();
  final LnameformKey = GlobalKey<FormState>();
  final DOBformKey = GlobalKey<FormState>();
  final genderformKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool FnameActiveButton = false;
  bool LnameActiveButton = false;
  bool DOBActiveButton = false;
  bool genderActiveButton = false;
  bool isFirstButtonPressed = false;
  bool isSecondButtonPressed = false;

  late String id;

  late DateTime selectedDate;
  bool isActivated() {
    // Check if at least one of the text fields is new (changed)
    bool isAnyFieldChanged = false;

    if (fnameController.text != widget.Fname ||
        lnameController.text != widget.Lname ||
        gender != widget.gender ||
        DOB != widget.DOB) {
      isAnyFieldChanged = true;
    }

    // Check if all the text fields are not empty
    bool areAllFieldsNotEmpty =
        fnameController.text.isNotEmpty && lnameController.text.isNotEmpty;

    return isAnyFieldChanged && areAllFieldsNotEmpty;
  }

  // int calculateAge(String dateOfBirth) {
  //   DateTime now = DateTime.now();
  //   List<String> parts = dateOfBirth.split('-');
  //   int year = int.parse(parts[0]);
  //   int month = int.parse(parts[1]);
  //   int day = int.parse(parts[2]);
  //   DateTime dob = DateTime(year, month, day);
  //   int age = now.year - dob.year;

  //   if (now.month < dob.month ||
  //       (now.month == dob.month && now.day < dob.day)) {
  //     age--;
  //   }

  //   return age;
  // }

  void deleteConfirmed() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      title: 'تـم حـذف الـطـفـل بـنـجـاح',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {},
      btnOkText: "الـرجـوع",

      btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  void deleteChild() async {
    await FirebaseFirestore.instance
        .collection('children')
        .doc(widget.id)
        .delete();

    final collectionRef = FirebaseFirestore.instance.collection('sessions');
    final querySnapshot =
        await collectionRef.where('childID', isEqualTo: widget.id).get();

    final batch = FirebaseFirestore.instance.batch();

    querySnapshot.docs.forEach((document) {
      batch.delete(document.reference);
    });

    await batch.commit();

    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => accountChildren()));

    deleteConfirmed();
  }

  void childedited() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      //dismissOnTouchOutside: false,
      title: 'تـم تعديل ملف الـطـفـل بـنـجـاح',
      //desc: 'Dialog description here.............',

      btnOkOnPress: () {},
      btnOkText: "الـرجـوع",

      btnOkColor: Color.fromARGB(147, 124, 71, 203),
    )..show();
  }

  Future signUp() async {
    print("inside sign up");
    print(widget.id);

    setState(() {
      showLoading = true;
    });

    final QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('children')
        .where('id', isEqualTo: widget.id)
        .limit(1)
        .get();

    if (querySnap.docs.isNotEmpty) {
      final DocumentSnapshot doc = querySnap.docs.first;
      final DocumentReference docRef = doc.reference;

      await docRef.update({
        'Fname': fnameController.text,
        'Lname': lnameController.text,
        'gender': gender,
        'DOB': DOB,
        //'age': calculateAge(DOB),
      });
    }

    setState(() {
      showLoading = false;
    });
    //Navigator.of(context).pop();
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => viewChildProfile(
              id: widget.id,
            )));
    childedited();
    //Navigator.of(context).pop();
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

  void initState() {
    // TODO: implement initState
    super.initState();
    fnameController.text = widget.Fname;
    lnameController.text = widget.Lname;
    DOB = widget.DOB;
    gender = widget.gender;
    isFirstButtonPressed = widget.gender == "أنثى" ? true : false;
    isSecondButtonPressed = widget.gender == "ذكر" ? true : false;

    //user = FirebaseAuth.instance.currentUser!.phoneNumber;
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
                      'تعديل ملف الطفل',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 83, 40, 108),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    //Text(PNErrorMsg),

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

                        // text field of gender
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
                                  color: Color.fromARGB(226, 177, 43, 255),
                                  fontSize: 17),
                            ),
                            onPressed: _showDatePicker,
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
                                      signUp();

                                      // Perform action when button is pressed
                                    }
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        TextButton(
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              headerAnimationLoop: false,

                              animType: AnimType.rightSlide,
                              title: 'هـل انـت مـتأكد مـن حـذف هـذا الـطـفل؟',
                              //desc: 'Dialog description here.............',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                deleteChild();
                              },
                              btnOkText: "نـعـم",
                              btnCancelText: "الـرجـوع",
                              btnOkColor: Color.fromARGB(193, 246, 7, 7),
                              btnCancelColor: Colors.black26,
                            )..show();
                          },
                          child: Text(
                            'حذف الطفل',
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
