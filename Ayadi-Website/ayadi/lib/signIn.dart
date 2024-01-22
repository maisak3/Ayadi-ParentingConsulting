import 'package:ayadi/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'AdminHP.dart';
//import 'forgetPassApp1.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isObscure3 = true;
  String errorMessage = '';
  bool validuser = false;
  int count = 0;
  bool errorMessage2 = false;

    double welcomeHeight = 1000;
  double welcomeWidth = 1000;
  double welcomeX = 0;
  double welcomeY = 0;
  bool showSignIn = false;

  void isAccepted() async {
    final QuerySnapshot<Map<String, dynamic>> readRequest =
        await FirebaseFirestore.instance.collection("Admins").get();
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
      welcomeHeight = 380;
      welcomeWidth = 380;
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

                  Form(
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
                  
                    //                         Center(
                    //   child: Text(
                    //         errorMessage,
                    //         style: TextStyle(
                    //           fontSize: 17,
                    //           color: Color.fromARGB(255, 215, 1, 1),
                    //         ),
                    //   ),
                    // ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                  
                          Row(
                            children: [
                              TextButton( 
                        onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => welcome()));
                        },
                        child: Text(
                          'عودة',
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


                  Align(
                   alignment: Alignment.bottomRight,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
             // width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height* 0.85,
                  width: MediaQuery.of(context).size.width* 0.6,
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
    
//     return Scaffold(

//         /////////
//         body: Form(
//       key: _key,
//       child: Container(
//         height: 1440,
//         child: Stack(
//           children: [
            

//             //Email text
//             Positioned(
//               left: 750,
//               top: 250,
//               child: Text(
//                 "Email",
//                 style: TextStyle(
//                   fontSize: 30,
//                   color: Color(0xff4b6d76),
//                 ),
//               ),
//             ),

//             //password text
//             Positioned(
//               left: 750,
//               top: 360,
//               child: Text(
//                 "Password",
//                 style: TextStyle(
//                   fontSize: 30,
//                   color: Color(0xff4b6d76),
//                 ),
//               ),
//             ),

//             // forgot password?
//             /* Positioned(
//               left: 45,
//               top: 570,
//               child: Text(
//                 "Forgot Password?",
//                 style: GoogleFonts.alice(
//                   fontSize: 12,
//                   color: Color.fromARGB(255, 215, 1, 1),
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),*/

//             ///////////////////////////////////////////////////
//             Positioned.fill(
//               left: 490,
//               child: Column(
//                 children: [

//                   SizedBox(height: 180),

//                   //Welcome Back! text
//                   /*Text(
//                     'Welcome Back!',
//                     style: GoogleFonts.alice(
//                         fontSize: 40, color: Color(0xff204854)),
//                   ),
// ////
//                   SizedBox(height: 140),*/

//                   //Email textfield

//                   SizedBox(height: 115),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 240.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: TextFormField(
//                         controller: _emailController,

//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: ' Enter your Email',
//                           contentPadding: EdgeInsets.only(left: 20.0),
//                         ),
//                         //////////////validation////////////
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "* Required";
//                           } else if (!RegExp(
//                                   r"^(?!.* )[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                               .hasMatch(value!)) {
//                             return "Enter a valid email";
//                           } else
//                             return null;
//                         },

//                         //////////////////////////////////
//                         ///
//                       ),
//                     ),
//                   ),

//                   //Password textfield

//                   SizedBox(height: 60),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 240.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: TextFormField(
//                         controller: _passwordController,

//                         obscureText: _isObscure3,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: ' Enter your Password',
//                           contentPadding:
//                               EdgeInsets.only(left: 20.0, top: 10.0),
//                           suffixIcon: IconButton(
//                               icon: Icon(_isObscure3
//                                   ? Icons.visibility
//                                   : Icons.visibility_off),
//                               onPressed: () {
//                                 setState(() {
//                                   _isObscure3 = !_isObscure3;
//                                   //isAccepted();
//                                 });
//                               }),
//                         ),

//                         //////////////validation////////////
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "* Required";
//                           } else if (!RegExp(r"^(?!.* ).{8,15}")
//                               .hasMatch(value!)) {
//                             return "Enter a valid password";
//                           } /*else if(validDriver == false){
//                                   return "your account is not accepted yet";
//                                 }*/
//                           else
//                             return null;
//                         },

//                         //////////////////////////////////
//                       ),
//                     ),
//                   ),

//                   //SizedBox(height: 80),

//                   //Sign in button GestureDetector
//                   /*Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 90.0),
//                     child: GestureDetector(
//                       onTap: signIn,
//                       child: Container(
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                             color: Color(0xff204854),
//                             borderRadius: BorderRadius.circular(40)),
//                         child: Center(
//                           child: Text(
//                             'Sign In',
//                             style: GoogleFonts.alice(
//                                 fontSize: 30, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),*/

//                   /*Center(
//                     child: Text(errorMessage),
//                   ),*/
//                   // error message
//                   Center(
//                     child: Text(
//                       errorMessage,
//                       style: TextStyle(
//                         fontSize: 17,
//                         color: Color.fromARGB(255, 215, 1, 1),
//                       ),
//                     ),
//                   ),

//                   /*Container(
//                             width: 30,
//                             height: 20,
//                             child: StreamBuilder<QuerySnapshot>(
//                               stream: readRequest,
//                               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
//                                 if (snapshot.hasData){
//                                   final users = snapshot.data!;
//                                   int count = users.docs.length;
//                                   for(int x = 0 ; x < count ;x++){
//                                     if ( _emailController.text.trim() == users.docs[x]['email'].toString()){
//                                       validDriver = false;
//                                       return Text(
//                                                   "your account is not accepted yet!",
//                                               );}; }
//                                               return Text(
//                                                   "",
//                                               );
//                                     }
//                                   return Center(child: CircularProgressIndicator()); 
//                                 },
//                                         ),
//                           ),*/
//                 /*Row(
//                    children:[
//                   Positioned(
//                     left: 1000,
//                       child: TextButton(
//                         child: Container(
//                 width: 193,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(
//                     color: Color(0x1e000000),
//                     width: 1,
//                   ),
//                   color: Color(0xcc1e4854),
//                 ),
//                 child: Center(
//                   child: GestureDetector(
//                     //onTab: Widget.showRegisterPage, //registration page onPressed?
//                     child: Text(
//                       'Sign in',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
              
//                         onPressed: () async {
//                           if (_key.currentState!.validate()) {
//                             signIn();
//                           } //if
//                         },
//                       ),
//                   ),
                  
//               Positioned(
//               left: 1000,
//               top: 500,
//               child:TextButton( 
//                       onPressed: (){
//                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
//                       },
//                       child: Container(
//                 width: 193,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(
//                     color: Color(0xff204854),
//                     width: 1,
//                   ),
//                   color: Color(0xffffdf75),
//                 ),
//                 child: Center(
//                   child: GestureDetector(
//                     //onTab: Widget.showRegisterPage, //registration page onPressed?
//                     child: Text(
//                       'Home',
//                       style: TextStyle(
//                         color: Color(0xff204854),
//                         fontSize: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               ),
//             ),
//             ],
//                 ),*/
//                   //////////////////////////////////////
//                 ],
//               ),
//             ),

//           Positioned(
//                     left: 730,
//                     top:500,
//                       child: TextButton(
//                         child: Container(
//                 width: 193,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(
//                     color: Color(0x1e000000),
//                     width: 1,
//                   ),
//                   color: Color(0xcc1e4854),
//                 ),
//                 child: Center(
//                   child: GestureDetector(
//                     //onTab: Widget.showRegisterPage, //registration page onPressed?
//                     child: Text(
//                       'Sign in',
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         fontSize: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
              
//                         onPressed: () async {
//                           if (_key.currentState!.validate()) {
//                             signIn();
//                           } //if
//                         },
//                       ),
//                   ),
                  
//               Positioned(
//               left: 930,
//               top: 500,
//               child:TextButton( 
//                       onPressed: (){
//                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => webwelcome()));
//                       },
//                       child: Container(
//                 width: 193,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(
//                     color: Color(0xff204854),
//                     width: 1,
//                   ),
//                   color: Color(0xffffdf75),
//                 ),
//                 child: Center(
//                   child: GestureDetector(
//                     //onTab: Widget.showRegisterPage, //registration page onPressed?
//                     child: Text(
//                       'Back',
//                       style: TextStyle(
//                         color: Color(0xff204854),
//                         fontSize: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               ),
//             ),


//             //1) Welcome Back!
//             Positioned(
//               left: 150,
//               top: 250,
//               child: Text(
//                 "Welcome Back!",
//                 style:
//                     TextStyle(fontSize: 40, color: Color(0xff204854)),
//               ),
//             ),

//             //line of footer
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Container(
//                   width: 1440,
//                   height: 30,
//                   color: Color(0xff4b6d76),
//                 ),
//               ),
//             ),

//             //copy right
//             Positioned.fill(
//               bottom: 8,
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: SizedBox(
//                   child: Text(
//                     "©2022 UniBee. All rights reserved.",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }

// /*SizedBox(
//       width: 390,
//       height: 844,
//       child: Material(
//         color: Colors.white,
//         elevation: 4,
//         //color: Color(0x3f000000),
//         child: Stack(
//           children: [
//             Positioned(
//               left: 47,
//               top: 479,
//               child: SizedBox(
//                 width: 296,
//                 height: 37,
//                 child: Material(
//                   color: Color(0x1e000000),
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 1,
//                       color: Color(0x1e000000),
//                     ),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//               ),
//             ),
//             Transform.rotate(
//               angle: 3.14,
//               child: Container(
//                 width: 390,
//                 height: 844,
//                 padding: const EdgeInsets.only(
//                   right: 89,
//                   top: 41,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Transform.rotate(
//                       angle: 3.14,
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: FlutterLogo(size: 40),
//                       ),
//                     ),
//                     SizedBox(height: 606),
//                     Container(
//                       width: double.infinity,
//                       height: 844,
//                       child: FlutterLogo(size: 390),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 68,
//               top: 19,
//               child: Transform.rotate(
//                 angle: -1.60,
//                 child: Container(
//                   width: 209.12,
//                   height: 149.85,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(101),
//                   ),
//                   child: FlutterLogo(size: 149.84681701660156),
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 47,
//               top: 392,
//               child: SizedBox(
//                 width: 296,
//                 height: 37,
//                 child: Material(
//                   color: Color(0x1e000000),
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 1,
//                       color: Color(0x1e000000),
//                     ),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 61,
//               top: 255,
//               child: Text(
//                 "Welcome Back!",
//                 style: TextStyle(
//                   color: Color(0xff204854),
//                   fontSize: 40,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 80,
//               top: 586,
//               child: SizedBox(
//                 width: 230.83,
//                 height: 50,
//                 child: Material(
//                   color: Color(0xff1e4845),
//                   borderRadius: BorderRadius.circular(50),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       left: 74,
//                       right: 81,
//                       top: 12,
//                       bottom: 11,
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Sign In",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 57,
//               top: 368,
//               child: Text(
//                 "E-mail",
//                 style: TextStyle(
//                   color: Color(0xff204854),
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 57,
//               top: 524,
//               child: Text(
//                 "Forgot password?",
//                 style: TextStyle(
//                   color: Color(0xffff3939),
//                   fontSize: 10,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 57,
//               top: 455,
//               child: Text(
//                 "Password",
//                 style: TextStyle(
//                   color: Color(0xff204854),
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: Container(
//                   width: 266,
//                   height: 312,
//                   child: FlutterLogo(size: 266),
//                 ),
//               ),
//             ),
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: Container(
//                   width: 224,
//                   height: 149,
//                   child: FlutterLogo(size: 149),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );*/

