import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:hello_projekt/mathequiz.dart';
//import 'package:hello_projekt/plus.dart';
//import 'package:hello_projekt/mixedexercises.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_quiz/mixedexercises.dart';
import 'package:math_quiz/plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'highscores.dart';
import 'minus.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'highscores.dart';
//import 'package:hello_projekt/highscores.dart';
//import 'minus.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuswahlScreen(),
      theme: ThemeData(
        canvasColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.pinkAccent,
        brightness: Brightness.dark,
      ),
    ));

Widget mycard(
    context, int gameTime, String imagePfad, String beschreibung, int goal) {
  return Card(
    borderOnForeground: true,
    color: Colors.grey,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(width: 0, color: Colors.white)),
    child: RaisedButton(
      color: Colors.black,
      onPressed: () {
        if (goal == 1) {
          //mixedExercises
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MySpieleApp(spieldauer: gameTime)));
        } else if (goal == 2) {
          //Addition
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  PlusScreen(spieldauer: gameTime)));
        } else if (goal == 3) {
          //Subtraktion
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MinusScreen(spieldauer: gameTime)));
        } else if (goal == 4) {
          //Mathequiz
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MinusScreen(spieldauer: 60)));
        }
      },
      child: Container(
        /*  decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.indigo, blurRadius: 500.0)]),*/
        height: 130,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                margin: EdgeInsets.only(right: 50),
                height: 50,
                width: 50,
                child: Image(
                  image: AssetImage(imagePfad),
                ),
              ),
            ),
            Text(
              beschreibung,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

class MyMatheQuiz {}

class AuswahlScreen extends StatefulWidget {
  final int highscore, highscorePlus, highscoreMinus, highscoreQuiz;

  /*Standartkonstruktor Auswahlscreen() erweitern mit dem named arguments 
    {'this.highscore,
      this.highscorePlus,
      this.highscoreMinus,
      this.highscoreQuiz}*/
  AuswahlScreen(
      {Key key,
      this.highscore,
      this.highscorePlus,
      this.highscoreMinus,
      this.highscoreQuiz});
  @override
  _AuswahlScreenState createState() => _AuswahlScreenState();
}

class _AuswahlScreenState extends State<AuswahlScreen> {
  int highscore = 0;
  int highscorePlus = 0;
  int highscoreMinus = 0;
  int highscoreQuiz = 0;

  @override
  void initState() {
    super.initState();
    loadHighscore();
  }

  ///Highscores werden aus sharedPreferences abgerufen
  loadHighscore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highscore = (prefs.getInt('highscore') ??
          0); //wenn prefs.getInt('highscore') != null ist, dann wird er highscore zugewiesen, ansonsten wird 0 dem highscore zugewiesen
      highscorePlus = (prefs.getInt('highscorePlus') ?? 0);
      highscoreMinus = (prefs.getInt('highscoreMinus') ?? 0);
      highscoreQuiz = (prefs.getInt('highscoreQuiz') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Logo(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.orange,
          margin: EdgeInsets.only(top: 72),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Highscores(
                        highscore: highscore,
                        highscorePlus: highscorePlus,
                        highscoreMinus: highscoreMinus,
                        highscoreQuiz: highscoreQuiz,
                      )));
            },
            title: Text(
              'Higscores',
              style: TextStyle(fontSize: 22.5),
            ),
          ),
        ),
        elevation: 200,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24),
        child: ListView(
          children: <Widget>[
            mycard(context, 60, 'assets/images/taschenrechner2.png',
                '    MIXED EXERCISES  \n\n    Gametime 60 seconds! ', 1),
            mycard(context, 60, 'assets/images/plus.png',
                '    ADDITION  \n\n    Gametime 60 seconds! ', 2),
            mycard(context, 60, 'assets/images/minus.png',
                '   SUBTRACTION  \n\n   Gametime 60 seconds! ', 3),
            mycard(context, 120, 'assets/images/fragezeichen.png',
                '    MATH QUIZ   \n\n   Gametime 120 seconds! ', 4),
          ],
        ),
      ),
    );
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
          style: GoogleFonts.pacifico(fontSize: 20.0, color: Colors.white),
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
