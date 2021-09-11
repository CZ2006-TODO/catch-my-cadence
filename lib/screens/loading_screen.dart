import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// LoadingScreen shows the loading screen when the user first starts the app.
// This screen contains the logic of checking the user authentication,
// and then routing the user to the appropriate screen.
class LoadingScreen extends StatefulWidget with WidgetsBindingObserver {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen>
    with WidgetsBindingObserver {
  // asyncLoad : Asynchronously load up the application.
  // This function contains logic for routing the user to the appropriate
  // screen after loading.
  Future<void> asyncLoad() async {
    // Artificially slow down the loading for user experience.
    await Future.delayed(Duration(seconds: 1));

    // Load environment secrets.
    await Config.loadSecrets();

    // Check permission
    _checkActivityRecognitionPermissionAndProceed();
  }

  // _checkActivityRecognitionPermissionAndProceed : Checks whether
  // the ActivityRecognition permission has been granted.
  // If yes, then navigate user to required screen based on first run status.
  // If no, then keep prompting user for the permission.
  Future<void> _checkActivityRecognitionPermissionAndProceed() async {
    if (!(await Permission.activityRecognition.isGranted)) {
      _requestActivityRecognitionPermission();
    } else {
      bool firstRun = await Config.getFirstRunFlag();
      log("First run status: $firstRun");

      // Navigate to required screen based on flag.
      // If flag is true, then should direct user to login screen
      Navigator.of(context).pushReplacementNamed(firstRun
          ? RouteDelegator.CONFIRM_CONNECTION_SCREEN_ROUTE
          : RouteDelegator.MAIN_SCREEN_ROUTE);
    }
  }

  // _requestActivityRecognitionPermission : Shows a dialog to the user asking
  // for activity recognition permission.
  Future<void> _requestActivityRecognitionPermission() async {
    log("Activity Recognition Permission not granted, requesting...");
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text("Activity Recognition Permission"),
        content: Text(
            "Whoops! It looks like you are missing the required permissions "
            "to let the pedometer work.\n\nPlease grant it!"),
        actions: [
          TextButton(
            child: Text("Open Settings"),
            onPressed: () {
              Navigator.of(c).pop();
              openAppSettings();
            },
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("Checking App Lifecycle...");
    if (state == AppLifecycleState.resumed) {
      log("App resumed, checking permissions...");
      _checkActivityRecognitionPermissionAndProceed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
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
