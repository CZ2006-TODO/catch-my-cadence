import 'dart:developer';
import 'dart:io';

import 'package:catch_my_cadence/main.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

const List<String> scopes = [
  "app-remote-control",
  "user-modify-playback-state",
  "user-read-currently-playing"
];

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(title: Text("Login Screen")),
        body: Center(
            child: TextButton(
          child: Text("Login to Spotify"),
          onPressed: () async {
            try {
              var token = await SpotifySdk.getAuthenticationToken(
                  clientId: clientID, redirectUrl: redirectURI,
                  scope: scopes.join(", "));
              // Save token into file.
              final appDirectory = await getApplicationDocumentsDirectory();
              File tokenFile = File("${appDirectory.path}/usrToken");
              tokenFile.writeAsString(token);
              // Navigate to main screen after successfully getting auth token.
              Navigator.of(ctx)
                  .pushReplacementNamed(MAIN_SCREEN_ROUTE, arguments: token);
            } on PlatformException catch (e) {
              log("PlatformException on getting auth token:\n${e.toString()}");
              showDialog(
                  context: ctx,
                  builder: (c) => ErrorDialog(
                      c,
                      "It seems that we have some trouble "
                      "authenticating you right now. Try again later!"),
                  barrierDismissible: false);
            } on MissingPluginException catch (e) {
              log("MissingPluginException on getting auth token:\n${e.toString()}");
              showDialog(
                  context: ctx,
                  builder: (c) => ErrorDialog(
                      c,
                      "Your platform is missing required SDKs for this app."
                      "Sorry!\n\n"),
                  barrierDismissible: false);
            }
          },
        )));
  }
}
