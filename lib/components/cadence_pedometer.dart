import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

// CadencePedometer : Contains information regarding the current pedometer
// reading as well as cadence reading.
class CadencePedometer extends StatefulWidget {
  final Function
      onCadenceChange; // A function that runs everytime cadence changes. (int updatedCadence) => void

  CadencePedometer(this.onCadenceChange);
  @override
  CadencePedometerState createState() => CadencePedometerState();
}

class CadencePedometerState extends State<CadencePedometer> {
  late Stream<StepCount>
      _stepCountStream; // for pedometer to keep track of steps
  int _numberOfSteps = 0; // number of steps in a specific time period
  int _initialNumberOfSteps =
      0; // initial number of steps when loaded. Pedometer tracks number of steps from phone boot
  int _cadence = 0; // cadence of user
  bool _isActive = false; // whether cadence is being actively calculated
  Timer timer = null; // timer to calculate cadence
  static const int TIME_PERIOD = 10; // time period to update cadence
  static const int SECONDS_IN_ONE_MINUTE = 60;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      if (_initialNumberOfSteps == 0) {
        _initialNumberOfSteps = event.steps;
      } else {
        _numberOfSteps = event.steps - _initialNumberOfSteps;
      }
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
  }

  void initPlatformState() async {
    if (!await Permission.activityRecognition.request().isGranted) {
      print("Permission not granted");
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void toggleCadenceCalculation() {
    setState(() {
      if (_isActive) {
        timer = Timer.periodic(
            Duration(seconds: TIME_PERIOD),
            (Timer t) => {
                  // every 10 seconds update cadence
                  setState(() {
                    int updatedCadence =
                        (_numberOfSteps / TIME_PERIOD * SECONDS_IN_ONE_MINUTE)
                            .round();
                    if (updatedCadence != _cadence) {
                      widget.onCadenceChange(updatedCadence);
                    }
                    _cadence = updatedCadence;
                    _initialNumberOfSteps += _numberOfSteps;
                    _numberOfSteps = 0;
                  })
                });
      } else {
        timer = null;
      }

      _isActive = !_isActive;
    })
 
  }

  @override
  Widget build(BuildContext context) {
    Column(
      children: [
        Text(
          _isActive ? _cadence.toString() +
              " steps per minute" +
              _numberOfSteps.toString() +
              " steps" : "",
        ),
        TextButton(
          child: Text(_isActive ? "Stop" : "Start"),
          onPressed: toggleCadenceCalculation,
        )
      ],
    ))
  }
}
