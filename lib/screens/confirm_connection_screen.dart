import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';

// LoginScreen is a screen that prompts the user to connect the app to the
// Spotify app. This is done through directly opening the Spotify app, or
// by opening a fallback WebView to log in.
class ConfirmConnectionScreen extends StatelessWidget {
  const ConfirmConnectionScreen({Key? key}) : super(key: key);

  // confirmSpotifyLinkage : This function sets the first run flag to false
  // and then directs user to the main screen.
  Future<void> confirmSpotifyLinkage(BuildContext ctx) async {
    // Set first run flag to false.
    log("Setting first run flag to false...");
    Config.firstRunFlag = false;

    // Navigate to main screen.
    Navigator.of(ctx).pushReplacementNamed(RouteDelegator.MAIN_SCREEN_ROUTE);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(title: Text("Confirm Connection Screen")),
        body: Center(
            child: ElevatedButton(
          child: Text("Connect to Spotify"),
          onPressed: () async {
            confirmSpotifyLinkage(ctx);
          },
        )));
  }
}
