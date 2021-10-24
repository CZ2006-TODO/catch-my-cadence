import 'dart:developer';

import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/screens/widgets/media_player_widget.dart';
import 'package:catch_my_cadence/screens/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/player_state.dart';

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
    _spotifyModel = SpotifyControllerModel(context);
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
            // Toggle button.
            Selector<SpotifyControllerModel, bool>(
              selector: (_, spotifyModel) => spotifyModel.isActive,
              builder: (context, active, child) {
                log("Building button...");
                return ElevatedButton(
                  child: Text(active ? "Stop" : "Start"),
                  onPressed: () => _spotifyModel.toggleStatus(),
                );
              },
            ),
            // TODO : Add more widgets here.
            // Spacer so the MediaPlayerWidget will be at the bottom.
            Spacer(),
            // MediaPlayerWidget.
            Selector<SpotifyControllerModel, PlayerState?>(
                selector: (_, spotifyModel) => spotifyModel.playerState,
                builder: (context, state, child) {
                  log("Building media widget...");
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: MediaPlayerWidget(state),
                  );
                }),
          ],
        );
      },
    );
  }
}
