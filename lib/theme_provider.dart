import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //Uses system's theme first (and responsive to system).
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  //Theme is changed when theme_button_widget is pressed and notifyListeners.
  void changeTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppTheme {
  //Define darkTheme and lightTheme.
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF2121),
    colorScheme: ColorScheme.dark(),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    }),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.dark(),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    }),
  );
}
