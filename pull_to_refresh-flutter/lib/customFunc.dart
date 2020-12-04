import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';


class CustomFunction{
showToast({String message}) {
Fluttertoast.showToast(
msg: message,
toastLength: Toast.LENGTH_SHORT,
gravity: ToastGravity.CENTER,
timeInSecForIos: 1,
backgroundColor: Colors.redAccent,
textColor: Colors.white,
fontSize: 20.0);
}
Future<int> checkInternetConnection() async {
var result = await Connectivity().checkConnectivity();
if (result == ConnectivityResult.none) {
return 0;
} else if (result == ConnectivityResult.mobile) {
return 1;
} else if (result == ConnectivityResult.wifi) {
return 1;
} else {
return 0;
}}
}