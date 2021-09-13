import 'package:catch_my_cadence/screens/confirm_connection_screen.dart';
import 'package:catch_my_cadence/screens/loading_screen.dart';
import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:flutter/material.dart';

// RouteDelegator helps to navigate the different screens of the app.
class RouteDelegator {
  static const String LOADING_SCREEN_ROUTE = '/';
  static const String MAIN_SCREEN_ROUTE = '/main';
  static const String CONFIRM_CONNECTION_SCREEN_ROUTE = '/connect';

  static Route<dynamic> delegateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LOADING_SCREEN_ROUTE: // Loading screen
        return MaterialPageRoute(builder: (ctx) => LoadingScreen());
      case MAIN_SCREEN_ROUTE: // Main screen
        return MaterialPageRoute(builder: (ctx) => MainScreen());
      case CONFIRM_CONNECTION_SCREEN_ROUTE: // Confirm connection screen
        return MaterialPageRoute(builder: (ctx) => ConfirmConnectionScreen());
      default: // Unexpected error screen
        return MaterialPageRoute(
            builder: (ctx) => Scaffold(body: Center(child: Text("Error!"))));
    }
  }
}
