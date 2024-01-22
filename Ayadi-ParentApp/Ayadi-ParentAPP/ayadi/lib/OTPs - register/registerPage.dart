import 'package:ayadi/WelcomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:ayadi/NavigationPages/parentHomePage.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.phoneWithoutCode});
  final String phoneWithoutCode;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController FnameController = TextEditingController();
  final TextEditingController LnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FnameformKey = GlobalKey<FormState>();
  final LnameformKey = GlobalKey<FormState>();
  final phoneformKey = GlobalKey<FormState>();
  final emailformKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showLoading = false;
  bool FnameActiveButton = false;
  bool LnameActiveButton = false;
  bool phoneActiveButton = false;
  bool emailActiveButton = false;
  late String id;

  void initState() {
    super.initState();
    phoneController.text = widget.phoneWithoutCode;
  }

  bool isActivated() {
    if (FnameActiveButton && LnameActiveButton && emailActiveButton)
      return true;
    else
      return false;
  }

  Future signUp() async {
    const uuid = Uuid();
    id = uuid.v4();
    print(id); // id of parent account
    String phoneNumberWO = phoneController.text.trim();
    setState(() {
      showLoading = true;
    });
    await FirebaseFirestore.instance.collection('parent').add({
      'Fname': FnameController.text.trim(),
      'Lname': LnameController.text.trim(),
      'phone': "+${selectedCountry.phoneCode}$phoneNumberWO",
      'email': emailController.text.trim(),
      'id': id,
      'wallet': 0.0,
    });
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => parentHomePage()));
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,

      body: showLoading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(160, 145, 75, 185))),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0, right: 20.0),
                    child: Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                        ),
                        iconSize: 30,
                        color: Colors.purple,
                        splashColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => WelcomePage()));
                        },
                      ),
                    ),
                  ),

                  Center(
                    child: Text(
                      "أنــشــئ حســابــك",
                      style: GoogleFonts.vazirmatn(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 83, 40, 108),
                      ),
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
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
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
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
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
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  //button to sign up
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        child: Text(
                          'تـسـجـيـل الـدخـول',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.vazirmatn(
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
                ],
              ),
            ),
    );
  }
}
