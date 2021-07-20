import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
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
                      child: Column(
                        //email password TextField
                        children: [
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
