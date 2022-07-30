import 'dart:convert';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:major_project/loggedinPage.dart';
import 'main.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: signin());
  }
}

class signin extends StatefulWidget {
  const signin({Key? key}) : super(key: key);

  @override
  Signin createState() {
    return Signin();
  }
}

class Signin extends State<signin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final isDarkMode = Settings.getValue<bool>(keyDarkMode, true);
  static const keyDarkMode = 'key-dark-mode';
  bool isloading = false;
  var username = TextEditingController();
  var password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFFAFAFA),
        child: ValueChangeObserver<bool>(
            defaultValue: true,
            cacheKey: keyDarkMode,
            builder: (_, isDarkMode, __) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Dark Mode',
                theme: isDarkMode
                    ? ThemeData.dark().copyWith(
                        primaryColor: Colors.teal,
                        accentColor: Colors.white,
                        scaffoldBackgroundColor: Color(0xDD000000),
                        canvasColor: Color(0xDD000000),
                      )
                    : ThemeData.light().copyWith(
                        accentColor: Colors.black,
                        scaffoldBackgroundColor: Colors.transparent),
                home: Scaffold(
                    key: _scaffoldKey,
                    appBar: AppBar(
                      backgroundColor: Colors.red,
                      centerTitle: true,
                      leading: BackButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Page1()));
                        },
                      ),
                      title: Image.asset("assets/images/logo20B.png",
                          fit: BoxFit.contain,
                          height: 130,
                          width: 130,
                          alignment: Alignment.center),
                    ),
                    body: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Username",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    )),
                                TextFormField(
                                  controller: username,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  validator: (value) {
                                    if (username.text == null ||
                                        username.text.isEmpty) {
                                      return 'Username is required';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1))),
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Password",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    )),
                                TextFormField(
                                  controller: password,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  validator: (value) {
                                    if (password.text == null ||
                                        password.text.isEmpty) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1))),
                                ),
                                Container(
                                  child: Text(''),
                                ),
                                SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: ElevatedButton(
                                      child: isloading
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text('Login'),
                                      onPressed: () async {
                                        setState(() {
                                          isloading = true;
                                        });
                                        await login();
                                        setState(() {
                                          isloading = false;
                                        });
                                      },
                                    )),
                              ]),
                        ))))));
  }

  Future<void> login() async {
    if (password.text.isNotEmpty && username.text.isNotEmpty) {
      var response = await http.post(Uri.parse("http://3.6.24.16:5555/token"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: ({'username': username.text, 'password': password.text}),
          encoding: Encoding.getByName("utf-8"));
      if (response.statusCode == 200) {
        var jsonresponse = jsonDecode(response.body);
        var token = tokens(user_id: 0, token_type: '', access_token: '')
            .access_token = jsonresponse['access_token'];
        tokens(
                access_token: 'access_token',
                token_type: 'token_type',
                user_id: 0)
            .setToken(token);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => loggedin()));
      } else {
        _scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text(
            'Invalid Credentials',
          ),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(
          'Fill in the blanks',
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
