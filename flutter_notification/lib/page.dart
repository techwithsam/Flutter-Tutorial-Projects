import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hk/hk_controller.dart';
import 'package:flutter_hk/hk_player.dart';
import 'package:flutter_hk/hk_player_controller.dart';

class FirstPage extends StatelessWidget {
  String ip;
  int port = 0;
  String user, psd;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Streaming Demo"),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10), labelText: "Enter ip"),
                  // initialValue: "218.2.210.206",
                  onSaved: (v) => this.ip = v,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10), labelText: "Enter port"),
                  // initialValue: "8000",
                  onSaved: (v) => this.port = int.parse(v),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10), labelText: "Enter User"),
                  // initialValue: "admin",
                  onSaved: (v) => this.user = v,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10), labelText: "Enter the password"),
                  // initialValue: "admin",
                  onSaved: (v) => this.psd = v,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator.pushNamed(context, "/v", arguments: {
                        "ip": ip,
                        "port": port,
                        "user": user,
                        "psd": psd,
                      });
                    }
                  },
                ),
                IconButton(icon: Icon(Icons.pages),
                onPressed: (){
                  HkController.platformVersion.then((v)=>print("output:" + v));
                },)
              ],
            )));
  }
}

class SecondPage extends StatefulWidget {
  String ip;
  int port = 0;
  String user, psd;

  SecondPage(Map<String, Object> map) {
    ip = map["ip"];
    port = map["port"];
    psd = map["psd"];
    user = map["user"];
  }
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  _SecondPageState({cameras});
  String pltformVersion = 'Unknown';
  HkController hkController;
  HkPlayerController playerController;
  Map cameras;
  String errMsg = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    this.hkController.logout();
    this.hkController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      hkController = HkController("hk"); // Must have a name, if you have multiple cameras or hard disk recorders, you must define multiple
      playerController = HkPlayerController(hkController); // If you have multiple players, you need to define multiple

      await hkController.init();
      await hkController.login(
          this.widget.ip, this.widget.port, this.widget.user, this.widget.psd);

      var chans = await hkController.getChans();

      if (!mounted) return;

      setState(() {
        cameras = chans;
      });
    } catch (e, r) {
      setState(() {
        errMsg = e.toString();
      });
    }
  }

  Widget buildCameras(Map cameras) {
    var list = List<Widget>();
    List<int> keys = List.from(cameras.keys);
    keys.sort((l, r) => l.compareTo(r));
    for (int key in keys) {
      list.add(FlatButton(
        child: Text(cameras[key]),
        padding: EdgeInsets.all(1),
        color: Colors.lightBlueAccent,
        onPressed: () {
          if (this.playerController.isPlaying) {
            this.playerController.stop();
          }
          this.playerController.play(key);
        },
      ));
    }
    return Container(
      height: 200,
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: list,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loading() {
      if (this.cameras == null) {
        if (errMsg == null) {
          return Center(
            child: Text("logging in. . ."),
          );
        } else {
          return Center(
            child: Text('$errMsg iii'),
          );
        }
      } else {
        return Column(
          children: [
            buildCameras(this.cameras),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4),
                child: HkPlayer(
                  chan: 1,
                  controller: this.playerController,
                ),
              ),
            ),
          ],
        );
      }
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: loading(),
      ),
    );
  }
}


// https://www.behance.net/gallery/59155539/Delivery-Boy-Mobile-App
// https://dribbble.com/shots/4642751-Delivery-Boy-App