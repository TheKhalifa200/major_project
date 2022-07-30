import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:major_project/Courseregistration.dart';
import 'package:major_project/Curriculum.dart';
import 'package:major_project/Schedule.dart';
import 'package:major_project/Transcript.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'icon_widget.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

void main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());
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
        home: loggedin());
  }
}

class loggedin extends StatefulWidget {
  @override
  _TabBar createState() => _TabBar();
}

class tokens {
  String access_token;
  final String token_type;
  final int user_id;
  tokens({
    required this.access_token,
    required this.token_type,
    required this.user_id,
  });

  tokens.fromJson(Map<String, dynamic> json)
      : access_token = json['access_token'],
        token_type = json['token_type'],
        user_id = json['user_id'];

  Map<String, dynamic> toJson() {
    return {
      'access_token': access_token,
      'token_type': token_type,
      'user_id': user_id
    };
  }

  Future<Future<bool>> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('access_token', value);
  }
}

class studentname {
  final int id;
  final String fname;
  final String sname;
  final String tname;
  final String lname;
  final Map<String, dynamic> info;

  studentname(this.fname, this.sname, this.tname, this.lname, this.info, this.id);
}

Future getstudentname() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  final response =
      await http.get(Uri.parse('http://3.6.24.16:5555/student/me'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  print(response);
  var jsonData = jsonDecode(response.body);

  List<studentname> students = [];
  if (response.statusCode == 200) {
    studentname student = studentname(jsonData['fname'], jsonData['sname'],
        jsonData['tname'], jsonData['lname'], jsonData['info'],jsonData['student_id'],);
    students.add(student);
    return students;
  } else {
    throw Exception('token');
  }
}

class _TabBar extends State<loggedin> {
  static const keyDarkMode = 'key-dark-mode';
  @override
  void initState() {
    getstudentname();
    super.initState();
  }

  Widget build(BuildContext context) {
    final isDarkMode = Settings.getValue<bool>(keyDarkMode, true);
    return Container(
        color: Color(0xFFFAFAFA),
        child: DefaultTabController(
          length: 2,
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
                    drawer: NavDrawer(),
                    appBar: AppBar(
                      backgroundColor: Colors.red,
                      centerTitle: true,
                      title: Image.asset("assets/images/logo20B.png",
                          fit: BoxFit.contain,
                          height: 130,
                          width: 130,
                          alignment: Alignment.center),
                    ),
                    body: TabBarView(children: [
                      Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Welcome", style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FutureBuilder(
                                        future: getstudentname(),
                                        builder: (context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(snapshot.data[0].fname +
                                                " " , style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                                          } else if (snapshot.hasError) {
                                            return Text('${snapshot.error}');
                                          }
                                          return const CircularProgressIndicator();
                                        }),
                                    FutureBuilder(
                                        future: getstudentname(),
                                        builder: (context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data[0].sname +
                                                " " , style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                                          } else if (snapshot.hasError) {
                                            return Text('${snapshot.error}');
                                          }
                                          return const CircularProgressIndicator();
                                        }),
                                    FutureBuilder(
                                        future: getstudentname(),
                                        builder: (context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data[0].tname +
                                                " ", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), );
                                          } else if (snapshot.hasError) {
                                            return Text('${snapshot.error}');
                                          }
                                          return const CircularProgressIndicator();
                                        }),
                                    FutureBuilder(
                                        future: getstudentname(),
                                        builder: (context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data[0].lname, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                                          } else if (snapshot.hasError) {
                                            return Text('${snapshot.error}');
                                          }
                                          return const CircularProgressIndicator();
                                        })
                                  ],
                                ),
                                FutureBuilder(
                                    future: getstudentname(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data[0].id.toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                                      } else if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      }
                                      return const CircularProgressIndicator();
                                    }),
                                FutureBuilder(
                                    future: getstudentname(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data[0].info["program"]["department"]["college"]["college_name"], style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),);
                                      } else if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      }
                                      return const CircularProgressIndicator();
                                    }),
                                FutureBuilder(
                                    future: gettranscript(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data.length-1 != -1)
                                        return Text("Cumulative GPA: "+
                                        snapshot.data[snapshot.data.length-1].cgpa.toString(), style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),);
                                      }
                                        else if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      }
                                      return const Text("");

                                    })
                          ])),
                      Container(
                          child: ListView(
                        children: [
                          SwitchSettingsTile(
                            title: 'Dark Mode',
                            settingKey: keyDarkMode,
                            leading: IconWidget(
                              icon: Icons.dark_mode,
                              color: Color(0xFF642ef3),
                            ),
                            onChange: (_) {},
                          ),
                          SettingsGroup(title: 'General', children: [
                            SimpleSettingsTile(
                              title: 'Logout',
                              subtitle: '',
                              leading: IconWidget(
                                icon: Icons.logout,
                                color: Colors.red,
                              ),
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Page1()),
                              ),
                            )
                          ])
                        ],
                      ))
                    ]),
                    bottomNavigationBar: Material(
                      color: Colors.red,
                      child: TabBar(
                        indicator: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(50), // Creates border
                            color: Colors
                                .white), //Change background color from here
                        tabs: [
                          Tab(
                              icon: Icon(
                            Icons.home,
                            color: Colors.green,
                          )),
                          Tab(
                              icon: Icon(
                            Icons.settings,
                            color: Colors.green,
                          ))
                        ],
                      ),
                    ),
                  ))),
        ));
  }
}
