import 'dart:developer';
import 'dart:io';

import 'package:catch_my_cadence/main.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:catch_my_cadence/screens/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

// LoadingScreen shows the loading screen when the user first starts the app.
// This screen contains the logic of checking the user authentication,
// and then routing the user to the appropriate screen.
class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  // loadSecrets : Attempts to load the client ID and redirect URI associated
  // with this application.
  Future<void> loadSecrets() async {
    await dotenv.load(fileName: "assets/secrets.env");
    clientId = dotenv.get("CLIENT_ID", fallback: "read_client_id_err");
    redirectUrl = dotenv.get("REDIRECT_URI", fallback: "read_redirect_uri_err");
    log("""Loaded Secrets:
    CLIENT_ID: $clientId
    REDIRECT_URI: $redirectUrl""");
  }

  // getStoredAuthToken : Attempts to get a saved authentication token to
  // connect with Spotify. If the function fails to get an authentication token,
  // it will return an empty string.
  Future<String> getStoredAuthToken() async {
    // Find the file containing the saved token.
    final appDirectory = await getApplicationDocumentsDirectory();
    File tokenFile = File("${appDirectory.path}/usrToken");

    // Try to read the file.
    try {
      log("Attempting to get stored auth token from ${tokenFile.path}");
      return await tokenFile.readAsString();
    } catch (e) {
      // If error getting auth tokens.
      return "";
    }
  }

  // asyncLoad : Asynchronously load up the application.
  // This function contains logic for routing the user to the appropriate
  // screen after loading.
  Future<void> asyncLoad() async {
    // First attempt to load environment secrets.
    await loadSecrets();

    try {
      // Attempt to login.
      log("Attempting to connect to Spotify...");

      if (Platform.isIOS) {
        // Try to load stored auth token.
        var token = await getStoredAuthToken();
        // If we get back empty string, then no stored token.
        if (token.isEmpty) {
          throw PlatformException(code: "NotLoggedInException");
        }
        await SpotifySdk.connectToSpotifyRemote(
            clientId: clientId, redirectUrl: redirectUrl, accessToken: token);
      } else if (Platform.isAndroid) {
        await SpotifySdk.connectToSpotifyRemote(
            clientId: clientId, redirectUrl: redirectUrl);
      } else {
        throw MissingPluginException;
      }

      Navigator.of(context)
          .pushReplacementNamed(RouteDelegator.MAIN_SCREEN_ROUTE);
    } on PlatformException catch (e) {
      // There are 2 possibilities.
      // 1. Spotify App not installed.         Ex: CouldNotFindSpotifyApp.
      // 2. User not logged in to Spotify app. Ex: NotLoggedInException.
      if (e.toString().contains("CouldNotFindSpotifyApp")) {
        log("No Spotify App found: ${e.toString()}");
        showDialog(
          context: context,
          builder: (_) => FatalErrorDialog("Spotify App not installed!"),
          barrierDismissible: false,
        );
      } else {
        log("User has not logged in before: ${e.toString()}");
        // We bring user to the login screen.
        Navigator.of(context)
            .pushReplacementNamed(RouteDelegator.LOGIN_SCREEN_ROUTE);
      }
    } on MissingPluginException {
      log("Platform not supported due to missing plugins.");
      showDialog(
        context: context,
        builder: (_) => FatalErrorDialog("This platform is not supported"),
        barrierDismissible: false,
      );
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
      appBar: AppBar(title: Text("Loading Screen")),
      body: Center(child: Text("Loading...")),
    );
  }
}
