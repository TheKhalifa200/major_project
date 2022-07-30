import 'dart:async';
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
        home: course());
  }
}

class course extends StatefulWidget {
  @override
  registration createState() => registration();
}

class nextSemester {
  final List<dynamic> offers;
  nextSemester(this.offers);
}

Future getoffers() async {
  final response = await http
      .get(Uri.parse('http://3.6.24.16:5555/semester/openreg'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
  var jsonData = jsonDecode(response.body);
  List<nextSemester> offers = [];
  if (response.statusCode == 200) {
    nextSemester transcrip = nextSemester(jsonData["offers"]);
    offers.add(transcrip);
    print(offers);
    return offers;
  } else {
    throw Exception('Failed to load');
  }
}

class Error {
  final String error;
  Error(this.error);
}

class registered {
  final Map<String, dynamic> offered;
  registered(this.offered);
}

class registration extends State<course> {
  bool pressed = false;
  bool pressed2 = false;
  var courseid = TextEditingController();
  var offerid;
  static const keyDarkMode = 'key-dark-mode';
  @override
  void initState() {
    getoffers();
    getregistered();

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
            Column(children: [
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
                          child: Center(child: Text("Course ID"))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Course Name"))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Day"))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Time"))),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Credit")))
                    ])
                  ]),
              Card(
                child: FutureBuilder(
                    future: getregistered(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data.length > 0) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, i) {
                              return Card(
                                  child: Column(children: [
                                Table(
                                  border: TableBorder(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.red,
                                          style: BorderStyle.solid)),
                                  children: [
                                    for (var e = 0;
                                        e <
                                            snapshot
                                                .data[i].offered["time"].length;
                                        e++)
                                      TableRow(children: [
                                        if(e==0)
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot
                                                    .data[i]
                                                    .offered["course"]
                                                        ["course_id"]
                                                    .toString()))) else Text(""),
                                        if(e==0)
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot.data[i]
                                                    .offered["course"]["name"]
                                                    .toString()))) else Text(""),
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot.data[i]
                                                    .offered["time"][e]["day"]
                                                    .toString()))),
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot
                                                        .data[i]
                                                        .offered["time"][e]
                                                            ["start_time"]
                                                        .toString() +
                                                    " to " +
                                                    snapshot
                                                        .data[i]
                                                        .offered["time"][e]
                                                            ["end_time"]
                                                        .toString()))),
                                        if(e==0)
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot.data[i]
                                                    .offered["course"]["credit"]
                                                    .toString()))) else Text("")
                                      ]),
                                  ],
                                )
                              ]));
                            });
                      } else {
                        return const Text("Register for a class");
                      }
                      return const Text("a problem occurred");
                    }),
              ),
              Card(
                  child: TextFormField(
                controller: courseid,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                enableSuggestions: true,
                autocorrect: true,
                validator: (value) {
                  if (courseid.text == null || courseid.text.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1))),
              )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pressed = true;
                      });
                    },
                    child: Text("Search")),
                Text("      "),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        getregistered();
                      });
                    },
                    child: Text("Refresh"))
              ]),
              if (pressed == true)
                if (courseid.text.isNotEmpty)
                  FutureBuilder(
                      future: getoffers(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          for (int i = 0; i < snapshot.data.length; i++)
                            for (int e = 0; e < 43; e++)
                                if (courseid.text.toString().toUpperCase() ==
                                  snapshot
                                      .data[i].offers[e]["course"]["course_id"]
                                      .toString())
                                return Card(
                                    child: Column(children: [
                                  Table(
                                    border: TableBorder(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Colors.red,
                                            style: BorderStyle.solid)),
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text("Course ID"))),
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text("Course Name"))),
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text("Day"))),
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text("Time"))),

                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child:
                                                Center(child: Text("Credit")))
                                      ]),
                                      for (int x = 0; x < snapshot.data[i].offers[e]["time"].length; x++)
                                        TableRow(children: [
                                          if(x==0)
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot
                                                    .data[i]
                                                    .offers[e]["course"]
                                                        ["course_id"]
                                                    .toString()
                                                    .toString()))) else Text(""),
                                          if(x==0)
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot.data[i]
                                                    .offers[e]["course"]["name"]
                                                    .toString()
                                                    .toString()))) else Text(""),
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot.data[i]
                                                    .offers[e]["time"][x]["day"]
                                                    .toString()
                                                    .toString()))),
                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot
                                                    .data[i]
                                                    .offers[e]["time"][x]
                                                ["start_time"]
                                                    .toString() +
                                                    " to " +
                                                    snapshot
                                                        .data[i]
                                                        .offers[e]["time"][x]
                                                    ["end_time"]
                                                        .toString()))),
                                          if(x==0)

                                        Padding(
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                                child: Text(snapshot
                                                    .data[i]
                                                    .offers[e]["course"]
                                                        ["credit"]
                                                    .toString()
                                                    .toString()))) else Text("")
                                      ]),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              await register();
                                              setState(() {
                                                getregistered();
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          _buildPopupDialog(
                                                              context));
                                            },
                                            child: Text("Register")),
                                        Text("    "),
                                        ElevatedButton(
                                            onPressed: () async {
                                              await drop();
                                              setState(() {
                                                getregistered();
                                              });
                                            },
                                            child: Text("Drop"))
                                      ])
                                ]));
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      }),
              if (pressed == true)
                if (courseid.text.isNotEmpty)
                  FutureBuilder(
                      future: getoffers(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          for (int i = 0; i < 43; i++)
                            for (int e = 0; e < 43; e++)
                              if (courseid.text.toString().toUpperCase() ==
                                  snapshot
                                      .data[i].offers[e]["course"]["course_id"]
                                      .toString())
                                offerid = snapshot.data[i].offers[e]["offer_id"]
                                    .toString();
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      }),
            ])
          ],
        ));
  }

  Future register() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String offer = offerid.toString();
    print(offer);
    final response = await http.post(
        Uri.parse('http://3.6.24.16:5555/registration/add/$offer'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    List<Error> respo = [];
    var u = jsonDecode(response.body);
    if (response.body == 200) {
      Error success = Error(u["detail"]);
      respo.add(success);
      return respo;
    } else {
      Error error = Error(u["detail"]);
      respo.add(error);
      return respo;
    }
  }

  Future drop() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String offer = offerid.toString();
    print(offer);
    final response = await http.delete(
        Uri.parse('http://3.6.24.16:5555/registration/delete/$offer'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
  }

  Future getregistered() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final response = await http.get(
        Uri.parse('http://3.6.24.16:5555/registration/registered'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    var jsonData = jsonDecode(response.body);
    List<registered> register = [];
    if (response.statusCode == 200) {
      for (var u in jsonData) {
        registered transcrip = registered(u["offer"]);
        register.add(transcrip);
      }
      print(register);
      return register;
    } else {
      throw Exception('Failed to load');
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: FutureBuilder(
          future: register(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Card(
                child: Text(snapshot.data[0].error.toString()),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
