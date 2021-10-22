import 'package:catch_my_cadence/routes.dart';
import 'package:catch_my_cadence/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// App starts running from the main activity.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            // References theme_provider
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            title: "Catch My Cadence",
            // App always shows the loading screen when open.
            initialRoute: RouteDelegator.LOADING_SCREEN_ROUTE,
            onGenerateRoute: RouteDelegator.delegateRoute,
          );
        },
      );
}
