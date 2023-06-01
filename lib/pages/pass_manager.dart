import 'package:flutter/material.dart';

class PassManager extends StatefulWidget {
  const PassManager({Key? key}) : super(key: key);

  @override
  State<PassManager> createState() => _PassManagerState();
}

class _PassManagerState extends State<PassManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text('Password Manager')),
      ),
    );
  }
}
