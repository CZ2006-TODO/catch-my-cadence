import 'package:catch_my_cadence/routes.dart';
import 'package:flutter/material.dart';

// SideMenu is the side menu for the application.
// This side menu contains options to go to other different screens
// such as the HelpScreen or the AboutScreen.
class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  //SideMenu
  @override
  Widget build(BuildContext context) {
    //return a drawer containing a ListView containg multiple
    //widgets to allow users to scroll up and down should it be required
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        //SideMenu built in this order
        _drawerHeader(),
        _homeOption(context),
        _activityHistoryOption(context),
        _aboutOption(context),
        _helpOption(context),
        _settingsOption(context),
      ]),
    );
  }

  //DrawerHeader: Contains the user's name, email, and avatar
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

  //Home: Routes the user back to MainScreen
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
          //pops all screens from view stack until main screen is at the top of the stack
          Navigator.of(context)
              .popUntil(ModalRoute.withName(RouteDelegator.MAIN_SCREEN_ROUTE));
        });
  }

  //ActivityHistory: Routes the user to ActivityHistoryScreen
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

  //About: Routes the user to AboutScreen to learn more about the app
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

  //Help: Routes the user to HelpScreen where they can access website(if applicable)
  //or seek assisstance
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

  //Settings: Routes user to SettingsScreen
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
