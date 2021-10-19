import 'dart:async';
import 'dart:math';

import 'package:catch_my_cadence/models/get_song_bpm_model.dart';
import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/util/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/player_options.dart';
import 'package:spotify_sdk/models/player_options.dart' as popt;
import 'package:spotify_sdk/models/player_restrictions.dart';
import 'package:spotify_sdk/models/player_state.dart';

class MediaPlayerController extends ChangeNotifier {
  late StreamController controller = StreamController();
  late StreamSubscription playerStateSubscription;
  late Stream<PlayerState> playerStateStream;
  PlayerState playerState = PlayerState(
      null,
      1,
      0,
      PlayerOptions(popt.RepeatMode.context, isShuffling: false),
      PlayerRestrictions(
          canSkipNext: true,
          canSkipPrevious: true,
          canRepeatContext: true,
          canRepeatTrack: true,
          canSeek: true,
          canToggleShuffle: true),
      isPaused: false);

  void updatePlaytime() {
    if (playerState.track != null && !playerState.isPaused) notifyListeners();
  }

  void updatePlayerState(state) {
    playerState = state;
    notifyListeners();
  }

  static void resume() {
    SpotifyControllerModel.doResume();
  }

  static void pause() {
    SpotifyControllerModel.doPause();
  }

  static void play(String uri) {
    SpotifyControllerModel.doPlay(uri);
  }

  static void playByTitle(TempoSong song) async {
    String? uri = await SpotifyControllerModel.searchTrackByTitle(song);
    play(uri);
  }

  void playNext() {}

  static void playByBPM(int bpm) {
    if (bpm < 60 || bpm > 150) {
      //TODO: Decide how to handle invalid bpm range, currently generating bpm from arbitrary range
      var random = new Random();
      bpm = random.nextInt(90) + 60;
    }
    GetSongBPMModel.getSongs(bpm).then((value) {
      var random = new Random();
      var title = value[random.nextInt(value.length + 1) - 2];

      //Pick random title from list of results from GetSongBPM API
      AppConstants.toastShort("Playing " + title.songTitle);
      playByTitle(title);
    });
  }
}
