//import 'dart:html';

import 'package:ayadi/bookAppointment/DescribeProblem.dart';
import 'package:ayadi/bookAppointment/viewSpecialistProfile.dart';

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
import '../Components/navigationBar.dart';
import 'BookAppointment.dart';

class searchSpecialist extends StatefulWidget {
  final sessionType;
  const searchSpecialist({super.key, required this.sessionType});

  @override
  State<searchSpecialist> createState() => _searchSpecialistState(sessionType);
}

class _searchSpecialistState extends State<searchSpecialist> {
  String sessionType;
  _searchSpecialistState(this.sessionType);
  // final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance.collection("parent").where("phoneNumber", isEqualTo: "56477388").snapshots();

  // .where("phoneNumber", isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
  // .snapshots();

  // final user = FirebaseAuth.instance.currentUser!;

  //final user = FirebaseAuth.instance.currentUser!;
  //final CollectionReference db = FirebaseFirestore.instance.collection();
  // final user = FirebaseAuth.instance.currentUser!.email;

  // List<DocumentSnapshot> parentInfo = [];
  // //String
  // int count = 0;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String parentFname = '';
  String parentLname = '';
  String parentEmail = '';
//String parentID = '';
  String parentPhoneNo = '';
  bool isBack = false;

  String dropdownValue = '-----';

  final _formKey = GlobalKey<FormState>();

  List<dynamic> _list = [];
  bool _isSearching = false;
  String _searchText = "";
  List searchresult = [];
  List specializationList = [];
  final TextEditingController _controller = new TextEditingController();

  searchSpecialistState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    for (int i = 0; i < _list.length; i++) {
      String data = _list[i];
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        searchresult.add(data);
      }
    }
  }

  Widget searchList(List list) {
    print("inside search list");
    if (list.isEmpty){
      return Center(
                                    child:  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/Search.png",
                                          height: 250,
                                          width: 250,
                                        ),
                                        Text(
                                          "لا يوجد أخصائيين",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  71, 55, 164, 1)),
                                        ),
                                      ],
                                    )
                                  );
    }
    else
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        // return new ListTile(
        //   title: new Text(listData.toString()),
        // );

        return Padding(
          padding: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w),
          child: Container(
              width: 100.w,
              height: 195.h,
              //padding: EdgeInsets.all(15.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0x4c000000),
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    sessionType == "none";
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => viewSpecialistProfile(
                          specialistPhone: list[index]["phoneNumber"])));
                },
                child: Padding(
                  padding: EdgeInsets.all(5.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // SizedBox(width: 5.h),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      list[index]['avgRate'].toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Color(0xff4e4a8c),
                                        fontSize: 22.sp,
                                        fontFamily: 'Alice',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // SizedBox(width: 5.w),

                                    // Text(
                                    //   "(${users[index]['numOfRates']})",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //     fontSize: 14.sp,
                                    //   ),
                                    // ),

                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .22,
                                      height: 20.0,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: const Color(0xFFFFFF),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(32.0)),
                                      ),
                                      child: Center(
                                        child: RatingBarIndicator(
                                          rating: list[index]['avgRate'] * 1.0,
                                          itemSize: 16.sp,
                                          direction: Axis.horizontal,
                                          itemCount: 5,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Text(
                                      "(${list[index]['numOfRates']})",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                      ),
                                    ),

                                    // sessions num
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: 40.w,
                          ),

                          SafeArea(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    //name

                                    Text(
                                      "${list[index]['Fname']} ${list[index]['Lname']}",
                                      style: TextStyle(
                                        color: Color(0xff4e4a8c),
                                        //fontSize: MediaQuery.of(context).size.width*0.05,
                                        fontWeight: FontWeight.w500,
                                        height: 1.8.h,
                                        fontSize: 18.sp,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),

                                    //specialization

                                    Text(
                                      "${list[index]['specialization']}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        height: 1.2.h,
                                      ),
                                    ),
                                  ],
                                ),
                                // photo

                                Container(
                                  width: 50.w,
                                  height: 50.h,
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Color(0xff4e4a8c),
                                  ),
                                  //child: Image(
                                  //    image: AssetImage('assets/images/specialist2.png'), color: Color(0xff59567e),),
                                ),
                              ],
                            ),
                          ),

                          //phone number
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 10.w, left: 5.w),
                          height: 40.h,
                          child: Text(
                            "${list[index]['bio']}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              height: 1.3.h,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      Container(
                        height: 1.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "دقيقة",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff4e4a8c),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                height: 1.0.h,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              " 30",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff4e4a8c),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                height: 1.0.h,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              " / ر.س ",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff4e4a8c),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                height: 1.0.h,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              " ${list[index]['sessionPrice']}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff4e4a8c),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                height: 1.0.h,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  // void getChildrenName() async{

  //     FirebaseFirestore.instance.collection("children").where("parentID" , isEqualTo: parentID).get().then((value) {
  //       setState(() {
  //          childrenNames= List.from(value.data['point']);
  //       });
  //     });

  // }

//     void _getdata() async {
//  User user = _firebaseAuth.currentUser!;
//   FirebaseFirestore.instance
//     .collection('parent')
//     .doc(user.uid)
//     .snapshots()
//     .listen((userData) {
//     setState(() {
//       parentFname = userData.data()!['Fname'];
//         parentLname = userData.data()!['Lname'];
//        parentEmail = userData.data()!['email'];
//       // parentID = userData.data()!['id'];
//        parentPhoneNo = userData.data()!['phoneNumber'];
//     });
//   });

//   // getChildrenName();

//     }

//       @override
//   void initState() {
// super.initState();
// _getdata();
//  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(

            body: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80.w,
                      ),
                      Text(
                        'البحث عن اخصائي',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                          ),
                          iconSize: 30,
                          color: Colors.black,
                          splashColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              sessionType = "none";
                            });
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) => parentHomePage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      autofocus: ((sessionType != "none")) ? true : false,
                      controller: _controller,
                      onChanged: searchOperation,
                      textDirection: TextDirection.rtl,
                      cursorColor: Colors.deepPurple,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.deepPurple,
                        ),
                        //suffixIconColor: Colors.deepPurple,
                        border: InputBorder.none,
                        hintText: 'البحث عن أخصائي',
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              sessionType = "behavioral";
                            });
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => searchSpecialist(sessionType: "behavioral" ,)));
                          },
                          child: Text(
                            'سلوكي',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: (sessionType == "behavioral")
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.only(
                                      top: 5.h,
                                      bottom: 5.h,
                                      left: 20.w,
                                      right: 20.w)),
                              backgroundColor: (sessionType == "behavioral")
                                  ? MaterialStateProperty.all<Color>(
                                      Color.fromARGB(160, 145, 75, 185))
                                  : MaterialStateProperty.all<Color>(
                                      Colors.deepPurple[100]!),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                        ),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              sessionType = "educational";
                            });
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => searchSpecialist(sessionType: "educational" ,)));
                          },
                          child: Text(
                            'تربوي',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: (sessionType == "educational")
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.only(
                                      top: 5.h,
                                      bottom: 5.h,
                                      left: 22.w,
                                      right: 22.w)),
                              backgroundColor: (sessionType == "educational")
                                  ? MaterialStateProperty.all<Color>(
                                      Color.fromARGB(160, 145, 75, 185))
                                  : MaterialStateProperty.all<Color>(
                                      Colors.deepPurple[100]!),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                        ),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              sessionType = "speech";
                            });
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => searchSpecialist(sessionType: "speech" ,)));
                          },
                          child: Text(
                            'نطق و تخاطب',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: (sessionType == "speech")
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.only(
                                      top: 5.h,
                                      bottom: 5.h,
                                      left: 18.w,
                                      right: 18.w)),
                              backgroundColor: (sessionType == "speech")
                                  ? MaterialStateProperty.all<Color>(
                                      Color.fromARGB(160, 145, 75, 185))
                                  : MaterialStateProperty.all<Color>(
                                      Colors.deepPurple[100]!),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: .0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              sessionType = "";
                            });
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => searchSpecialist(sessionType: "" ,)));
                          },
                          child: Text(
                            'الكل',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: (sessionType == "")
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.only(top: 5.h, bottom: 5.h)),
                              backgroundColor: (sessionType == "")
                                  ? MaterialStateProperty.all<Color>(
                                      Color.fromARGB(160, 145, 75, 185))
                                  : MaterialStateProperty.all<Color>(
                                      Colors.deepPurple[100]!),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  //height: 800,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("specialist")
                          .where("status", isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final specialists = snapshot.data!;
                          int count = specialists.size;
                          List users = [];
                          List behavioralList = [];
                          List educationalList = [];
                          List speechList = [];

                          searchresult.clear();

                          for (int i = 0; i < specialists.size; i++) {
                            String data = specialists.docs[i]["Fname"] +
                                " " +
                                specialists.docs[i]["Lname"];
                            String specialization =
                                specialists.docs[i]["specialization"];
                            if (data
                                .toLowerCase()
                                .contains(_searchText.toLowerCase())) {
                              searchresult.add(data);
                              users.add(specialists.docs[i]);
                              if (specialists.docs[i]["specialization"] ==
                                  "إخصائى سلوكي")
                                behavioralList.add(specialists.docs[i]);
                              else if (specialists.docs[i]["specialization"] ==
                                  "إخصائى تربوي")
                                educationalList.add(specialists.docs[i]);
                              else if (specialists.docs[i]["specialization"] ==
                                  'إخصائي نطق و تخاطب')
                                speechList.add(specialists.docs[i]);
                            }
                          }

                          searchSpecialistState();
                          //print(searchresult);
                          if (searchresult.isNotEmpty &&
                              _controller.text.isNotEmpty) {
                            if (sessionType == "" || sessionType == "none")
                              return searchList(users);
                            else if (sessionType == "behavioral")
                              return searchList(behavioralList);
                            else if (sessionType == "educational")
                              return searchList(educationalList);
                            else if (sessionType == "speech")
                              return searchList(speechList);
                            else
                              return Container(
                                child: Text("لا يوجد اخصائيين"),
                              );
                          } else {
                            if (sessionType == "" || sessionType == "none")
                              return searchList(users);
                            else if (sessionType == "behavioral")
                              return searchList(behavioralList);
                            else if (sessionType == "educational")
                              return searchList(educationalList);
                            else if (sessionType == "speech")
                              return searchList(speechList);
                            else
                              return Container(
                                child: Text("لا يوجد اخصائيين"),
                              );
                          }
                        } else {
                          return Container(
                            child: Text("لا يوجد اخصائيين"),
                          );
                        }
                      }),
                ),
                SizedBox(
                  height: 30.h,
                )
              ],
            ),
          );
        });
  }
}
