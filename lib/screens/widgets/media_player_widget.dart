import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/player_state.dart';

class MediaPlayerWidget extends StatelessWidget {
  late final PlayerState? _state;

  MediaPlayerWidget(this._state);

  @override
  Widget build(BuildContext context) {
    var track = this._state?.track;

    if (this._state == null || track == null) {
      return Center(
        child: Container(
          child: Text("Not active!"),
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
            onPressed: () {},
            child: Icon(
              this._state!.isPaused ? Icons.play_arrow : Icons.pause,
            )),
        SizedBox(height: 10),
      ],
    );
  }
}
