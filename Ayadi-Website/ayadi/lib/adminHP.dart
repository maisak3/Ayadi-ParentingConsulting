import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ayadi/applicants.dart';
import 'package:ayadi/specialists.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'parents.dart';
import 'welcome.dart';

class AdminHP extends StatefulWidget {
  const AdminHP({super.key});
  @override
  State<AdminHP> createState() => _AdminHPState();
}

class _AdminHPState extends State<AdminHP> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffeaeaea),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                color: Color(0xffdcd3e1),
                alignment: Alignment.topRight,
              ),

              Column(
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
// تسجيل الخروج
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: TextButton(
                        onPressed: () {
                          AwesomeDialog(
                            width: 550,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            context: context,
                            animType: AnimType.leftSlide,
                            headerAnimationLoop: false,
                            dialogType: DialogType.question,
                            title: 'هل أنت متأكد من تسجيل الخروج؟',
                            titleTextStyle: TextStyle(
                              fontSize: 23,
                            ),
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              //Navigator.of(context, rootNavigator: true).pop(context);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => welcome()));
                            },
                            btnOkText: "نعم",
                            btnCancelText: "لا",
                            btnCancelColor: Color(0xFF00CA71),
                            btnOkColor: Color.fromARGB(255, 211, 59, 42),
                          ).show();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: 170.w,
                                height: 55.h,
                                child: Text(
                                  "تسجيل الخروج",
                                  style: TextStyle(
                                    color: Color(0xFF914BB9),
                                    fontSize: 22.sp,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child:  Icon(
                      Icons.logout,
                      size: 30,
                      color: Color(0xFF914BB9),
                    ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 700.w,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => parents())),
                            child: Text(
                              "الآباء",
                              style: TextStyle(
                                color: Color(0xFF914BB9),
                                fontSize: 22.sp,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 30.h,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => specialists())),
                            child: Text(
                              "الأخصائيين",
                              style: TextStyle(
                                color: Color(0xFF914BB9),
                                fontSize: 22.sp,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 30.h,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => applicants())),
                            child: Text(
                              "طلبات التسجيل",
                              style: TextStyle(
                                color: Color(0xFF914BB9),
                                fontSize: 22.sp,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h),
                        alignment: Alignment.topRight,
                        child: Image(
                            image: AssetImage('assets/images/AyadiLogo.png'),
                            width: 150.w,
                        height: 130.h,
                            ),
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 150.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "أهلًا بعودتك",
                          style: TextStyle(
                            color: Color.fromARGB(255, 83, 40, 108),
                            fontSize: 35.sp,
                            height: 1.5.sp,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          "إليك نبذة عامة عن اخر التحديثات",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 22.sp,
                            height: 1.0.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 30.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 90.w,
                    ),
                     Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width*0.013),
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: 53.w,
                                height: 63.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffdcd3e1),
                                ),
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/child.png')),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: 
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("children")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final users = snapshot.data!;
                                          int count = users.docs.length;
                                          return 
                                          Text(
                                            "$count",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 83, 40, 108),
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5
                                            ),
                                          )
                                         ;
                                        } else
                                          return Center(
                                              child: CircularProgressIndicator());
                                      }),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "عدد الأطفال",
                                    style: TextStyle(
                                      fontSize: 25.sp,
                                      color: Color(0xff555555),
                                      height: 1.0
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),

                    Container(
                        padding: EdgeInsets.all( MediaQuery.of(context).size.width * 0.015),
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                width: 53.w,
                                height: 63.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffdcd3e1),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height *
                                      0.5,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/parent.png')),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: 
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("parent")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final users = snapshot.data!;
                                          int count = users.docs.length;
                                          return 
                                          Text(
                                            "$count",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 83, 40, 108),
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5
                                            ),
                                          )
                                         ;
                                        } else
                                          return Center(
                                              child: CircularProgressIndicator());
                                      }),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "عدد الآباء",
                                    style: TextStyle(
                                      fontSize: 25.sp,
                                      color: Color(0xff555555),
                                      height: 1.0
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all( MediaQuery.of(context).size.width * 0.015),
                        width: MediaQuery.of(context).size.width * 0.18,
                        height:  MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                width: 53.w,
                                height: 63.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffdcd3e1),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height *
                                      0.5,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/specialist2.png')),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child:
                                   StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("specialist").where("status", isEqualTo: true)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final users = snapshot.data!;
                                          int count = users.docs.length;
                                          return 
                                          Text(
                                            "$count",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 83, 40, 108),
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5
                                            ),
                                          )
                                          ;
                                        } else
                                          return Center(
                                              child: CircularProgressIndicator());
                                      }),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "عدد الأخصائيين",
                                    style: TextStyle(
                                      fontSize: 25.sp,
                                      color: Color(0xff555555),
                                      height: 1.0
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all( MediaQuery.of(context).size.width * 0.015),
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                width: 53.w,
                                height: 63.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffdcd3e1),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height *
                                      0.5,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/listIcon.png')),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: 
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("sessions")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final users = snapshot.data!;
                                          int count = users.docs.length;
                                          return 
                                          Text(
                                            "$count",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 83, 40, 108),
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5
                                            ),
                                          )
                                         ;
                                        } else
                                          return Center(
                                              child: CircularProgressIndicator());
                                      }),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "عدد الجلسات",
                                    style: TextStyle(
                                      fontSize: 25.sp,
                                      color: Color(0xff555555),
                                      height: 1.0
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                    
                    SizedBox(
                      width: 100.w,
                    ),
                  ],
                ),

                SizedBox(height: 20.h,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 100.w,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.22,
                      height: MediaQuery.of(context).size.height * 0.41,
                      child: Image(
                        image: AssetImage('assets/images/homepage.png'),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  Container(
  padding: EdgeInsets.only(
    top: 15.h,
    left: 10.w,
    bottom: 20.h,
    right: 20.w,
  ),
  width: MediaQuery.of(context).size.width * 0.29,
  height: MediaQuery.of(context).size.height * 0.30,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Colors.white,
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Align(
        alignment: Alignment.topRight,
        child: Text(
          "أفضل الأخصائيين",
          style: TextStyle(
            fontSize: 20.sp,
            color: Color(0xff555555),
          ),
        ),
      ),


 StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection("sessions").snapshots(),
  builder: (context, snapshot) {
  if (snapshot.hasData){
    final sessionStream = snapshot.data!.docs;
    List specialistsList = [];
    for (int i = 0; i < sessionStream.length ; i++){
      specialistsList.add(sessionStream[i]["specialistPhone"]);
    }
    Map<String, int> counts = {};
    for (var item in specialistsList) {
      if (counts.containsKey(item)) {
        counts[item] = counts[item]! + 1;
      } else {
        counts[item] = 1;
      }
    }

    List<MapEntry<String, int>> sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); 

      Map<String, int> sortedCounts = {};

      if (sortedEntries.length >= 3)
     sortedCounts = Map.fromEntries(sortedEntries.take(3));
    else 
     sortedCounts = Map.fromEntries(sortedEntries);
    int circular = 0;
    List imageNames = ["assets/images/third-rank.png" , "assets/images/second-rank.png" , "assets/images/first-rank.png"];

    Row specialistsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [],
    );
     List<MapEntry<String, int>> reversedEntries = sortedCounts.entries.toList().reversed.toList();
      int i = 0;

    for (var entry in reversedEntries) {
     
      String specialistPhone = entry.key;
      int specialistCount = entry.value;
      // Here you can retrieve the specialist name from the database and add it to the row
      // For example, you can use another StreamBuilder to retrieve the specialist name:
      specialistsRow.children.add(
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("specialist").where("phoneNumber", isEqualTo: specialistPhone).limit(1).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var specialist = snapshot.data!.docs;
              String specialistName = specialist[0]["Fname"] + " " + specialist[0]["Lname"];
              return Container(
                width: MediaQuery.of(context).size.width * 0.077,
                height: MediaQuery.of(context).size.width * 0.09,
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
  // border: Border.all(
  //   color: Colors.grey[600]!,
  //   width: 1.0,
  // ),
  borderRadius: BorderRadius.circular(10.0),
  ),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(image:  AssetImage(
                                          imageNames[i++]),
                                          height: 60, width: 60,),
                      Text("$specialistName" , style: TextStyle(fontSize: 15, color: Color(0xFF914BB9)),),
                    ],
                  ),
                ));
            } else {
              circular++;
              if (circular ==1)
              return CircularProgressIndicator(
                color: Color.fromARGB(255, 83, 40, 108),
              );
              else
              return Container();
            }
          },
        ),
      );
    }

    return specialistsRow;
  } else {
    return CircularProgressIndicator(
      color: Color.fromARGB(255, 83, 40, 108),
    );
  }
  },
)

    ],
  ),
),


                    // Container(
                    //     padding: EdgeInsets.only(
                    //         top: 15.h, left: 10.w, bottom: 20.h, right: 20.w),
                    //     width: MediaQuery.of(context).size.width * 0.3,
                    //     height: MediaQuery.of(context).size.height * 0.32,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(15),
                    //       color: Colors.white,
                    //     ),
                    //     child: Align(
                    //       alignment: Alignment.topRight,
                    //       child: Text(
                    //        "الأرباح الأسبوعيـة",
                    //         style: TextStyle(
                    //           fontSize: 20.sp,
                    //           color: Color(0xff555555),
                    //         ),
                    //       ),
                    //     )),
                        Container(
                        padding: EdgeInsets.all(
                           MediaQuery.of(context).size.width * 0.015),
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                width: 53.w,
                                height: 63.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffdcd3e1),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height *
                                      0.5,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/payment.png')),
                                ),
                              ),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: 
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("sessions")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final users = snapshot.data!.docs;
                                          int count = users.length;
                                          double profit = 0;
                                          for (var i = 0; i < count; i++) {
                                            profit =
                                                profit + (users[i]["price"] * 0.3);
                                          }
                                          return 
                                          Text(
                                            "$profit",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 83, 40, 108),
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold
                                            ),
                                          )
                                          ;
                                        } else
                                          return Center(
                                              child: CircularProgressIndicator());
                                      }),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "مجموع الأرباح",
                                    style: TextStyle(
                                      fontSize: 25.sp,
                                      color: Color(0xff555555),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                    SizedBox(
                      width: 100.w,
                    ),
                  ],
                )
              ]),

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
            ],
          ),
        ));
  }
}
