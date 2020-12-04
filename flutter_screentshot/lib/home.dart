import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  GlobalKey scr = GlobalKey();
  GlobalKey scr1 = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: scr,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Flutter Screenshot Example'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RepaintBoundary(
                  key: scr1,
                  child: FlutterLogo(
                    size: 100,
                    textColor: Colors.pink,
                    style: FlutterLogoStyle.stacked,
                  )),
              SizedBox(height: 30),
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () {
                      saveScreen();
                    },
                    child: Text('The fullscreen shot'),
                    color: Colors.blue,
                  ),
                  MaterialButton(
                      onPressed: () {
                        saveScreen1();
                      },
                      child: Text('Only flutter logo shot'),
                      color: Colors.red),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  saveScreen() async {
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    if (boundary.debugNeedsPaint) {
      Timer(Duration(seconds: 1), () => saveScreen());
      return null;
    }
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final result =
        await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    print('$byteData ********** Saved to gallery *********** $result');
    _showInSnackBar(message: 'Saved to gallery - full screen');
  }

  saveScreen1() async {
    RenderRepaintBoundary boundary = scr1.currentContext.findRenderObject();
    if (boundary.debugNeedsPaint) {
      Timer(Duration(seconds: 1), () => saveScreen1());
      return null;
    }
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final result =
        await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    print('$byteData ********** Saved to gallery *********** $result');
    _showInSnackBar(message: 'Saved to gallery - Flutter Logo');
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print('$info');
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _showInSnackBar({String message}) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        duration: (Duration(seconds: 3)),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
    );
  }
}
