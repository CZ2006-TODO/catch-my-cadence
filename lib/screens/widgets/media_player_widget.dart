import 'package:catch_my_cadence/models/media_controller_model.dart';
import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/player_state.dart';

class MediaPlayerWidget extends StatelessWidget {
  late final Stream<PlayerState> _stateStream;

  MediaPlayerWidget(this._stateStream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
        stream: _stateStream,
        builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
          var track = snapshot.data?.track;
          var playerState = snapshot.data;

          if (playerState == null || track == null) {
            return Center(
              child: Container(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Playback position
              Text("${playerState.playbackPosition}/${track.duration}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: 10),
              // Track name
              Text("${track.name}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 10),
              // Track artist
              Text("${track.artist.name}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: 10),
              // Controls
              TextButton(
                  onPressed: () => playerState.isPaused
                      ? MediaPlayerController.resume()
                      : MediaPlayerController.pause(),
                  child: Icon(
                    playerState.isPaused ? Icons.play_arrow : Icons.pause,
                  )),
              SizedBox(height: 10),
              // Change song?
              // TODO : Fix lagginess (potential mem leak)?
              TextButton(
                  onPressed: () {
                    MediaPlayerController.playByBPM(80);
                  },
                  //TODO: Remove eventually. This eyesore is here for testing only.
                  child: Icon(Icons.money)),
            ],
          );
        });
  }
}
