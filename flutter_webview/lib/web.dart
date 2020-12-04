// this is the webview code

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {
  // so here we're taking the url and title from our main.dart page
  // so we can pass it to the webview page
  final String title;
  final String selectedUrl;
  WebView({
    Key key,
    @required this.title,
    @required this.selectedUrl,
  }) : super(key: key);

  @override
  _WebViewState createState() =>
      _WebViewState(title: title, selectedUrl: selectedUrl);
}

class _WebViewState extends State<WebView> {
  final String title;
  final String selectedUrl;
  _WebViewState({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        // you can make use of the appbar if you wish to
        // appBar: AppBar(
        //   title: Text('$title'),
        //   centerTitle: true,
        //   elevation: 0,
        // ),
        url: selectedUrl,
        withZoom: false,
        withJavascript: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
