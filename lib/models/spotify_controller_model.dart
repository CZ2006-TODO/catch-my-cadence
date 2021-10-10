import 'dart:convert';
import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/screens/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

// SpotifyControllerModel is in charge of communicating and controlling the
// Spotify App.
// TODO: Only does connection right now. Should also implement other stuff like the playing logic.
class SpotifyControllerModel {
  late Stream<ConnectionStatus> spotifyConnection;
  static List<SpotifySong> _listSpotifyHistory = [];
  static String _authToken = "";
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
      _authToken = await SpotifySdk.getAuthenticationToken(
          clientId: Config.clientId,
          redirectUrl:
              Config.redirectUri); //pull auth token for spotify web api usage
      print(_authToken);
      // Set up stream to poll Spotify connection. This allows the app
      // to check that it is continuously connected to Spotify when necessary.
      spotifyConnection = SpotifySdk.subscribeConnectionStatus()
        ..listen((event) async {
          log("Polling connection...");
          if (!event.connected) {
            log("Connection to Spotify app lost! Attempting reconnect...");
            await SpotifySdk.connectToSpotifyRemote(
                clientId: Config.clientId, redirectUrl: Config.redirectUri);
            _authToken = await SpotifySdk.getAuthenticationToken(
                clientId: Config.clientId, redirectUrl: Config.redirectUri);
            print(_authToken);
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

  //Wrapper for http get to attach spotify auth headers
  static Future<String> spotifyAPIGet(Uri uri) async {
    http.Response res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_authToken'
    });
    return res.body;
  }

  //Searches for a track using the endpoint @ api.spotify.com/v1/search and returns the first track uri
  static Future<String?> searchTrackByTitle(String title) async {
    Uri uri = Uri.http(
        "api.spotify.com", "/v1/search", {"q": title, "type": "track"});
    String response = await spotifyAPIGet(uri);
    var parsedJson = json.decode(response);
    List items = parsedJson["tracks"]["items"];
    if (items.length > 0 && items[0]["type"] == "track") {
      SpotifySong song = SpotifySong.fromJson(items[0]);
      _listSpotifyHistory.add(song);
      return song.songUri;
    }
    return "";
  }

  //Wrapper for searching + playing
  static void playSong(String title) async {
    String? uri = await searchTrackByTitle(title);
    if (uri != null) doPlay(uri);
  }

  //Retrieve user's last played song using SpotifySdk player state
  //This method is unable to retrieve certain information like songId and songExternalUrl
  static Future<SpotifySong> getLastSong() async {
    SpotifySong song = new SpotifySong();
    await SpotifySdk.getPlayerState().then((value) {
      if (value != null && value.track != null) {
        song = new SpotifySong(
            artistName: value.track?.artist == null
                ? ""
                : value.track?.artist.name as String,
            songId: "",
            songName: value.track?.name as String,
            songUri: value.track?.uri as String,
            songExternalUrl: "");
      }
    }).catchError((_) {
      song = new SpotifySong();
    });
    return song;
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

  static void doResume() {
    SpotifySdk.resume();
  }

  static void doPause() {
    SpotifySdk.pause();
  }

  static void doPlay(String uri) {
    SpotifySdk.play(spotifyUri: uri);
  }
}

class SpotifySong {
  String artistName;
  String songId;
  String songName;
  String songUri;
  String songExternalUrl;
  SpotifySong(
      {this.artistName = "None",
      this.songId = "",
      this.songName = "Not Playing",
      this.songUri = "",
      this.songExternalUrl = ""});

  factory SpotifySong.fromJson(Map<String, dynamic> json) {
    return SpotifySong(
        artistName: json['artists']?[0]?['name'] ?? '',
        songId: json['id'] ?? '',
        songName: json['name'] ?? '',
        songUri: json['uri'] ?? '',
        songExternalUrl: json['external_urls']?['spotify'] ?? '');
  }
}
