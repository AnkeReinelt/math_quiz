import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:math_quiz/auswahlscreen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Gameover(),
      theme: ThemeData(
        canvasColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.grey, //magenta
        brightness: Brightness.dark,
      ),
    ));

class Gameover extends StatefulWidget {
  final int score;
  final int highscore;
  final String imagePfad;

  //Standartkonstruktor Gameover() erweitern
  Gameover({Key key, this.score, this.highscore, this.imagePfad});
  @override
  _GameoverState createState() => _GameoverState();
}

class _GameoverState extends State<Gameover> {
  Future<Album> futureAlbum;
  // final int score;
//  _GameoverState({this.score});

  //ressourcenschonender per 'Umweg' über initState()
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
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
          body: ListView(children: [
            Column(
                //  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(top: 50.0, left: 16, right: 0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Game Ov',
                          style: GoogleFonts.pacifico(
                              fontSize: 40.0, color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'e',
                                style: TextStyle(
                                    color: _getColorFromHex('#F9AB12'), //orange
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'r',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ]),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 50.0,
                    ),
                    child: Text('Your score ${widget.score}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ), //Your score
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Text('Highscore ${widget.highscore}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 50.0,
                      ),
                      child: Image(image: AssetImage(widget.imagePfad)),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: RaisedButton(
                      // color: _getColorFromHex('#A901DB'), //magenta
                      splashColor: Colors.indigo,
                      hoverColor: Colors.indigo,
                      color: Colors.indigo[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'Play Again',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AuswahlScreen()));
                      },
                    ),
                  ), //Play Again Button//Your best score
                  Container(
                      margin:
                          const EdgeInsets.only(top: 32, left: 90, right: 90),
                      child: Text(
                        'By the way...',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),

                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 90, right: 90),
                    child: FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        //Check ob bereits Daten vorliegen vom Future
                        if (snapshot.hasData) {
                          return Text(
                            '${snapshot.data.text}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ]),
          ]),
          /*‚  floatingActionButton: FloatingActionButton(
            elevation: 100,
            mini: true,
            onPressed: () => exit(0),
            child: Image(image: AssetImage('assets/images/close.png')),
          ),*/
        ));
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

///Future mit Rückgabe eines Album-Objekts fetchAlbum()
Future<Album> fetchAlbum() async {
  var response =
      await http.get(Uri.parse('http://numbersapi.com/random/trivia?json'));
  // Check, ob Serverantwort mit Status-Code 200 (OK)
  if (response.statusCode == 200) {
    // Album-Objekt erzeugen "dank" Daten aus dem JSON-Objekt(dekodiert)
    return Album.fromJson(jsonDecode(response.body)); // Kurzform
  } else {
    print('Error - Server lierert keine gültige Antwort');
  }
}

class Album {
/*
{
  "text": "6800 is the approximate number of languages in the world.",
  "number": 6800,
  "found": true,
  "type": "trivia"
}*/
  bool found;
  var number;
  String text, type;

  //Standardkonstruktor mit named parameters
  Album({this.text, this.number, this.found, this.type});

  //named construktor (factory fromJson(json))
  //Daten von JSON stehen also zur Übernahme als JSON Objekt (bzw als Map<String,dynamic> zur Verfügung)
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        text: json['text'],
        number: json['number'],
        found: json['found'],
        type: json['type']);
  }
}
