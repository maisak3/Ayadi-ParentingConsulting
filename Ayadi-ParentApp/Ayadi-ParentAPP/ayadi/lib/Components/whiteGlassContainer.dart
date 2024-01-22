import 'dart:ui';
import 'package:ayadi/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class whiteGlassContainer extends StatelessWidget {
  const whiteGlassContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        width: 400,
        height: 790,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(235, 223, 201, 242).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          //color: Color.fromARGB(255, 172, 15, 15),
        ),
        child: Stack(
          children: [
            //blur effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 15,
                sigmaY: 15,
              ),
              child: Container(),
            ),
            //gardient effect
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.2),
                      ])),
            ),
            //slide down indicator
            Positioned(
              left: 165,
              child: Container(
                height: 7,
                width: MediaQuery.of(context).size.width / 6,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 165, 124, 190),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.black26,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
