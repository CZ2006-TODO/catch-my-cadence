import 'package:flutter/material.dart';

import '../main_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Color(0x3E3E3E)),
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
    );
  }

  UserAccountsDrawerHeader _buildDrawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
        accountName: Text(
          'Tan Ah Kow',
          style: TextStyle(backgroundColor: Color(0xFF778899)),
        ),
        accountEmail: Text(
          'tanahkow@gmail.com',
          style: TextStyle(backgroundColor: Color(0xFF778899)),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset("assets/images/splash_screen.png"),
        ),
        decoration: BoxDecoration(
          color: Color(0xFF778899),
        ));
  }

  ListTile _buildCMCItem(BuildContext context) {
    return ListTile(
        title: Text(
          'Catch My Cadence',
          style: TextStyle(color: Colors.white),
        ),
        leading: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 44,
            minHeight: 44,
            maxWidth: 44,
            maxHeight: 44,
          ),
          child: Image.asset("assets/images/cmc_home.png", fit: BoxFit.cover),
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
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 44,
          maxHeight: 44,
        ),
        child: Image.asset("assets/images/ah.png", fit: BoxFit.cover),
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
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 44,
          maxHeight: 44,
        ),
        child: Image.asset("assets/images/info.png", fit: BoxFit.cover),
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
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 44,
          maxHeight: 44,
        ),
        child: Image.asset("assets/images/help.png", fit: BoxFit.cover),
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
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 44,
          maxHeight: 44,
        ),
        child: Image.asset("assets/images/settings.png", fit: BoxFit.cover),
      ),
      // onTap:(){
      // TODO: Link to relevant screens
      // }
    );
  }
}
