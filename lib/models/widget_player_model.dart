import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/util/AppConstants.dart';
import 'package:flutter/material.dart';

class WidgetPlayerModel extends ChangeNotifier {
  late bool isPlaying = false;
  late SpotifySong lastSong = new SpotifySong();
  WidgetPlayerModel() {
    initState();
  }

  void initState() async {
    await SpotifyControllerModel.isPlaying().then((value) {
      isPlaying = value;
      notifyListeners();
    });
    await SpotifyControllerModel.getLastSong().then((value) {
      lastSong = value;
      notifyListeners();
    });
  }

  void resume() {
    _doResume();
  }

  void _doResume() {
    SpotifyControllerModel.doResume();
    isPlaying = true;
    initState();
    notifyListeners();
  }

  void pause() {
    _doPause();
  }

  void _doPause() {
    SpotifyControllerModel.doPause();
    isPlaying = false;
    notifyListeners();
  }

  void play(String uri) {
    _doPlay(uri);
  }

  void playNeverGonna() {
    AppConstants.toastShort(
        "Playing arbitrary song `Never Gonna Give You Up` by title");
    playByTitle("Never Gonna Give You Up");
  }

  void _doPlay(String uri) {
    SpotifyControllerModel.doPlay(uri);
    isPlaying = true;
    SpotifyControllerModel.getLastSong().then((value) {
      lastSong = value;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> playByTitle(String title) async {
    String? uri = await SpotifyControllerModel.searchTrackByTitle(title);
    if (uri != null) _doPlay(uri);
  }
}
