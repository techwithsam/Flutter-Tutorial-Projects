// Developer: Samuel Adekunle (techwithsam).

import 'package:flutter/material.dart';
import 'package:flutter_pull_to_refresh/screens/mainpage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Refresh',
      theme: ThemeData(
        accentColor: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
