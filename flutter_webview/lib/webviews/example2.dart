import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebExample2 extends StatefulWidget {
  WebExample2({Key key}) : super(key: key);

  @override
  _WebExample2State createState() => _WebExample2State();
}

class _WebExample2State extends State<WebExample2> {
  InAppWebViewController _webViewControl;
  double progress = 0;
  String urls = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example 2'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (_webViewControl != null) {
                _webViewControl.reload();
              }
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            progress < 1.0
                ? LinearProgressIndicator(
                    value: progress,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.green[700]),
                    backgroundColor: Colors.white,
                  )
                : Center(),
            Expanded(
              child: InAppWebView(
                initialUrl: "https://obounce.net",
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  debuggingEnabled: true,
                )),
                onProgressChanged: (_, load) {
                  setState(() {
                    this.progress = load / 100;
                  });
                },
                onWebViewCreated: (controller) {
                  _webViewControl = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    urls = url;
                  });
                  print('** ($urls) ****');
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    urls = url;
                  });
                  print('**000 ($urls) ****');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
