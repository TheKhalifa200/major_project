import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:major_project/Courseregistration.dart';
import 'package:major_project/Curriculum.dart';
import 'package:major_project/Schedule.dart';
import 'package:major_project/Transcript.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'icon_widget.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'loggedinPage.dart';
import 'signin.dart';
import 'dart:ui' as ui;

void main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
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
        home: Page1());
  }
}

class Page1 extends StatefulWidget {
  @override
  _TabBar createState() => _TabBar();
}

class _TabBar extends State<Page1> {
  static const keyDarkMode = 'key-dark-mode';
  @override
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
                    drawer: NavDrawerNull(),
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
                          child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => signin()),
                        ),
                        child: Text("Sign in"),
                      )),
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
                              title: 'Login',
                              subtitle: '',
                              leading: IconWidget(
                                icon: Icons.login,
                                color: Colors.blue,
                              ),
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => signin())),
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

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(width:250, height:250,child:DrawerHeader(
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.contain,
                    image: AssetImage('assets/images/logo2.0.png'))),
          )),
          ListTile(
              title: Container(
                  width: 40,
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Text(
                    'Course Registration',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => course()),
                  )),
          ListTile(
              title: Container(
                  width: 40,
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Text(
                    'Current Schedule',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => schedule()),
                  )),
          ListTile(
              title: Container(
                  width: 40,
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Text(
                    'Transcript',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => transcript()),
                  )),
          ListTile(
              title: Container(
                  width: 40,
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Text(
                    'Curriculum',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => curriculum()),
                  )),
        ],
      ),
    );
  }
}

class NavDrawerNull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(width:250, height:250,child:DrawerHeader(
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/logo2.0.png'))),
          )),
          ListTile(
              title: Container(
                  width: 40,
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Text(
                    'Course Registration',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))),
              onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => signin()),
                  )),
          ListTile(
              title: Container(
                  width: 40,
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Text(
                    'Current Schedule',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))),
              onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => signin()),
                  )),
          ListTile(
              title: Container(
                  width: 40,
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Text(
                    'Transcript',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))),
              onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => signin()),
                  )),
          ListTile(
              title: Container(
                  width: 40,
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Text(
                    'Curriculum',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )))),
              onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => signin()),
                  )),
        ],
      ),
    );
  }
}
