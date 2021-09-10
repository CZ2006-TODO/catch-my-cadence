import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

// CadencePedometerModel is in charge of handling the pedometer data, as well
// as calculating the cadence when necessary.
class CadencePedometerModel extends ChangeNotifier with WidgetsBindingObserver {
  late Stream<StepCount> _stepCountStream;

  late int _numberOfSteps; // number of steps in a specific time period
  late int _currentCadence; // current cadence of user
  late bool _isActive;
  late bool _shouldRestartPedometer;
  late int _startTime;
  PermissionStatus? _permissionStatus;

  CadencePedometerModel() {
    // Initialise the starting state for the model.
    resetState();
    initState();
  }

  void resetState() {
    _numberOfSteps = 0;
    _currentCadence = 0;
    _isActive = false;
    _shouldRestartPedometer = false;
    _startTime = 0;
  }

  // initState : Asynchronously initialise the starting state for the model.
  // THis includes setting up the required streams.
  Future<void> initState() async {
    // Request for permission to track steps
    _checkPermission();

    // Initialise required streams and variables.
    _setUpStepCountStream();
    _shouldRestartPedometer = false;

    // add observer
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  // remove observer and dispose when complete
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  // if permissions are changed from outside, we should update it
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    PermissionStatus permissionStatus =
        await Permission.activityRecognition.status;
    _permissionStatus = permissionStatus;

    // flag to indicate that once permission is granted later, we should restart pedometer
    if (!permissionStatus.isGranted && !_shouldRestartPedometer) {
      _shouldRestartPedometer = true;
    }
    notifyListeners();
  }

  void manuallyGrantPermission() async {
    await openAppSettings();
  }

  // _setUpStepCountStream : Sets up the streamer for the step count.
  // Implementation from https://www.all8.com/tools/hpm.htm
  void _setUpStepCountStream() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      if (_isActive) {
        _numberOfSteps += 1;
        if (_numberOfSteps == 1) {
          _startTime = DateTime.now().millisecondsSinceEpoch;
          return;
        }
        // Calculate the cadence.
        var thisTime = DateTime.now().millisecondsSinceEpoch;
        var timeDifference = thisTime - _startTime;
        // _numberOfSteps taken in timeDifference milliseconds.
        var calced = (_numberOfSteps /
            timeDifference *
            Duration.secondsPerMinute *
            Duration.millisecondsPerSecond);
        log("$calced");
        _currentCadence = calced.round();
        notifyListeners();
      }
    }).onError((e) {
      log("Pedometer Error: ${e.toString()}");
    });
  }

  // toggleStatus : Toggle isActive.
  void toggleStatus() {
    _isActive = !_isActive;
    _checkPermission();

    if (!_isActive) {
      log("Inactive, resetting...");
      resetState();
    }
    log("Setting active state to $_isActive");
    if (!_isActive) {
      log("Active state has been set to false, resetting...");
      resetState();
    } else {
      log("Active state has been set to true, preparing for cadence calculation...");
    }
    notifyListeners();
  }

  int get steps {
    return _numberOfSteps;
  }

  int get cadence {
    return _currentCadence;
  }

  bool get isActive {
    return _isActive;
  }

  bool get isGranted {
    return _permissionStatus != null ? _permissionStatus!.isGranted : false;
  }

  bool get shouldRestartPedometer {
    return _shouldRestartPedometer &&
        (_permissionStatus != null ? _permissionStatus!.isGranted : false);
  }
}
