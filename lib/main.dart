import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import './size_animation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    print('help.');
    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values. If we changed
    //   // _counter without calling setState(), then the build method would not be
    //   // called again, and so nothing would appear to happen.
    //   _counter++;
    // });
  }

  void setToken(token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  void logValue(value) {
    print(value);
  }

  void login() async {
    setState(() {
      buttonText = "Loading";
      showLoading = true;
    });
    // _onLoading();
    print(email + ' | ' + password);

    var url = 'https://api-bid.maxtime.co.uk/auth/login';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      var tokedn = jsonResponse['token'];
      print(tokedn);
      setToken(tokedn);
      setState(() {
        responseText = 'Success';
        token = tokedn;
        buttonText = "Sign in";
        showLoading = false;
      });
      Navigator.push(
        // context,
        // MaterialPageRoute(builder: (context) => SecondRoute()),
        context,
        MaterialPageRoute(
            builder: (context) => ShiftsPage(
                  token: token,
                )),
        // MaterialPageRoute(builder: (context) => SecondRoute(items: shifts)),
      );
    } else {
      print('Request failed with status: ${response.statusCode}.');
      setState(() {
        responseText = 'Failed';
        buttonText = "Failed";
        showLoading = false;
      });
      Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
            buttonText = "Log in";
          }));
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String value = "";
  String responseText = "";

  String email = "";
  String password = "";
  String token = "";
  List shifts = [];
  String buttonText = "Sign in";
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.blue,
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 15, top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0)),
                  color: Colors.yellow,
                ),
                child: Column(children: <Widget>[
                  Container(
                      child: Image(
                    image: AssetImage('assets/logo.png'),
                    height: 300,
                  )),
                  TextFormField(
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Login email',
                        labelText: 'Email',
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        hoverColor: Colors.black),
                    onChanged: (text) {
                      email = text;
                      logValue(text);
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Whats your password',
                        labelText: 'Password *',
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        hoverColor: Colors.black),
                    onChanged: (text) {
                      password = text;
                      logValue(text);
                    },
                  ),
                  Container(
                    // width: 100,
                    padding: const EdgeInsets.only(top: 15),
                    child: FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        buttonText,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ])),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            // context,
            // MaterialPageRoute(builder: (context) => SecondRoute()),
            context,
            MaterialPageRoute(
                builder: (context) => ShiftsPage(
                      token: token,
                    )),
            // MaterialPageRoute(builder: (context) => SecondRoute(items: shifts)),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.help),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ShiftsPage extends StatefulWidget {
  final Object token;

  ShiftsPage({Key key, @required this.token}) : super(key: key);

  @override
  ShiftsPageState createState() {
    return new ShiftsPageState();
  }
}

class ShiftsPageState extends State<ShiftsPage> with TickerProviderStateMixin {
  AnimationController controller;

  List shifts = [];
  String token = '';
  String responseText = '';

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));
    getToken();
    getShifts();
  }

  void getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print('TOKEN = ' + token);
  }

  // TOKEN IS BEING PASSED THROUGH INTO THIS CLASS -> NEED TO FIGURE OUT HOW TO RECIEVE IT TO DO THE API CALL

  void getShifts() async {
    var url = 'https://api-bid.maxtime.co.uk/shifts';

    // Await the http get response, then decode the json-formatted response.
    Object headers = {"Content-Type": "application/json", "x-api-key": token};

    print(headers);

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        responseText = jsonResponse;
        shifts = jsonResponse;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      setState(() {
        responseText = 'Request failed with status: ${response.statusCode}.';
      });
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('API Request Response'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(responseText),
                Text('TOKEN = ' + token),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Shifts"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          RotationTransition(
            turns: new Tween(begin: 0.0, end: 1.0).animate(controller),
            child: Container(
              child: Column(children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 4, top: 8),
                    // padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.red,
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 4, right: 8),
                          child: RaisedButton(
                            onPressed: () {
                              _showMyDialog();
                            },
                            child: Text('All Shifts'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4, right: 8),
                          child: RaisedButton(
                            onPressed: () {
                              _showMyDialog();
                            },
                            child: Text('Pending Shifts'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: RaisedButton(
                            onPressed: () {
                              _showMyDialog();
                            },
                            child: Text('Accepted Shifts'),
                          ),
                        ),
                      ],
                    )),
                Container(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Column(children: <Widget>[
                            SizeAnimation(
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 4),
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.blue,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Title",
                                      ),
                                      Text(
                                        "Subheading",
                                      ),
                                      Text(
                                        "Date / Time",
                                      ),
                                    ],
                                  )),
                            ),
                            SizeAnimation(
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 4, top: 4),
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.blue,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Title",
                                      ),
                                      Text(
                                        "Subheading",
                                      ),
                                      Text(
                                        "Date / Time",
                                      ),
                                    ],
                                  )),
                            ),
                            SizeAnimation(
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 4, top: 4),
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.blue,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Title",
                                      ),
                                      Text(
                                        "Subheading",
                                      ),
                                      Text(
                                        "Date / Time",
                                      ),
                                    ],
                                  )),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    new MaterialButton(
                      child: new Text('Start Animation'),
                      onPressed: () {
                        setState(() {
                          controller.forward().then((_) {
                            controller.reverse();
                          });
                        });
                      },
                    )
                  ],
                )),
                Container(
                  child: Text('Test'),
                ),
              ]),
            ),
          ),
          Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Sign out'),
                    ),
                  ),
                ]),
          ),
        ])));
  }
}

class SecondRoute extends StatelessWidget {
  final Object items;

  SecondRoute({Key key, @required this.items}) : super(key: key);

  // @override
  // void initState() {
  //   print('Async done');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Shifts"),
      ),
      body: Center(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Container(
              child: Column(children: <Widget>[
                Container(
                    child: Container(
                  margin: const EdgeInsets.all(10),
                  color: Colors.blue,
                  child: Row(children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(children: <Widget>[
                        Text(
                          "test",
                        ),
                        Text("test"),
                      ]),
                    )
                  ]),
                )),
                Container(
                  child: Text('Test'),
                ),
              ]),
            ),
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Sign out'),
                      ),
                    ),
                  ]),
            ),
          ])),
    );
  }
}

Widget getTextWidgets(List<dynamic> strings) {
  return new Row(
      children: strings.map((item) => new Text('${item}.')).toList());
}

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new RotationTransition(
              turns: new Tween(begin: 0.0, end: 1.0).animate(controller),
              child: new Container(
                width: 150.0,
                height: 150.0,
                color: Colors.blue,
              ),
            ),
            new MaterialButton(
              child: new Text('Start Animation'),
              onPressed: () {
                setState(() {
                  controller.forward().then((_) {
                    controller.reverse();
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
