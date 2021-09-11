import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

// CadencePedometerModel is in charge of handling the pedometer data, as well
// as calculating the cadence when necessary.
class CadencePedometerModel extends ChangeNotifier {
  late Stream<StepCount> _stepCountStream;

  late int _numSteps; // Number of steps from start.
  late int _currentCadence; // Current cadence of user
  late bool _isActive; // Whether cadence is being calculated
  late int _startTime; // Milliseconds from epoch of first stop from start.

  CadencePedometerModel() {
    // TODO: Set up permission checking here.
    // Initialise the starting state for the model.
    resetState();
  }

  // initState : Initialise the starting state for the model.
  // This includes setting up the required attributes and streams.
  void resetState() {
    _numSteps = _currentCadence = _startTime = 0;
    _isActive = false;

    // Initialise required streams.
    setUpStepCountStream();
  }

  // setUpStepCountStream : Sets up the streamer for the step count.
  // https://www.all8.com/tools/bpm.htm
  // Quite accurate, trying to replicate.
  void setUpStepCountStream() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      if (_isActive) {
        _numSteps += 1;
        if (_numSteps == 1) {
          _startTime = DateTime.now().millisecondsSinceEpoch;
          return;
        }
        // Calculate the cadence.
        var thisTime = DateTime.now().millisecondsSinceEpoch;
        var timeDifference = thisTime - _startTime;
        // _numSteps taken in timeDifference milliseconds.
        var calculatedCadence = (_numSteps /
            timeDifference *
            Duration.secondsPerMinute *
            Duration.millisecondsPerSecond);
        log("$calculatedCadence");
        _currentCadence = calculatedCadence.round();
        notifyListeners();
      }
    }).onError((e) {
      log("Pedometer Error: ${e.toString()}");
    });
  }

  // toggleStatus : Toggle isActive.
  void toggleStatus() {
    _isActive = !_isActive;
    log("Setting active state to $_isActive");
    if (!_isActive) {
      log("Active state has been set to false, resetting...");
      resetState();
    } else {
      log("Active state has been set to true, preparing for cadence calculation...");
    }
    notifyListeners();
  }

  // Getters
  int get steps {
    return _numSteps;
  }

  int get cadence {
    return _currentCadence;
  }

  bool get isActive {
    return _isActive;
  }
}
