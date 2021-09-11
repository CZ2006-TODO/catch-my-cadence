import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
import 'package:catch_my_cadence/screens/widgets/cadence_pedometer_widget.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/connection_status.dart';
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
  late Stream<ConnectionStatus> spotifyConnection;
  
  // connectWithSpotify: Calls the SpotifySdk.connectWithSpotify function
  // and shows user an error if connection fails.
  Future<void> connectWithSpotify() async {
    try {
      // Attempt to connect to Spotify.
      spotifyConnection = SpotifySdk.subscribeConnectionStatus()
        ..listen((event) async {
          log("Polling connection...");
          if (!event.connected) {
            log("Connection to Spotify app lost! Attempting reconnect...");
            await SpotifySdk.connectToSpotifyRemote(
                clientId: Config.clientId, redirectUrl: Config.redirectUri);
          }
          log("Poll complete!");
        }).onError((e) {
          log("Error attempting Spotify reconnect: ${e.toString()}");
        });
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

// MainScreenBody is the widget that acts as the main body of the main screen.
// This widget contains the CadencePedometerModel.
class MainScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return ChangeNotifierProvider(
        create: (_) => CadencePedometerModel(),
        child: Center(child: Consumer<CadencePedometerModel>(
          builder: (context, cadencePedometer, child) {
            if (cadencePedometer.shouldRestartPedometer) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Please restart application for changes to take place",
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(
                              RouteDelegator.LOADING_SCREEN_ROUTE),
                      child: Text("Restart App"),
                    )
                  ]);
            }

            if (!cadencePedometer.isGranted) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Permissions for pedometer not granted. Open app settings, and restart application",
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () => cadencePedometer.manuallyGrantPermission(),
                    child: Text("Open app settings"),
                  ),
                ],
              );
            }

            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text(cadencePedometer.isActive ? "Stop" : "Start"),
                    onPressed: () => cadencePedometer.toggleStatus(),
                  ),
                  CadencePedometerWidget(
                    cadenceActive: cadencePedometer.isActive,
                    steps: cadencePedometer.steps,
                    cadence: cadencePedometer.cadence,
                  )
                ],
              ),
            );
          },
        )));
  }
}
