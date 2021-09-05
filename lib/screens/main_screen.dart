import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/models/cadence_pedometer.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

// MainScreen is the screen that the user will see after authentication
// and connecting successfully with the Spotify app.
// This screen also contains many other widgets such as the CadencePedometerWidget.
class MainScreen extends StatefulWidget {
  final String token;

  MainScreen({Key? key, required this.token}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // connectWithSpotify: Calls the SpotifySdk.connectWithSpotify function
  // and shows user an error if connection fails.
  Future<void> connectWithSpotify() async {
    try {
      // Attempt to connect to Spotify.
      // There are 2 possible exceptions that both throw PlatformException:
      // 1. NotLoggedInException   : Thrown if user is not logged in on Spotify.
      // 2. CouldNotFindSpotifyApp : Thrown if Spotify App not installed.
      var res = await SpotifySdk.connectToSpotifyRemote(
          clientId: Config.clientId,
          redirectUrl: Config.redirectUrl,
          accessToken: widget.token);
      log(res ? "Connection successful" : "Connection failed!");
    } on PlatformException catch (e) {
      log("PlatformException: ${e.toString()}");
      if (e.toString().contains("CouldNotFindSpotifyApp")) {
        showDialog(
          context: context,
          builder: (_) => FatalErrorDialog(
              message: "It seems you do not have the Spotify App installed!"),
          barrierDismissible: false,
        );
      } else {
        showDialog(
            context: context,
            builder: (_) => FatalErrorDialog(
                title: "Whoopsie!",
                message:
                    "You may have logged out of your Spotify App recently.\n\nPlease check and come back!"));
      }
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
        body: ChangeNotifierProvider(
          create: (_) => CadencePedometerModel(),
          child: Center(child: Consumer<CadencePedometerModel>(
            builder: (context, cp, child) {
              return CadencePedometerWidget(cp.currStepCount);
            },
          )),
        ));
  }
}

// This part contains the other widgets that MainScreen makes use of.

class CadencePedometerWidget extends StatelessWidget {
  late final int steps;

  CadencePedometerWidget(int steps) {
    this.steps = steps;
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(steps.toString()));
  }
}
