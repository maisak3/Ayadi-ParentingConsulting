import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'Components/glassContainer.dart';
import 'OTPpage.dart';

class EnterPhone extends StatefulWidget {
  const EnterPhone({super.key});

  @override
  State<EnterPhone> createState() => _EnterPhoneState();
}

class _EnterPhoneState extends State<EnterPhone> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String PN = "";
  String PNErrorMsg = "";
  String verificationID = "";
  bool showLoading = false;
  bool activeButton = false;
  Color buttonColor = Color.fromARGB(160, 145, 75, 185);
  final _formKey = GlobalKey<FormState>();
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

  String getPhoneNumber() {
    String phoneNumberWO = phoneController.text.trim();
    PN = "+${selectedCountry.phoneCode}$phoneNumberWO";

    return PN;
  }

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

        Navigator.of(context).pop();
        _showModalBottomSheetOTPpage(context);
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

  void _showModalBottomSheetOTPpage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return OTPpage(
          verificationId: verificationID,
          phoneEntered: getPhoneNumber(),
          phoneWithoutCode: phoneController.text.trim(),
        );
      },
    );
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

                    //text
                    Text(
                      'أدخل رقم الجوال',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 83, 40, 108),
                      ),
                    ),
                    // photo
                    Image.asset(
                      "assets/image1OTP.png",
                      height: 200,
                      width: 200,
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // text field of phone number
                    Center(
                      child: Container(
                        width: 340,
                        child: Form(
                          key: _formKey,
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

                                activeButton = false;

                                return "الـرجـاء إدخـال رقـم الجوال";
                              } else if (value.length < 9) {
                                bool validated = false;
                                //print(validated);

                                activeButton = false;

                                print(activeButton);
                                buttonColor = Color.fromARGB(39, 65, 64, 65);

                                return "الـرجـاء إدخـال رقـم جوال صـحـيـح";
                              } else {
                                bool validated = true;
                                //print(validated);

                                activeButton = true;

                                print(activeButton);
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                activeButton =
                                    _formKey.currentState!.validate();
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
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
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          child: Text(
                            'اسـتـمرار',
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

                          onPressed: activeButton
                              ? () {
                                  sendOTP();
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
