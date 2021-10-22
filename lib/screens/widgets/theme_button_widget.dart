import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catch_my_cadence/theme_provider.dart';

class ThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    //Switch that allows user to toggle between darkTheme and lightTheme.
    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.changeTheme(value);
      },
    );
  }
}
