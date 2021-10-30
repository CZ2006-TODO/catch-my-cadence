import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/models/get_song_bpm_model.dart';
import 'package:catch_my_cadence/screens/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

// SpotifyControllerModel is in charge of maintaining connection between
// the app and the Spotify app, as well as for managing the player.
// Also includes functionality to find new songs when instructed by the user.
class SpotifyControllerModel with ChangeNotifier {
  // For interfacing with Spotify Web API.
  static final _spotify =
      SpotifyApi(SpotifyApiCredentials(Config.clientId, Config.clientSecret));

  // How many seconds before we start finding a new song.
  static final _loopThreshold = 15;

  // How many seconds to allow for calculation of the cadence.
  static final _cadencePollPeriod = 10;

  // How many milliseconds to wait for Spotify app to play the song before
  // pausing it.
  static final _pauseDelayMilliseconds = 500;

  // Miscellaneous requirements.
  final BuildContext _ctx;
  final math.Random _random = math.Random();

  // For ensuring connection to Spotify app.
  late Stream<ConnectionStatus> _connectionStream;

  // Used by the SpotifyControllerModel to search for songs.
  final CadencePedometerModel _cadenceModel = CadencePedometerModel();

  // Player status.
  Timer? _playerStateUpdater;
  PlayerState? _lastState;
  ImageUri? _imageUri;

  // Keeps track if the user wants songs to play songs.
  bool _isActive = false;
  bool _hasStartedFind = false; // Flag to check if app already finding new song
  bool _isPaused = false; // Flag to check if player paused song while finding.

  // Cadence data
  String _cadenceValue = "-";
  String _cadenceStatus = "Inactive";

  SpotifyControllerModel(this._ctx) {
    // Set inactive state.
    _setInactiveState();
    // Initialise required connections to Spotify app.
    _setUpSpotifyConnection();
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
        // Since it was initially disconnected, we should reset to inactive state.
        this._setInactiveState();
        notifyListeners();
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
  Future<void> _setActiveState() async {
    _isActive = true;
    _performPlayLoop();
  }

  // _performPlayLoop : This function sets up a looping "state machine" for the
  // model such that it attempts to find a new song everytime the current song
  // is about to end.
  Future<void> _performPlayLoop() async {
    await _calculateCadenceAndPlaySong();

    // Set up a new periodic player state checker.
    // Required since SpotifySdk.subscribePlayerState is not regularly updated.
    // https://github.com/brim-borium/spotify_sdk/issues/13
    // Helps to update the player state every 1 second.

    // Cancel the previous timer.
    _playerStateUpdater?.cancel();
    _playerStateUpdater = Timer.periodic(Duration(seconds: 1), (timer) async {
      // Catch instances where active state has been set to false
      // while the periodic updater is still active.
      if (!_isActive) {
        timer.cancel();
        return;
      }

      // Update PlayerState.
      _lastState = await SpotifySdk.getPlayerState();
      notifyListeners();
      var state = _lastState;

      // We check how much time is left. If the song is finishing, then we
      // have to start finding a new song.
      var track = state?.track;
      if (state == null || track == null) {
        return;
      }

      // Check for change in image.
      if (this._imageUri?.raw != track.imageUri.raw) {
        _imageUri = track.imageUri;
        notifyListeners();
      }

      // Check for paused status.
      _isPaused = state.isPaused;

      // Get time to end of song.
      int timeLeft = track.duration - state.playbackPosition;
      if (Duration(milliseconds: timeLeft).inSeconds < _loopThreshold &&
          !_hasStartedFind) {
        _hasStartedFind = true;
        Fluttertoast.showToast(
            msg: "Finding new song...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
        _performPlayLoop();
      }
    });
  }

  // _calculateCadenceAndPlaySong : Calculates the current cadence
  // and plays a song matching that cadence.
  Future<void> _calculateCadenceAndPlaySong() async {
    _cadenceStatus = "Calculating...";
    _cadenceValue = "Polling...";
    notifyListeners();

    // Calculate cadence with sample time of 10 seconds.
    int cadence = await _cadenceModel.calculateCadence(_cadencePollPeriod);
    // If the returned cadence is -1 (to indicate failure), we just return.
    if (!_isActive || cadence == -1) {
      return;
    }

    _cadenceStatus = "Complete!";
    _cadenceValue = cadence.toString();
    notifyListeners();

    // Use calculated cadence to find songs.
    List<TempoSong> songs;
    TempoSong selectedSong;
    final String uri;
    try {
      songs = await GetSongBPMModel.getSongs(cadence);
      if (!_isActive) {
        return;
      }
      // Select a random song from the list.
      selectedSong = songs[_random.nextInt((songs.length / 4).ceil())];
      // Once we select this song, then we find the Spotify URI for this song.
      uri = await _getTrackSpotifyURI(selectedSong);
      if (!_isActive) {
        return;
      }
    } on HttpException catch (e) {
      // Error getting a song, so stop everything.
      Fluttertoast.showToast(
        msg: "Cadence error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      log("Error getting a new song to play: ${e.message}\n"
          "Setting to inactive state...");
      this._setInactiveState();
      notifyListeners();
      return;
    }

    // Play the required song!
    bool paused = _isPaused;
    Fluttertoast.showToast(
      msg: "'${selectedSong.songTitle}': ${selectedSong.tempo}BPM",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
    await SpotifySdk.play(spotifyUri: uri);
    if (paused) {
      log("Player was paused while finding song, so pausing...");
      // We need to delay to allow the Spotify app to receive the play command,
      // so we can actually pause the next song that is playing.
      await Future.delayed(Duration(milliseconds: _pauseDelayMilliseconds));
      SpotifySdk.pause();
    }
    _hasStartedFind = false;
  }

  // _getTrackSpotifyURI : Gets the Spotify URI of a particular track by
  // searching for the track on the Spotify API.
  Future<String> _getTrackSpotifyURI(TempoSong song) async {
    final searchString = "${song.songTitle} ${song.artist.name}";
    var search = await _spotify.search
        .get(searchString, types: [SearchType.track]) // Do the search
        .first(1) // Get the first 1 page(s) of results.
        .onError((err, _) {
          throw HttpException(
              "Error getting search results: ${(err as SpotifyException).message}");
        });

    var firstPage = search.first;
    var firstTrack = firstPage.items?.first;

    if (firstTrack is Track && firstTrack.uri != null) {
      log('Track URI: ${firstTrack.uri}');
      return firstTrack.uri!;
    }
    throw HttpException("No song found!");
  }

  // _setInactiveState : Sets the model to inactive state.
  // This will also stop the playerStateUpdater and cancels any upcoming searches.
  void _setInactiveState() {
    _isActive = _hasStartedFind = _isPaused = false;
    // Stop the player state checker.
    _playerStateUpdater?.cancel();
    // Reset last PlayerState
    _lastState = null;
    _imageUri = null;
    // Reset cadence values
    _cadenceStatus = "Inactive";
    _cadenceValue = "-";
    // Also stop playing any song that is being played.
    SpotifySdk.pause();
  }

  // isActive : Whether the model is actively finding and playing songs.
  bool get isActive {
    return this._isActive;
  }

  // playerState : Gets the latest player state returned from the Spotify app.
  PlayerState? get playerState {
    return this._lastState;
  }

  // imageData : Gets image data of current playing song.
  ImageUri? get imageUri {
    return this._imageUri;
  }

  // cadenceValue : Gets the latest cadence value calculated.
  String get cadenceValue {
    return this._cadenceValue;
  }

  // cadenceStatus : Gets the latest cadence status.
  String get cadenceStatus {
    return this._cadenceStatus;
  }
}
