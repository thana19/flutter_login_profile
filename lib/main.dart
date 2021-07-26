import 'package:flutter/material.dart';
import 'package:flutter_login_profile/pages/HomePage.dart';
import 'package:flutter_login_profile/pages/Launcher.dart';
import 'package:flutter_login_profile/pages/LoginPage.dart';
import 'package:flutter_login_profile/pages/ProfilePage.dart';
import 'package:flutter_login_profile/pages/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');
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
        // "/": (context) => LoginPage(),
        '/': (context) => token == null ? LoginPage() : Launcher(),
        "/home": (context) => HomePage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/launcher": (context) => Launcher(),
        "/profile": (context) => ProfilePage(),
      },
    );
  }
}
