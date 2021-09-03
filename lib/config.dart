// Config stores the general global variables
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Config {
  // Private
  static const String _tokenFileName = "usrToken";

  // Public
  static late String clientId;
  static late String redirectUrl;

  // Returns the path to the stored auth token file.
  static Future<File> get tokenFilePath async {
    final appDirectory = await getApplicationDocumentsDirectory();
    return File("${appDirectory.path}/$_tokenFileName");
  }
}
