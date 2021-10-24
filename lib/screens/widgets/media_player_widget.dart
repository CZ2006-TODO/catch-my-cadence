import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class MediaPlayerWidget extends StatelessWidget {
  late final PlayerState? _state;

  MediaPlayerWidget(this._state);

  @override
  Widget build(BuildContext context) {
    var track = this._state?.track;

    if (this._state == null || track == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Not playing any songs matching your cadence.\n",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              "Press the 'Start' button to discover something special!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Playback position
        Text("${this._state!.playbackPosition}/${track.duration}",
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
            onPressed: () {
              this._state!.isPaused ? SpotifySdk.resume() : SpotifySdk.pause();
            },
            child: Icon(
              this._state!.isPaused ? Icons.play_arrow : Icons.pause,
            )),
        SizedBox(height: 10),
      ],
    );
  }
}
