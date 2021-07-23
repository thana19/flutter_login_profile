import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late SharedPreferences prefs ;

  _initPref() async {
    prefs = await SharedPreferences.getInstance();
    // int counter = (prefs.getInt('counter') ?? 0) + 1;
    // print('Pressed $counter times.');
    // await prefs.setInt('counter', counter);
  }

  @override
  void initState(){
    super.initState();
    _initPref();
  }

  _login(var values) async {
    var url = Uri.parse('https://api.thana.in.th/login');
    var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode({
        'username': values['username'],
        'password': values['password']
        })
    );

    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("Logged In");
      print(body['message']);
      print(body['id']);
      final snackBar = SnackBar(content: Text(body['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //save token to pref
      await prefs.setString('token', response.body);

      //get profile
      _getProfile();

      // Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);

      // Navigator.pushNamed(context, '/launcher');

    } else {
      print(body['message']);

      final snackBar = SnackBar(content: Text(body['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _getProfile() async{
    //get token from pref
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString!);
    print(token['access_token']);

    //http get profile
    var url = Uri.parse('https://api.codingthailand.com/api/profile');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token['access_token']}',
      },
    );
    var body = convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      print(response.body);
    }else{
      print(response.body);
      print(body['message']);
    }

    //save profile to pref
    await prefs.setString('user', body['data']['user']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image (
                  image: AssetImage('assets/logo.png'),
                  height: 100,
                ),
                Text('Login', style: TextStyle(fontSize: 20,color: Colors.blue)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FormBuilder(
                      key: _formKey,
                      initialValue: {
                        'username': '',
                        'password': ''
                      },
                      child: Column(
                        children: [
                          //email password TextField
                          FormBuilderTextField(
                            name: 'username',
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                            ),

                          ),
                          SizedBox(height: 15),
                          FormBuilderTextField(
                            name: 'password',
                            decoration: InputDecoration(
                              labelText: 'password',
                              filled: true,
                            ),

                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            child: MaterialButton(
                              onPressed: () {
                              _formKey.currentState!.save();

                               print(_formKey.currentState!.value);
                               _login(_formKey.currentState!.value);
                              },
                              child: Text("Login",style: TextStyle(color: Colors.blue)),
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
                                    child: Text('Register', style: TextStyle(color: Colors.blue)),
                                  )
                              )
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
