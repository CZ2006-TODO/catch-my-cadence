import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/screens/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

// SpotifyControllerModel is in charge of communicating and controlling the
// Spotify App.
// TODO: Only does connection right now. Should also implement other stuff like the playing logic.
class SpotifyControllerModel {
  late Stream<ConnectionStatus> spotifyConnection;

  SpotifyControllerModel(BuildContext ctx) {
    connectWithSpotify(ctx);
  }

  // connectWithSpotify: Calls the SpotifySdk.connectWithSpotify function
  // and shows user an error if connection fails.
  // This sets up a stream that will continue to monitor the connection
  // and will attempt to reconnect if the connection ever drops.
  Future<void> connectWithSpotify(BuildContext ctx) async {
    try {
      // Attempt to connect to Spotify.
      var res = await SpotifySdk.connectToSpotifyRemote(
          clientId: Config.clientId, redirectUrl: Config.redirectUri);
      log(res ? "Connection successful" : "Connection failed!");

      // Set up stream to poll Spotify connection. This allows the app
      // to check that it is continuously connected to Spotify when necessary.
      spotifyConnection = SpotifySdk.subscribeConnectionStatus()
        ..listen((event) async {
          log("Polling connection...");
          if (!event.connected) {
            log("Connection to Spotify app lost! Attempting reconnect...");
            await SpotifySdk.connectToSpotifyRemote(
                clientId: Config.clientId, redirectUrl: Config.redirectUri);
          }
          log("Poll complete!");
        }).onError((e) {
          log("Error attempting Spotify reconnect: ${e.toString()}");
        });
    } on PlatformException catch (e) {
      log("PlatformException: ${e.toString()}");

      // Check for the type of PlatformException.
      // There are 2 possible exceptions that both throw PlatformException:
      // 1. NotLoggedInException   : Thrown if user is not logged in on Spotify app.
      // 2. CouldNotFindSpotifyApp : Thrown if Spotify App not installed.
      String message = (e.toString().contains("CouldNotFindSpotifyApp"))
          ? "It seems you do not have the Spotify App installed!"
          : "You may have logged out of your Spotify App recently.\n\n"
              "Please check and come back!";
      showDialog(
        context: ctx,
        builder: (_) => FatalErrorDialog(title: "Uh oh!", message: message),
      );
    }
  }
}
