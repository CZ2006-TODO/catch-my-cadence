import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';

late String clientId;
late String redirectUrl;

// App starts running from the main activity.
void main() {
  runApp(MaterialApp(
    title: "Catch My Cadence",
    // App always shows the loading screen when open.
    initialRoute: RouteDelegator.LOADING_SCREEN_ROUTE,
    onGenerateRoute: RouteDelegator.delegateRoute,
  ));
}
