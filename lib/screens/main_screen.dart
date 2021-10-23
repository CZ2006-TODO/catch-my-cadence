import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/screens/widgets/media_player_widget.dart';
import 'package:catch_my_cadence/screens/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
class _MainScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    // Allows to hold multiple models.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => SpotifyControllerModel(ctx)),
      ],
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<SpotifyControllerModel>(
                builder: (context, spotifyModel, child) {
              return ElevatedButton(
                child: Text(spotifyModel.isActive ? "Stop" : "Start"),
                onPressed: () => spotifyModel.toggleStatus(),
              );
            }),
            Spacer(),
            Consumer<SpotifyControllerModel>(
                builder: (context, spotifyModel, child) {
              return Align(
                  alignment: Alignment.bottomCenter,
                  child: MediaPlayerWidget(spotifyModel.playerState));
            }),
          ],
        );
      },
    );
  }
}
