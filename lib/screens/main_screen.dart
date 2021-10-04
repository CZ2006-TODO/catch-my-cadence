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
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: SideMenu(),
      body: _MainScreenBody(),
    );
  }
}

// _MainScreenBody is the widget that acts as the main body of the main screen.
// This widget contains all the necessary data models.
class _MainScreenBody extends StatefulWidget {
  const _MainScreenBody({Key? key}) : super(key: key);

  @override
  _MainScreenBodyState createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<_MainScreenBody> {
  late CadencePedometerModel _cadenceModel;
  late GetSongBPMModel _bpmModel;
  late SpotifyControllerModel _spotifyModel;

  @override
  void initState() {
    super.initState();
    _cadenceModel = CadencePedometerModel();
    _bpmModel = GetSongBPMModel();
    _spotifyModel = SpotifyControllerModel(context);
  }

  @override
  Widget build(BuildContext ctx) {
    // Allows to hold multiple models.
    return MultiProvider(
        // TODO : The interaction between models has not been finalised.
        providers: [
          ChangeNotifierProvider.value(value: _cadenceModel),
          Provider.value(value: _bpmModel),
          Provider.value(value: _spotifyModel),
        ],
        child: Center(child: Consumer<CadencePedometerModel>(
          builder: (context, cpModel, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(cpModel.isActive ? "Stop" : "Start"),
                    onPressed: () => cpModel.toggleStatus(),
                  ),
                  CadencePedometerWidget(
                    cadenceActive: cpModel.isActive,
                    steps: cpModel.steps,
                    cadence: cpModel.cadence,
                  )
                ]);
          },
        )));
  }
}
