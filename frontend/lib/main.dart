import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SmartATCApp());
}

class SmartATCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart ATC",
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}
