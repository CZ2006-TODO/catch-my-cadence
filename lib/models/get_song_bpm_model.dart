import 'dart:convert';

import 'package:catch_my_cadence/config.dart';
import 'package:http/http.dart' as http;

// GetSongBPMModel is responsible for interfacing with the GetSongBPM API.
// It provides functionality to get a list of songs of a certain BPM.
class GetSongBPMModel {
  static const _baseAPI = "api.getsongbpm.com";
  static const _tempoPath = "/tempo/";

  // getSongs: Returns a list of songs with a given BPM.
  static Future<List<Song>> getSongs(int bpm) async {
    final queryParams = {
      "api_key": Config.getSongBpmApiKey,
      "bpm": bpm.toString(),
    };
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.https(_baseAPI, _tempoPath, queryParams);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var songListJson = jsonDecode(response.body)["tempo"] as List;
      List<Song> songs = songListJson.map((s) => Song.fromJson(s)).toList();
      return songs;
    } else {
      throw Exception("Failed to fetch songs from getSongBPM API");
    }
  }
}

// Song class contains information of a song returned from the GetSongBPM API.
class Song {
  String songId;
  String songTitle;
  String songUri;
  String tempo;
  Artist artist;
  Album album;

  Song(this.songId, this.songTitle, this.songUri, this.tempo, this.artist,
      this.album);

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
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
