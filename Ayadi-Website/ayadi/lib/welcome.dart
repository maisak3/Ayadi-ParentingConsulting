import 'package:ayadi/adminHP.dart';
import 'package:ayadi/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:collection';
import 'package:ayadi/CV.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';




class welcome extends StatefulWidget {

   const welcome ({super.key});
    @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {

     TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isObscure3 = true;
  String errorMessage = '';
  bool validuser = false;
  int count = 0;
  bool errorMessage2 = false;

    double welcomeHeight = 900;
  double welcomeWidth = 900;
  double welcomeX = 0;
  double welcomeY = 0;
  bool showSignIn = false;

  
  void isAccepted() async {
    final QuerySnapshot<Map<String, dynamic>> readRequest =
        await FirebaseFirestore.instance.collection("admin").get();
    count = readRequest.size;
    for (var i = 0; i < count; i++) {
      if (_emailController.text.trim() ==
          readRequest.docs[i]['email'].toString()) {
        validuser = true;
        //print(validDriver);
        break;
      }
    }
  }

    void sizeWelcome() {
    setState(() {
      welcomeHeight= MediaQuery.of(context).size.height* 0.8;
     welcomeWidth = MediaQuery.of(context).size.width* 0.55;

    });
  }

     void sizeWelcome1() {
    setState(() {
      welcomeHeight= 900;
     welcomeWidth = 900;

    });
  }

  void moveWelcome() {
    setState(() {
      welcomeX = -2;
      welcomeY = -2;
      showSignIn = true;
    });
  }


  Future signIn() async {
    if (validuser == true) {
      validuser = false;
    }
    if (errorMessage2 == true) {
      errorMessage2 = false;
    }

    setState(() {
      isAccepted();
    });

    try {
      //loading circle
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      setState(() {});
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => adminList()));

      //pop loading circle
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        //errorMessage = error.message!;
        errorMessage = "بريدك الالكتروني أو كلمة المرور غير صحيحة! حاول مرة أخرى";
        errorMessage2 = true;
        print("لا يوجد مستخدم بهذا البريد الإلكتروني");
      } else if (error.code == 'wrong-password') {
        errorMessage = "بريدك الالكتروني أو كلمة المرور غير صحيحة! حاول مرة أخرى";
        errorMessage2 = true;
        print("كلمة مرور خاطئة");
      }
      setState(() {});
    }

    print(validuser);
    print(errorMessage2);
    print(count);

    if (validuser == false && errorMessage2 == false) {
      errorMessage = "هذا البريد الالكتروني لا يعود لحساب مشرف";
    } else if (validuser == true && errorMessage2 == false) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => AdminHP()));
    } else
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

                                                     Align(
                                                      alignment: Alignment.topRight,
                                                       child: Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 10.w , vertical: 10.h),
                                                                                    child: Container(
                                                                                     // alignment: Alignment.topRight,
                                                                                    width: 150.w,
                                                                                    height: 119.h,
                                                                                    child: Image(
                                                                                        image: AssetImage('assets/images/AyadiLogo.png')),
                                                                                ),
                                                                                  ),
                                                     ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 120.w,),

                  (!showSignIn)?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        child: Text(
                              'أيـــــادي',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.vazirmatn(
                                fontSize: 80.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF914BB9),
                              ),
                            ),
                      ),

                                  AnimatedContainer(
                          duration: Duration(seconds: 1),
                          child: Text(
                            'لتخدم عائلتنا عائلتك',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.vazirmatn(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF914BB9),
                            ),
                          ),
                        ),
                        
                        SizedBox(
                          height: 50.h,
                        ),

                        TextButton(
                          onPressed: (){
                            sizeWelcome();
                            moveWelcome();
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                          }
                        ,
                         child: Text(
                                              "تسجيل الدخول",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23.sp,
                                              ),
                                          ),
                                           style:  ButtonStyle(
                                                padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 40, vertical: 22)),
                                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff9366ad)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      )
                                    )
                                  ),
                         
                         ),

                        //   SizedBox(
                        //   height: 100.h,
                        // ),
                    ],
                  ):
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                    ":"+'البريد الإلكتروني',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 25.sp,
                                      color: Color.fromARGB(255, 83, 40, 108)
                                    ),
                                  ),
                    
                                
                                SizedBox(
                                  height: 10.h,
                                ),
                    
                                 Container(
                                  width: 350,
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                cursorColor: Color.fromARGB(255, 83, 40, 108),
                    
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'ادخل بريدك الإلكتروني',
                                  hintTextDirection: TextDirection.rtl,
                                  contentPadding: EdgeInsets.only(right: 20.0 , left: 20.0),
                                ),
                                //////////////validation////////////
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "*هذا الحقل مطلوب";
                                  } else if (!RegExp(
                                          r"^(?!.* )[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return "ادخل بريد الكتروني صحيح";
                                  } else
                                    return null;
                                },
                    
                                //////////////////////////////////
                                ///
                              ),
                        ),
                  
                        SizedBox(
                          height: 20,
                        ),
                    
                         Text(
                                    ":"+"كلمة المرور",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 25.sp,
                                      color: Color.fromARGB(255, 83, 40, 108)
                                    ),
                                  ),
                    
                                  Container(
                                    width: 350,
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                cursorColor: Color.fromARGB(255, 83, 40, 108),
                    
                                obscureText: _isObscure3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'ادخل كلمة المرور',
                                  hintTextDirection: TextDirection.rtl,
                                  contentPadding:
                                      EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
                                  prefixIcon: IconButton(
                                      icon: Icon(_isObscure3
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                          color: _isObscure3? Colors.grey: Color.fromARGB(255, 83, 40, 108),),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure3 = !_isObscure3;
                                          //isAccepted();
                                        });
                                      }),
                                ),
                    
                                //////////////validation////////////
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "*هذا الحقل مطلوب";
                                  } else if (!RegExp(r"^(?!.* ).{8,15}")
                                      .hasMatch(value)) {
                                    return "ادخل كلمة مرور صحيحة";
                                  } /*else if(validDriver == false){
                                          return "your account is not accepted yet";
                                        }*/
                                  else
                                    return null;
                                },
                    
                                //////////////////////////////////
                              ),
                        ),
                    
                                              Center(
                        child: Text(
                              errorMessage,
                              style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 215, 1, 1),
                              ),
                        ),
                      ),
                            ],
                          ),
                  
                          // SizedBox(
                          //   height: 20,
                          // ),
                    
                            Row(
                              children: [
                                TextButton( 
                          onPressed: (){
                                sizeWelcome1();
                                showSignIn = false;
                                _emailController = TextEditingController();
                                _passwordController = TextEditingController();
                          },
                          child: Text(
                            'عـودة',
                            style: TextStyle(
                                  color: Color.fromARGB(255, 83, 40, 108),
                                  fontSize: 20,
                            ),
                          ),
                          style:  ButtonStyle(
                                                padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 40, vertical: 22)),
                                                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(226, 223, 248, 1)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      )
                                    )
                                  ),
                                      ),
                  
                                      SizedBox(
                                        width: 20,
                                      ),
                                TextButton(
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 20,
                                  ),
                                ),
                                style:  ButtonStyle(
                                                padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 35, vertical: 22)),
                                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff9366ad)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      )
                                    )
                                  ),
                                      
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    signIn();
                                  } //if
                                },
                          ),
                    
                        
                              ],
                            ),
                    
                            //   SizedBox(
                            //   height: 100.h,
                            // ),
                        ],
                      ),
                    ),
                  ),



                  Align(
                   alignment: Alignment.bottomRight,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                  // height: MediaQuery.of(context).size.height* 0.85,
                  // width: MediaQuery.of(context).size.width* 0.6,
                  height: welcomeHeight,
                width: welcomeWidth,
                   alignment: Alignment.bottomRight,
                    child: Lottie.network(
                        'https://lottie.host/01f578b2-5f74-4c5c-91c5-1c9bdf30cd3b/4xsTKMHdyZ.json'),
                  ),
            ),


                ],
              ),

            //line of footer
              Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 37.h,
                        color: Color.fromARGB(159, 105, 51, 136),
                      ),
                    ),
                    //copy right
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 37.h,
                        child: Text(
                          "©2023 أيادي. جميع الحقوق محفوظة.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


          ]),

      )
    );
   }

}