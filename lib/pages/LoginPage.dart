import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login_profile/pages/ScreenArguments.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late SharedPreferences prefs;

  _initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPref();
  }

  _login(var values) async {
    var url = Uri.parse('https://api.thana.in.th/login');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(
            {'username': values['username'], 'password': values['password']}));

    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("Logged In");
      print(body['access_token']);

      //save token to pref
      await prefs.setString('token', response.body);
      print(prefs.getString('token'));

      //get profile
      _getProfile();
    } else {
      print(body['message']);

      final snackBar = SnackBar(content: Text(body['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _getProfile() async {
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

      // Navigator.pushNamed(context, '/launcher',
      //     arguments: ScreenArguments(
      //       body['userid'],
      //       body['username'],
      //       body['name'],
      //       body['surname'],
      //     ));

      Navigator.pushNamed(
        context,
        '/launcher',
      );
      print(body['username']);

      //save profile to pref
      await prefs.setString('profile', response.body);
    } else {
      print('fail');
      print(body['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue,
              Colors.white,
            ])),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/profile.png'),
                  height: 100,
                ),
                Text('Login',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {'username': '', 'password': ''},
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
                            // FormBuilderValidators.numeric(context),
                            // FormBuilderValidators.max(context, 70),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: 'password',
                          decoration: InputDecoration(
                            labelText: 'password',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert password'),
                            FormBuilderValidators.minLength(context, 8,
                                errorText: 'min length 8 character'),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: MaterialButton(
                            onPressed: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                print(_formKey.currentState!.value);
                                _login(_formKey.currentState!.value);
                              } else {
                                print("validation failed");
                              }
                            },
                            child: Text("Login",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Register',
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
      ),
    );
  }
}
