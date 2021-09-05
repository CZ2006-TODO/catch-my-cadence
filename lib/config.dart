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
    final appDirectory = await getApplicationDocumentsDirectory();
    return File("${appDirectory.path}/$_tokenFileName");
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
