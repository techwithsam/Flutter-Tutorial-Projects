// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'package:workmanager/workmanager.dart';
// import 'package:flutter/material.dart';
// import 'page.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// //this is the name given to the background fetch
// const simplePeriodicTask = "simplePeriodicTask";
// // flutter local notification setup
// void showNotification( v, flp) async {
//   var android = AndroidNotificationDetails(
//       'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
//       priority: Priority.High, importance: Importance.Max);
//   var iOS = IOSNotificationDetails();
//   var platform = NotificationDetails(android, iOS);
//   await flp.show(0, 'Flutter', 'Notification', platform,
//       payload: 'Notificatoin working');
// }


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Workmanager.initialize(callbackDispatcher, isInDebugMode: true); //to true if still in testing lev turn it to false whenever you are launching the app
//   await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
//       existingWorkPolicy: ExistingWorkPolicy.replace,
//       frequency: Duration(minutes: 15),//when should it check the link
//       initialDelay: Duration(seconds: 5),//duration before showing the notification
//       constraints: Constraints(
//         networkType: NetworkType.connected,
//       ));
//   runApp(MyApp());
// }

// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) async {

//     FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
//     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = IOSInitializationSettings();
//     var initSetttings = InitializationSettings(android, iOS);
//     flp.initialize(initSetttings);

    
  
    
//    var response= await http.post('https://seeviswork.000webhostapp.com/api/testapi.php');
//    print("here================");
//    print(response);
//     var convert = json.decode(response.body);
//       if (convert['status']  == true) {
//         showNotification(convert['msg'], flp);
//       } else {
//       print("no messgae");
//       }


//     return Future.value(true);
//   });
// }



// class MyApp extends StatelessWidget {
//   MyApp();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Testing Stream',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: FirstPage(),
//       onGenerateRoute: (RouteSettings settings) {
//           switch (settings.name) {
//             case "/":
//               return MaterialPageRoute(
//                   builder: (context) => FirstPage(), maintainState: false);
//               break;
//             case "/v":
//               Map<String, Object> map = settings.arguments;
//               return MaterialPageRoute(
//                   builder: (context) => SecondPage(map), maintainState: false);
//               break;
//           }
//         });
//   }
// }


        



import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isRunning = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Mjpeg(
                isLive: isRunning.value,
                stream:
                    'http://64.74.184.131:8080/mjpg/video.mjpg?timestamp=1560785721651', //'http://192.168.1.37:8081',
              ),
            ),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  isRunning.value = !isRunning.value;
                },
                child: Text('Toggle'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(),
                          )));
                },
                child: Text('Push new route'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}