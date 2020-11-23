import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';
import 'package:status_saver/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variables
  final App _app = new App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _app.appShortDescription,
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
