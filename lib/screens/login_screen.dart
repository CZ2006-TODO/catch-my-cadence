import 'dart:io';

import 'package:catch_my_cadence/main.dart';
import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

const String LOGIN_SCREEN_ROUTE = '/login';

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
            // TODO: Handle PlatformException if fail to get valid auth token.
            var token = await SpotifySdk.getAuthenticationToken(
                clientId: CLIENT_ID, redirectUrl: REDIRECT_URI);
            // Save token into file.
            final appDirectory = await getApplicationDocumentsDirectory();
            File tokenFile = File("${appDirectory.path}/usrToken");
            tokenFile.writeAsString(token);

            Navigator.of(ctx)
                .pushReplacementNamed(MAIN_SCREEN_ROUTE, arguments: token);
          },
        )));
  }
}
