import 'package:flutter/material.dart';
import 'package:flutter_local_auth/services/local_authentication_service.dart';
import 'package:flutter_local_auth/services/service_locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthenticationService _localAuth = locator<LocalAuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FingerPrint Auth'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Use fingerprint'),
          onPressed: _localAuth.authenticate,
        ),
      ),
    );
  }
}
// 116533.20000
