import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ScreenArguments.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late SharedPreferences prefs;
  List<dynamic> articles = [];

  SharedPreferences? preferences;

  // String? _token;
  // String? _id;
  // String? _username;
  // String? _name;
  // String? _surname;
  // TextEditingController? _usernameController;
  // TextEditingController? _nameController;
  // TextEditingController? _surnameController;

  _initPref() async {
    // try {
    // _username = 'testusername';
    prefs = await SharedPreferences.getInstance();

    // setState(() {
    // _token = prefs.getString('token')!;
    // _id = prefs.getString('userid')!;
    // _username = prefs.getString('username')!;
    // _name = prefs.getString('name')!;
    // _surname = prefs.getString('surname')!;

    // _usernameController = new TextEditingController(text: _username);
    // _nameController = new TextEditingController(text: _name);
    // _surnameController = new TextEditingController(text: _surname);
    // });
    // } catch (e) {
    //   setState(() {
    //     // isLoading = false;
    //   });
    // }
  }

  // Future<void> _getProfile() async {
  //   //get token from pref
  //   var tokenString = prefs.getString('token');
  //   var token = convert.jsonDecode(tokenString!);
  //   print(token['access_token']);

  //   //http get profile
  //   var url = Uri.parse('https://api.thana.in.th/getprofile');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer ${token['access_token']}',
  //     },
  //   );
  //   var body = convert.jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     print('ok');
  //     print(response.body);
  //   } else {
  //     print('fail');
  //     // print(response.body);
  //     print(body['message']);
  //   }

  //   final Map<String, dynamic> profile = convert.jsonDecode(response.body);
  //   setState(() {
  //     // articles = profile:
  //     // articles.addAll(profile['articles']);
  //     _username = profile['username'];
  //     print(_username);
  //     // isLoading = false;
  //   });
  //   //save profile to pref
  //   // await prefs.setString('profile', response.body);
  //   // print(prefs.getString('profile'));
  // }

  _updateProfile(var values) async {
    print(values);
    // print(_id);
    // print(_token);

    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString!);
    print(token);

    var profileString = prefs.getString('profile');
    var profile = convert.jsonDecode(profileString!);
    print(profile);

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

      // Future.delayed(Duration(seconds: 3),(){
      //   Navigator.pop(context);
      // });

    } else {
      print(response.body);
      print(body['message']);
      final snackBar = SnackBar(content: Text(body['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
    this.preferences?.setString("name", "Peter");
    this.preferences?.setStringList("infoList", ["developer", "mobile dev"]);
  }

  @override
  void initState() {
    super.initState();
    // _username = '';
    // _initPref();

    _initPref().whenComplete(() {
      setState(() {});
    });

    // SharedPreferences.getInstance().then((prefValue) => {
    //       setState(() {
    //         _username = prefValue.getString('username') ?? false;
    //         // _controller = new TextEditingController(text: _name);
    //       })
    //     });

    // _getProfile();
    // initializePreference().whenComplete(() {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    final contact =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
                'The user ${prefs.getString("username")} pushed share Preference',
              ),

              // Text(contact.username),
              Padding(
                padding: EdgeInsets.all(10),
                child: FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'username': contact.username,
                    'name': contact.name,
                    'surname': contact.surname,
                  },
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        // controller: _usernameController,
                        name: 'username',
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                        // controller: _nameController,
                      ),
                      SizedBox(height: 15),
                      FormBuilderTextField(
                        // controller: _surnameController,
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
                              print('Update');
                              _formKey.currentState!.save();

                              _updateProfile(_formKey.currentState!.value);
                            },
                            child: Text('Save',
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
