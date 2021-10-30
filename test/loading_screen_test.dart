import 'package:catch_my_cadence/screens/confirm_connection_screen.dart';
import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    // wait until all widgets are initialsed
    // WidgetsFlutterBinding.ensureInitialized();
    // set default initial values
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    Config.prefs = pref;

    await dotenv.load(fileName: "assets/secrets.env");
    // by default grant all permissions
    const MethodChannel('flutter.baseflow.com/permissions/methods')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      return PermissionStatus.granted.index;
    });
  });

  testWidgets(
      'Loading screen redirects to confirm connection screen if first run',
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      title: "Catch My Cadence",
      initialRoute: RouteDelegator.LOADING_SCREEN_ROUTE,
      onGenerateRoute: RouteDelegator.delegateRoute,
    ));

    await tester.pump(Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(ConfirmConnectionScreen), findsOneWidget);
  });

  testWidgets('Loading screen redirects to main screen if already logged in',
      (WidgetTester tester) async {
    Config.firstRunFlag = false;
    await tester.pumpWidget(new MaterialApp(
      title: "Catch My Cadence",
      initialRoute: RouteDelegator.LOADING_SCREEN_ROUTE,
      onGenerateRoute: RouteDelegator.delegateRoute,
    ));

    await tester.pump(Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
  });
}
