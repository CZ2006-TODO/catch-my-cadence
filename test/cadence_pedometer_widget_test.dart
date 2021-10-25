import 'package:catch_my_cadence/screens/widgets/cadence_pedometer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'Cadence status and Cadence are displayed in the CadencePedometerWidget',
      (WidgetTester tester) async {
    String _cadenceStatus = "CADENCE_STATUS";
    String _cadenceValue = "100";
    await tester.pumpWidget(new MaterialApp(
      home: new CadencePedometerWidget(_cadenceStatus, _cadenceValue),
    ));

    expect(find.textContaining(_cadenceValue), findsOneWidget);
    expect(find.textContaining(_cadenceStatus), findsOneWidget);
  });
}
