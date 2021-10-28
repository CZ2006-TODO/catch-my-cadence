import 'dart:developer';

import 'package:catch_my_cadence/config.dart';
import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';

// SideMenu is the side menu for the application.
// This side menu contains options to go to other different screens
// such as the HelpScreen or the AboutScreen.
// The selected screens DO NOT replace the current screen.
// Instead, they should be pushed ON TOP of the current screen where applicable.
class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Returns a drawer containing a ListView containing multiple miscellaneous
    // widgets (options).
    // Using a ListView allows users to scroll up and down should it be required.
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        // The menu follows this order.
        _drawerHeader(),
        _homeOption(context),
        _aboutOption(context),
        _settingsOption(context),
        _logoutOption(context)
      ]),
    );
  }

  // _drawerHeader : Contains the user's name, email, and avatar
  UserAccountsDrawerHeader _drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        'Catch My Cadence',
      ),
      accountEmail: Text(
        'Run to the Beat',
      ),
      decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
              image:
                  AssetImage("assets/images/splash_screen_without_words.png"),
              fit: BoxFit.scaleDown)),
    );
  }

  // _homeOption: Routes the user back to MainScreen.
  ListTile _homeOption(BuildContext context) {
    return ListTile(
        title: Text(
          'Home',
        ),
        leading: Icon(
          Icons.home,
        ),
        onTap: () {
          // Pops all screens from view stack until MainScreen is at the top of the stack.
          Navigator.of(context)
              .popUntil(ModalRoute.withName(RouteDelegator.MAIN_SCREEN_ROUTE));
        });
  }

  // _aboutOption : Routes the user to AboutScreen to learn more about the app.
  ListTile _aboutOption(BuildContext context) {
    return ListTile(
        title: Text(
          'About',
        ),
        leading: Icon(
          Icons.info,
        ),
        onTap: () {
          // Pop SideMenu and push AboutScreen.
          Navigator.of(context)
              .popAndPushNamed(RouteDelegator.ABOUT_SCREEN_ROUTE);
        });
  }

  // _settingsOption : Routes user to SettingsScreen.
  ListTile _settingsOption(BuildContext context) {
    return ListTile(
        title: Text(
          'Settings',
        ),
        leading: Icon(
          Icons.settings,
        ),
        onTap: () {
          // Pop SideMenu and push SettingsScreen.
          Navigator.of(context)
              .popAndPushNamed(RouteDelegator.SETTINGS_SCREEN_ROUTE);
        });
  }

  // _LogoutOption : Routes the user to LoggedOutScreen.
  ListTile _logoutOption(BuildContext context) {
    return ListTile(
        title: Text(
          'Log Out',
        ),
        leading: Icon(
          Icons.logout,
        ),
        onTap: () {
          showLogoutDialog(context);
        });
  }
}

showLogoutDialog(BuildContext context) {
  // set up the button
  Widget cancelButton = TextButton(
    child: Text("CANCEL"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      // Sets firstRunFlag to true.
      Config.firstRunFlag = true;
      log("Logging Out");
      // "Restart" app by removing all screens from the stack
      // and loading the LoadingScreen again.
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteDelegator.LOADING_SCREEN_ROUTE, (Route<dynamic> route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Catch My Cadence"),
    content: Text("Are you sure you want to logout?"),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
