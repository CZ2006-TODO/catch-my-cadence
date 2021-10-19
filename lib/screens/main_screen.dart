import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/models/get_song_bpm_model.dart';
import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/models/media_controller_model.dart';
import 'package:catch_my_cadence/screens/widgets/cadence_pedometer_widget.dart';
import 'package:catch_my_cadence/screens/widgets/side_menu_widget.dart';
import 'package:catch_my_cadence/screens/widgets/media_player_widget.dart';
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
class _MainScreenBody extends StatefulWidget {
  const _MainScreenBody({Key? key}) : super(key: key);

  @override
  _MainScreenBodyState createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<_MainScreenBody> {
  late CadencePedometerModel _cadenceModel;
  late GetSongBPMModel _bpmModel;
  late SpotifyControllerModel _spotifyModel;
  late MediaPlayerController _mediaModel;

  @override
  void initState() {
    super.initState();
    _spotifyModel = SpotifyControllerModel(context);
    _cadenceModel = CadencePedometerModel();
    _bpmModel = GetSongBPMModel();
    _mediaModel = MediaPlayerController();
  }

  @override
  Widget build(BuildContext ctx) {
    // Allows to hold multiple models.
    return MultiProvider(
      // TODO : The interaction between models has not been finalised.
      providers: [
        ChangeNotifierProvider.value(value: _cadenceModel),
        ChangeNotifierProvider.value(value: _mediaModel),
        Provider.value(value: _bpmModel),
        Provider.value(value: _spotifyModel),
      ],
      child: mainWidgets(),
    );
  }

  Widget mainWidgets() {
    return Center(child:
        Consumer<CadencePedometerModel>(builder: (context, cpModel, child) {
      // These widgets are always built.
      List<Widget> widgets = [
        ElevatedButton(
          child: Text(cpModel.isActive ? "Stop" : "Start"),
          onPressed: () => cpModel.toggleStatus(),
        ),
        CadencePedometerWidget(
          cadenceActive: cpModel.isActive,
          steps: cpModel.steps,
          cadence: cpModel.cadence,
        )
      ];
      // Add this only if the cpMpdel is active and time elapsed > 3s.
      if (cpModel.isActive &&
          cpModel.timeElapsed > Duration(seconds: 3).inMilliseconds) {
        widgets.add(Spacer());
        widgets.add(Align(
          alignment: Alignment.bottomCenter,
          child: MediaPlayerWidget(),
        ));
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgets,
      );
    }));
  }
}
