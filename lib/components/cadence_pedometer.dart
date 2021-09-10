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
  final bool isActive;

  CadencePedometer(this.onCadenceChange, this.isActive);
  @override
  CadencePedometerState createState() => CadencePedometerState();
}

class CadencePedometerState extends State<CadencePedometer> {
  late Stream<StepCount>
      _stepCountStream; // for pedometer to keep track of steps
  int _numberOfSteps = 0; // number of steps in a specific time period
  int _currentCadence = 0; // current cadence of user

  static const int TIME_PERIOD = 10; // time period to update cadence
  static const int SECONDS_IN_ONE_MINUTE = 60;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _numberOfSteps += 1;
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
  }

  void initPlatformState() async {
    // request for permission to track steps
    if (!await Permission.activityRecognition.request().isGranted) {
      print("Permission not granted");
    }

    // initalise pedometer and listen
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    // when isActive, every TIME_PERIOD, update cadence
    Stream.periodic(const Duration(seconds: TIME_PERIOD))
        .takeWhile((_) => widget.isActive)
        .forEach((e) {
      setState(() {
        int updatedCadence =
            (_numberOfSteps / TIME_PERIOD * SECONDS_IN_ONE_MINUTE).round();

        if (updatedCadence != _currentCadence) {
          widget.onCadenceChange(updatedCadence);
        }

        _currentCadence = updatedCadence;
        _numberOfSteps = 0;
      });
    });
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.isActive
              ? _currentCadence.toString() +
                  " steps per minute" +
                  _numberOfSteps.toString() +
                  " steps"
              : "",
        ),
      ],
    );
  }
}
