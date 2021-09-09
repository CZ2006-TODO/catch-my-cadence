import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/components/cadence_pedometer.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _currentCadence = 0;

  // connectWithSpotify: Calls the SpotifySdk.connectWithSpotify function
  // and shows user an error if connection fails.
  Future<void> connectWithSpotify() async {
    try {
      // Attempt to connect to Spotify.
      var res = await SpotifySdk.connectToSpotifyRemote(
          clientId: Config.clientId, redirectUrl: Config.redirectUrl);
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

  void onCadenceChange(updatedCadence) {
    setState(() {
      _currentCadence = updatedCadence;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Screen"),
        ),
        body: Column(
          children: [
            CadencePedometer(onCadenceChange),
            Text(
                "Cadence state from main screen: " + _currentCadence.toString())
          ],
        ));
  }
}

/*
* This part contains the other widgets that MainScreen makes use of.
* */

class CadencePedometerWidget extends StatelessWidget {
  late final int steps;

  CadencePedometerWidget(int steps) {
    this.steps = steps;
  }

  @override
  Widget build(BuildContext context) {
    return Text(steps.toString() + " steps");
  }
}
