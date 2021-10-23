import 'dart:async';
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
  Timer? _playerStateChecker;
  PlayerState? _lastState;

  // Keeps track if the user wants songs to play.
  late bool isActive;

  SpotifyControllerModel(BuildContext ctx) {
    setUpSpotifyConnection(ctx);
    _setInactiveState();
  }

  void setUpSpotifyConnection(BuildContext ctx) async {
    await _ensureSpotifyConnection(ctx);
    _setUpConnectionStream();
  }

  Future<void> _ensureSpotifyConnection(BuildContext ctx) async {
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

  void _setUpConnectionStream() {
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
  }

  void toggleStatus() {
    isActive = !isActive;
    if (isActive) {
      log("Active state set to true.");
      _setActiveState();
    } else {
      log("Active state set to false.");
      _setInactiveState();
    }
    notifyListeners();
  }

  void _setActiveState() {
    isActive = true;
    // Set up a new periodic state checker.
    // Required since SpotifySdk.subscribePlayerState is not regularly updated.
    _playerStateChecker = Timer.periodic(Duration(seconds: 1), (timer) async {
      _lastState = await SpotifySdk.getPlayerState();
      notifyListeners();
    });
  }

  void _setInactiveState() {
    isActive = false;
    // Stop the player state checker.
    _playerStateChecker?.cancel();
  }

  PlayerState? get playerState {
    return isActive ? this._lastState : null;
  }
}
