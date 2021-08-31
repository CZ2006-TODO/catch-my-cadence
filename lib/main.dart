import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';

import 'screens/loading_screen.dart';

const String CLIENT_ID = '';
const String REDIRECT_URI = '';

// App starts running from the main activity.
void main() {
  runApp(MaterialApp(
    title: "Catch My Cadence",
    // App always shows the loading screen when open.
    initialRoute: LOADING_SCREEN_ROUTE,
    onGenerateRoute: RouteDelegator.delegateRoute,
  ));
}
