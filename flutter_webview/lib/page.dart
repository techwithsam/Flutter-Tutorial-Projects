import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'webviews/example1.dart';
import 'webviews/example2.dart';
import 'webviews/example4.dart';
import 'webviews/example3.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MyInAppBrowser inAppbrowser = MyInAppBrowser();
  final ChromeSafariBrowser inAppChrome =
      MyChromeSafariBrowser(MyInAppBrowser());

  @override
  void initState() {
    super.initState();
    inAppChrome.addMenuItem(ChromeSafariBrowserMenuItem(
        id: 1,
        label: 'Custom item menu 1',
        action: (url, title) {
          print('Custom item menu 1 clicked!');
          print(url);
          print(title);
        }));
    inAppChrome.addMenuItem(ChromeSafariBrowserMenuItem(
        id: 2,
        label: 'Custom item menu 2',
        action: (url, title) {
          print('Custom item menu 2 clicked!');
          print(url);
          print(title);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Webview Tutorial'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => WebExample1()));
                },
                child: Text('Example 1', style: TextStyle(color: Colors.white)),
                color: Colors.pink,
              ),
              SizedBox(height: 12),
              MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WebExample2()));
                },
                child: Text('Example 2', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              SizedBox(height: 12),
              MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  inAppbrowser.openUrl(url: 'https://obounce.net');
                },
                child: Text('Example 3', style: TextStyle(color: Colors.white)),
                color: Colors.purple,
              ),
              SizedBox(height: 12),
              MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  inAppChrome.open(
                      url: 'https://obounce.net',
                      options: ChromeSafariBrowserClassOptions(
                          android: AndroidChromeCustomTabsOptions(
                              addDefaultShareMenuItem: true),
                          ios: IOSSafariOptions()));
                },
                child: Text('Example 4', style: TextStyle(color: Colors.white)),
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
