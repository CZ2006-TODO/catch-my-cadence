import 'package:catch_my_cadence/util/AppConstants.dart';

import 'util/ConnectivityService.dart';

import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';

//gradlew signingReport
// App starts running from the main activity.
void main() {
  runApp(new CadenceApp());
}

class CadenceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityResult>(
      create: (context) =>
          ConnectivityService().connectionStatusController.stream,
      child: new CadenceMainApp(),
      initialData: ConnectivityResult.none,
    );
  }
}

class CadenceMainApp extends StatefulWidget {
  CadenceMainApp() : super();

  final String title = "Catch my Cadence";

  @override
  CadenceMainAppState createState() => CadenceMainAppState();
}

class CadenceMainAppState extends State<CadenceMainApp> {
  ConnectivityResult _networkStatus = ConnectivityResult.none;
  ConnectivityService connService = new ConnectivityService();
  bool _first = true;
  @override
  Widget build(BuildContext context) {
    checkConnectivity();
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      title: "Catch My Cadence",
      // App always shows the loading screen when open.
      initialRoute: RouteDelegator.LOADING_SCREEN_ROUTE,
      onGenerateRoute: RouteDelegator.delegateRoute,
    );
  }

  void checkConnectivity() async {
    var connectivityResult = Provider.of<ConnectivityResult>(context);
    var conn = connectivityResult;
    if (!_first) {
      //Check if network status has gone from Wifi/Mobile at first to disconnected.
      if ((_networkStatus == ConnectivityResult.mobile ||
              _networkStatus == ConnectivityResult.wifi) &&
          conn == ConnectivityResult.none) {
        AppConstants.toastShortError("Network was disconnected");
      } else if (_networkStatus == ConnectivityResult.none &&
          (conn == ConnectivityResult.wifi ||
              conn == ConnectivityResult.mobile)) {
        //Check if network status was disconnected at first and has recovered to Wifi/Mobile.
        connService.checkConnectivity().then((value) {
          if (value == true) {
            AppConstants.toastShortSuccess("Network connection restored");
          }
        });
      }
    }
    setState(() {
      _networkStatus = conn;
      _first = false;
    });
  }
}
