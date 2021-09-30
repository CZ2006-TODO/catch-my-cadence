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
        _buildDrawerHeader(context),
        _buildCMCItem(context),
        _buildAHItem(context),
        _buildInfoItem(context),
        _buildHelpItem(context),
        _buildSettingsItem(context),
      ]),
    );
  }

  UserAccountsDrawerHeader _buildDrawerHeader(BuildContext context) {
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

  ListTile _buildCMCItem(BuildContext context) {
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

  ListTile _buildAHItem(BuildContext context) {
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

  ListTile _buildInfoItem(BuildContext context) {
    return ListTile(
      title: Text(
        'About this App',
      ),
      leading: Icon(
        Icons.info,
      ),
      // onTap:(){
      // TODO: Link to relevant screens
      // }
    );
  }

  ListTile _buildHelpItem(BuildContext context) {
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

  ListTile _buildSettingsItem(BuildContext context) {
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
