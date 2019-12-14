import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';
//import "acceralation.dart";
import "acceralation.dart" as acc;
import 'package:http/http.dart' as http;
import 'UserRegist.dart';
import 'dart:convert';
import 'dart:math';


int step_sum = 0;
int step_now = 0;
String name = 'user_1';

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

  acc.Acceralation acceralation;
  List<acc.Acceralation> acceralation_list = [];

  List<double> _gyroscopeValues;

  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  //x,y,z xは縦軸，yは横軸，zは奥行き
  //gyro : デバイスの回転を示す

  @override
  void initState() {
    super.initState();
    getacceralation();
//    UserRegistRequest();
//    UserStepRequest();
//    post = fetchPost();
//    post.then((context) => {
//      print(context);
//    });
//    print('222222222222222222222222222222222222222222222222222');
    Timer.periodic(const Duration(milliseconds: 500), getData);
    Timer.periodic(const Duration(milliseconds: 500), UserStepRequest);

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
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
//                Text('Accelerometer: $accelerometer',
//                  style: TextStyle(fontSize: 15),
//                ),
//                Padding(padding: EdgeInsets.all(15)),
//
//                Text('ACCEL_X: $accel_x',
//                  style: TextStyle(fontSize: 15),
//                ),
//
//                Padding(padding: EdgeInsets.all(15)),

              Text('歩数 : ${step_sum}',
                style: TextStyle(fontSize: 30),
              )
              ],
            ),
          ],
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
    step_now = acc.getStep(acceralation_list);
    step_sum += step_now;
    acceralation_list.clear();
  }

}

//Future<Post> fetchPost() async {
//
//  final response =
//  await http.get('http://d11f9a85.ngrok.io/location/update');
//
//  if (response.statusCode == 200) {
////    If server returns an OK response, parse the JSON.
////    print(response.body);
////    print("111111111111111111111111111111111111111111111111111");
//    return Post.fromJson(json.decode(response.body));
//  } else {
//    // If that response was not OK, throw an error.
//    throw Exception('Failed to load post');
//  }
//}


void UserRegistRequest() async {
  String url = "http://d11f9a85.ngrok.io/location/update";
  Map<String, String> headers = {'content-type': 'application/json'};
  String body = json.encode({'name':'user_1','x':3,'y':4,'step':1});
  http.Response resp = await http.post(url, headers: headers, body: body);

  if (resp.statusCode != 200) {
    return;
  }
//  print(json.decode(resp.body));
//  print(resp.body);
}


void UserStepRequest(Timer timer) async {
  String url = "http://d11f9a85.ngrok.io/location/update";
  Map<String, String> headers = {'content-type': 'application/json'};
  String body = json.encode({'name':name,'step':step_now});
  http.Response resp = await http.post(url, headers: headers, body: body);
  if (resp.statusCode != 200) {
    return;
  }
  print(json.decode(resp.body));
//  print(resp.body);
}

//   UserRegist post = UserRegist(name:'user_1',x:2,y:2,step:4);
