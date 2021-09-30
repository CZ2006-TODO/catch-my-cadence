import 'dart:convert';

import 'package:catch_my_cadence/config.dart';
import 'package:http/http.dart' as http;

// GetSongBpmModel is responsible for fetching a list of songs, based on the input bpm
class GetSongBPMModel {
  // returns a list of songs for a given bpm
  // https://api.getsongbpm.com/tempo?api_key=9b8db61c9e5afe783b82f7ffc75d145a&bpm=120
  static Future<List<Object>> getSongs(int bpm) async {
    String apiKey = Config.getSongBpmApiKey;
    String uri = "https://api.getsongbpm.com/tempo/?api_key=$apiKey&bpm=$bpm";
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var songList = jsonResponse.tempo;
      return songList;
    } else {
      throw Exception("Failed to fetch songs from getSongBPM API");
    }
  }
}
