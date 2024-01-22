import 'package:ayadi/adminHP.dart';
import 'package:ayadi/parents.dart';
import 'package:ayadi/reviews.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:collection';
import 'package:ayadi/CV.dart';
import 'package:ayadi/welcome.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'applicants.dart';




class specialists extends StatefulWidget {

   const specialists ({super.key});
    @override
  State<specialists> createState() => _specialistsState();
}

class _specialistsState extends State<specialists> {

  final Stream<QuerySnapshot> readRequest = FirebaseFirestore.instance.collection("specialist").where('status', isEqualTo: true).snapshots();

    void deleted() async {
    AwesomeDialog(
      width: 550,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      title: 'تم حذف حساب هذا الاخصائي بنجاح',
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
          children: [

            // right menu
         

          //   //applicant name
          //   Positioned.fill(
          //     left: 1040.w,
          //     top: 160.h,
          //     child: SizedBox(
          //     width: 171.w,
          //     height: 28.h,
          //     child: Text(
          //         "اسم الأخصائي",
          //         style: TextStyle(
          //             color: Color(0xff59567e),
          //             fontSize: 23.sp,
          //         ),
          //     ),
          //     ),
          //   ),

          //   //phone number
          //   Positioned.fill(
          //     left: 860.w,
          //     top: 160.h,
          //     child: SizedBox(
          //     width: 171.w,
          //     height: 28.h,
          //     child: Text(
          //         "رقم الهاتف",
          //         style: TextStyle(
          //             color: Color(0xff59567e),
          //             fontSize: 23.sp,
          //         ),
          //     ),
          //     ),
          //   ),


          // //specialization
          //   Positioned.fill(
          //     left: 675.w,
          //     top: 160.h,
          //     child: SizedBox(
          //     width: 171.w,
          //     height: 28.h,
          //     child: Text(
          //         "التخصص",
          //         style: TextStyle(
          //             color: Color(0xff59567e),
          //             fontSize: 23.sp,
          //         ),
          //     ),
          //     ),
          //   ),

          //   //cv
          //   Positioned.fill(
          //     left: 455.w,
          //     top: 160.h,
          //     child: SizedBox(
          //     width: 171.w,
          //     height: 28.h,
          //     child: Text(
          //         "السيرة الذاتية",
          //         style: TextStyle(
          //             color: Color(0xff59567e),
          //             fontSize: 23.sp,
          //         ),
          //     ),
          //     ),
          //   ),

             
                                         Positioned.fill(
                  left: 1000.w,
                  top: 70.h,
                  child: SizedBox(
                    width: 171.w,
                    height: 28.h,
                    child: Text(
                      " الأخصائيين",
                      style: TextStyle(
                        color: Color(0xff59567e),
                        fontSize: 30.sp,
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
                stream: readRequest,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData){
                  final users = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 50.h),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: users.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String CVviewed = "";
                      return Container(
                      width: 875.w,
                      height: 200.h,
                      margin: new EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0x4c000000), width: 1, ),
                      color: Colors.white,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                       // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          //buttons
                          //reject
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                               // SizedBox(width: 5.h),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                          
                                          Container(
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
                                                            rating: users.docs[index]
                                                                ['avgRate'],
                                                            itemSize: 20,
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
                                                
                                                SizedBox(width: 5.w,),
                                                
                                                Text(
                                                        users.docs[index]['avgRate']
                                                            .toStringAsFixed(1),
                                                        style: TextStyle(
                                                          color: Color(0xff4e4a8c),
                                                          fontSize: 25.sp,
                                                          fontFamily: 'Alice',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                          
                                      ],
                          
                                    ),
                          
                              Padding(
                              padding: EdgeInsets.only(left:5.w , top: 0.h),
                              child: SizedBox(
                                            child: 
                                            Text(
                                                "${users.docs[index]['bio']}",
                                                style: TextStyle(
                                                     color: Colors.black,
                                                    fontSize: 16.sp,
                                                    height: 2.0.h,
                                                ),
                                                textAlign: TextAlign.right,
                                            ),
                                                                ),
                            ),
                                  ],
                                ),
                          
                                                  Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                // Padding(
                                //   padding: EdgeInsets.only(left:20.w , top: 12.h , bottom: 12.h),
                                //  child:
                          
                                TextButton(
                                    onPressed: () =>  AwesomeDialog(
                            width: 550.sp,
                                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
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
                                                                        'هل انت متأكد من حذف حساب هذا الاخصائي؟',
                                                                        titleTextStyle: TextStyle(
                                          fontSize: 23.sp,
                                      ),
                                                                    btnCancelOnPress:
                                                                        () {},
                                                                    btnOkOnPress:
                                                                        () {
                                                                        FirebaseFirestore.instance.collection("specialist").doc(users.docs[index].id).delete();
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
                                          "حذف الاخصائي",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                          ),
                                      ),
                                      style:  ButtonStyle(
                                        padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top:12.h, bottom:12.h , left:20.h , right: 20.h)),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                            )
                          ),
                           ),
                          SizedBox(width: 180.w,),
                          
                                                              Row(
                                                                children: [
                                                                                             TextButton(
                                    onPressed: () =>  showDialog(
                                    context:
                                   context,
                                    builder:
                                    (BuildContext
                                     context) {
                                      return CV(applicant: users.docs[index]);

                                     }),
                                      child: Text(
                                          "عرض السيرة الذاتية",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                          ),
                                      ),
                                                                          style:  ButtonStyle(
                                        padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top:12, bottom:12 , left:20 , right: 20)),
                                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffdcd3e1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                            )
                          ),
                                                        ),
                          
                                                        SizedBox(width: 15.w,),
                          

                                  TextButton(
                                    onPressed: () => showDialog(
                                    context:
                                   context,
                                    builder:
                                    (BuildContext
                                     context) {
                                      return reviews(specialist: users.docs[index]["phoneNumber"]);

                                     }) ,
                          
                                      child: Text(
                                          "عرض جميع التقييمات",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                          ),
                                      ),
                                       style:  ButtonStyle(
                                        padding:  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top:12, bottom:12 , left:20 , right: 20)),
                                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffdcd3e1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                            )
                          ),
                          
                                                        ),
                              //  ),
                                                                ],
                                                              ),
                          
                                      ],
                          
                          
                                      
                                    ),
                          SizedBox(width: 15.h),
                          
                                  ],
                                ),
                          ),

                              SizedBox(
                                width: 50.sp,
                              ),



                           SizedBox(
                            width: MediaQuery.of(context).size.width*0.19,
                             child: Column(
                             // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children:[
                                        //name
                                 
                              Text(
                                    "${users.docs[index]['Fname']} ${users.docs[index]['Lname']}",
                                    style: TextStyle(
                                         color: Color(0xff4e4a8c),
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold,
                                       // height: 1.5.h,
                                    ),
                                ),
                                                    
                                      //specialization
                              Padding(
                              padding: EdgeInsets.only(left:5.w),
                              
                                child: Text(
                                    "${users.docs[index]['specialization']}",
                                    style: TextStyle(
                                         color: Colors.black,
                                        fontSize: 15.sp,
                                        height: 1.0.h,
                                    ),
                                ),
                                                    
                                                     ),
                           
                                      ],
                                    ),
                                    // photo
                           
                              Container(
                                  width: 50.w,
                                  height: 50.h,
                                  child: Image(
                                                  image: AssetImage('assets/images/specialist2.png'), color: Color(0xff59567e),),
                              ),
                                                     
                           
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //reviews num
                                    // SizedBox(
                                    //           width: 263.w,
                                    //           height: 28.h,
                                     //         child: 
                                      Text(
                                                "تقييم",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                           
                                              SizedBox(width: 5.w),
                           
                                              Text(
                                                "${users.docs[index]['numOfRates']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                //            ),
                                //SizedBox(width: 20.w),
                                // Text(
                                //                 "تقييم",
                                //                 style: TextStyle(
                                //                   color: Colors.black,
                                //                   fontSize: 16.sp,
                                //                 ),
                                //               ), 
                           
                                //               SizedBox(width: 5.w),
                                              
                                // Text(
                                //                 "${users.docs[index]['numOfRates']}",
                                //                 style: TextStyle(
                                //                   color: Colors.black,
                                //                   fontSize: 16.sp,
                                //                 ),
                                //               ),
                                              SizedBox(width: 15.w),
                                    // sessions num
                                  ],
                                ),
                                //phone number
                                                  //   SizedBox(
                                // width: 163.w,
                                // height: 28.h,
                              //  child:
                                 Padding(
                                   padding: EdgeInsets.only(right: 15.w),
                                   child: Text(
                                      "رقم التواصل: ${users.docs[index]['phoneNumber']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                      ),
                                                               ),
                                 ),
                           
                                 Padding(
                                   padding: EdgeInsets.only(right: 15.w),
                                   child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                     child: Text(
                                       "${users.docs[index]['IBAN']}"+ " :"+"رقم الآيبان",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                        ),
                                                                 ),
                                   ),
                                 ),
                                            //        ),
                              ],
                             ),
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
Padding(
  padding: EdgeInsets.only(right: 10.w),
  child:   TextButton(
  
    onPressed: (){},
  
        //alignment: Alignment.topRight,
  
                        child: Text(

  
                            "الأخصائيين",
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


// الآباء
TextButton(
  onPressed: (){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => parents()));
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
  
                          "الآباء",
  
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
                                                image: AssetImage('assets/images/parent.png'),color: Color(0xff59567e),),
  
                  ),
  
              ),
  
          
  
          ],
  
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
                        color: Color(0xff9366ad),
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