import 'package:flutter/material.dart';

class CadencePedometerWidget extends StatelessWidget {
  late final int steps;

  CadencePedometerWidget(int steps) {
    this.steps = steps;
  }

  @override
  Widget build(BuildContext context) {
    return Text(steps.toString() + " steps per minute");
  }
}
