import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ScreenArguments.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({Key? key}) : super(key: key);

  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  SharedPreferences? prefs;
  Map<String, dynamic> profile = {'username': '', 'name': '', "surname": ''};
  Map<String, dynamic> token = {'access_token': ''};

  @override
  void initState() {
    super.initState();
    _getProfile();
    _getToken();
  }

  _getProfile() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    var profileString = prefs!.getString('profile');
    print(profileString);
    if (profileString != null) {
      setState(() {
        profile = convert.jsonDecode(profileString);
      });
    }
  }

  // void _openProfilePage() async {
  //   Navigator.pushNamed(context, '/profile',
  //       arguments: ScreenArguments(
  //         profile['userid'],
  //         profile['username'],
  //         profile['name'],
  //         profile['surname'],
  //       ));
  // }

  _getToken() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs!.getString('token');
    print(tokenString);
    if (tokenString != null) {
      setState(() {
        token = convert.jsonDecode(tokenString);
      });
    }
  }

  _getProfile2() async {
    //get token from pref
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var tokenString = prefs.getString('token');
    // var token = convert.jsonDecode(tokenString!);
    // print(token['access_token']);
    prefs = await SharedPreferences.getInstance();

    //http get profile
    var url = Uri.parse('https://api.thana.in.th/getprofile');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token['access_token']}',
      },
    );
    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('ok');
      print(response.body);

      Navigator.pushNamed(context, '/profile',
          arguments: ScreenArguments(
            body['userid'],
            body['username'],
            body['name'],
            body['surname'],
          ));
      print(body['username']);

      //save profile to pref
      await prefs!.setString('profile', response.body);
      print('update profile');
      print(prefs!.getString('profile'));

      // Navigator.pushNamed(context, '/profile',
      //     arguments: ScreenArguments(
      //       profile['userid'],
      //       profile['username'],
      //       profile['name'],
      //       profile['surname'],
      //     ));

    } else {
      print('fail');
      print(body['message']);
      _logout();
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('profile');

    //open login
    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/login', (Route<dynamic> route) => false);
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                _getProfile2();
                // _openProfilePage();
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/logo.png'),
                height: 100,
              ),
              Text(profile['name'],
                  style: TextStyle(fontSize: 20, color: Colors.blue)),
              Text(
                'The profile ${profile['name']} pushed from share Preference',
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: MaterialButton(
                    onPressed: () {
                      _getProfile2();
                      // _openProfilePage();
                    },
                    child: Text('edit profile',
                        style: TextStyle(color: Colors.blue)),
                  )),
                ],
              )
              // Padding(
              //   padding: EdgeInsets.all(10),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
