import 'package:flutter/material.dart';

class NextPage extends StatefulWidget {

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Next Page', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}