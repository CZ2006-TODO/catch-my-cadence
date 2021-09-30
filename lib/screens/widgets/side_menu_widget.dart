import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';

// SideMenu is the side menu for the application.
// This side menu contains options to go to other different screens
// such as the HelpScreen or the AboutScreen.
class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

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
        child: Image.asset("assets/images/splash_screen.png"),
      ),
    );
  }

  ListTile _homeOption(BuildContext context) {
    return ListTile(
        title: Text(
          'Home',
        ),
        leading: Icon(
          Icons.home,
        ),
        onTap: () {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(RouteDelegator.MAIN_SCREEN_ROUTE));
        });
  }

  ListTile _activityHistoryOption(BuildContext context) {
    return ListTile(
      title: Text(
        'Activity History',
      ),
      leading: Icon(
        Icons.history,
      ),
      // onTap:(){
      // TODO: Link to relevant screens
      // }
    );
  }

  ListTile _aboutOption(BuildContext context) {
    return ListTile(
      title: Text(
        'About',
      ),
      leading: Icon(
        Icons.info,
      ),
      // onTap:(){
      // TODO: Link to relevant screens
      // }
    );
  }

  ListTile _helpOption(BuildContext context) {
    return ListTile(
      title: Text(
        'Help',
      ),
      leading: Icon(
        Icons.help,
      ),
      // onTap:(){
      // TODO: Link to relevant screens
      // }
    );
  }

  ListTile _settingsOption(BuildContext context) {
    return ListTile(
      title: Text(
        'Settings',
      ),
      leading: Icon(
        Icons.settings,
      ),
      // onTap:(){
      // TODO: Link to relevant screens
      // }
    );
  }
}
