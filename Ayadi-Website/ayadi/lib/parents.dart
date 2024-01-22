import 'package:ayadi/applicants.dart';
import 'package:ayadi/children.dart';
import 'package:ayadi/parents.dart';
import 'package:ayadi/specialists.dart';
import 'package:ayadi/welcome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:collection';
import 'package:ayadi/CV.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'adminHP.dart';




class parents extends StatefulWidget {

   const parents ({super.key});
    @override
  State<parents> createState() => _parentsState();
}

class _parentsState extends State<parents> {

  //final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance.collection("parent").snapshots();

    void deleted() async {
    AwesomeDialog(
      width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'تم حذف الحساب بنجاح',
      titleTextStyle: TextStyle(
                                        fontSize: 23,
                                    ),
      btnOkOnPress: () {},
    ).show();
  }




  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children:[

          Positioned.fill(
                  left: 1100.w,
                  top: 70.h,
                  child: SizedBox(
                    width: 171.w,
                    height: 28.h,
                    child: Text(
                      "الأباء",
                      style: TextStyle(
                        color: Color(0xff59567e),
                        fontSize: 30.sp,
                      ),
                    ),
                  ),
                ),

            //applicant name
            Positioned.fill(
              left: 1100.w,
              top: 160.h,
              child: SizedBox(
              width: 171.w,
              height: 28.h,
              child: Text(
                  "الاسم",
                  style: TextStyle(
                      color: Color(0xff59567e),
                      fontSize: 23.sp,
                  ),
              ),
              ),
            ),

            //phone number
            Positioned.fill(
              left: 780.w,
              top: 160.h,
              child: SizedBox(
              width: 171.w,
              height: 28.h,
              child: Text(
                  "رقم الهاتف",
                  style: TextStyle(
                      color: Color(0xff59567e),
                      fontSize: 23.sp,
                  ),
              ),
              ),
            ),


          //specialization
            Positioned.fill(
              left: 470.w,
              top: 160.h,
              child: SizedBox(
              width: 171.w,
              height: 28.h,
              child: Text(
                  "الأطفال",
                  style: TextStyle(
                      color: Color(0xff59567e),
                      fontSize: 23.sp,
                  ),
              ),
              ),
            ),

            
             

             //requests list
             Positioned.fill(
              left: 150.w,
              top: 200.h,
              right: 270.w,
              bottom: 50.h,
              child: Align(
                alignment: Alignment.topLeft,
                      child:
                      StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("parent").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final users = snapshot.data!;
                  //getChildrenNames
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 50.h),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: users.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String childrenName = "";
                      String parentphone = users.docs[index]['phone'];
                      
                    
                            return Container(
                            width: 875.w,
                            height: 90.h,
                            margin: new EdgeInsets.only(bottom: 20.h),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Color(0x4c000000), width: 1, ),
                            // boxShadow: [
                            //     BoxShadow(
                            //         color: Color(0x3f000000),
                            //         blurRadius: 4,
                            //         offset: Offset(0, 4),
                            //     ),
                            // ],
                            color: Colors.white,
                            ),
                                                
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                                
                                //buttons
                                //reject
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left:20.w , top: 12.h , bottom: 12.h),
                                      child:TextButton(
                                        onPressed: () =>  AwesomeDialog(
                                width: 550,
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                                        context:
                                                                            context,
                                                                        animType: AnimType
                                                                            .leftSlide,
                                                                        headerAnimationLoop:
                                                                            false,
                                                                        dialogType:
                                                                            DialogType
                                                                                .question,
                                                                        title:
                                                                            'هل انت متأكد من حذف هذا الأب؟',
                                                                            titleTextStyle: TextStyle(
                                              fontSize: 23,
                                          ),
                                                                        btnCancelOnPress:
                                                                            () {},
                                                                        btnOkOnPress:
                                                                            () {
                                                                            FirebaseFirestore.instance.collection("parent").doc(users.docs[index].id).delete();
                                                                            deleted();
                                                                           // Navigator.pop(context, 'YES');
                                                                        },
                                                                        btnOkText:
                                                                            "نعم",
                                                                        btnCancelText:
                                                                            "لا",
                                                                        btnCancelColor:
                                                                            Color(
                                                                                0xFF00CA71),
                                                                        btnOkColor: Color
                                                                            .fromARGB(
                                                                                255,
                                                                                211,
                                                                                59,
                                                                                42),
                                                                      ).show(),
                                                
                                          child: Text(
                                              "حذف",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.sp,
                                              ),
                                          ),
                                          style:  ButtonStyle(
                                              padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top:12.h, bottom:12.h , left:20.w , right: 20.w)),
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )
                                  )
                                ),
                                                            ),
                                    ),
                            
                                  ],
                                ),
                                                
                                  // SizedBox(
                                  //   // width: 163.w,
                                  //   // height: 28.h,
                                  //   child: Text(
                                  //       childrenName,
                                  //       style: TextStyle(
                                  //           color: Colors.black,
                                  //           fontSize: 20.sp,
                                  //       ),
                                  //   ),
                                  //                       ),                         
                                                
                                                                   TextButton(
                                    onPressed: () => showDialog(
                                    context:
                                   context,
                                    builder:
                                    (BuildContext
                                     context) {
                                      return children(parentPhone: users.docs[index]["phone"]);
                                     }) ,
                          
                                      child: Text(
                                      "استعراض",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                          ),
                                      ),
                                       style:  ButtonStyle(
                                        padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top:12, bottom:12 , left:30 , right: 30)),
                                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffdcd3e1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                            )
                          ),
                          
                                                        ),
                                  SizedBox(
                                    // width: 163.w,
                                    // height: 28.h,
                                    child: Text(
                                        "${users.docs[index]['phone']}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.sp,
                                        ),
                                    ),
                                                        ),
                                
                                                
                                                
                                 
                                                        Row(
                                                          children: [
                                                            Padding(
                                  padding: EdgeInsets.only(left:5.w , top: 0.h),
                                  child: SizedBox(
                                    width: 100.w,
                                     height: 50.h,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${users.docs[index]['Fname']} ${users.docs[index]['Lname']}",
                                          style: TextStyle(
                                               color: Colors.black,
                                              fontSize: 23.sp,
                                          ),
                                      ),
                                    ),
                                                            ),
                                ),
                                             
                                                
                                Padding(
                                  padding: EdgeInsets.only(right:8.w , top: 3.h , left: 10.w),
                                  child: Container(
                                      width: 37.w,
                                      height: 37.h,
                                      child: Image(
                                                      image: AssetImage('assets/images/parent.png')),
                                  ),
                                ),
                                                
                                  ],
                                                        ),
                                                
                                                
                              ],
                            )
                                            );

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

             

             
   Align(
              alignment: Alignment.topRight,
              child: Container(
                 width: 275.w,
                height: 982.h,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                color: Color(0xffd9d9d9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    // logo
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w , vertical: 10.h),
                                  child: Container(
                                    alignment: Alignment.topRight,
                                  width: 120.w,
                                  height: 95.h,
                                  child: Image(
                                      image: AssetImage('assets/images/AyadiLogo.png')),
                              ),
                                ),

                                // white line
                                Container(
    width: 275.w,
    height: 3.h,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2, ),
    ),
),

SizedBox(
height: 50.h,
),

// الصفحة الرئيسية 
TextButton(
  onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminHP()));
  },
  child:   Container(
  
      width: 220.w,
  
      height: 55.h,
  
      child: Row(
  mainAxisAlignment: MainAxisAlignment.end,
          children:[
  
              Align(
  
                 alignment: Alignment.centerLeft,
  
                  child: SizedBox(
  
                      width: 170.w,
  
                      height: 55.h,
  
                      child: Text(
  
                          "الصفحة الرئيسية",
  
                          style: TextStyle(
  
                              color: Color(0xff4e4a8c),
  
                              fontSize: 22.sp,
  
                          ),
  
                          textAlign: TextAlign.right,
  
                      ),
  
                  ),
  
              ),
  
          
  
           Align(
  
                  alignment: Alignment.centerRight,
  
                  child: Container(
  
                      width: 25.w,
  
                      height: 25.h,
  
                      child:Image(
                      image: AssetImage('assets/images/dashboardIcon.png'), color: Color(0xff59567e),),
  
                  ),
  
              ),
  
          
  
          ],
  
      ),
  
  ),
),
SizedBox(
height: 15.h,
),

                TextButton(
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => applicants()));
                          },
                          child:   Container(
  
      width: 220.w,
  
      height: 55.h,
  
      child: Row(
  mainAxisAlignment: MainAxisAlignment.end,
          children:[
  
              Align(
  
                 alignment: Alignment.centerLeft,
  
                  child: SizedBox(
  
                      width: 170.w,
  
                      height: 55.h,
   
                          child: 
                            Text(
                                  "طلبات التسجيل",
                                  style: TextStyle(
                                      color: Color(0xff4e4a8c),
                                      fontSize: 22.sp,
                                  ),
                                  textAlign: TextAlign.right,
                              ),
                              
                  ),
  
              ),
  
          
  
           Align(
  
                  alignment: Alignment.centerRight,
  
                  child: Container(
  
                      width: 25.w,
  
                      height: 25.h,
  
                      child:Image(
                      image: AssetImage('assets/images/request.png'), color: Color(0xff59567e),),
  
                  ),
  
              ),
  
          
  
          ],
  
      ),
  
  ),

                         
                    ),


                  SizedBox(
height: 15.h,
),
             

// الاخصائيين
TextButton(
  onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => specialists()));

  },
  child:   Container(
  
      width: 220.w,
  
      height: 55.h,
  
      //alignment: Alignment.topRight,
  
      child: Row(
  mainAxisAlignment: MainAxisAlignment.end,
          children:[
  
              Align(
  
                 alignment: Alignment.topLeft,
  
                  child: SizedBox(
  
                      width: 170.w,
  
                      height: 55.h,
  
                      child: Text(
  
                          "الأخصائيين",
  
                          style: TextStyle(
  
                              color: Color(0xff4e4a8c),
  
                              fontSize: 22.sp,
  
                          ),
  
                          textAlign: TextAlign.right,
  
                      ),
  
                  ),
  
              ),
  
          
  
           Align(
  
                  alignment: Alignment.centerRight,
  
                  child: Container(
  
                      width: 25.w,
  
                      height: 25.h,
  
                      child: Image(
                                                image: AssetImage('assets/images/specialist2.png'), color: Color(0xff59567e),),
  
                  ),
  
              ),
  
        
  
          ],
  
      ),
  
  ),
),

                  SizedBox(
height: 15.h,
),


// الآباء
Padding(
  padding: EdgeInsets.only(right: 10.w),
  child:   TextButton(
  
    onPressed: (){
  
         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => parents()));
  
  
  
    },
  
  
                        child: Text(
  
    
  
                            "الآباء",
  
    
  
                            style: TextStyle(
  
    
  
                                color: Color(0xff4e4a8c),
  
    
  
                                fontSize: 22.sp,
  
    
  
                            ),
  
    
  
                            textAlign: TextAlign.right,
  
    
  
                        ),
  
  
     style:  ButtonStyle(
  
                                            padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top:10, bottom:10, left:90 , right: 15)),
  
                                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xe5ffffff)),
  
                                            alignment: Alignment.center,
  
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  
                                  RoundedRectangleBorder(
  
                                    borderRadius: BorderRadius.circular(10.0),
  
                                  )
  
                                )
  
                              ),
  
    
  
                    ),
  
    
  
                ),
  
    
  
            
  
    

                  SizedBox(
height: 15.h,
),





SizedBox(
height: 320.h,
),
                                // white line
                                Container(
    width: 275.w,
    height: 3.h,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2, ),
    ),
),

SizedBox(
height: 20.h,
),


// تسجيل الخروج
TextButton(
  onPressed: () {
                        AwesomeDialog(
                          width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                                  context:
                                                                      context,
                                                                  animType: AnimType
                                                                      .leftSlide,
                                                                  headerAnimationLoop:
                                                                      false,
                                                                  dialogType:
                                                                      DialogType
                                                                          .question,
                                                                  title:
                                                                      'هل أنت متأكد من تسجيل الخروج؟',
                                                                      titleTextStyle: TextStyle(
                                        fontSize: 23,
                                    ),
                                                                  btnCancelOnPress:
                                                                      () {},
                                                                  btnOkOnPress:
                                                                      () {
                                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => welcome()));
                                                                  },
                                                                  btnOkText:
                                                                      "نعم",
                                                                  btnCancelText:
                                                                      "لا",
                                                                  btnCancelColor:
                                                                      Color(
                                                                          0xFF00CA71),
                                                                  btnOkColor: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          211,
                                                                          59,
                                                                          42),
                                                                ).show();
                    
                    },
  child:   Container(
  
      //width: 210.w,
  
      height: 55.h,
  
      //alignment: Alignment.topRight,
  
      child: Row(
  mainAxisAlignment: MainAxisAlignment.end,
          children:[
  
            Align(
  
                 alignment: Alignment.topLeft,
  
                  child: SizedBox(
  
                      width: 170.w,
  
                      height: 55.h,
  
                      child: Text(
  
                          "تسجيل الخروج",
  
                          style: TextStyle(
  
                              color: Color(0xff4e4a8c),
  
                              fontSize: 22.sp,
  
                          ),
  
                          textAlign: TextAlign.right,
  
                      ),
  
                  ),
  
              ),
  
          
  
          Align(
  
                  alignment: Alignment.centerRight,
  
                  child: Container(
  
                      width: 35.w,
  
                      height: 35.h,
  
                      child: Image(
                                                image: AssetImage('assets/images/logout.png')),
  
                  ),
  
              ),
  
          
  
          ],
  
      ),
  
  ),
),


SizedBox(
height: 20.h,
),


SizedBox(
height: 20.h,
),


                  ],
                  ),
              ),
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