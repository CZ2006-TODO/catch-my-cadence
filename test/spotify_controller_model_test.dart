import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:catch_my_cadence/screens/widgets/album_art_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'main_screen_mocks.dart';

void main() async {
  setUp(() async {
    await dotenv.load(
        fileName: "assets/secrets.env"); // MainScreen requires secrets
  });

  testWidgets('Gets song when start is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: new MainScreen(mockedMainScreenClient),
    ));

    await tester.tap(find.text("Start"));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // debugDumpApp();
    expect(find.byType(AlbumArtWidget), findsOneWidget);
  });
}
