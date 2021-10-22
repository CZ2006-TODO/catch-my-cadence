import 'package:catch_my_cadence/screens/widgets/theme_button_widget.dart';
import 'package:flutter/material.dart';

// SettingsScreen allows user to change toggle dark theme within the app
// It is accessible via side menu options.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        // Back arrow that returns to MainScreen.
        leading: IconButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("Settings Screen"),
      ),
      // theme_button_widget
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            trailing: ThemeButtonWidget()),
      ),
    );
  }
}
