import 'dart:developer';

import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/screens/widgets/album_art_widget.dart';
import 'package:catch_my_cadence/screens/widgets/cadence_pedometer_widget.dart';
import 'package:catch_my_cadence/screens/widgets/media_player_widget.dart';
import 'package:catch_my_cadence/screens/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:tuple/tuple.dart';

// MainScreen is the screen that the user will see after confirming connection
// with Spotify.
// This screen also contains many other widgets such as the CadencePedometerWidget.
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _MainScreenBody(),
      ),
    );
  }
}

// _MainScreenBody is the widget that acts as the main body of the main screen.
// This widget contains all the necessary data models.
class _MainScreenBody extends StatefulWidget {
  _MainScreenBody({Key? key}) : super(key: key);

  @override
  _MainScreenBodyState createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<_MainScreenBody> {
  late final SpotifyControllerModel _spotifyModel;

  @override
  void initState() {
    super.initState();
    _spotifyModel = SpotifyControllerModel(context, http.Client());
  }

  @override
  void dispose() {
    if (_spotifyModel.isActive) {
      _spotifyModel.toggleStatus();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    log("Building MainScreenBody...");
    return ChangeNotifierProvider.value(
      value: _spotifyModel,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Album Art.
            _albumArtWidget(),
            SizedBox(height: 10),
            // MediaPlayerWidget.
            _mediaPlayerWidget(),
            Spacer(),
            // Cadence Information.
            _cadenceWidget(),
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            // Toggle button.
            _toggleButtonWidget(),
          ],
        );
      },
    );
  }

  Widget _albumArtWidget() {
    return Selector<SpotifyControllerModel, ImageUri?>(
        selector: (_, spotifyModel) => spotifyModel.imageUri,
        builder: (context, data, child) {
          log("Building new image");
          return AlbumArtWidget(data);
        });
  }

  Widget _mediaPlayerWidget() {
    return Selector<SpotifyControllerModel, PlayerState?>(
        selector: (_, spotifyModel) => spotifyModel.playerState,
        builder: (context, state, child) {
          log("Building media widget...");
          return MediaPlayerWidget(state);
        });
  }

  Widget _cadenceWidget() {
    return Selector<SpotifyControllerModel, Tuple2<String, String>>(
        selector: (_, spotifyModel) =>
            Tuple2(spotifyModel.cadenceStatus, spotifyModel.cadenceValue),
        builder: (context, data, child) {
          log("Building Cadence widget...");
          return CadencePedometerWidget(data.item1, data.item2);
        });
  }

  Widget _toggleButtonWidget() {
    return Selector<SpotifyControllerModel, bool>(
      selector: (_, spotifyModel) => spotifyModel.isActive,
      builder: (context, active, child) {
        log("Building button...");
        return Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            child: Text(active ? "Stop" : "Start"),
            onPressed: () => _spotifyModel.toggleStatus(),
          ),
        );
      },
    );
  }
}
