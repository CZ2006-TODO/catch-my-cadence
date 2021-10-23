import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Config stores the general global variables
class Config {
  // Private
  static final String _firstRunFlag = "first_run";
  static final String _darkModeFlag = "dark_mode";

  static late SharedPreferences prefs;

  // Public
  static String get clientId {
    return dotenv.get("CLIENT_ID", fallback: "read_client_id_err");
  }

  static String get redirectUri {
    return dotenv.get("REDIRECT_URI", fallback: "read_redirect_uri_err");
  }

  static String get getSongBpmApiKey {
    return dotenv.get("GET_SONG_BPM_API_KEY",
        fallback: "read_song_bpm_api_err");
  }

  static bool get firstRunFlag {
    return prefs.getBool(_firstRunFlag) ?? true;
  }

  static set firstRunFlag(bool flag) {
    prefs.setBool(_firstRunFlag, flag);
  }

  static bool get isDarkMode {
    return prefs.getBool(_darkModeFlag) ?? false;
  }

  static set isDarkMode(bool flag) {
    prefs.setBool(_darkModeFlag, flag);
  }

  static ThemeData getTheme() {
    var theme = (isDarkMode) ? ThemeData.dark() : ThemeData.light();
    return theme.copyWith(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    }));
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
