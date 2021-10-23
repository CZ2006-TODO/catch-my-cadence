import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/screens/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyControllerModel with ChangeNotifier {
  // For ensuring connection to Spotify app.
  late Stream<ConnectionStatus> _connectionStream;

  // For checking player status.
  late Stream<PlayerState> _playerStream;

  // Keeps track if the user wants songs to play.
  late bool isActive;

  SpotifyControllerModel(BuildContext ctx) {
    setUpSpotifyConnection(ctx);
    isActive = false;
  }

  void setUpSpotifyConnection(BuildContext ctx) async {
    await ensureSpotifyConnection(ctx);
    setUpDataStreams();
  }

  Future<void> ensureSpotifyConnection(BuildContext ctx) async {
    try {
      await SpotifySdk.connectToSpotifyRemote(
          clientId: Config.clientId, redirectUrl: Config.redirectUri);
    } on PlatformException catch (e) {
      showDialog(
          context: ctx,
          builder: (_) =>
              FatalErrorDialog(title: "Uh oh!", message: e.toString()));
    }
  }

  void setUpDataStreams() {
    _connectionStream = SpotifySdk.subscribeConnectionStatus();
    _connectionStream.listen((event) async {
      log("Polling Spotify App connection...");
      if (!event.connected) {
        log("Not currently connected to Spotify App, attempting reconnect...");
        var res = await SpotifySdk.connectToSpotifyRemote(
            clientId: Config.clientId, redirectUrl: Config.redirectUri);
        log(res
            ? "Connection established!"
            : "Unable to connect to Spotify App.");
      }
      log("Poll complete!");
    }).onError((e) {
      log("Error polling Spotify connection: ${e.toString()}");
    });

    _playerStream = SpotifySdk.subscribePlayerState();
    _playerStream.listen((event) {});
  }

  void toggleStatus() {
    isActive = !isActive;
    notifyListeners();
  }
}
