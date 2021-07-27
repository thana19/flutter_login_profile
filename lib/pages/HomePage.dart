import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> profile = {'username': '', 'name': '', "surname": ''};

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    var profileString = prefs.getString('profile');
    print(profileString);
    if (profileString != null) {
      setState(() {
        profile = convert.jsonDecode(profileString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Container(
          decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: AssetImage('assets/star02.png'), fit: BoxFit.cover)
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.blue,
                Colors.white,
              ])),
          child: Center(
            child: Text('Hello ${profile['name']} ',
                style: TextStyle(fontSize: 30, color: Colors.white)),
          ),
        ));
  }
}
