import 'package:catch_my_cadence/screens/main_screen.dart';
import 'package:flutter/material.dart';

// SideMenu is the side menu for the application.
// This side menu contains options to go to other different screens
// such as the HelpScreen or the AboutScreen.
class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Colors.black.withOpacity(0.8)),
        child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            _buildDrawerHeader(context),
            _buildCMCItem(context),
            Divider(),
            _buildAHItem(context),
            Divider(),
            _buildInfoItem(context),
            Divider(),
            _buildHelpItem(context),
            Divider(),
            _buildSettingsItem(context),
          ]),
        ));
  }

  UserAccountsDrawerHeader _buildDrawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
        accountName: Text(
          'Tan Ah Kow',
          style: TextStyle(backgroundColor: Color(0xFF778899).withOpacity(0.8)),
        ),
        accountEmail: Text(
          'tanahkow@gmail.com',
          style: TextStyle(backgroundColor: Color(0xFF778899).withOpacity(0.8)),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset("assets/images/splash_screen.png"),
        ),
        decoration: BoxDecoration(
          color: Color(0xFF778899).withOpacity(0.8),
        ));
  }

  ListTile _buildCMCItem(BuildContext context) {
    return ListTile(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          Icons.home,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        });
  }

  ListTile _buildAHItem(BuildContext context) {
    return ListTile(
      title: Text(
        'Activity History',
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        Icons.history,
        color: Colors.white,
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
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        Icons.info,
        color: Colors.white,
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
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        Icons.help,
        color: Colors.white,
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
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        Icons.settings,
        color: Colors.white,
      ),
      // onTap:(){
      // TODO: Link to relevant screens
      // }
    );
  }
}
