import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

// CadencePedometerWidget shows the current pedometer step count,
// whether cadence calculation is active, and if yes, the calculated cadence.
class CadencePedometerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Build cadence_pedometer_widget");
    final _model = context.watch<CadencePedometerModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Pedometer Reading:", style: TextStyle(fontSize: 30)),
        Text(_model.steps.toString(), style: TextStyle(fontSize: 50)),
        Divider(height: 30, color: Colors.white),
        Text(
            "Cadence Calculation status: ${_model.isActive ? "Active" : "Not Active"}",
            style: TextStyle(fontSize: 20)),
        Text("Cadence:", style: TextStyle(fontSize: 30)),
        Text(_model.cadence.toString(), style: TextStyle(fontSize: 40))
      ],
    );
  }
}
