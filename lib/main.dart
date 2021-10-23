import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App starts running from the main activity.
Future<void> main() async {
  // Do this so we can load preferences here.
  WidgetsFlutterBinding.ensureInitialized();
  Config.prefs = await SharedPreferences.getInstance();

  runApp(MaterialApp(
    theme: Config.getTheme(),
    title: "Catch My Cadence",
    // App always shows the loading screen when open.
    initialRoute: RouteDelegator.LOADING_SCREEN_ROUTE,
    onGenerateRoute: RouteDelegator.delegateRoute,
  ));
}
