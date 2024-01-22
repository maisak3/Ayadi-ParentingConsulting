import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ayadi/NavigationPages/parentHomePage.dart';

class DescribeProblem extends StatefulWidget {
  const DescribeProblem({super.key});

  @override
  State<DescribeProblem> createState() => _DescribeProblemState();
}

class _DescribeProblemState extends State<DescribeProblem> {
  String dropdownValue = '-----';
  //String parentID = "bbbJwXoeJqAr7Pujrvri";

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var parentFname = "";
  var parentLname = "";
  var parentEmail = '';
//String parentID = '';
  var parentPhoneNo = '';
  List<String> childrenName = [];

  void _getdata() async {
    User user = _firebaseAuth.currentUser!;
    FirebaseFirestore.instance
        .collection('parent')
        .where("phone", isEqualTo: user.phoneNumber)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data();
          setState(() {
            parentFname = documentSnapshot['Fname'];
            parentLname = documentSnapshot['Lname'];
            parentEmail = documentSnapshot['email'];
            //parentID = userData.data()!['id'];
            parentPhoneNo = documentSnapshot['phone'];
          });
        } else {
          print('No documents found');
        }
      } else {
        print('No documents found');
      }
    });

    getChildrenName();
    print(childrenName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    //user = FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  void getChildrenName() {
    childrenName = [];
    String fullName = "";
    childrenName.add('-----');
    FirebaseFirestore.instance
        .collection("children")
        .where("parentPhone", isEqualTo: _firebaseAuth.currentUser!.phoneNumber)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((element) {
          if (element.exists) {
            var data = element.data();
            String childFname = element['Fname'];
            String childLname = element['Lname'];
            fullName = childFname + " " + childLname;
            setState(() {
              childrenName.add(fullName);
            });
          } else {
            print('No documents found');
          }
        });
      } else {
        print('No documents found');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.white,
              color: Color.fromRGBO(94, 90, 153, 1.0),
              animationDuration: Duration(milliseconds: 500),
              height: 75.0.h,
              index: 2,
              onTap: (index) {
                setState(() {
                  if (index == 0) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => parentHomePage()));
                  }
                });
              },
              // letIndexChange: (index) => true,
              items: [
                Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
                Icon(
                  Icons.people_rounded, //
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //app bar
                    SizedBox(height: 40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 95.w,
                          ),
                          Text(
                            'حجز موعد جديد',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 40.w,
                          ),
                          Container(
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
                                    pageBuilder: (_, __, ___) =>
                                        parentHomePage()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Text(
                      'دعنا نساعدك في البحث عن الأخصائي المناسب',
                      style: TextStyle(
                        fontSize: 17.sp,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 30.h),

                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                      child: Text(
                        'اسم الطفل',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    //search bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              // Step 1.
                              DropdownButton<String>(
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(12),
                            // Step 3.

                            value: '-----',
                            //alignment: AlignmentDirectional.centerEnd,

                            // Step 4.

                            items: childrenName
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                alignment: AlignmentDirectional.centerEnd,
                              );
                            }).toList(),
                            // Step 5.
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                          )),
                    ),

                    SizedBox(height: 30.h),

                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                      child: Text(
                        'المشكلة',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          maxLines: null,
                          textAlign: TextAlign.end,
                          //textDirection: TextDirection.ltr,
                          cursorColor: Colors.deepPurple,
                          decoration: InputDecoration(
                            suffixIconColor: Colors.deepPurple,
                            border: InputBorder.none,
                            hintText: 'قم بوصف مشكلتك هنا',
                            // hintTextDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: Text(
                        'ابحث',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.only(
                                  top: 10.h,
                                  bottom: 10.h,
                                  left: 70.w,
                                  right: 70.w)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple[300]!),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ))),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
