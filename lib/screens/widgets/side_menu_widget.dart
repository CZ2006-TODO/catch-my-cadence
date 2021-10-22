import 'package:catch_my_cadence/routes.dart';
import 'package:catch_my_cadence/config.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

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
        _activityHistoryOption(context),
        _aboutOption(context),
        _helpOption(context),
        _settingsOption(context),
        _logoutOption(context)
      ]),
    );
  }

  // _drawerHeader : Contains the user's name, email, and avatar
  // TODO: Might not be possible to get such info using the provided SDK,
  // so might need to change to show other information.
  UserAccountsDrawerHeader _drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        'Tan Ah Kow',
      ),
      accountEmail: Text(
        'tanahkow@gmail.com',
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset("assets/images/Spotify_Icon_RGB_Green.png"),
      ),
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

  // _activityHistoryOption : Routes the user to ActivityHistoryScreen.
  ListTile _activityHistoryOption(BuildContext context) {
    return ListTile(
      title: Text(
        'Activity History',
      ),
      leading: Icon(
        Icons.history,
      ),
      // onTap:(){
      // TODO: Link to ActivityHistory screen
      // }
    );
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
          // Pops all screens from view stack until MainScreen is at the top of the stack, then push AboutScreen.
          Navigator.of(context).pushNamedAndRemoveUntil(
              RouteDelegator.ABOUT_SCREEN_ROUTE,
              ModalRoute.withName(RouteDelegator.MAIN_SCREEN_ROUTE));
        });
  }

  // _helpOption: Routes the user to HelpScreen where they can access
  // website(if applicable) or seek assistance.
  ListTile _helpOption(BuildContext context) {
    return ListTile(
      title: Text(
        'Help',
      ),
      leading: Icon(
        Icons.help,
      ),
      // onTap:(){
      // TODO: Link to Help screen
      // }
    );
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
          // Pops all screens from view stack until MainScreen is at the top of the stack, then push SettingsScreen.
          Navigator.of(context).pushNamedAndRemoveUntil(
              RouteDelegator.SETTINGS_SCREEN_ROUTE,
              ModalRoute.withName(RouteDelegator.MAIN_SCREEN_ROUTE));
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
          // Sets firstRunFlag to true, logs "logging out" and pops the entire view stack and push LoadingScreen.
          Config.setFirstRunFlag(true);
          log("Logging Out");
          Navigator.of(context).pushNamedAndRemoveUntil(
              RouteDelegator.LOADING_SCREEN_ROUTE,
              (Route<dynamic> route) => false);
        });
  }
}
