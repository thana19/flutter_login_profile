import 'package:flutter/material.dart';
import 'package:flutter_login/pages/HomePage.dart';
import 'package:flutter_login/pages/Launcher.dart';
import 'package:flutter_login/pages/LoginPage.dart';
import 'package:flutter_login/pages/RegisterPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),
      initialRoute: '/',
      routes: {
        "/": (context) => LoginPage(),
        "/home": (context) => HomePage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/launcher": (context) => Launcher(),
      },
    );
  }
}


