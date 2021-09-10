import 'package:flutter/material.dart';

class CadencePedometerWidget extends StatelessWidget {
  late final bool cadenceActive;
  late final int steps;
  late final String cadence;

  CadencePedometerWidget(
      {required this.cadenceActive,
      required this.steps,
      required int cadence}) {
    this.cadence = (this.cadenceActive) ? cadence.toString() : "-";
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
