import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

// CadencePedometerModel is in charge of handling the pedometer data, as well
// as calculating the cadence when necessary.
class CadencePedometerModel extends ChangeNotifier with WidgetsBindingObserver {
  // Period for calculating cadence.
  static const int CADENCE_CALCULATION_PERIOD = 10;

  late Stream<StepCount> _stepCountStream;
  late Stream<void> _cadenceStream;

  int _numberOfSteps = 0; // number of steps in a specific time period
  int _currentCadence = 0; // current cadence of user
  bool _isActive = false;
  bool _shouldRestartPedometer = false;
  PermissionStatus? _permissionStatus;

  CadencePedometerModel() {
    // Initialise the starting state for the model.
    initState();
  }

  // initState : Asynchronously initialise the starting state for the model.
  // THis includes setting up the required streams.
  Future<void> initState() async {
    // Request for permission to track steps
    _checkPermission();

    // Initialise required streams and variables.
    _setUpStepCountStream();
    _setUpCadenceStream();
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

  // _onStepCount : Listener for step count stream.
  // Used by _setUpStepCountStream.
  void _onStepCount(StepCount event) {
    _numberOfSteps += 1;
    notifyListeners();
  }

  // _onStepCountError : Log an error if the pedometer encounters an error.
  // Used by _setUpStepCountStream.
  void _onStepCountError(error) {
    log("Pedometer Error: $error");
  }

  // _setUpStepCountStream : Sets up the streamer for the step count.
  void _setUpStepCountStream() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
  }

  // _setUpCadenceStream : Sets up the streamer for the cadence.
  void _setUpCadenceStream() {
    // When isActive, every TIME_PERIOD, update cadence
    _cadenceStream = Stream.periodic(
      const Duration(seconds: CADENCE_CALCULATION_PERIOD),
    );
    _cadenceStream.skipWhile((_) => !_isActive).forEach((_) {
      // To get the cadence, we can simply divide by the sampling period and
      // multiply by 60 to get the steps per minute.
      int updatedCadence = _numberOfSteps ~/
          CADENCE_CALCULATION_PERIOD *
          Duration.secondsPerMinute;

      _numberOfSteps = 0;
      _currentCadence = updatedCadence;
      log("Notifying new cadence: $_currentCadence");
      notifyListeners();
    });
  }

  // toggleStatus : Toggle isActive.
  void toggleStatus() {
    _isActive = !_isActive;
    _checkPermission();
    log("Setting active state to $_isActive");
    notifyListeners();
  }

  // Getters
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
    return _permissionStatus!.isGranted;
  }

  bool get shouldRestartPedometer {
    return _shouldRestartPedometer && _permissionStatus!.isGranted;
  }
}
