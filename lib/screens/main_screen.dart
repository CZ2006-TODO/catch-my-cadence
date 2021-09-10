import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
import 'package:catch_my_cadence/screens/widgets/cadence_pedometer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

// MainScreen is the screen that the user will see after authentication
// and connecting successfully with the Spotify app.
// This screen also contains many other widgets such as the CadencePedometerWidget.
class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // connectWithSpotify: Calls the SpotifySdk.connectWithSpotify function
  // and shows user an error if connection fails.
  Future<void> connectWithSpotify() async {
    try {
      // Attempt to connect to Spotify.
      var res = await SpotifySdk.connectToSpotifyRemote(
          clientId: Config.clientId, redirectUrl: Config.redirectUri);
      log(res ? "Connection successful" : "Connection failed!");
    } on PlatformException catch (e) {
      log("PlatformException: ${e.toString()}");

      // Check for the type of PlatformException.
      // There are 2 possible exceptions that both throw PlatformException:
      // 1. NotLoggedInException   : Thrown if user is not logged in on Spotify app.
      // 2. CouldNotFindSpotifyApp : Thrown if Spotify App not installed.
      String message = (e.toString().contains("CouldNotFindSpotifyApp"))
          ? "It seems you do not have the Spotify App installed!"
          : "You may have logged out of your Spotify App recently.\n\n"
              "Please check and come back!";
      showDialog(
        context: context,
        builder: (_) => FatalErrorDialog(message: message),
      );
    }
  }

  @override
  initState() {
    super.initState();
    // Connect with Spotify here.
    connectWithSpotify();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: MainScreenBody(),
    );
  }
}

/*
* This part contains the other widgets that MainScreen makes use of.
* */

class MainScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return ChangeNotifierProvider(
        create: (_) => CadencePedometerModel(),
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
