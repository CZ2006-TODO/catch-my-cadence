import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/models/get_song_bpm_model.dart';
import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/screens/widgets/cadence_pedometer_widget.dart';
import 'package:catch_my_cadence/screens/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// MainScreen is the screen that the user will see after confirming connection
// with Spotify.
// This screen also contains many other widgets such as the CadencePedometerWidget.
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: SideMenu(),
      body: MainScreenBody(),
    );
  }
}

// MainScreenBody is the widget that acts as the main body of the main screen.
// This widget contains the CadencePedometerModel.
class MainScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    // Allows to hold multiple models.
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CadencePedometerModel()),

          // If required, the interaction between the 2 will change.
          // Right now, I can foresee a need for a proxy provider for communication
          // between GetSongBPMModel and SpotifyControllerModel
          Provider(create: (ctx) => GetSongBPMModel()),
          // lazy is set to false because usually models are not created until
          // they are needed, but we want to connect the moment user enters the
          // main screen.
          Provider(create: (ctx) => SpotifyControllerModel(ctx), lazy: false),
        ],
        child: Center(child: Consumer<CadencePedometerModel>(
          builder: (context, cadped, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(cadped.isActive ? "Stop" : "Start"),
                    onPressed: () => cadped.toggleStatus(),
                  ),
                  CadencePedometerWidget(
                    cadenceActive: cadped.isActive,
                    steps: cadped.steps,
                    cadence: cadped.cadence,
                  ),
                ]);
          },
        )));
  }
}
