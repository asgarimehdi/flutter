import 'package:flutter/material.dart';
import 'package:my_first_app/screens/categories.dart';
import 'package:my_first_app/screens/login.dart';
import 'package:my_first_app/screens/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to flutter',
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/categories': (context) => Categories(),
      },
    );
  }
}
