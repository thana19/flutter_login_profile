import 'package:flutter/material.dart';
import 'package:flutter_login/pages/AboutPage.dart';
import 'package:flutter_login/pages/ContactPage.dart';
import 'package:flutter_login/pages/HomePage.dart';
import 'package:flutter_login/pages/ProfilePage.dart';
import 'package:flutter_login/pages/SettingPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Launcher extends StatefulWidget {
  const Launcher({Key? key}) : super(key: key);
  // static const routeName = "/";

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = [
    HomePage(),
    AboutPage(),
    ProfilePage(),
    ContactPage(),
    SettingPage(),
  ];

  List<BottomNavigationBarItem> _menuBar
  = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.infoCircle),
      label: 'About',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.userAlt),
      label: 'Profile',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.addressCard),
      label: 'Contact',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.cog),
      label: 'Settings',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme
            .of(context)
            .primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
