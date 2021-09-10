import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';

// LoadingScreen shows the loading screen when the user first starts the app.
// This screen contains the logic of checking the user authentication,
// and then routing the user to the appropriate screen.
class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  // asyncLoad : Asynchronously load up the application.
  // This function contains logic for routing the user to the appropriate
  // screen after loading.
  Future<void> asyncLoad() async {
    // Artificially slow down the loading for user experience.
    await Future.delayed(Duration(seconds: 1));

    // Load environment secrets.
    await Config.loadSecrets();

    bool firstRun = await Config.getFirstRunFlag();
    log("First run status: $firstRun");

    // Navigate to required screen based on flag.
    // If flag is true, then should direct user to login screen
    Navigator.of(context).pushReplacementNamed(firstRun
        ? RouteDelegator.CONFIRM_CONNECTION_SCREEN_ROUTE
        : RouteDelegator.MAIN_SCREEN_ROUTE);
  }

  @override
  initState() {
    super.initState();
    asyncLoad();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset("assets/images/splash_screen.png")),
    );
  }
}
