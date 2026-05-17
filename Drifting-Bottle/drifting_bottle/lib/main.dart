import 'package:drifting_bottle/pages/bottle_capture.dart';
import 'package:drifting_bottle/pages/bottle_history.dart';
import 'package:drifting_bottle/pages/bottle_writes.dart';
import 'package:flutter/material.dart';
import 'package:drifting_bottle/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => LoginScreen(),
        '/Throw': (context) => ThrowScreen(),
        '/Capture': (context) => DriftedMessageScreen(),
        '/History' : (context) => YourBottlesScreen()
      },
    );
  }
}
