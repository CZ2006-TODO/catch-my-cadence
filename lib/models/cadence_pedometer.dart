import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:pedometer/pedometer.dart';

// CadencePedometer : Contains information regarding the current pedometer
// reading as well as cadence reading.
class CadencePedometer extends ChangeNotifier {
  // Private
  late Stream<StepCount> _stepCount;

  // Public
  int currStepCount = 0;

  void onStepUpdate(StepCount event) {
    log("Step Count updated, notifying listener~");
    currStepCount = event.steps;
    notifyListeners();
  }

  CadencePedometer() {
    _stepCount = Pedometer.stepCountStream;
    _stepCount.listen(onStepUpdate);
  }
}