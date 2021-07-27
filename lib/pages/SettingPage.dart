import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
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
            child: Text(
              'setting',
            ),
          ),
        ));
  }
}
