import 'package:flutter/material.dart';

// CadencePedometerWidget shows the current pedometer step count,
// whether cadence calculation is active, and if yes, the calculated cadence.
class CadencePedometerWidget extends StatelessWidget {
  final String _cadenceStatus;
  final String _cadenceValue;

  const CadencePedometerWidget(this._cadenceStatus, this._cadenceValue);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Status
        Text("Pedometer Status: $_cadenceStatus",
            textAlign: TextAlign.center,
            style: Theme.of(ctx).textTheme.headline5),
        // Cadence
        Text("Cadence: $_cadenceValue",
            textAlign: TextAlign.center,
            style: Theme.of(ctx).textTheme.headline5),
      ],
    );
  }
}
