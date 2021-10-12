import 'dart:developer';

import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/models/widget_player_model.dart';
import 'package:catch_my_cadence/util/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/player_state.dart';

class WidgetSpotifyPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var _bpm = context.read<CadencePedometerModel>();

    print("Building widget_player");
    return StreamBuilder<PlayerState>(
        stream: SpotifyControllerModel.subscribePlayerState(),
        builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
          log("Player snapshot connstate: " +
              snapshot.connectionState.toString());
          var track = snapshot.data?.track;
          var playerState = snapshot.data;

          if (playerState == null || track == null) {
            return Center(
              child: Container(),
            );
          }
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                      onPressed: null,
                      child: Text(playerState.playbackPosition.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 32,
                              overflow: TextOverflow.ellipsis,
                              height: 1)))
                ]),
                getPlayerControlTrackTitle(playerState),
                getPlayerControlTrackArtist(playerState),
                getPlayerControlButtons(playerState),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          WidgetPlayerControl.playByBPM(80);
                        },
                        //TODO: Remove eventually. This eyesore is here for testing only.
                        child: Icon(Icons.money,
                            size: AppConstants.sizePlayerControls,
                            color: AppConstants.colorPlayerControls)),
                  ],
                )
              ]));
        });
  }

  Row getPlayerControlTrackTitle(PlayerState playerState) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
          onPressed: null,
          child: Text(
              playerState.track == null
                  ? "Not available"
                  : playerState.track!.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 32,
                  overflow: TextOverflow.ellipsis,
                  height: 1)))
    ]);
  }

  Row getPlayerControlTrackArtist(PlayerState playerState) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
          onPressed: null,
          child: Text(
              playerState.track == null
                  ? "Not available"
                  : playerState.track!.artist.name!,
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  height: -0.5)))
    ]);
  }

  Row getPlayerControlButtons(PlayerState playerState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () => AppConstants.toastShort(
                "Not implemented"), //TODO: Implementation
            child: Icon(Icons.block,
                size: AppConstants.sizePlayerControls,
                color: AppConstants.colorPlayerControls)),
        TextButton(
            onPressed: () => playerState.isPaused
                ? WidgetPlayerControl.resume()
                : WidgetPlayerControl.pause(),
            child: Icon(playerState.isPaused ? Icons.play_arrow : Icons.pause,
                size: AppConstants.sizePlayerControls! + 40,
                color: AppConstants.colorPlayerControls)),
        TextButton(
            onPressed: () => AppConstants.toastShort(
                "Not implemented"), //TODO: Implementation
            child: Icon(Icons.skip_next,
                size: AppConstants.sizePlayerControls,
                color: AppConstants.colorPlayerControls)),
      ],
    );
  }
}
