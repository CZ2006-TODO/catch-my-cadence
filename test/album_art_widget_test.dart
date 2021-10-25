import 'package:catch_my_cadence/screens/loading_screen.dart';
import 'package:catch_my_cadence/screens/widgets/album_art_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_sdk/models/image_uri.dart';

void main() {
  group("Album art widget", () {
    testWidgets('Album widget shows no image if image URI is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(new MaterialApp(home: new AlbumArtWidget(null)));
      expect(find.textContaining("No image!"), findsOneWidget);
    });

    testWidgets('Album widget starts to fetch image if given image URI',
        (WidgetTester tester) async {
      await tester.pumpWidget(new MaterialApp(
          home: new AlbumArtWidget(new ImageUri("raw image uri"))));
      expect(find.textContaining("Getting image"), findsOneWidget);
    });
  });
}
