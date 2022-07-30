import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
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
        home: schedule());
  }
}

class schedule extends StatefulWidget {
  @override
  printing createState() => printing();
}

class Schedule {
  final Map<String, dynamic> semester;
  final Map<String, dynamic> offer;
  Schedule(this.semester, this.offer);
}

Future getschedule() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  final response = await http
      .get(Uri.parse('http://3.6.24.16:5555/student/schedule'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  var jsonData = jsonDecode(response.body);
  List<Schedule> schedules = [];
  if (response.statusCode == 200) {
    for (var u in jsonData) {
      Schedule schedule = Schedule(u["semester"], u["offer"]);
      schedules.add(schedule);
    }

    print(schedules);
    return schedules;
  } else {
    throw Exception('Failed to load');
  }
}

class printing extends State<schedule> {
  static const keyLanguage = 'key-language';
  static const keyDarkMode = 'key-dark-mode';
  @override
  void initState() {
    getschedule();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Image.asset("assets/images/logo20B.png",
              fit: BoxFit.contain,
              height: 130,
              width: 130,
              alignment: Alignment.center),
        ),
        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Column(children: [
                FutureBuilder(
                    future: getschedule(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(children: [
                          Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                  child: Text(
                                snapshot.data[1].semester["semester_name"]
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.red,
                                ),
                              ))),
                          Table(
                            border: TableBorder(
                                horizontalInside: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                    style: BorderStyle.solid)),
                            children: [
                              TableRow(children: [
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(child: Text("Course"))),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(child: Text("Sec"))),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(child: Text("Day"))),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(child: Text("Time"))),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(child: Text("Room")))
                              ])
                            ],
                          )
                        ]);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    }),
                for (int i = 0; i < 4; i++)
                  for (int e = 0; e < 4; e++)
                    FutureBuilder(
                      future: getschedule(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Card(
                              child: Table(
                            border: TableBorder(
                                horizontalInside: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                    style: BorderStyle.solid)),
                            children: [
                              TableRow(children: [
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(snapshot
                                            .data[i].offer["course_id"]
                                            .toString()))),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(snapshot
                                            .data[i].offer["section_no"]
                                            .toString()))),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(snapshot
                                            .data[i].offer["time"][e]["day"]
                                            .toString()))),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(snapshot.data[i]
                                                .offer["time"][e]["start_time"]
                                                .toString() +
                                            " to " +
                                            snapshot.data[i]
                                                .offer["time"][e]["end_time"]
                                                .toString()))),
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(snapshot
                                                .data[i].offer["room"]["type"]
                                                .toString() +
                                            " " +
                                            snapshot.data[i]
                                                .offer["room"]["room_id"]
                                                .toString()))),
                              ]),
                            ],
                          ));
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    )
              ])
            ]));
  }
}
