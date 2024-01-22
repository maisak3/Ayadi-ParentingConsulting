import 'package:ayadi/applicants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:collection';
import 'package:intl/intl.dart';


class reviews extends StatefulWidget {
  final specialist;
  const reviews({super.key, required this.specialist});

  @override
  State<reviews> createState() => _reviewsState(specialist);
}

class _reviewsState extends State<reviews> {
  String specialist;
  _reviewsState(this.specialist);
    //final Stream<QuerySnapshot> ReadReviews = FirebaseFirestore.instance.collection("sessions").where('specialistPhone', isEqualTo: specialist.id.).snapshots();

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd MMM, yyyy').format(dateFromTimeStamp);
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
        //key: scaffoldkey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            width: 900.w,
            height: 850.h,
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
        "التقييمات",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color(0xff5e5a99),
            fontSize: 32.sp,
        ),
                     ),

                     SizedBox()
                   ],
                 ),


 Expanded(
   child: 
   SizedBox(
    height: 700,
    width: 850,
     child: 
     StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("sessions").orderBy('date',descending: false).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if (snapshot.hasData){
                      final reviews1 = snapshot.data!.docs;
                     // print(reviews.size);
                      print("specialist:" + specialist);
                      List reviews = [];

                      for (int i = 0 ; i < reviews1.length ; i++){
                        if ((reviews1[i]['specialistPhone'] == specialist) && (reviews1[i]['review'] != "") )
                        reviews.add(reviews1[i]);
                      }
                      print("reviews num: ${reviews.length}");
                      //print(reviews.docs[index]['Fname']);
                      if (reviews.isEmpty)
                      return Center(
                        child: Text(
                          "لا يوجد تقييمات",
                          style: TextStyle( fontSize: 20),
                        )
                      );
                      else
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 50.h),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: reviews.length,
                        itemBuilder: (BuildContext context, int index) {
                          String parentName = "";
                          String parentID = "";
                          print(reviews[index]['specialistPhone']);
                        
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection("parent").where('phone', isEqualTo: reviews[index]['parentPhone']).limit(1).snapshots(),
                                  builder: (context, snapshot) { 
                                    if(snapshot.hasData){
                                      final parent = snapshot.data!.docs;
                                parentName = parent[0]['Fname'] + " " + parent[0]['Lname'];
                                     return Container(
                                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h , left: 20.w , right: 20.w),
                                      width: 875.w,
                                      height: 160.h,
                                      margin: new EdgeInsets.only(bottom: 20.h),
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
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                        Container(
                                          padding: EdgeInsets.only(top: 10.h , bottom: 10.h),
                                                                      // width: MediaQuery.of(context)
                                                                      //         .size
                                                                      //         .width *
                                                                      //     .20,
                                                                      // height: 20.0,
                                                                      decoration: new BoxDecoration(
                                                                        shape: BoxShape.rectangle,
                                                                        color:
                                                                            const Color(0xFFFFFF),
                                                                        borderRadius:
                                                                            new BorderRadius.all(
                                                                                new Radius.circular(
                                                                                    32.0)),
                                                                      ),
                                                                      child: Center(
                                                                        child: RatingBarIndicator(
                                                                          rating: reviews[index]
                                                                              ['rate'],
                                                                          itemSize: 22,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          itemCount: 5,
                                                                          itemPadding:
                                                                              EdgeInsets.symmetric(
                                                                                  horizontal: 0),
                                                                          itemBuilder:
                                                                              (context, _) => Icon(
                                                                            Icons.star,
                                                                            color: Colors.amber,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                               
                                                                    Text(formattedDate(
                                                            reviews[index]['date']),
                                                            style: TextStyle(
                                                              color: Color(0xff555555),
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                          ]),

                                          SizedBox(width: 20.w,),
                                                           
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                  parentName,
                                                  style: TextStyle(
                                                       color: Color(0xff4e4a8c),
                                                      fontSize: 22.sp,
                                                      fontWeight: FontWeight.bold,
                                                     // height: 1.5.h,
                                                  ),
                                              ),
                                      SizedBox(height: 10.h,),

                                              Text(
                                                  "${reviews[index]['review']}",
                                                  style: TextStyle(
                                                       color: Colors.black,
                                                      fontSize: 16.sp,
                                                      height: 1.5.h,
                                                  ),
                                                  textAlign: TextAlign.right,
                                              ),
                                      
                                      
                                      
                                        ]),
                                      ),
                                                               
                                         ],
                                      )
                                      , 
                                                          );
                                  } else {
                      return Container();
                                  }
                                  }
                                );
///////////////////////////////////////
                           
                           },
                        );
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
                //     // FirebaseFirestore.instance.collection("specialist").doc(applicant.docs.id).update({
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