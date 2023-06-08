import 'package:flutter/material.dart';
import 'package:super_project/pages/pass_pin.dart';
import 'pages/home.dart';
import 'pages/pass_manager.dart';
import 'pages/timeline.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: "/timeline",
    routes: {
      '/': (context) => Home(),
      '/passManager': (context) => PassManager(),
      '/passPin': (context) => PassPin(),
      '/timeline': (context) => Timeline()
    },
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.orange[600],
      primaryColorDark: Colors.red,
      // primaryTextTheme: TextTheme(bodyText1: TextStyle(color: )),
      primaryColorLight: Colors.orange[100],
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.indigo, // Your accent color
      ),
    ),
    darkTheme: ThemeData(
      primaryColor: Colors.black,
      brightness: Brightness.dark
    ),
    themeMode: ThemeMode.light,
  ));
}

