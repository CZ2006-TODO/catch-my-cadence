import 'dart:convert';

import 'package:catch_my_cadence/config.dart';
import 'package:http/http.dart' as http;

// GetSongBpmModel is responsible for fetching a list of songs, based on the input bpm
class GetSongBPMModel {
  // returns a list of songs for a given bpm
  static Future<List<Tempo>> getSongs(int bpm) async {
    String apiKey = Config.getSongBpmApiKey;
    String uri = "https://api.getsongbpm.com/tempo/?api_key=$apiKey&bpm=$bpm";
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(Uri.parse(uri), headers: requestHeaders);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var songList = jsonResponse.tempo;
      return songList;
    } else {
      throw Exception("Failed to fetch songs from getSongBPM API");
    }
  }
}

class Tempo {
  String? songId;
  String? songTitle;
  String? songUri;
  String? tempo;
  Artist? artist;
  Album? album;

  Tempo(
      {this.songId,
        this.songTitle,
        this.songUri,
        this.tempo,
        this.artist,
        this.album});

  Tempo.fromJson(Map<String, dynamic> json) {
    songId = json['song_id'];
    songTitle = json['song_title'];
    songUri = json['song_uri'];
    tempo = json['tempo'];
    artist =
    json['artist'] != null ? new Artist.fromJson(json['artist']) : null;
    album = json['album'] != null ? new Album.fromJson(json['album']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['song_id'] = this.songId;
    data['song_title'] = this.songTitle;
    data['song_uri'] = this.songUri;
    data['tempo'] = this.tempo;
    if (this.artist != null) {
      data['artist'] = this.artist?.toJson();
    }
    if (this.album != null) {
      data['album'] = this.album?.toJson();
    }
    return data;
  }
}

class Artist {
  String? id;
  String? name;
  String? uri;
  String? img;
  List<String>? genres;
  String? from;
  String? mbid;

  Artist(
      {this.id,
        this.name,
        this.uri,
        this.img,
        this.genres,
        this.from,
        this.mbid});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    uri = json['uri'];
    img = json['img'];
    genres = json['genres'].cast<String>();
    from = json['from'];
    mbid = json['mbid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['uri'] = this.uri;
    data['img'] = this.img;
    data['genres'] = this.genres;
    data['from'] = this.from;
    data['mbid'] = this.mbid;
    return data;
  }
}

class Album {
  String? title;
  String? uri;
  String? img;
  String? year;

  Album({this.title, this.uri, this.img, this.year});

  Album.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    uri = json['uri'];
    img = json['img'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['uri'] = this.uri;
    data['img'] = this.img;
    data['year'] = this.year;
    return data;
  }
}