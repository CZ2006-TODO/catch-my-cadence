import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'main_screen_mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  setUp(() async {
    // https://stackoverflow.com/questions/60686746/how-to-access-flutter-environment-variables-from-tests
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(
        fileName: "assets/secrets.env"); // MainScreen requires secrets
  });
  group("Media widget", () {
    testWidgets(
        'Media widget displays appropriate message when no media is found',
        (WidgetTester tester) async {
      String text = "Not playing any songs matching your cadence";

      await tester.pumpWidget(new MaterialApp(
        home: new MainScreen(mockedMainScreenClient),
      ));

      expect(find.textContaining(text), findsOneWidget);
    });
  });
}
