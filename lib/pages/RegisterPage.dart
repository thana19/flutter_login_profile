import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  _register(var values) async {
    print(values);

    var url = Uri.parse('https://api.thana.in.th/users');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode({
          'username': values['username'],
          'password': values['password'],
          'name': values['name'],
          'surname': values['surname']
        }));

    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      // print(body['message']);
      final snackBar = SnackBar(content: Text(body['username']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } else {
      print(response.body);
      print(body['message']);
      final snackBar = SnackBar(content: Text(body['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
              Text('Profile',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              Padding(
                padding: EdgeInsets.all(10),
                child: FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'username': '',
                    'password': '',
                    'name': '',
                    'surname': '',
                  },
                  child: Column(
                    children: [
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
                      SizedBox(height: 15),
                      FormBuilderTextField(
                        name: 'name',
                        decoration: InputDecoration(
                          labelText: 'name',
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 15),
                      FormBuilderTextField(
                        name: 'surname',
                        decoration: InputDecoration(
                          labelText: 'surname',
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                              child: MaterialButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, '/register');
                              print('register');
                              _formKey.currentState!.save();

                              _register(_formKey.currentState!.value);
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
    );
  }
}
