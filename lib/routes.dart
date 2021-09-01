import 'package:catch_my_cadence/screens/loading_screen.dart';
import 'package:catch_my_cadence/screens/login_screen.dart';
import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:flutter/material.dart';

// RouteDelegator helps to navigate the different screens of the app.
class RouteDelegator {
  static const String LOADING_SCREEN_ROUTE = '/';
  static const String MAIN_SCREEN_ROUTE    = '/main';
  static const String LOGIN_SCREEN_ROUTE   = '/login';

  static Route<dynamic> delegateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case LOADING_SCREEN_ROUTE: // Loading screen
        return MaterialPageRoute(builder: (ctx) => LoadingScreen());
      case MAIN_SCREEN_ROUTE: // Main screen
        if (args is String) {
          return MaterialPageRoute(builder: (ctx) => MainScreen(token: args));
        }
        continue error;
      case LOGIN_SCREEN_ROUTE: // Login screen
        return MaterialPageRoute(builder: (ctx) => LoginScreen());
      error:
      default: // Unexpected error screen
        return MaterialPageRoute(
            builder: (ctx) => Scaffold(body: Center(child: Text("Error!"))));
    }
  }
}
