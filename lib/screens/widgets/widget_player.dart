import 'package:catch_my_cadence/models/widget_player_model.dart';
import 'package:catch_my_cadence/util/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class WidgetSpotifyPlayer extends StatefulWidget {
  WidgetSpotifyPlayer() : super();

  @override
  WidgetSpotifyPlayerState createState() => WidgetSpotifyPlayerState();
}

class WidgetSpotifyPlayerState extends State<WidgetSpotifyPlayer> {
  @override
  Widget build(BuildContext context) {
    final _model = context.watch<WidgetPlayerModel>();
    _model.initState();
    return Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        color: AppConstants.colorPlayerBackground,
        child: Column(children: [
          Row(children: [
            TextButton(onPressed: null, child: Text(_model.lastSong.songName))
          ]),
          Row(
            children: [
              TextButton(
                  onPressed: () => AppConstants.toastShort(
                      "Not implemented"), //TODO: Implementation
                  child: Icon(Icons.block,
                      size: AppConstants.sizePlayerControls,
                      color: AppConstants.colorPlayerControls)),
              TextButton(
                  onPressed: () =>
                      _model.isPlaying ? _model.pause() : _model.resume(),
                  child: Icon(_model.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: AppConstants.sizePlayerControls,
                      color: AppConstants.colorPlayerControls)),
              TextButton(
                  onPressed: () => AppConstants.toastShort(
                      "Not implemented"), //TODO: Implementation
                  child: Icon(Icons.skip_next,
                      size: AppConstants.sizePlayerControls,
                      color: AppConstants.colorPlayerControls)),
              TextButton(
                  onPressed: () => _model
                      .playNeverGonna(), //TODO: Remove eventually. This eyesore is here for testing only.
                  child: Icon(Icons.money,
                      size: AppConstants.sizePlayerControls,
                      color: AppConstants.colorPlayerControls)),
            ],
          )
        ]));
  }
}
