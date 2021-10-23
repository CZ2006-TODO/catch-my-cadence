import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/models/get_song_bpm_model.dart';
import 'package:catch_my_cadence/screens/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

// SpotifyControllerModel is in charge of maintaining connection between
// the app and the Spotify app, as well as for managing the player.
// Also includes functionality to find new songs when instructed by the user.
class SpotifyControllerModel with ChangeNotifier {
  // For interfacing with Spotify Web API.
  static final _spotify =
      SpotifyApi(SpotifyApiCredentials(Config.clientId, Config.clientSecret));

  // Miscellaneous requirements.
  late final BuildContext _ctx;
  late final math.Random _random;

  // For ensuring connection to Spotify app.
  late Stream<ConnectionStatus> _connectionStream;

  // For checking player status.
  Timer? _playerStateUpdater;
  PlayerState? _lastState;

  // Keeps track if the user wants songs to play songs.
  late bool _isActive;
  Timer? _finder; // Delayed runner to find new song.

  // Used by the SpotifyControllerModel to search for songs.
  late CadencePedometerModel _cadenceModel;

  SpotifyControllerModel(BuildContext ctx) {
    this._ctx = ctx;
    this._random = math.Random();

    // Initialise required connections to Spotify app.
    _setUpSpotifyConnection();
    // Model starts off in inactive state.
    _setInactiveState();

    // Initialise the CadencePedometerModel.
    _cadenceModel = CadencePedometerModel();
  }

  // _setUpSpotifyConnection : Attempts to connect to the Spotify app
  // and maintain that connection while the app is running.
  void _setUpSpotifyConnection() async {
    await _ensureSpotifyConnection();
    _setUpConnectionStream();
  }

  // _ensureSpotifyConnection : Connects to the Spotify app once.
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

  // _setUpConnectionStream : Subscribes to connection status with the Spotify
  // App. If connection is ever lost with the app, it will attempt to reconnect.
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

  // toggleStatus : Toggles the model between active and inactive state.
  void toggleStatus() {
    _isActive = !_isActive;
    if (_isActive) {
      log("Active state set to true.");
      _setActiveState();
    } else {
      log("Active state set to false.");
      _setInactiveState();
    }
    notifyListeners();
  }

  // _setActiveState : Sets the model to active state. Calling this function
  // initialises a "state loop" where the model will:
  // 1. Continuously calculate cadence
  // 2. Find songs to play with calculated cadence.
  // This will repeat until the user puts the model to inactive state.
  void _setActiveState() {
    _isActive = true;

    // Set up a new periodic player state checker.
    // Required since SpotifySdk.subscribePlayerState is not regularly updated.
    // https://github.com/brim-borium/spotify_sdk/issues/13
    // Helps to update the player state every 1 second.
    _playerStateUpdater = Timer.periodic(Duration(seconds: 1), (_) async {
      _lastState = await SpotifySdk.getPlayerState();
      notifyListeners();
    });

    // Initialises a loop for the model to calculate cadence and play songs.
    _findAndPlaySong();
  }

  // ---------------------------------------------------------------------------
  Future<void> _findAndPlaySong() async {
    // Calculate cadence with sample time of 10 seconds.
    int cadence = await _cadenceModel.calculateCadence(10);
    if (!_isActive) {
      return;
    }

    // Use calculated cadence to find songs.
    List<TempoSong> songs = await GetSongBPMModel.getSongs(cadence);
    if (!_isActive) {
      return;
    }

    // Select a random song from the list.
    TempoSong selectedSong = songs[_random.nextInt(songs.length)];
    // Once we select this song, then we find the Spotify URI for this song.
    final uri = await _getTrackSpotifyURI(selectedSong);
    if (!_isActive) {
      return;
    }

    // Play the required song!
    SpotifySdk.play(spotifyUri: uri);
    if (!_isActive) {
      return;
    }

    // Set up a future that will find the next song.
    // Get current player state.
    _lastState = await SpotifySdk.getPlayerState();
    if (!_isActive) {
      return;
    }

    // Start finding the next song a few seconds before the end of the current
    // song.
    final before = 15;
    int wait = _lastState!.track!.duration -
        Duration(seconds: before).inMilliseconds;
    if (!_isActive) {
      return;
    }

    _finder = Timer(Duration(milliseconds: wait), () {
      _findAndPlaySong();
    });
  }

  Future<String> _getTrackSpotifyURI(TempoSong song) async {
    final searchString = "${song.songTitle} ${song.artist.name}";
    var search = await _spotify.search
        .get(searchString, types: [SearchType.track]) // Do the search
        .first(1) // Get the first 1 page(s) of results.
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

  // _setInactiveState : Sets the model to inactive state.
  // This will also stop the playerStateUpdater and cancels any upcoming searches.
  void _setInactiveState() {
    _isActive = false;
    _finder?.cancel();
    // Stop the player state checker.
    _playerStateUpdater?.cancel();
    // Also stop playing any song that is being played.
    SpotifySdk.pause();
  }

  // isActive : Whether the model is actively finding and playing songs.
  bool get isActive {
    return this._isActive;
  }

  // playerState : Gets the latest player state returned from the Spotify app.
  PlayerState? get playerState {
    return _isActive ? this._lastState : null;
  }
}
