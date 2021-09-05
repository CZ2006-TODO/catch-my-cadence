import 'dart:developer';
import 'dart:io';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
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
  // getStoredAuthToken : Attempts to get a saved authentication token to
  // connect with Spotify. If there is no stored token, a FileSystemException is thrown.
  Future<String> getStoredAuthToken() async {
    // Try to read the file.
    File tokenFile = await Config.tokenFilePath;
    log("Attempting to get stored auth token from ${tokenFile.path}");
    return await tokenFile.readAsString();
  }

  // asyncLoad : Asynchronously load up the application.
  // This function contains logic for routing the user to the appropriate
  // screen after loading.
  Future<void> asyncLoad() async {
    // Load environment secrets.
    await Config.loadSecrets();

    try {
      // Attempt to login.
      log("Attempting to authenticate with Spotify...");

      // Get stored auth token.
      // If no stored token, FileSystemException thrown.
      var token = await getStoredAuthToken();
      log("Authentication successful! Bringing user to main screen.");
      // Then navigate to the main screen together with the saved token.
      Navigator.of(context).pushReplacementNamed(
          RouteDelegator.MAIN_SCREEN_ROUTE,
          arguments: token);
    } on FileSystemException {
      log("No stored token found! Prompting user to login.");
      Navigator.of(context)
          .pushReplacementNamed(RouteDelegator.LOGIN_SCREEN_ROUTE);
    } on Exception catch (e) {
      // Platform is not supported.
      log("Exception: ${e.toString()}");
      showDialog(
          context: context,
          builder: (c) => ErrorDialog(c, "General Exception: ${e.toString()}"));
    }
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
