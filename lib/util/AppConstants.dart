import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppConstants {
  static const double? sizePlayerControls = 36;
  static const Color colorPlayerControls = Color.fromARGB(255, 240, 240, 240);
  static const Color colorPlayerBackground = Color.fromARGB(255, 0, 0, 0);
  static const Color colorToastBackground = Color.fromARGB(128, 0, 0, 0);

  static void toast(String message,
      {Toast toastLength = Toast.LENGTH_SHORT,
      Color bg = colorToastBackground,
      Color fg = Colors.white}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: toastLength == Toast.LENGTH_SHORT ? 1 : 5,
        backgroundColor: bg,
        textColor: fg,
        fontSize: 16.0);
  }

  static void toastShort(String message) {
    toast(message);
  }

  static void toastShortError(String message) {
    toast(message, bg: Colors.red, fg: Colors.white);
  }

  static void toastShortSuccess(String message) {
    toast(message, bg: Colors.green, fg: Colors.white);
  }

  static void toastLong(String message) {
    toast(
      message,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void toastLongError(String message) {
    toast(message,
        toastLength: Toast.LENGTH_LONG, bg: Colors.red, fg: Colors.white);
  }

  static void toastLongSuccess(String message) {
    toast(message,
        toastLength: Toast.LENGTH_LONG, bg: Colors.green, fg: Colors.white);
  }
}
