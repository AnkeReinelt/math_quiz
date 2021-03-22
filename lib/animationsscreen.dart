import 'dart:async';
import 'package:flutter/material.dart';
import 'package:math_quiz/auswahlscreen.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class AnimationScreen extends StatefulWidget {
  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animController;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      //nach vier Sekunden gelangt man automatisch zum AuswahlScreen()
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AuswahlScreen(),
      ));
    });

    animController = AnimationController(
      duration:
          Duration(seconds: 3), //MatheQuiz - Logo dreht sich drei Sekunden
      vsync: this,
    );

    animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi, //Logo macht eine Umdrehung
    ).animate(animController)
      ..addListener(() {
        setState(() {});
      });
    animController.forward();
    // animController.fling(); -> geht schneller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 270.0, left: 110, right: 0),
              child: Transform.rotate(
                angle: animation.value,
                child: RichText(
                  text: TextSpan(
                      text: 'Mathgeni',
                      style: GoogleFonts.pacifico(
                          textStyle: TextStyle(color: Colors.white)),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'u',
                            style: TextStyle(
                                color: _getColorFromHex('#F9AB12'), //orange
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 's !',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ]),
                ),
              )),
        ],
      ),
    );
  }
}

///Methode, um HTML  Farbencode (zB #F9AB12) umzuwandeln
Color _getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", ""); //Raute wird entfernt
  if (hexColor.length == 6) {
    //wenn EingabeString eine Länge = 6  hat, dann wird FF davor eingefügt
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    // 0x wird vor hexColor eingefügt
    return Color(int.parse("0x$hexColor"));
  }
}
