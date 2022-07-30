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
        home: transcript());
  }
}

class transcript extends StatefulWidget {
  @override
  tran createState() => tran();
}

class Transcript {
  final String Semester;
  final List<dynamic> Courses;
  final double cgpa;
  final String sgpa;
  Transcript(this.Semester, this.Courses, this.cgpa, this.sgpa);
}

Future gettranscript() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  final response = await http
      .get(Uri.parse('http://3.6.24.16:5555/student/transcript'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  var jsonData = jsonDecode(response.body);
  List<Transcript> transcripts = [];
  if (response.statusCode == 200) {
    for (var u in jsonData) {
      Transcript transcrip =
          Transcript(u["SemesterName"], u["Courses"], u["CumulativeGPA"],u["StrSemesterGPA"]);
      transcripts.add(transcrip);
    }
    print(transcripts);
    return transcripts;
  } else {
    throw Exception('Failed to load');
  }
}

class tran extends State<transcript> {
  static const keyDarkMode = 'key-dark-mode';
  @override
  void initState() {
    gettranscript();
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
          children: [
            FutureBuilder(
                future: gettranscript(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, i) {
                          return Column(children: [
                            Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                    child: Text(
                                  snapshot.data[i].Semester.toString(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.red,
                                  ),
                                ))),
                            Card(
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
                                      child: Center(child: Text("Course"))),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(child: Text("Grade"))),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(child: Text("Credit"))),
                                ]),
                                for (var e = 0;
                                    e < snapshot.data[i].Courses.length;
                                    e++)
                                  TableRow(children: [
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                            child: Text(snapshot.data[i]
                                                .Courses[e]["CourseName"]
                                                .toString()))),
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                            child: Text(snapshot
                                                .data[i].Courses[e]["Grade"]
                                                .toString()))),
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                            child: Text(snapshot.data[i]
                                                .Courses[e]["CourseCredit"]
                                                .toString()))),
                                  ]),
                                TableRow(children: [
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(child: Text(""))),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                          child: Text("Semester GPA"))),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                          child: Text(snapshot.data[i].sgpa
                                              .toString()))),
                                ]),
                                TableRow(children: [
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(child: Text(""))),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                          child: Text("Cumulative GPA"))),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                          child: Text(snapshot.data[i].cgpa
                                              .toString()))),
                                ]),
                              ],
                            ))
                          ]);
                        });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                }),
          ],
        ));
  }
}
