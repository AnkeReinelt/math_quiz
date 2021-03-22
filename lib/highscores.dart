import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_quiz/auswahlscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Highscores extends StatefulWidget {
  final int highscore;
  final int highscorePlus;
  final int highscoreMinus;
  final int highscoreQuiz;
  //Standartkonstruktor Gameover() erweitern mit dem named argument '{this.punktestand}'
  Highscores(
      {Key key,
      this.highscore,
      this.highscoreMinus,
      this.highscorePlus,
      this.highscoreQuiz});
  @override
  _HighscoresState createState() => _HighscoresState();
}

class _HighscoresState extends State<Highscores> {
  ///Highscore wird geladen
  loadHighscore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var highscore = (prefs.getInt('highscore') ??
          0); //wenn prefs.getInt('highscore') != null ist, dann wird er highscore zugewiesen, ansonsten wird 0 dem highscore zugewiesen

      var highscorePlus = (prefs.getInt('highscorePlus') ?? 0);
      var highscoreMinus = (prefs.getInt('highscoreMinus') ?? 0);
      var highscoreQuiz = (prefs.getInt('highscoreQuiz') ?? 0);
    });
  }

  @override
  void initState() {
    super.initState();
    loadHighscore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AuswahlScreen()));
          },
        ),
        //  title: Logo()
      ),
      body: Container(
        margin: EdgeInsets.only(top: 0, left: 42),
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                  text: 'Highscor',
                  style: GoogleFonts.pacifico(
                    fontSize: 40.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'e',
                        style: TextStyle(
                            color: _getColorFromHex('#F9AB12'), //orange
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 's',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 32),
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Container(
                      margin: EdgeInsets.only(top: 4, left: 24),
                      child: Image(
                          image:
                              AssetImage('assets/images/taschenrechner2.png')),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 0, left: 24),
                      child: Text(
                        'Mixed Exercises:   ${widget.highscore}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Container(
                    margin: EdgeInsets.only(top: 4, left: 24),
                    child: Image(image: AssetImage('assets/images/plus.png')),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 0, left: 24),
                    child: Text(
                      'Addition:                  ${widget.highscorePlus}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Container(
                    margin: EdgeInsets.only(top: 4, left: 24),
                    child: Image(image: AssetImage('assets/images/minus.png')),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 0, left: 24),
                    child: Text(
                      'Subtraction:             ${widget.highscoreMinus}',
                      //'Mixed Exercises: ${widget.highscore}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Container(
                    margin: EdgeInsets.only(top: 4, left: 24),
                    child: Image(
                        image: AssetImage('assets/images/fragezeichen.png')),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 0, left: 24),
                    child: Text(
                      'Math Quiz:               ${widget.highscoreQuiz}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ],
            ),
          ],
        ),
        //child: Text('Highscores auf dem Screem'),
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
