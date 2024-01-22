import 'package:ayadi/applicants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:collection';
import 'package:intl/intl.dart';


class children extends StatefulWidget {
  final parentPhone;
  const children({super.key, required this.parentPhone});

  @override
  State<children> createState() => _childrenState(parentPhone);
}

class _childrenState extends State<children> {
  String parentPhone;
  _childrenState(this.parentPhone);
  bool noChildren = true;
    //final Stream<QuerySnapshot> Readchildren = FirebaseFirestore.instance.collection("sessions").where('parentPhone', isEqualTo: parent.id.).snapshots();

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMM, yyyy').format(dateFromTimeStamp);
  }

    int getSessionNum(String childID){
      int i = 0;
      FirebaseFirestore.instance.collection("sessions").where("childID" , isEqualTo: childID).get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.size > 0) {
      i = querySnapshot.size;
      print("foundd $i");
    } else {
      print('No documents found');
    }
  });

  return i;
}

  int calculateAge(String dateOfBirth) {
    DateTime now = DateTime.now();
    List<String> parts = dateOfBirth.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    DateTime dob = DateTime(year, month, day);
    int age = now.year - dob.year;

    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
        //key: scaffoldkey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            width: 900.w,
            height: 800.h,
            decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xff9c95a0), width: 0.50, ),
        boxShadow: [
            BoxShadow(
                color: Color(0x3f000000),
                blurRadius: 4,
                offset: Offset(0, 4),
            ),
        ],
        color: Color(0xffededed),
    ),
           // color: Color.fromARGB(0, 255, 255, 255),
            padding: EdgeInsets.all(10.h),


            child: Column(
              children:[


                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 15.w),
                                  width: 40.w,
                                  height: 40.h,
                                  child: Image(
                                                  image: AssetImage('assets/images/close.png'), color: Color(0xff59567e),),
                              ),
                    ),
                     Text(
        "الأطفال",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color(0xff5e5a99),
            fontSize: 32.sp,
        ),
                     ),

                     SizedBox()
                   ],
                 ),

                 SizedBox(
                  height: MediaQuery.of(context).size.height*0.05,
                 ),

                //  if (!noChildren)
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 60.w),
                //     child: Row(
                //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                           children: [
                //                             SizedBox(height: 30.w,),
                //                               Text(
                //                                     "عدد الجلسات",
                //                                     style: TextStyle(
                //                                          color: Color(0xff5e5a99),
                //                                         fontSize: 20.sp,
                //                                         height: 1.5.h,
                //                                         fontWeight: FontWeight.bold
                //                                     ),
                //                                     textAlign: TextAlign.right,
                //                                 ),
                //                         SizedBox(height: 10.w,),
                  
                //                                 Text(
                //                                     "العمر",
                //                                     style: TextStyle(
                //                                          color: Color(0xff5e5a99),
                //                                         fontSize: 20.sp,
                //                                         height: 1.5.h,
                //                                         fontWeight: FontWeight.bold
                //                                     ),
                //                                     textAlign: TextAlign.right,
                //                                 ),
                //                                 //  SizedBox(height: 10.w,),
                  
                //                                 Text(
                //                                     "الجنس",
                //                                     style: TextStyle(
                //                                          color: Color(0xff5e5a99),
                //                                         fontSize: 20.sp,
                //                                         height: 1.5.h,
                //                                         fontWeight: FontWeight.bold
                //                                     ),
                //                                     textAlign: TextAlign.right,
                //                                 ),
                  
                //                                 SizedBox(
                //                                   width: MediaQuery.of(context).size.width*0.08,
                //                                   child: FittedBox(
                //                                     fit: BoxFit.scaleDown,
                //                                     child: Text(
                //                                         "اسم الطفل",
                //                                         style: TextStyle(
                //                                              color: Color(0xff5e5a99),
                //                                             fontSize: 20.sp,
                //                                             height: 1.5.h,
                //                                             fontWeight: FontWeight.bold
                //                                         ),
                //                                         textAlign: TextAlign.right,
                //                                     ),
                //                                   ),
                //                                 ),
                //                            ],
                //                         ),
                //   ),


 Expanded(
   child: 
   SizedBox(
    height: 700,
    width: 850,
     child: 
     StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("children").where("parentPhone", isEqualTo: parentPhone).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if (snapshot.hasData){
                      final children = snapshot.data!.docs;
                     print(children.length);
                      print("parent:" + parentPhone);
                      //print(children.docs[index]['Fname']);
                      if (children.isEmpty){
                        //noChildren = true;
                        return Center(
                        child: Text(
                          "لا يوجد أطفال",
                          style: TextStyle( fontSize: 20),
                        )
                      );
                      }
                      else {
                        //noChildren =false;
                        return Column(
                          children: [

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.w),
                    child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(height: 30.w,),
                                              Text(
                                                    "عدد الجلسات",
                                                    style: TextStyle(
                                                         color: Color(0xff5e5a99),
                                                        fontSize: 20.sp,
                                                        height: 1.5.h,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    textAlign: TextAlign.right,
                                                ),
                                        SizedBox(height: 10.w,),
                  
                                                Text(
                                                    "العمر",
                                                    style: TextStyle(
                                                         color: Color(0xff5e5a99),
                                                        fontSize: 20.sp,
                                                        height: 1.5.h,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    textAlign: TextAlign.right,
                                                ),
                                                //  SizedBox(height: 10.w,),
                  
                                                Text(
                                                    "الجنس",
                                                    style: TextStyle(
                                                         color: Color(0xff5e5a99),
                                                        fontSize: 20.sp,
                                                        height: 1.5.h,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    textAlign: TextAlign.right,
                                                ),
                  
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.08,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                        "اسم الطفل",
                                                        style: TextStyle(
                                                             color: Color(0xff5e5a99),
                                                            fontSize: 20.sp,
                                                            height: 1.5.h,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.right,
                                                    ),
                                                  ),
                                                ),
                                           ],
                                        ),
                  ),
                            ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 50.h),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: children.length,
                            itemBuilder: (BuildContext context, int index) {
                              String parentName = "hi";
                              String parentID = "";
                              print(children[index]['parentPhone']);
                              print(children[index]['parentPhone'] == parentPhone);
                              return Container(
                                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h , left: 50.w , right: 30.w),
                                          width: 875.w,
                                          height: 100.h,
                                          margin: EdgeInsets.only(bottom: 20.h),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                boxShadow: [
                                                    BoxShadow(
                                                        color: Color(0x3f000000),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 4),
                                                    ),
                                                ],
                                          color: Color(0xfff5f5f5),
                                          ),
                                                                   
                                          child: 
                                          
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(height: 30.w,),
                                              StreamBuilder<QuerySnapshot>(
                                                stream:  FirebaseFirestore.instance.collection("sessions").where("childID" , isEqualTo: children[index]["id"]).snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                  if (snapshot.hasData){
                      int sessionNum = snapshot.data!.docs.length;
                                                  return Text(
                                                          "$sessionNum",
                                                          style: TextStyle(
                                                               color: Colors.black,
                                                              fontSize: 23.sp,
                                                              height: 1.5.h,
                                                          ),
                                                          textAlign: TextAlign.right,
                                                      );
                                                  }
                                                  else{
                                                    return Text(
                                                          "0",
                                                          style: TextStyle(
                                                               color: Colors.black,
                                                              fontSize: 23.sp,
                                                              height: 1.5.h,
                                                          ),
                                                          textAlign: TextAlign.right,
                                                      );
                                                  }
                                                }
                                              ),

                                              SizedBox(height: 10.w,),

                                              Text(
                                                      "${calculateAge(children[index]["DOB"])}",
                                                      style: TextStyle(
                                                           color: Colors.black,
                                                          fontSize: 23.sp,
                                                          height: 1.5.h,
                                                      ),
                                                      textAlign: TextAlign.right,
                                                  ),

                                                  Text(
                                                      "${children[index]["gender"]}",
                                                      style: TextStyle(
                                                           color: Colors.black,
                                                          fontSize: 23.sp,
                                                          height: 1.5.h,
                                                      ),
                                                      textAlign: TextAlign.right,
                                                  ),

                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.08,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                          "${children[index]['Fname']} ${children[index]['Lname']}",
                                                          style: TextStyle(
                                                               color: Colors.black,
                                                              fontSize: 23.sp,
                                                              height: 1.5.h,
                                                          ),
                                                          textAlign: TextAlign.right,
                                                      ),
                                                  ),
                                                ),
                                                  
                                             ],
                                          )
                                          , 
                                                              );

                               },
                            ),
                          ],
                        );
                      }
                    } 
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                }
                ),
   ),
 ),



                // Container(
                //   alignment: Alignment.bottomCenter,
                //   height: 90.h,
                //   decoration: BoxDecoration(
                // color: Color(0xffb9b4bc),
                // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20) , bottomRight: Radius.circular(20)),
                // ),

                // child: TextButton(
                //   onPressed: () {
                //     // FirebaseFirestore.instance.collection("parent").doc(applicant.docs.id).update({
                //     //                                         'status':true,
                //     //                                       });
                //     Navigator.pop(context);
                //   } ,
                //   child: Container(
                //     margin: EdgeInsets.only(bottom: 15.h),
                //     height: 60.h,
                //     width: 180.w,
                //   decoration: BoxDecoration(
                // color: Color(0xffe8dbf0),
                // borderRadius: BorderRadius.circular(15),
                // ),
                // child: SizedBox(
                //             width: 100.w,
                //              height: 60.h,
                //             child: Text(
                //                 "اغلاق",
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(
                //                     color:Color(0xff5e5a99),
                //                     fontSize: 22.sp,
                //                 ),
                //             ),
                //             ),
                //   )
                // ,)
                // ),

              ],
            )));
  }
}