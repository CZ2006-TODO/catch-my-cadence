import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;

import 'package:pedometer/pedometer.dart';

// CadencePedometerModel is in charge of handling the pedometer data, as well
// as calculating the cadence when necessary.
class CadencePedometerModel {
  static const _queueSize = 5;

  // Data streams
  final ListQueue<int> _cadences =
      ListQueue(_queueSize); // Holds past cadences.
  final Stream<StepCount> _stepCountStream = Pedometer.stepCountStream;
  Timer? _timer;

  int _numSteps = 0; // Number of steps from start.
  bool _isActive = false; // Whether cadence is being calculated
  int _startTime = 0; // Milliseconds from epoch of start.

  CadencePedometerModel() {
    // Initialise the starting state for the model.
    _setInactiveState();
    // Initialise the StepCount stream (only happens once).
    _setUpCountStream();
  }

  // _setUpCountStream : Sets up streams for pedometer data.
  void _setUpCountStream() {
    // This step stream adds one to the current step count when
    // calculation is active, then notifies.
    _stepCountStream.listen((StepCount event) {
      if (_isActive) {
        _numSteps += 1;
      }
    }).onError((e) {
      log("Pedometer Error: ${e.toString()}");
    });
  }

  // start : Start cadence calculation.
  void start() {
    log("Starting cadence calculation...");
    _setActiveState();
  }

  // _setActiveState : Put model into active state.
  // This sets the start time and also the timer for periodic calculation.
  void _setActiveState() {
    _isActive = true;
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
    log("Creating timer...");
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int timeDifference = this._timeElapsed;
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
      log("$_cadences <-: ${this.cadence}");
    });
  }

  // stop : Stop cadence calculation.
  void stop() {
    log("Stopping cadence calculation...");
    _setInactiveState();
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

  // calculateCadence ： Calculates cadence within a given sampling time period.
  // Note that this function uses a return value of -1 to indicate that the
  // result of the sampling is invalid.
  // This is indicated by a different startTime by the end of the calculation.
  Future<int> calculateCadence(int seconds) async {
    // Calculate cadence with sample time of 10 seconds.
    this.start();
    // Keep track of start time, so we can check if the button was pressed
    // again while we were polling.
    int startTime = _startTime;
    await Future.delayed(Duration(seconds: seconds));
    int cadence = this.cadence;
    if (startTime != _startTime) {
      return -1;
    }
    this.stop();
    return cadence;
  }

  // cadence : The current cadence calculated by the model.
  int get cadence {
    int total = _cadences.fold(0, (prev, next) => prev + next);
    return (total == 0) ? 0 : (total / _cadences.length).round();
  }

  // isActive : Whether the model is actively calculating the cadence.
  bool get isActive {
    return _isActive;
  }

  // _timeElapsed : Calculates the time since start of cadence calculation.
  int get _timeElapsed {
    if (!_isActive) {
      return 0;
    }
    var now = DateTime.now().millisecondsSinceEpoch;
    var diff = now - _startTime;
    // Needed due to start time error correction. See _setActiveState.
    return math.max(diff, 0); // Returns elapsed milliseconds.
  }
}
