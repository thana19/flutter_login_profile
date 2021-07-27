import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ScreenArguments.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

      Navigator.pushNamed(context, '/launcher');
      // Navigator.pop(context, 'About AAA');
      _getProfile2();
    } else {
      print(response.body);
      print(body['message']);
      _logout();
      // final snackBar = SnackBar(content: Text(body['message']));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _getProfile2() async {
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
      print(body['username']);

      //save profile to pref
      await prefs.setString('profile', response.body);
      print(prefs.getString('username'));
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
    final screenAgr =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile'),
        actions: [
          IconButton(
              onPressed: () {
                _logout();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue,
              Colors.white,
            ])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/profile.png'),
                height: 100,
              ),
              Text(profile['name'],
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              Text(
                'The profile ${profile['name']} pushed share Preference',
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FormBuilder(
                  key: _formKey,
                  initialValue: {
                    // 'username': profile['username'],
                    // 'name': profile['name'],
                    // 'surname': profile['surname'],
                    'username': screenAgr.username,
                    'name': screenAgr.name,
                    'surname': screenAgr.surname,
                  },
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'username',
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'please insert email'),
                          FormBuilderValidators.email(context),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15),
                      FormBuilderTextField(
                        name: 'name',
                        decoration: InputDecoration(
                          labelText: 'name',
                          filled: true,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'not null'),
                        ]),
                      ),
                      SizedBox(height: 15),
                      FormBuilderTextField(
                        name: 'surname',
                        decoration: InputDecoration(
                          labelText: 'surname',
                          filled: true,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'not null'),
                        ]),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                              child: MaterialButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, '/register');
                              if (_formKey.currentState!.validate()) {
                                print('Update');
                                _formKey.currentState!.save();
                                _updateProfile(_formKey.currentState!.value);
                              } else {
                                print("validation failed");
                              }
                            },
                            child: Text('Save',
                                style: TextStyle(color: Colors.blue)),
                          )),
                          Expanded(
                              child: MaterialButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, '/register');
                              _logout();
                            },
                            child: Text('Log out',
                                style: TextStyle(color: Colors.blue)),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
