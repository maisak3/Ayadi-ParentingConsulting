import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ayadi/WelcomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

class RegisterSP extends StatefulWidget {
  const RegisterSP({super.key, required this.phoneWithoutCode});
  final String phoneWithoutCode;

  @override
  State<RegisterSP> createState() => _RegisterSPState();
}

class _RegisterSPState extends State<RegisterSP> {
  PageController dotController = PageController(initialPage: 1);
  final TextEditingController FnameController = TextEditingController();
  final TextEditingController LnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sessionPriceController = TextEditingController();
  final FnameformKey = GlobalKey<FormState>();
  final LnameformKey = GlobalKey<FormState>();
  final phoneformKey = GlobalKey<FormState>();
  final emailformKey = GlobalKey<FormState>();
  final sessionformKey = GlobalKey<FormState>();
  String downloadURL = '';

  bool FnameActiveButton = false;
  bool LnameActiveButton = false;
  bool phoneActiveButton = false;
  bool emailActiveButton = false;
  bool sessionActiveButton = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showLoading = false;
  late String id;
  PlatformFile? pickedFile;

  String? selectedItem = null;

  bool itemSelected() {
    if (selectedItem == "none")
      return false;
    else
      return true;
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
   downloadURL = await ref.getDownloadURL();
   print("the url is $downloadURL");
  }

  void waitToBeAccepted() {
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
  }

  bool isActivated() {
    if (FnameActiveButton &&
        LnameActiveButton &&
        phoneActiveButton &&
        emailActiveButton &&
        itemSelected() &&
        pickedFile != null)
      return true;
    else
      return false;
  }

  Future signUp() async {
    String phoneNumberWO = phoneController.text.trim();
    
    setState(() {
      showLoading = true;
    });
    uploadFile();
    await FirebaseFirestore.instance.collection('specialist').add({
      'Fname': FnameController.text.trim(),
      'Lname': LnameController.text.trim(),
      'avgRate': 0,
      'bio': "إخصائي لدى ايادي",
      'email': emailController.text.trim(),
      'numOfRates': 0,
      'phoneNumber': "+${selectedCountry.phoneCode}$phoneNumberWO",
      'sessionPrice': 0,
      'specialization': selectedItem,
      'status': false,
      'IBAN': "",
      'CV' : downloadURL,
    });

    //uploadFile();

    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => WelcomePage()));
    waitToBeAccepted();

    setState(() {
      showLoading = false;
    });
  }

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
  int currentPageIndex = 1;
  int totalPages = 2;

  void initState() {
    super.initState();
    phoneController.text = widget.phoneWithoutCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              //page view
              PageView(
                controller: dotController,
                onPageChanged: (int pageIndex) {
                  setState(() {
                    currentPageIndex = pageIndex;
                  });
                },
                children: [
                  //second page
                  Container(
                    child: showLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(160, 145, 75, 185))),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       top: 60.0, left: 320.0),
                              //   child: Container(
                              //     alignment: Alignment.topLeft,
                              //     child: IconButton(
                              //       icon: Icon(
                              //         Icons.arrow_forward_ios,
                              //       ),
                              //       iconSize: 30,
                              //       color: Colors.purple,
                              //       splashColor: Colors.white,
                              //       onPressed: () {
                              //         Navigator.of(context).push(
                              //             PageRouteBuilder(
                              //                 pageBuilder: (_, __, ___) =>
                              //                     WelcomePage()));
                              //       },
                              //     ),
                              //   ),
                              // ),

                              SizedBox(
                                height: 50,
                              ),

                              // text field of major
                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "الــتــخــصص",
                                    style: GoogleFonts.vazirmatn(
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
                                children: [
                                  SizedBox(
                                    width: 200,
                                  ),
                                  Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(184, 194, 151, 219),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton(
                                        //menuMaxHeight: 200,
                                        borderRadius: BorderRadius.circular(10),
                                        // Set maximum height of menu
                                        value: selectedItem,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text(
                                              '  إخصائي نطق و تخاطب',
                                              style: GoogleFonts.vazirmatn(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 63, 60, 60),
                                              ),
                                            ),
                                            value: 'إخصائي نطق و تخاطب',
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              'إخصائى سلوكي',
                                              style: GoogleFonts.vazirmatn(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 63, 60, 60),
                                              ),
                                            ),
                                            value: 'إخصائى سلوكي',
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              'إخصائى تربوي',
                                              style: GoogleFonts.vazirmatn(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 63, 60, 60),
                                              ),
                                            ),
                                            value: 'إخصائى تربوي',
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedItem = value;
                                          });
                                        },
                                        hint: selectedItem == null
                                            ? Text(
                                                'حـدد تـخـصـصـك',
                                                style: GoogleFonts.vazirmatn(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 63, 60, 60),
                                                ),
                                              )
                                            : null,
                                        alignment: Alignment.centerRight,
                                      )),
                                ],
                              ),

                              SizedBox(
                                height: 30,
                              ),

                              // text field of Session Price

                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "قـيـمـة الـجلـسـة",
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 83, 40, 108),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 170.0),
                                child: Container(
                                  width: 180,
                                  height: 80,
                                  child: Form(
                                    key: sessionformKey,
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      cursorColor: Colors.purple,
                                      controller: sessionPriceController,
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      maxLength: 3,
                                      validator: (value) {
                                        if (value!.isEmpty || value == null) {
                                          phoneActiveButton = false;

                                          return "الـرجـاء إدخـال قيمة الجلسة";
                                        } else if (value.length < 2) {
                                          phoneActiveButton = false;

                                          return "الـرجـاء إدخـال قيمة صحيحة";
                                        } else {
                                          phoneActiveButton = true;
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          sessionActiveButton = sessionformKey
                                              .currentState!
                                              .validate();

                                          ///
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: "أدخل قيمة الجلسة هنا",

                                        ///
                                        counterText: '',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black12),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.red),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black38),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 30,
                              ),

                              // text field of CV
                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "الــسـيـرة الــذاتـيـة",
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 83, 40, 108),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              pickedFile == null
                                  ? Container(
                                      alignment: Alignment(0.7, 0),
                                      child: ElevatedButton.icon(
                                        // <-- ElevatedButton
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Color.fromARGB(195, 209, 166, 233),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.post_add,
                                          size: 24.0,
                                          color:
                                              Color.fromARGB(255, 63, 60, 60),
                                        ),

                                        label: Text(
                                          'أرفق السيرة الذاتية هنا',
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 63, 60, 60),
                                          ),
                                        ),
                                        onPressed: () {
                                          selectFile();
                                        },
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment(0.7, 0),
                                      child: ElevatedButton.icon(
                                        // <-- ElevatedButton
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Color.fromARGB(195, 209, 166, 233),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.file_download_done,
                                          size: 24.0,
                                          color:
                                              Color.fromARGB(255, 63, 60, 60),
                                        ),

                                        label: Text(
                                          pickedFile!.name,
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 63, 60, 60),
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                              SizedBox(
                                height: 80,
                              ),
                              //button to sign up
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: ElevatedButton(
                                    child: Text(
                                      'إرسـال الطـلـب',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.5);
                                          } else if (states
                                              .contains(MaterialState.disabled))
                                            return Colors.grey;
                                          return const Color.fromARGB(
                                              160,
                                              145,
                                              75,
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
                            ],
                          ),
                  ),
                  //first page
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 60.0, left: 320.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                              ),
                              iconSize: 30,
                              color: Colors.purple,
                              splashColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        WelcomePage()));
                              },
                            ),
                          ),
                        ),

                        Center(
                          child: Text(
                            "إنـضــم إلـى عــائـلـتنا",
                            style: GoogleFonts.vazirmatn(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 83, 40, 108),
                            ),
                          ),
                        ),
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

                        Center(
                          child: Container(
                            width: 340,
                            child: Form(
                              key: phoneformKey,
                              child: TextFormField(
                                enabled: false,
                                cursorColor: Colors.purple,
                                controller: phoneController,
                                textAlign: TextAlign.left,
                                maxLength: 9,
                                decoration: InputDecoration(
                                  hintText: "أدخل رقم الجوال هنا",
                                  counterText: '',
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.black12),
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
                          height: 20,
                        ),

                        // text field of email
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              " البريد الالكتروني",
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
                            key: emailformKey,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.purple,
                              controller: emailController,

                              ///
                              textAlign: TextAlign.left,
                              //keyboardType: TextInputType.name,

                              ///
                              maxLength: 30,
                              validator: (value) {
                                ///
                                if (value!.isEmpty || value == null) {
                                  emailActiveButton = false;

                                  return "الـرجـاء إدخـال البريد الالكتروني";

                                  ///
                                } else if (!RegExp(
                                        r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
                                        caseSensitive: false)
                                    .hasMatch(value)) {
                                  emailActiveButton = false;

                                  return "الـرجـاء إدخـال بريد الكتروني صـحـيـح";

                                  ///
                                } else {
                                  emailActiveButton = true;
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  emailActiveButton =
                                      emailformKey.currentState!.validate();

                                  ///
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "أدخل بريدك الالكتروني هنا",

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
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                alignment: Alignment(0, 0.9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Show/hide the left arrow based on the current page index
                    if (currentPageIndex > 0)
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          dotController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    SmoothPageIndicator(
                      controller: dotController,
                      count: totalPages,
                      effect: ScrollingDotsEffect(
                        fixedCenter: true,
                        dotColor: Colors.grey,
                        activeDotColor: Color.fromARGB(255, 108, 33, 174),
                      ),
                    ),
                    // Show/hide the right arrow based on the current page index
                    if (currentPageIndex < totalPages - 1)
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          dotController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
