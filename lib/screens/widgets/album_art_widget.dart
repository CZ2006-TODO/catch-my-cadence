import 'package:flutter/material.dart';
import 'package:spotify_sdk/enums/image_dimension_enum.dart';
import 'package:spotify_sdk/extensions/image_dimension_extension.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class AlbumArtWidget extends StatelessWidget {
  static final double _dim = ImageDimension.small.value.toDouble() * 2 / 3;

  final ImageUri? _imageUri;

  const AlbumArtWidget(this._imageUri);

  @override
  Widget build(BuildContext context) {
    if (this._imageUri == null) {
      return _noAlbumArtWidget();
    }
    return _hasAlbumArtWidget();
  }

  Widget _noAlbumArtWidget() {
    return SizedBox(
      height: _dim,
      width: _dim,
      child: Center(
          child: Text(
        "No image!",
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _hasAlbumArtWidget() {
    return FutureBuilder(
      future: SpotifySdk.getImage(
          imageUri: this._imageUri!, dimension: ImageDimension.large),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: _dim,
            width: _dim,
            child: Image.memory(snapshot.data),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: _dim,
            width: _dim,
            child: Center(
                child: Text(
              "Error getting image.",
              textAlign: TextAlign.center,
            )),
          );
        } else {
          return SizedBox(
            height: _dim,
            width: _dim,
            child: Center(
                child: Text("Getting image...", textAlign: TextAlign.center)),
          );
        }
      },
    );
  }
}
