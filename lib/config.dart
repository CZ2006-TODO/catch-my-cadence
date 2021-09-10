import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Config stores the general global variables
class Config {
  // Private
  static final String _firstRunFlag = "first_run";

  // Public
  static String get clientId {
    return dotenv.get("CLIENT_ID", fallback: "read_client_id_err");
  }

  static String get redirectUri {
    return dotenv.get("REDIRECT_URI", fallback: "read_redirect_uri_err");
  }

  // getFirstRunFlag : Checks if the user has opened the app before or not.
  // If the user is running the app for the first time, return true, else false.
  static Future<bool> getFirstRunFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstRunFlag) ?? true;
  }

  // setFirstRunFlag : Sets the first run flag to false
  static Future<void> setFirstRunFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_firstRunFlag, false);
  }

  // loadSecrets : Attempts to load the client ID and redirect URI associated
  // with this application.
  static Future<void> loadSecrets() async {
    await dotenv.load(fileName: "assets/secrets.env");
    log("""Loaded Secrets:
    CLIENT_ID: ${Config.clientId}
    REDIRECT_URI: ${Config.redirectUri}""");
  }
}
