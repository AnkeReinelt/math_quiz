import 'package:flutter/material.dart';
import 'animationsscreen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimationScreen(),
      theme: ThemeData(
        canvasColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.indigo,
        brightness: Brightness.dark,
        // primaryColor: Colors.red,
      ),
      color: Colors.white,
    ));
