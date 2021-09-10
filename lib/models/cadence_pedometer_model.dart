import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

// CadencePedometerModel is in charge of handling the pedometer data, as well
// as calculating the cadence when necessary.
class CadencePedometerModel extends ChangeNotifier {
  // Period for calculating cadence.
  static const int CADENCE_CALCULATION_PERIOD = 10;

  late Stream<StepCount> _stepCountStream;
  late Stream<void> _cadenceStream;

  int _numberOfSteps = 0; // number of steps in a specific time period
  int _currentCadence = 0; // current cadence of user
  bool _isActive = false;

  CadencePedometerModel() {
    // Initialise the starting state for the model.
    initState();
  }

  // initState : Asynchronously initialise the starting state for the model.
  // THis includes setting up the required streams.
  Future<void> initState() async {
    // TODO: Broken.
    // Request for permission to track steps
    while (!await Permission.activityRecognition.request().isGranted) {
      print("Permission not granted for pedometer, but is required");
    }

    // Initialise required streams.
    setUpStepCountStream();
    setUpCadenceStream();
  }

  // onStepCount : Listener for step count stream.
  // Used by setUpStepCountStream.
  void onStepCount(StepCount event) {
    _numberOfSteps += 1;
    notifyListeners();
  }

  // onStepCountError : Log an error if the pedometer encounters an error.
  // Used by setUpStepCountStream.
  void onStepCountError(error) {
    log("Pedometer Error: $error");
  }

  // setUpStepCountStream : Sets up the streamer for the step count.
  void setUpStepCountStream() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  // setUpCadenceStream : Sets up the streamer for the cadence.
  void setUpCadenceStream() {
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
}
