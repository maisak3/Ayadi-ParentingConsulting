import 'package:ayadi/applicants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:collection';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class CV extends StatefulWidget {
  final applicant;
  const CV({super.key, required this.applicant});

  @override
  State<CV> createState() => _CVState(applicant);
}

class _CVState extends State<CV> {
  final applicant;
  _CVState(this.applicant);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        //key: scaffoldkey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            width: 900.w,
            height: 850.h,
            color: Color.fromARGB(0, 255, 255, 255),
            //padding: EdgeInsets.all(10),
            child: Column(
              children:[
                Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                color: Color(0xffb9b4bc),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20) , topRight: Radius.circular(20)),
                ),
                child: SizedBox(
                            width: 900.w,
                             height: 90.h,
                            child: Text(
                                "السيرة الذاتية",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.sp,
                                ),
                            ),
                            ),
                ),
                SafeArea(
                  child: 
                  Container(
                    width: 900.w,
            height: 670.h,
            child: SfPdfViewer.network(
                                'https://firebasestorage.googleapis.com/v0/b/ayadi-49020.appspot.com/o/files%2FResume%20.pdf?alt=media&token=459bafcd-88ff-4046-8a01-08b4e9357213&_gl=1*cv0ry7*_ga*MTA2NjgzMTU4OC4xNjcwOTQ4ODM3*_ga_CW55HF8NVT*MTY4NjYzNDM0OS45MS4xLjE2ODY2MzQzODIuMC4wLjA.',onDocumentLoadFailed: (details) {
                                  print(details.description);
                                }, ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 90.h,
                  decoration: BoxDecoration(
                color: Color(0xffb9b4bc),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20) , bottomRight: Radius.circular(20)),
                ),

                child: TextButton(
                  onPressed: () {
                    // FirebaseFirestore.instance.collection("specialist").doc(applicant.docs.id).update({
                    //                                         'status':true,
                    //                                       });
                    Navigator.pop(context);
                  } ,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    height: 60.h,
                    width: 180.w,
                  decoration: BoxDecoration(
                color: Color(0xffe8dbf0),
                borderRadius: BorderRadius.circular(15),
                ),
                child: SizedBox(
                            width: 100.w,
                             height: 60.h,
                            child: Text(
                                "اغلاق",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:Color(0xff5e5a99),
                                    fontSize: 22.sp,
                                ),
                            ),
                            ),
                  )
                ,)
                ),

              ],
            )));
  }
}