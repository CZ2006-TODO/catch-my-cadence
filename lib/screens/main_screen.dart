import 'dart:async';

import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/models/get_song_bpm_model.dart';
import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/models/widget_player_model.dart';
import 'package:catch_my_cadence/screens/widgets/cadence_pedometer_widget.dart';
import 'package:catch_my_cadence/screens/widgets/side_menu_widget.dart';
import 'package:catch_my_cadence/screens/widgets/widget_player.dart';
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
  late WidgetPlayerControl _widgetPlayerModel;

  @override
  void initState() {
    super.initState();
    _spotifyModel = SpotifyControllerModel(context);
    _cadenceModel = CadencePedometerModel();
    _bpmModel = GetSongBPMModel();
    _widgetPlayerModel = WidgetPlayerControl();
  }

  @override
  Widget build(BuildContext ctx) {
    // Allows to hold multiple models.
    return MultiProvider(
        // TODO : The interaction between models has not been finalised.
        providers: [
          ChangeNotifierProvider.value(value: _cadenceModel),
          ChangeNotifierProvider.value(value: _widgetPlayerModel),
          Provider.value(value: _bpmModel),
          Provider.value(value: _spotifyModel),
        ],
        child: Container(
            height: double.maxFinite, child: Column(children: [buildMain()])));
  }

  Widget buildMain() {
    return Consumer<CadencePedometerModel>(builder: (context, cpModel, child) {
      //Arbitrary X seconds counter to 'assume' BPM has been stabilized
      //TODO: Change X, X is 3 for now for testing purposes
      const int DELAY_BEFORE_FETCHING = 5;
      if (!cpModel.isActive ||
          (cpModel.isActive && cpModel.timeElapsed < DELAY_BEFORE_FETCHING)) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                  child: Text(cpModel.isActive ? "Stop" : "Start"),
                  // onPressed: () => cpModel.toggleStatus(),
                  onPressed: () {
                    cpModel.toggleStatus();
                    Timer? t;
                    if (cpModel.isActive) {
                      Timer(new Duration(seconds: DELAY_BEFORE_FETCHING), () {
                        WidgetPlayerControl.playByBPM(cpModel.cadence);
                      });
                    } else {
                      t?.cancel();
                    }
                  }),
              CadencePedometerWidget()
            ]);
      } else {
        return Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              ElevatedButton(
                  child: Text("Stop Activity"),
                  onPressed: () {
                    cpModel.stop();
                    WidgetPlayerControl.pause(); //TODO: Full implementation
                  }),
              CadencePedometerWidget(),
              Spacer(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: WidgetSpotifyPlayer()),
            ]));
      }
    });
  }
}
