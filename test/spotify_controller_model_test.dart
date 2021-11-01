import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

void main() async {
  setUp(() async {
    await dotenv.load(
        fileName: "assets/secrets.env"); // MainScreen requires secrets
  });

  group("Main Screen", () {
    test('', () async {});
  });
}
