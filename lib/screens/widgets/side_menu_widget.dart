import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';

// SideMenu is the side menu for the application.
// This side menu contains options to go to other different screens
// such as the HelpScreen or the AboutScreen.
class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  //build sidemenu in the order below
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        _drawerHeader(),
        _homeOption(context),
        _activityHistoryOption(context),
        _aboutOption(context),
        _helpOption(context),
        _settingsOption(context),
      ]),
    );
  }

  //build the drawer header
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

  //Home
  ListTile _homeOption(BuildContext context) {
    return ListTile(
        title: Text(
          'Home',
        ),
        leading: Icon(
          Icons.home,
        ),
        onTap: () {
          //routes back to MainScreen on tap
          Navigator.of(context)
              .popUntil(ModalRoute.withName(RouteDelegator.MAIN_SCREEN_ROUTE));
        });
  }

  //ActivityHistory
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

  //About
  ListTile _aboutOption(BuildContext context) {
    return ListTile(
      title: Text(
        'About',
      ),
      leading: Icon(
        Icons.info,
      ),
      // onTap:(){
      // TODO: Link to About screen
      // }
    );
  }

  //Help
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

  //Settings
  ListTile _settingsOption(BuildContext context) {
    return ListTile(
      title: Text(
        'Settings',
      ),
      leading: Icon(
        Icons.settings,
      ),
      // onTap:(){
      // TODO: Link to settings screen
      // }
    );
  }
}
