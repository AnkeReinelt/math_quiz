import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:math_quiz/gameover.dart';
import 'dart:math' as math;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MaterialApp(
    home: MinusScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      canvasColor: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      accentColor: Colors.pinkAccent,
      brightness: Brightness.dark,
    )));

class MinusScreen extends StatefulWidget {
  final int spieldauer;

  //Standartkonstruktor MinusScreen() erweitern mit dem named argument '{this.spieldauer}'
  MinusScreen({Key key, this.spieldauer});
  @override
  _MinusScreenState createState() => _MinusScreenState();
}

class _MinusScreenState extends State<MinusScreen>
    with TickerProviderStateMixin {
  ///Zeitverzögerte Methode, welche nach Ablauf der Spieldauer zum GameOver() Screen navigiert
  Future gameOver(BuildContext context) async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Future.delayed(Duration(seconds: widget.spieldauer), () {
      if (openGameOverScreenAfterTime == true) {
        setHigscore();
        //nur wenn vorher keine falsche Lösung angeklickt wurde, wird nach Ablauf der Zeit der GameOver() Screen geöffnet
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Gameover(
                  score: punktestand,
                  highscore: highscoreMinus,
                  imagePfad: 'assets/images/minus.png',
                )));
      }
    });
  }

  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String resultString = '';
  String wrongResult1String = '';
  String wrongResult2String = '';

  int zahl1,
      zahl2,
      zahl3,
      result,
      random,
      random2,
      wrongResult1,
      wrongResult2,
      but1,
      but2,
      but3;
  String operatorString = '';
  String myAufgabentext = '';
  int punktestand = 0;
  int highscoreMinus = 0;

  bool isPlaying = false;
  bool visibility = false;
  bool visibilityTimer = false;
  bool visibiltiyPlayButton = true;
  bool visibilityZonk = false;
  bool openGameOverScreenAfterTime = true;

  ///Falls die Antwort richtig ist, wird der punktestand um eins erhöht
  ///und der Countdown neu gestartet.
  ///Falls die Antwort falsch ist, wird alles ausgeblendet und nach 2 Sekunden
  ///wird zum GameOver() Screen navigiert.
  checkAnswer(int answer, int result) async {
    setState(() {
      if (answer == result) {
        punktestand++;

        //Countdown wird neu gestartet
        /*  controller.value = 1;
        controller.reverse(
            from: controller.value == 0.0 ? 1.0 : controller.value);*/
      } else {
        setHigscore();
        visibilityTimer = false;
        visibility = false;
        visibilityZonk = true;
        Timer(Duration(seconds: 2), goToGameOver);
        openGameOverScreenAfterTime =
            false; //wird auf false gesetzt, damit der GameOver() Screen nicht mehr über die gameOver() Methode geöffnet wird
      }
    });
  }

  void goToGameOver() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => Gameover(
              score: punktestand,
              highscore: highscoreMinus,
              imagePfad: 'assets/images/minus.png',
            )));
  }

  /// Methode, welche den neuen Highscore festlegt.
  void setHigscore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (punktestand > highscoreMinus) {
        highscoreMinus = punktestand;
        prefs.setInt('highscoreMinus', highscoreMinus);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadHighscore();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.spieldauer),
    );
  }

  loadHighscore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highscoreMinus = (prefs.getInt('highscoreMinus') ??
          0); //wenn prefs.getInt('highscore') != null ist, dann wird er highscore zugewiesen, ansonsten wird 0 dem highscore zugewiesen
    });
  }

  // Methode zum Ändern Zufallszahlen
  void changeNumbers() {
    Random rg = new Random();
    // per setState() dem Framework mitteilen, dass sich die Zufallszahlen ändern und
    // diese Zahlen überall wo sie zum Einsatz kommen, geändert werden
    setState(() {
      zahl1 = rg.nextInt(200); //
      zahl2 = rg.nextInt(20);
      zahl3 = rg.nextInt(20);

      random = rg.nextInt(3);
      random2 = rg.nextInt(5);

      result = zahl1 - zahl2;
      resultString = result.toString();
      myAufgabentext = '$zahl1 - $zahl2 = ?';

      wrongResult1 = result +
          rg.nextInt(20) +
          1; //um sicherzustellen, dass zahl3 != zahl1 und zahl3 != zahl2
      wrongResult2 = result - rg.nextInt(20) - 1;

      if (random == 0) {
        but1 = result; //korrekte Lösung kommt auf Button1
        but2 = wrongResult1;
        but3 = wrongResult2;
      } else if (random == 1) {
        but1 = wrongResult2;
        but2 = result; //korrekte Lösung kommt auf Button2
        but3 = wrongResult1;
      } else if (random == 2) {
        but1 = wrongResult1;
        but2 = wrongResult2;
        but3 = result; //korrekte Lösung kommt auf Button3
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    //  title: Text(
                    //  'Mathgenius',
                    //  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    //‚‚ ),
                    elevation: 100,
                    content: Text(
                      'You can\'t go back',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'))
                    ],
                  ));
        },
        child: Scaffold(
          /*  appBar: AppBar(
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.more_vert), onPressed: null),
            //  title: Logo(),
            backgroundColor: Colors.transparent,
          ),*/
          body: ListView(children: [
            Column(
              children: <Widget>[
                Visibility(
                  visible: visibilityZonk,
                  child: Container(
                    child: Image(image: AssetImage('assets/images/zonk.png')),
                  ),
                ),
                Visibility(
                  visible: visibility,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    alignment: Alignment.center,
                    //   color: Colors.red,
                    margin: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: Text(
                      myAufgabentext,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Visibility(
                  visible: visibility,
                  child: Container(
                    //Button1

                    margin: const EdgeInsets.only(
                      top: 30,
                    ),

                    child: SizedBox(
                      width: 320,
                      height: 64,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        splashColor: Colors.black,
                        color: Colors.indigo[400],
                        onPressed: () {
                          checkAnswer(but1,
                              result); //bei korrekter Antwort wird 1 dazuaddiert

                          changeNumbers();
                        },
                        child: Text(
                          '$but1',
                          style: TextStyle(
                              fontSize: 22.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: visibility,
                  child: Container(
                    //Button2

                    margin: const EdgeInsets.only(
                      top: 10,
                    ),

                    child: SizedBox(
                      width: 320,
                      height: 64,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        splashColor: Colors.black,
                        color: Colors.indigo[400],
                        onPressed: () {
                          checkAnswer(but2, result);

                          changeNumbers();
                        },
                        child: Text(
                          '$but2',
                          style: TextStyle(
                              fontSize: 22.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: visibility,
                  child: Container(
                    //Button3

                    margin: const EdgeInsets.only(
                      top: 10,
                    ),

                    child: SizedBox(
                      width: 320,
                      height: 64,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        splashColor: Colors.black,
                        color: Colors.indigo[400],
                        onPressed: () {
                          checkAnswer(but3, result);

                          changeNumbers();
                        },
                        child: Text(
                          '$but3',
                          style: TextStyle(
                              fontSize: 22.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: visibility,
                  child: Container(
                    //Punktestand -> erreichte Punktzahl / maximal erreichbare Punktzahl
                    margin: const EdgeInsets.only(
                      top: 30,
                    ),

                    child: Text(
                      'Score: $punktestand',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Visibility(
                  visible: visibilityTimer,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.topCenter,
                    //   color: Colors.green,
                    margin: const EdgeInsets.only(
                      top: 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 180,
                          height: 150,
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Align(
                              //der lilane dynamische Kreis wird ausgerichtet (aligned)
                              alignment: FractionalOffset.center,
                              child: AspectRatio(
                                aspectRatio: 1.0, // Winkel des pinken Kreises
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: AnimatedBuilder(
                                        animation: controller,
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return CustomPaint(
                                              painter: TimerPainter(
                                            animation: controller,
                                            backgroundColor: Colors.white,
                                            color: _getColorFromHex(
                                                '#A901DB'), //magenta,
                                          ));
                                        },
                                      ),
                                    ),
                                    Align(
                                      //der Timerstring wird ausgerichtet
                                      alignment: FractionalOffset.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          AnimatedBuilder(
                                              animation: controller,
                                              builder: (BuildContext context,
                                                  Widget child) {
                                                return Text(timerString,
                                                    style: TextStyle(
                                                        fontSize: 20));
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: visibiltiyPlayButton,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 170,
                    ),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.indigo[400],
                      elevation: 100,

                      // color: _getColorFromHex('#757575'), //grau
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (BuildContext context, Widget child) {
                          return Text(
                            'Start Game',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      onPressed: () {
                        visibility = true;
                        visibilityTimer = true;
                        visibiltiyPlayButton = false;
                        changeNumbers();
                        setState(() => isPlaying = !isPlaying);

                        if (!controller.isAnimating) {
                          controller.reverse(
                              from: controller.value == 0.0
                                  ? 1.0
                                  : controller.value);
                          gameOver(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}

class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: 'Mathgeni',
          style: GoogleFonts.pacifico(
            fontSize: 20.0,
          ),
          children: <TextSpan>[
            TextSpan(
                text: 'u',
                style: TextStyle(
                    color: _getColorFromHex('#F9AB12'), //orange
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: 's !',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
    );
  }
}

///Methode, um HTML Farbencode umzuwandeln
Color _getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
}

//VERWENDETE FARBEN
// color: _getColorFromHex('#F9AB12'), //orange
//  color: _getColorFromHex('#757575'), //grau
// color: _getColorFromHex('#4000FF'), blau
// color: _getColorFromHex('#A901DB'), //magenta

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2,
        paint); //der weiße circle dadrunter
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
