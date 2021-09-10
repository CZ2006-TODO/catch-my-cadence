import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class CadencePedometerModel extends ChangeNotifier {
  late Stream<StepCount>
      _stepCountStream; // for pedometer to keep track of steps
  int _numberOfSteps = 0; // number of steps in a specific time period
  int _currentCadence = 0; // current cadence of user
  bool _isActive = false;

  static const int TIME_PERIOD = 10; // time period to update cadence
  static const int SECONDS_IN_ONE_MINUTE = 60;

  CadencePedometerModel() {
    initState();
  }

  void onStepCount(StepCount event) {
    _numberOfSteps += 1;
    notifyListeners();
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
  }

  void initState() async {
    // request for permission to track steps
    if (!await Permission.activityRecognition.request().isGranted) {
      print("Permission not granted");
    }

    // initalise pedometer and listen
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    // when isActive, every TIME_PERIOD, update cadence
    Stream.periodic(const Duration(seconds: TIME_PERIOD))
        .takeWhile((_) => _isActive)
        .forEach((e) {
      int updatedCadence =
          (_numberOfSteps / TIME_PERIOD * SECONDS_IN_ONE_MINUTE).round();

      _numberOfSteps = 0;
      _currentCadence = updatedCadence;
      notifyListeners();
    });
  }

  void toggleStatus() {
    _isActive = !_isActive;
  }

  int getCadence() {
    return _currentCadence;
  }

  int getSteps() {
    return _numberOfSteps;
  }

  bool getIsActive() {
    return _isActive;
  }
}
