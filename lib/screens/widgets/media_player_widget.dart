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
                  onPressed: () {},
                  child: Icon(
                    playerState.isPaused ? Icons.play_arrow : Icons.pause,
                  )),
              SizedBox(height: 10),
            ],
          );
        });
  }
}
