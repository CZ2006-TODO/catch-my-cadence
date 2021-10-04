import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

// CadencePedometerModel is in charge of handling the pedometer data, as well
// as calculating the cadence when necessary.
class CadencePedometerModel with ChangeNotifier {
  static const _queueSize = 5;

  // Data streams
  ListQueue<int> _cadences = ListQueue(_queueSize); // Holds past calculated cadences.
  late Stream<StepCount> _stepCountStream;
  late Timer _timer;

  late int _numSteps; // Number of steps from start.
  late bool _isActive; // Whether cadence is being calculated
  late int _startTime; // Milliseconds from epoch of start.

  CadencePedometerModel() {
    // Initialise the starting state for the model.
    _resetState();
    _setUpDataStreams();
  }

  // resetState : Initialise the starting state for the model.
  // This includes setting up the required attributes and streams,
  // and also clears the cadence queue.
  void _resetState() {
    _numSteps = _startTime = 0;
    _isActive = false;
    _cadences.clear();
  }

  // setUpStepDataStreams : Sets up streams for the cadence data.
  // https://www.all8.com/tools/bpm.htm
  // Quite accurate for calculating cadence, trying to replicate.
  void _setUpDataStreams() {
    // This step stream adds one to the current step count when
    // calculation is active.
    _stepCountStream = Pedometer.stepCountStream
      ..listen((StepCount event) {
        if (_isActive) {
          _numSteps += 1;
          notifyListeners();
        }
      }).onError((e) {
        log("Pedometer Error: ${e.toString()}");
      });

    // This periodic timer updates the current cadence when calculation is active.
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isActive) {
        var timeDifference = DateTime.now().millisecondsSinceEpoch - _startTime;
        if (timeDifference <= 0) {
          return;
        }
        var cadence = ((_numSteps / timeDifference) *
                Duration.secondsPerMinute *
                Duration.millisecondsPerSecond)
            .round();
        _cadences.add(cadence);
        if (_cadences.length > _queueSize) {
          _cadences.removeFirst();
        }
        log(_cadences.toString());
        log(this.cadence.toString());
        notifyListeners();
      }
    });
  }

  // toggleStatus : Toggle isActive.
  void toggleStatus() {
    _isActive = !_isActive;
    log("Setting active state to $_isActive");
    if (!_isActive) {
      log("Active state has been set to false, resetting...");
      _resetState();
    } else {
      // Error correction with pedometer delay.
      _startTime = DateTime.now().millisecondsSinceEpoch +
          Duration(milliseconds: 500).inMilliseconds;
      log("Active state has been set to true, preparing for cadence calculation...");
    }
    notifyListeners();
  }

  // Getters
  int get steps {
    return _numSteps;
  }

  int get cadence {
    int total = _cadences.fold(0, (prev, next) => prev + next);
    return (total == 0) ? 0 : (total / _cadences.length).round();
  }

  bool get isActive {
    return _isActive;
  }
}
