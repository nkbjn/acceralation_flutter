import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';
//import "acceralation.dart";
import "acceralation.dart" as acc;
import 'package:http/http.dart' as http;
import 'post.dart';
import 'dart:convert';
import 'dart:math';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ACCELEROMETER AND GYROSCOPE Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<Post> post;

  acc.Acceralation acceralation;
  List<acc.Acceralation> acceralation_list = [];

  List<double> _gyroscopeValues;

  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  int step = 0;
  //x,y,z xは縦軸，yは横軸，zは奥行き
  //gyro : デバイスの回転を示す

  @override
  void initState() {
    super.initState();
    print("init start");
    getacceralation();
    post = fetchPost();
    Timer.periodic(const Duration(seconds: 2), getData);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> gyroscopemeter = _gyroscopeValues?.map((double v) =>
        v.toStringAsFixed(1))?.toList();
    final String gyro_x = _gyroscopeValues[0].toStringAsFixed(2);
    final String gyro_y = _gyroscopeValues[1].toStringAsFixed(2);

    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void getacceralation(){
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acceralation = acc.Acceralation(event.x, event.y, event.z);
        acceralation_list.add(acceralation);
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  void getData(Timer timer){
//    acceralation_list.forEach((e){
//      print(e.getStep(e));
//    });
    acc.getStep(acceralation_list);
    acceralation_list.clear();

  }

}

Future<Post> fetchPost() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}


