import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pull_to_refresh/customFunc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'nextpage.dart';

class RefreshPage extends StatefulWidget {
  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  bool _enablePullDown = true; // this enable our app to able to pull down
  RefreshController _refreshController; // the refresh controller
  var _scaffoldKey =
      GlobalKey<ScaffoldState>(); // this is our key to the scaffold widget
  @override
  void initState() {
    _refreshController =
        RefreshController(); // we have to use initState because this part of the app have to restart
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // the key we create up there
      appBar: AppBar(
        title: Text('Pull to Refresh'),
        centerTitle: true,
        elevation: 0,
      ),
// So inside the body widget we will implement pull to refresh, So first we call
      body: SmartRefresher(
        enablePullDown:
            _enablePullDown, // the bool we create, so this gave access to be able to pull the app down
        header: WaterDropHeader(
          waterDropColor: Colors.teal,
// complete: If the refresh is completed show this else failed
          complete: Text('Complete',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18,
                  fontWeight: FontWeight
                      .bold)), // you can customize this whatever you like
          failed:
              Text('Failed', style: TextStyle(color: Colors.red, fontSize: 18)),
        ),
        controller: _refreshController,
        onRefresh:
            _onRefresh, // we are going to inplement _onRefresh and _onLoading below our build method
        onLoading: _onLoading,
        child:
            txtlist(), // we are going to create a list of text in this dynamic ii()
      ),
    );
  }

  txtlist() {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          elevation: 10,
          child: ListTile(
            dense: true,
            title: Text('List - Dummy Text',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            leading: Text('$index'),
            subtitle: Text('subtitle'),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NextPage()));
              },
            ),
          ),
        );
      },
    );
  }

  _onLoading() {
    _refreshController
        .loadComplete(); // after data returned,set the footer state to idle
  }

  _onRefresh() {
    setState(() {
      Future<int> a =
          CustomFunction().checkInternetConnection(); // check internet access
      a.then((value) {
        if (value == 0) {
          CustomFunction().showToast(
              message:
                  'No Internet Connection'); // will show a toast if there is no internet
        } else {
          RefreshPage(); // if you want to refresh the whole page you can put the page name or
          txtlist(); // if you only want to refresh the list you can place this, so the two can be inside setState
          _refreshController.refreshCompleted();
// request complete,the header will enter complete state,
// resetFooterState : it will set the footer state from noData to idle
        }
      });
    });
  }

  // loadingpage() {
  //   FutureBuilder(
  //     future: txtlist(),
  //     builder: (context, load) {
  //     switch (load.connectionState) {
  //       case ConnectionState.none:
  //         return Text('');
  //         break;
  //       case ConnectionState.waiting:
  //         return CircularProgressIndicator();
  //         break;
  //       case ConnectionState.active:
  //         return Text('');
  //         break;
  //       case ConnectionState.done:
  //         return txtlist();
  //         break;
  //     }
  //     return Text('');
  //   });
  // }
}
