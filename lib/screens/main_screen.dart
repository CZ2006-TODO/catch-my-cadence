import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class MainScreen extends StatefulWidget {
  final String token;

  MainScreen({Key? key, required this.token}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // connectWithSpotify: Calls the SpotifySdk.connectWithSpotify function
  // and shows user an error if connection fails.
  Future<void> connectWithSpotify() async {
    try {
      // Attempt to connect to Spotify
      var res = await SpotifySdk.connectToSpotifyRemote(
          clientId: Config.clientId,
          redirectUrl: Config.redirectUrl,
          accessToken: widget.token);
      log(res ? "Connection successful" : "Connection failed!");
    } on PlatformException catch (e) {
      log("PlatformException: ${e.toString()}");
      showDialog(
        context: context,
        builder: (_) => FatalErrorDialog(
            "It seems you do not have the Spotify App installed!"),
        barrierDismissible: false,
      );
    }
  }

  @override
  initState() {
    super.initState();
    // Connect with Spotify here.
    connectWithSpotify();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Screen"),
        ),
        body: Center(child: Text("This is the main screen.")));
  }
}
