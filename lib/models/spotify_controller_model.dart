import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/models/get_song_bpm_model.dart';
import 'package:catch_my_cadence/screens/widgets/dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyControllerModel with ChangeNotifier {
  static final _spotify =
      SpotifyApi(SpotifyApiCredentials(Config.clientId, Config.clientSecret));

  late final BuildContext _ctx;

  // For ensuring connection to Spotify app.
  late Stream<ConnectionStatus> _connectionStream;

  // For checking player status.
  Timer? _playerStateChecker;
  PlayerState? _lastState;

  // Keeps track if the user wants songs to play.
  late bool isActive;

  // Used by the SpotifyControllerModel to search for songs.
  late CadencePedometerModel _cadenceModel;

  SpotifyControllerModel(BuildContext ctx) {
    this._ctx = ctx;
    setUpSpotifyConnection();
    _setInactiveState();

    _cadenceModel = CadencePedometerModel();
  }

  void setUpSpotifyConnection() async {
    await _ensureSpotifyConnection();
    _setUpConnectionStream();
  }

  Future<void> _ensureSpotifyConnection() async {
    try {
      await SpotifySdk.connectToSpotifyRemote(
          clientId: Config.clientId, redirectUrl: Config.redirectUri);
    } on PlatformException catch (e) {
      showDialog(
          context: this._ctx,
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

  Future<String> searchTrackByTitle(TempoSong song) async {
    final searchString = "${song.songTitle} ${song.artist.name}";
    var search = await _spotify.search
        .get(searchString, types: [SearchType.track])
        .first(1)
        .catchError((err) {
          print((err as SpotifyException).message);
        });

    var firstPage = search.first;
    var firstTrack = firstPage.items?.first;

    if (firstTrack is Track && firstTrack.uri != null) {
      log('Track URI: ${firstTrack.uri}\n');
      return firstTrack.uri!;
    }
    return "";
  }

  Future<void> findAndPlaySong() async {
    // Start cadence calculation.
    _cadenceModel.start();
    // Wait for 10 seconds to get an accurate reading of the cadence.
    await Future.delayed(Duration(seconds: 10));
    int calculatedCadence = _cadenceModel.cadence;
    _cadenceModel.stop(); // Remember to stop the CadencePedometerModel.

    // Use calculated cadence to find songs.
    List<TempoSong> songs = await GetSongBPMModel.getSongs(calculatedCadence);

    // Select a random song from the list.
    final random = math.Random();
    TempoSong selectedSong = songs[random.nextInt(songs.length)];

    // Once we select this song, then we find the Spotify URI for this song.
    final spotifyUri = await searchTrackByTitle(selectedSong);

    SpotifySdk.play(spotifyUri: spotifyUri);

    // Set up a future that will find the next song.
    // Get current player state.
    _lastState = await SpotifySdk.getPlayerState();
    int delay =
        _lastState!.track!.duration - Duration(seconds: 17).inMilliseconds;
    Future.delayed(Duration(milliseconds: delay), () {
      findAndPlaySong();
    });
  }

  void _setActiveState() async {
    isActive = true;
    await findAndPlaySong();
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
