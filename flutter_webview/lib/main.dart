import 'package:flutter/material.dart';
import 'web.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google', // change this to your company description
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: WebView(
        title: "Google", // change this to your company name
        selectedUrl: "https://google.com/", // change the url to your desire url
      ),
    );
  }
}

