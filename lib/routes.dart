import 'dart:developer';

import 'package:catch_my_cadence/screens/about_screen.dart';
import 'package:catch_my_cadence/screens/confirm_connection_screen.dart';
import 'package:catch_my_cadence/screens/loading_screen.dart';
import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:catch_my_cadence/screens/settings_screen.dart';
import 'package:flutter/material.dart';

// RouteDelegator helps to navigate the different screens of the app.
class RouteDelegator {
  static const String LOADING_SCREEN_ROUTE = 'loading';
  static const String MAIN_SCREEN_ROUTE = 'main';
  static const String CONFIRM_CONNECTION_SCREEN_ROUTE = 'confirm_connect';
  static const String ABOUT_SCREEN_ROUTE = 'about';
  static const String SETTINGS_SCREEN_ROUTE = 'settings';

  static Route<dynamic> delegateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LOADING_SCREEN_ROUTE: // Loading screen
        log("Pushing LoadingScreen...");
        return MaterialPageRoute(
            settings: RouteSettings(name: LOADING_SCREEN_ROUTE),
            builder: (ctx) => LoadingScreen());
      case MAIN_SCREEN_ROUTE: // Main screen
        log("Pushing MainScreen...");
        return MaterialPageRoute(
            settings: RouteSettings(name: MAIN_SCREEN_ROUTE),
            builder: (ctx) => MainScreen());
      case CONFIRM_CONNECTION_SCREEN_ROUTE: // Confirm connection screen
        log("Pushing ConfirmConnectionScreen...");
        return MaterialPageRoute(
            settings: RouteSettings(name: CONFIRM_CONNECTION_SCREEN_ROUTE),
            builder: (ctx) => ConfirmConnectionScreen());
      case ABOUT_SCREEN_ROUTE: // About screen
        log("Pushing AboutScreen...");
        return MaterialPageRoute(
            settings: RouteSettings(name: ABOUT_SCREEN_ROUTE),
            builder: (ctx) => AboutScreen());
      case SETTINGS_SCREEN_ROUTE: // Settings screen
        log("Pushing SettingsScreen...");
        return MaterialPageRoute(
            settings: RouteSettings(name: SETTINGS_SCREEN_ROUTE),
            builder: (ctx) => SettingsScreen());
      default: // Unexpected error screen
        log("Pushing ErrorScreen...");
        return MaterialPageRoute(
            builder: (ctx) => Scaffold(body: Center(child: Text("Error!"))));
    }
  }
}
