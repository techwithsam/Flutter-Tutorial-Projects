import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebExample1 extends StatefulWidget {
  WebExample1({Key key}) : super(key: key);

  @override
  _WebExample1State createState() => _WebExample1State();
}

class _WebExample1State extends State<WebExample1> {
  final _flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'https://obounce.net',
      appBar: AppBar(
        title: Text('O\'Bounce Technologies'),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: Text('This is a bottomNavigationBar in a webview page'),
      ),
      withZoom: true,
      withLocalStorage: true,
      withJavascript: true,
      scrollBar: false,
      hidden: true,
      initialChild: Center(
        child: Text('Loading.....'),
      ),
    );
  }

  @override
  void dispose() {
    _flutterWebviewPlugin.dispose();
    super.dispose();
  }
}
