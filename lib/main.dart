import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/pass_manager.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      '/': (context) => Home(),
      '/passManager': (context) => PassManager()
    },
  ));
}

