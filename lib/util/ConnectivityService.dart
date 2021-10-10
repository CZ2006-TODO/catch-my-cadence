import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  //
  StreamController<ConnectivityResult> connectionStatusController =
      StreamController<ConnectivityResult>();
  ConnectivityResult connRes = ConnectivityResult.none;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionStatusController.add(result);
    });
  }

  Stream<ConnectivityResult> connCheck() async* {
    var connectivityResult = await (Connectivity().checkConnectivity());
    yield connectivityResult;
  }

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup(
          'example.com'); // Using example.com arbitrarily
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
