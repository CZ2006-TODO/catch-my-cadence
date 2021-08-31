import 'package:catch_my_cadence/main.dart';
import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

const String MAIN_SCREEN_ROUTE = '/main';

class MainScreen extends StatelessWidget {
  final String token;

  MainScreen({Key? key, required this.token}) : super(key: key) {
    // Connect to Spotify app.
    // TODO: Handle PlatformException if fail to connect to Spotify app.
    SpotifySdk.connectToSpotifyRemote(
        clientId: CLIENT_ID, redirectUrl: REDIRECT_URI, accessToken: token);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Screen"),
        ),
        body: Center(child: Text("This is the main screen."))
    );
  }
}