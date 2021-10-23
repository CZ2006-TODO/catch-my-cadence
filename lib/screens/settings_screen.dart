import 'package:catch_my_cadence/config.dart';
import 'package:flutter/material.dart';

// SettingsScreen allows user to change toggle dark theme within the app
// It is accessible via side menu options.
class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Config.isDarkMode;
  }

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
        child: options(),
      ),
    );
  }

  ListView options() {
    return ListView(
      children: [
        // Change theme option
        SwitchListTile.adaptive(
            value: _isDarkMode,
            title: Text("Dark Mode"),
            subtitle: Text("Restart the app to view changes."),
            onChanged: (val) {
              Config.isDarkMode = val;
              setState(() {
                _isDarkMode = val;
              });
            })
      ],
    );
  }
}
