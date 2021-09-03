import 'dart:developer';
import 'dart:io';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // authenticateWithSpotify : Calls the SpotifySdk.getAuthenticationToken
  // function to get an auth token from Spotify. It will then save it into a
  // designated file.
  Future<void> authenticateWithSpotify(BuildContext ctx) async {
    try {
      // Open the Spotify App or a fallback WebView to authenticate user.
      var token = await SpotifySdk.getAuthenticationToken(
          clientId: Config.clientId, redirectUrl: Config.redirectUrl);

      // Save token into file.
      File tokenFile = await Config.tokenFilePath;
      tokenFile.writeAsString(token);

      // Navigate to main screen after successfully getting auth token.
      Navigator.of(ctx).pushReplacementNamed(RouteDelegator.MAIN_SCREEN_ROUTE,
          arguments: token);
    } on Exception catch (e) {
      log("Exception: ${e.toString()}");
      showDialog(
        context: ctx,
        builder: (c) => ErrorDialog(c, "Error logging in to Spotify!"),
        barrierDismissible: false,
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(title: Text("Login Screen")),
        body: Center(
            child: TextButton(
          child: Text("Login to Spotify"),
          onPressed: () async {
            authenticateWithSpotify(ctx);
          },
        )));
  }
}
