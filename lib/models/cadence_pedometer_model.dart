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
  ListQueue<int> _cadences = ListQueue(_queueSize); // Holds past cadences.
  late Stream<StepCount> _stepCountStream;
  Timer? _timer;

  late int _numSteps; // Number of steps from start.
  late bool _isActive; // Whether cadence is being calculated
  late int _startTime; // Milliseconds from epoch of start.

  CadencePedometerModel() {
    // Initialise the starting state for the model.
    _setInactiveState();

    // _timer not set up as initially, cadence is not calculated.
    _setUpCountStream();
  }

  // _setUpCountStream : Sets up streams for pedometer data.
  void _setUpCountStream() {
    // This step stream adds one to the current step count when
    // calculation is active, then notifies.
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      if (_isActive) {
        _numSteps += 1;
        notifyListeners();
      }
    }).onError((e) {
      log("Pedometer Error: ${e.toString()}");
    });
  }

  // _setInactiveState : Put model into inactive state.
  // This resets calculation variables to 0, stops the periodic timer,
  // and empties the cadence queue.
  void _setInactiveState() {
    _numSteps = _startTime = 0;
    _isActive = false;
    _timer?.cancel();
    _cadences.clear();
  }

  // _setActiveState : Put model into active state.
  // This sets the start time and also the timer for periodic calculation.
  void _setActiveState() {
    // Error correction with pedometer delay.
    _startTime = DateTime.now().millisecondsSinceEpoch +
        Duration(milliseconds: 500).inMilliseconds;
    // Create a new periodic timer.
    _setUpTimer();
  }

  // _setUpTimer : Creates a new periodic timer for cadence calculation.
  // This is called when the model is put into active state.
  // The timer is cancelled when the model is toggled to inactive state, and
  // a new timer will be created when it is re-toggled to active state.
  void _setUpTimer() {
    // This periodic timer updates the current cadence when calculation is active.
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int timeDifference = DateTime.now().millisecondsSinceEpoch - _startTime;
      // Needed due to start time error correction.
      if (timeDifference <= 0) {
        return;
      }
      int cadence = ((_numSteps / timeDifference) *
              Duration.secondsPerMinute *
              Duration.millisecondsPerSecond)
          .round();
      _cadences.add(cadence);
      // This ensures only _queueSize elements in the queue.
      if (_cadences.length > _queueSize) {
        _cadences.removeFirst();
      }
      log("$_cadences -> ${this.cadence}");
      notifyListeners();
    });
  }

  // toggleStatus : Toggles active state.
  // The model will re-configure itself based on the new state.
  void toggleStatus() {
    _isActive = !_isActive;
    log("Setting active state to $_isActive");
    if (!_isActive) {
      log("Active state has been set to false, resetting...");
      _setInactiveState();
    } else {
      log("Active state has been set to true, preparing for cadence calculation...");
      _setActiveState();
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
