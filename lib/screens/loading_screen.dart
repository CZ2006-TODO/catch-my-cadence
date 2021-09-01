import 'dart:developer';
import 'dart:io';

import 'package:catch_my_cadence/main.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

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
    clientID = dotenv.get("CLIENT_ID", fallback: "read_client_id_err");
    redirectURI = dotenv.get("REDIRECT_URI", fallback: "read_redirect_uri_err");
  }

  // getStoredAuthToken : Attempts to get a saved authentication token to
  // connect with Spotify. If the function fails to get an authentication token,
  // then an error will be returned.
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
      return Future.error(e);
    }
  }

  // asyncLoad : Asynchronously load up the application.
  // This application contains logic for routing the user to the appropriate
  // screen after loading.
  Future<void> asyncLoad() async {
    // First attempt to load environment secrets.
    await loadSecrets();
    log("""Loaded Secrets:
    CLIENT_ID: $clientID
    REDIRECT_URI: $redirectURI""");

    // Then attempt to load auth token.
    getStoredAuthToken().then((token) {
      // Successfully got a token.
      // Navigate to the main screen.
      log("Successfully loaded stored auth token!");
      Navigator.of(context)
          .pushReplacementNamed(MAIN_SCREEN_ROUTE, arguments: token);
    }, onError: (e) {
      // If future returns an error, rethrow it.
      throw e;
    }).catchError((e) {
      // If the result is an error, that means the user needs to login again.
      // Navigate to the login screen.
      log("Error while attempting to get stored auth token: ${e.toString()}");
      Navigator.of(context).pushReplacementNamed(LOGIN_SCREEN_ROUTE);
    });
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
