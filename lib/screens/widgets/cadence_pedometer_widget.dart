import 'package:flutter/material.dart';

// CadencePedometerWidget shows the current pedometer step count,
// whether cadence calculation is active, and if yes, the calculated cadence.
class CadencePedometerWidget extends StatelessWidget {
  late final bool cadenceActive;
  late final String steps;
  late final String cadence;

  CadencePedometerWidget(
      {required this.cadenceActive,
      required int steps,
      required int cadence}) {
    if (this.cadenceActive) {
      this.steps = steps.toString();
      this.cadence = cadence.toString();
    } else {
      this.steps = this.cadence = "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Pedometer Reading:", style: TextStyle(fontSize: 30)),
        Text("$steps", style: TextStyle(fontSize: 50)),
        Divider(height: 30, color: Colors.white),
        Text(
            "Cadence Calculation status: ${cadenceActive ? "Active" : "Not Active"}",
            style: TextStyle(fontSize: 20)),
        Text("Cadence:", style: TextStyle(fontSize: 30)),
        Text("$cadence", style: TextStyle(fontSize: 40))
      ],
    );
  }
}
