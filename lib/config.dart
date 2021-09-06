import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

// Config stores the general global variables
class Config {
  // Private
  static const String _tokenFileName = "usrToken";

  // Public
  static String get clientId {
    return dotenv.get("CLIENT_ID", fallback: "read_client_id_err");
  }

  static String get redirectUrl {
    return dotenv.get("REDIRECT_URL", fallback: "read_redirect_url_err");
  }

  // Returns the path to the stored auth token file.
  static Future<File> get tokenFilePath async {
    // This is different from the Project Directory.
    // It refers to where the Platform OS keeps any persistent storage
    // linked to this app on the platform!
    final appDirectory = await getApplicationDocumentsDirectory();
    return File("${appDirectory.path}/$_tokenFileName");
  }

  // getStoredAuthToken : Attempts to get a saved authentication token from
  // persistent storage to connect with Spotify.
  // If there is no stored token, a FileSystemException is thrown.
  static Future<String> getStoredAuthToken() async {
    // Try to read the file.
    File tokenFile = await Config.tokenFilePath;
    log("Attempting to get stored auth token from ${tokenFile.path}");
    return await tokenFile.readAsString();
  }

  // storeAuthToken : Saves a provided authentication token into app persistent
  // memory.
  static Future<void> storeAuthToken(String token) async {
    File tokenFile = await Config.tokenFilePath;
    tokenFile.writeAsString(token);
  }

  // loadSecrets : Attempts to load the client ID and redirect URI associated
  // with this application.
  static Future<void> loadSecrets() async {
    await dotenv.load(fileName: "assets/secrets.env");
    log("""Loaded Secrets:
    CLIENT_ID: ${Config.clientId}
    REDIRECT_URI: ${Config.redirectUrl}""");
  }
}
