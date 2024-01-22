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
import 'package:uuid/uuid.dart';
import 'homePage.dart';

class RegisterSP extends StatefulWidget {
  const RegisterSP({super.key});

  @override
  State<RegisterSP> createState() => _RegisterSPState();
}

class _RegisterSPState extends State<RegisterSP> {
  PageController dotController = PageController();
  final TextEditingController FnameController = TextEditingController();
  final TextEditingController LnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showLoading = false;
  late String id;
  List<String> majors = ['نطق و تخاطب', 'سلوكي', 'تربوي'];
  String? selectedItem = 'نطق و تخاطب';

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
    });
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()));
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
                children: [
                  //first page
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0, left: 20.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
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
                            "أنـضــم إلـى عــائـلـتنا",
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
                          child: TextFormField(
                            cursorColor: Colors.purple,
                            controller: FnameController,
                            textAlign: TextAlign.right,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: "أدخل اسمك الأول هنا",
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
                          child: TextFormField(
                            cursorColor: Colors.purple,
                            controller: LnameController,
                            textAlign: TextAlign.right,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: "أدخل اسمك الأخير هنا",
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
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

                        Container(
                          width: 340,
                          child: TextFormField(
                            cursorColor: Colors.purple,
                            controller: phoneController,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 9,
                            decoration: InputDecoration(
                              hintText: "أدخل رقم الجوال هنا",
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    showCountryPicker(
                                        context: context,
                                        countryListTheme: CountryListThemeData(
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
                        SizedBox(
                          height: 30,
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
                          child: TextFormField(
                            cursorColor: Colors.purple,
                            controller: emailController,
                            textAlign: TextAlign.left,
                            maxLength: 20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("^[\u0000-\u007F]+\$"))
                            ],
                            decoration: InputDecoration(
                              hintText: "أدخل بريدك الالكتروني هنا",
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60.0, left: 20.0),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                      ),
                                      iconSize: 30,
                                      color: Colors.purple,
                                      splashColor: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    WelcomePage()));
                                      },
                                    ),
                                  ),
                                ),

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

                                Container(
                                  alignment: Alignment(0.85, 0),
                                  child: DropdownButton<String>(
                                    // Step 3.
                                    value: selectedItem,
                                    // Step 4.
                                    items: majors.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 18,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    // Step 5.
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedItem = newValue!;
                                      });
                                    },
                                  ),
                                ),

                                SizedBox(
                                  height: 30,
                                ),

                                // text field of email
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
                                Container(
                                  alignment: Alignment(0.7, 0),
                                  child: ElevatedButton.icon(
                                    // <-- ElevatedButton
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Color.fromARGB(130, 151, 106, 178),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.post_add,
                                      size: 24.0,
                                    ),

                                    label: Text(
                                      'أرفق السيرة الذاتية هنا',
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
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
                                          'إرســال الـطــلـب',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(Color.fromARGB(
                                                        160, 145, 75, 185))),
                                        onPressed: () async {}),
                                  ),
                                ),
                              ],
                            ))
                ],
              ),

              //dot indicator
              Container(
                  alignment: Alignment(0, 0.9),
                  child: SmoothPageIndicator(
                    controller: dotController,
                    count: 2,
                    effect: ScrollingDotsEffect(
                        fixedCenter: true,
                        dotColor: Colors.grey,
                        activeDotColor: Color.fromARGB(255, 108, 33, 174)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
