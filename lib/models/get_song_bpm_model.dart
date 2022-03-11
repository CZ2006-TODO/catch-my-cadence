import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:catch_my_cadence/config.dart';
import 'package:http/http.dart' as http;

// GetSongBPMModel is responsible for interfacing with the GetSongBPM API.
// It provides functionality to get a list of songs of a certain BPM.
class GetSongBPMModel {
  static const _baseAPI = "api.getsongbpm.com";
  static const _tempoPath = "/tempo/";
  static const _httpTimeout = 10; // Leeway for HTTP request.

  static const _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  // Required for testing
  http.Client _client;

  GetSongBPMModel(this._client);

  // getSongs : Returns a list of songs with a given BPM.
  Future<List<TempoSong>> getSongs(int bpm) async {
    log("Getting songs of BPM $bpm");
    final queryParams = {
      "api_key": Config.getSongBpmApiKey,
      "bpm": bpm.toString(),
    };
    final uri = Uri.https(_baseAPI, _tempoPath, queryParams);
    final response = await _client
        .get(uri, headers: _headers)
        .timeout(Duration(seconds: _httpTimeout), onTimeout: () {
      throw TimeoutException("GetSongBPM timed out!");
    });

    var resp = jsonDecode(response.body);

    if (response.statusCode != 200 || resp is! Map) {
      throw HttpException("GetSongBPM error!");
    } else if (!resp.containsKey("tempo")) {
      throw HttpException("GetSongBPM endpoint error!");
    } else if (resp["tempo"] is Map &&
        (resp["tempo"] as Map).containsKey("error")) {
      throw HttpException(
          "GetSongBPM tempo endpoint error: ${resp["tempo"]["error"]}");
    }

    List songsJson = resp["tempo"] as List;
    List<TempoSong> songs =
        songsJson.map((s) => TempoSong.fromJson(s)).toList();
    log("Got ${songs.length} songs");
    return songs;
  }
}

// TempoSong class contains information of a song returned from the GetSongBPM API.
class TempoSong {
  String songId;
  String songTitle;
  String songUri;
  String tempo;
  Artist artist;
  Album album;

  TempoSong(this.songId, this.songTitle, this.songUri, this.tempo, this.artist,
      this.album);

  factory TempoSong.fromJson(Map<String, dynamic> json) {
    return TempoSong(
        json['song_id'] ?? '',
        json['song_title'] ?? '',
        json['song_uri'] ?? '',
        json['tempo'] ?? '',
        Artist.fromJson(json['artist']),
        Album.fromJson(json['album']));
  }
}

// Artist class contains information of an artist from the GetSongBPM API.
class Artist {
  String id;
  String name;
  String uri;
  String img;
  List<String> genres;
  String from;
  String mbid;

  Artist(this.id, this.name, this.uri, this.img, this.genres, this.from,
      this.mbid);

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
        json['id'] ?? '',
        json['name'] ?? '',
        json['uri'] ?? '',
        json['img'] ?? '',
        List<String>.from(json['genres'] ?? []),
        json['from'] ?? '',
        json['mbid'] ?? '');
  }
}

// Album class contains information of an album from the GetSongBPM API.
class Album {
  String title;
  String uri;
  String img;
  String year;

  Album(this.title, this.uri, this.img, this.year);

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(json['title'] ?? '', json['uri'] ?? '', json['img'] ?? '',
        json['year'] ?? '');
  }
}
