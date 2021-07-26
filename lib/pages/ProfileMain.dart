import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();
  late SharedPreferences prefs;
  Map<String, dynamic> profile = {'username': '', 'name': '', "surname": ''};
  Map<String, dynamic> token = {'access_token': ''};

  _initPref() async {
    prefs = await SharedPreferences.getInstance();
    // int counter = (prefs.getInt('counter') ?? 0) + 1;
    // print('Pressed $counter times.');
    // await prefs.setInt('counter', counter);
  }

  @override
  void initState() {
    super.initState();
    _initPref();
    _getProfile();
    _getToken();
  }

  _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profileString = prefs.getString('profile');
    print(profileString);
    if (profileString != null) {
      setState(() {
        profile = convert.jsonDecode(profileString);
      });
    }
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    print(tokenString);
    if (tokenString != null) {
      setState(() {
        token = convert.jsonDecode(tokenString);
      });
    }
  }

  _updateProfile(var values) async {
    // print(values);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var tokenString = prefs.getString('token');
    // var token = convert.jsonDecode(tokenString!);
    // print(token);

    // var profileString = prefs.getString('profile');
    // var profile = convert.jsonDecode(profileString!);
    // print(profile);

    var url = Uri.parse('https://api.thana.in.th/updateprofile');
    var response = await http.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token['access_token']}',
        },
        body: convert.jsonEncode({
          'userId': profile['userid'],
          'name': values['name'],
          'surname': values['surname']
        }));

    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      // print(body['message']);
      // final snackBar = SnackBar(content: Text(body['nModified']));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Navigator.pushNamed(context, '/launcher');
      _getProfile2();
    } else {
      print(response.body);
      print(body['message']);
      final snackBar = SnackBar(content: Text(body['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _getProfile2() async {
    //get token from pref
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString!);
    print(token['access_token']);

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

      Navigator.pushNamed(context, '/launcher',
          arguments: ScreenArguments(
            body['userid'],
            body['username'],
            body['name'],
            body['surname'],
          ));
      print(body['username']);

      //save profile to pref
      await prefs.setString('profile', response.body);
      // print(prefs.getString('profile'));
      // await prefs.setString('username', body['username']);
      print(prefs.getString('username'));
    } else {
      print('fail');
      // print(response.body);
      print(body['message']);
    }
  }

  void _openProfilePage() async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //  var profileString = prefs.getString('profile');

    //open login
    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/login', (Route<dynamic> route) => false);
    Navigator.pushNamed(context, '/profile',
        arguments: ScreenArguments(
          profile['userid'],
          profile['username'],
          profile['name'],
          profile['surname'],
        ));
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
                _openProfilePage();
              },
              icon: Icon(Icons.exit_to_app))
        ],
        // title: Text('Profile'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/logo.png'),
                height: 100,
              ),
              Text('profile',
                  style: TextStyle(fontSize: 20, color: Colors.blue)),
              Text(
                'The profile ${profile['name']} pushed share Preference',
              ),
              Padding(
                padding: EdgeInsets.all(10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
