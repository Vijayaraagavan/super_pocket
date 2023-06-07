import 'package:flutter/material.dart';
import 'package:super_project/pages/pass_pin.dart';
import 'pages/home.dart';
import 'pages/pass_manager.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      '/': (context) => Home(),
      '/passManager': (context) => PassManager(),
      '/passPin': (context) => PassPin()
    },
  ));
}

