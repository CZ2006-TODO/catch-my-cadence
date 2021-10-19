import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/screens/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'package:catch_my_cadence/models/get_song_bpm_model.dart';

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

  static Future<String> searchTrackByTitle(TempoSong song) async {
    final credentials =
        SpotifyApiCredentials(Config.clientId, Config.clientSecret);
    final spotify = SpotifyApi(credentials);
    String songtitle = song.songTitle;
    String songartist = song.artist.name;
    String searchargument = songtitle + ' ' + songartist;
    var search = await spotify.search
        .get(searchargument, types: [SearchType.track])
        .first(1)
        .catchError((err) {
          print((err as SpotifyException).message);
        });

    var firstPage = search.single;
    var firstTrack = firstPage.items?.first;

    if (firstTrack is Track && firstTrack.uri != null) {
      print('Track:\n'
          'uri: ${firstTrack.uri}\n');
      return firstTrack.uri!;
    }
    throw new Exception(
        "searchTrackByTitle did not find a valid uri for title " + songtitle);
  }

  //Wrapper for searching + playing
  static void playSong(TempoSong song) async {
    String uri = await searchTrackByTitle(song);
    doPlay(uri);
  }

  static Future<bool> isPlaying() async {
    bool retVal = false;
    await SpotifySdk.getPlayerState().then((value) {
      if (value != null) {
        retVal = !(value.isPaused);
      }
    }).catchError((_) {
      retVal = false;
    });
    return retVal;
  }

  static Future<void> doResume() async {
    await SpotifySdk.resume();
  }

  static Future<void> doPause() async {
    await SpotifySdk.pause();
  }

  static Future<void> doPlay(String uri) async {
    await SpotifySdk.play(spotifyUri: uri);
  }

  static Stream<PlayerState> subscribePlayerState() {
    return SpotifySdk.subscribePlayerState();
  }
}
