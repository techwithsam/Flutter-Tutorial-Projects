// Developer: Samuel Adekunle (acctgen1).

import 'package:flutter/material.dart';
import 'refresh.dart'; // we'll create another file for the page called refresh.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Refresh',
      darkTheme: ThemeData.dark(),
      home: RefreshPage(),
    );
  }
}