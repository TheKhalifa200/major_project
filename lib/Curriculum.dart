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
        home: curriculum());
  }
}

class curriculum extends StatefulWidget {
  @override
  tran createState() => tran();
}

class Curriculum {
  final int year;
  final int semester;
  final Map<String, dynamic> course;
  Curriculum(this.year, this.semester, this.course);
}

Future getcurriculum() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  final response = await http
      .get(Uri.parse('http://3.6.24.16:5555/program/curriculum'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  var jsonData = jsonDecode(response.body);
  List<Curriculum> transcripts = [];
  if (response.statusCode == 200) {
    for (var u in jsonData) {
      Curriculum transcrip = Curriculum(u["year"], u["semester"], u["course"]);
      transcripts.add(transcrip);
    }
    print(transcripts);
    return transcripts;
  } else {
    throw Exception('Failed to load');
  }
}

class tran extends State<curriculum> {
  static const keyDarkMode = 'key-dark-mode';
  @override
  void initState() {
    getcurriculum();
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
          shrinkWrap: true,
          children: [
            Column(
              children: [
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
                          child: Center(child: Text(" "))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Course Name"))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Course ID"))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Credit"))),
                    ]),
                  ],
                ),
                for (var i = 1; i < 5; i++)
                  for (var e = 1; e < 4; e++)
                    FutureBuilder(
                        future: getcurriculum(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Column(children: [
                              Card(
                                  child: Table(
                                border: TableBorder(
                                    horizontalInside: BorderSide(
                                        width: 1,
                                        color: Colors.red,
                                        style: BorderStyle.solid)),
                                children: [
                                  for (int u = 0; u < snapshot.data.length; u++)
                                    if (snapshot.data[u].year == i &&
                                        snapshot.data[u].semester == e)
                                      TableRow(children: [
                                        Center(
                                            child: Text("Year " +
                                                snapshot.data[u].year
                                                    .toString() +
                                                "\nSemester " +
                                                snapshot.data[u].semester
                                                    .toString())),
                                        Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(snapshot
                                                .data[u].course["name"])),
                                        Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(snapshot
                                                .data[u].course["course_id"])),
                                        Center(
                                            child: Text(snapshot
                                                .data[u].course["credit"]
                                                .toString())),
                                      ]),
                                ],
                              )),
                              Text(" ")
                            ]);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                        }),
              ],
            )
          ],
        ));
  }
}
