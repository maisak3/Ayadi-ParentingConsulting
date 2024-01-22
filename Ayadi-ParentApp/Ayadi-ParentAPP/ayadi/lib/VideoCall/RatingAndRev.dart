import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_dialog/rating_dialog.dart';

final _firestore = FirebaseFirestore.instance;

Future<void> addRating(double rating, String rev, dynamic session) async {
  print(session["specialistPhone"]);
  final sessionDocRef = _firestore.collection('sessions').doc(session.id);

  await sessionDocRef.update({'rate': rating, 'review': rev});

  final specialistCollectionRef = _firestore.collection('specialist');

  //final sessionSnapshot = await sessionDocRef.get();
  final specialistPhoneNumber = session["specialistPhone"];

  final specialistQuerySnapshot = await specialistCollectionRef
      .where('phoneNumber', isEqualTo: session["specialistPhone"])
      .get();

  if (specialistQuerySnapshot.docs.isNotEmpty) {
    print("specialist found");
    final specialistDocRef = specialistQuerySnapshot.docs.first.reference;
    final specialistSnapshot = await specialistDocRef.get();

    final currentAverageRating = specialistSnapshot.data()!['avgRate'] ?? 0.0;
    final currentNumRatings = specialistSnapshot.data()!['numOfRates'] ?? 0;

    print("current num rate: $currentNumRatings");
    print("current avg rate: $currentAverageRating");

    // Calculate the new average rating and number of ratings
    final totalRating = currentAverageRating * currentNumRatings;
    final newNumRatings = currentNumRatings + 1;
    double newAverageRating = (totalRating + rating) / newNumRatings;
    newAverageRating = double.parse(newAverageRating.toStringAsFixed(2));

    // Update the specialist document with the new average rating and number of ratings
    await specialistDocRef.update({
      'avgRate': newAverageRating,
      'numOfRates': newNumRatings,
    });
  }
}

final TextEditingController messageTextController = TextEditingController();
final messageformKey = GlobalKey<FormState>();

showRateDialog(BuildContext context, dynamic session) {
  double rating = 0;
  String rev = "";
  AwesomeDialog(
    context: context,
    animType: AnimType.leftSlide,
    customHeader: Image.asset('assets/star-10.png'),
    body: Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
      child: Column(
        children: [
          Text(
            "تم الانتهاء من الجلسة",
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF914BB9),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "كيف تقيم تجربتك مع الأخصائي؟",
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
              //fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              width: MediaQuery.of(context).size.width * .90,
              height: 30.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) =>
                        Image.asset('assets/star-9.png'),
                    onRatingUpdate: (value) {
                      rating = value;
                    },
                  ),
                ),
              )),
          SizedBox(
            height: 40,
          ),
          Text(
            "اترك لنا مراجعة عن تجربتك",
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
              //fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0x7fd9d9d9),
              ),
              child: Form(
                key: messageformKey,
                child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.end,
                    cursorColor: Color(0xFF914BB9),
                    controller: messageTextController,
                    maxLength: 150,
                    maxLines: 4,
                    onChanged: (value) {
                      rev = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      hintText: 'اكتب شيئًا',
                      border: InputBorder.none,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z\u0621-\u064A\\s]+")),
                    ]),
              ),
            ),
          ),
        ],
      ),
    ),
    showCloseIcon: true,
    btnOkText: "ارسال",
    btnOkColor: Color.fromRGBO(217, 204, 225, 1),
    buttonsBorderRadius: BorderRadius.circular(5),
    buttonsTextStyle: GoogleFonts.vazirmatn(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color(0xFF914BB9),
    ),
    btnOkOnPress: () async {
      await addRating(rating, rev, session);
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        title: 'تم الارسال بنجاح',
        btnOkOnPress: () {},
      ).show();
    },
  ).show();
}
