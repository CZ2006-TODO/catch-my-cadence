import 'package:catch_my_cadence/models/cadence_pedometer_model.dart';
import 'package:catch_my_cadence/models/get_song_bpm_model.dart';
import 'package:catch_my_cadence/models/spotify_controller_model.dart';
import 'package:catch_my_cadence/screens/widgets/cadence_pedometer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// MainScreen is the screen that the user will see after confirming connection
// with Spotify.
// This screen also contains many other widgets such as the CadencePedometerWidget.
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: MainScreenBody(),
      drawer: SideMenuState(),
    );
  }
}

// MainScreenBody is the widget that acts as the main body of the main screen.
// This widget contains the CadencePedometerModel.
class MainScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    // Allows to hold multiple models.
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CadencePedometerModel()),

          // If required, the interaction between the 2 will change.
          // Right now, I can foresee a need for a proxy provider for communication
          // between GetSongBPMModel and SpotifyControllerModel
          Provider(create: (ctx) => GetSongBPMModel()),
          // lazy is set to false because usually models are not created until
          // they are needed, but we want to connect the moment user enters the
          // main screen.
          Provider(create: (ctx) => SpotifyControllerModel(ctx), lazy: false),
        ],
        child: Center(child: Consumer<CadencePedometerModel>(
          builder: (context, cadped, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(cadped.isActive ? "Stop" : "Start"),
                    onPressed: () => cadped.toggleStatus(),
                  ),
                  CadencePedometerWidget(
                    cadenceActive: cadped.isActive,
                    steps: cadped.steps,
                    cadence: cadped.cadence,
                  ),
                ]);
          },
        )));
  }
}

class SideMenu extends StatefulWidget {
  @override
  SideMenuState createState() => new SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: Center(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              currentAccountPicture: new CircleAvatar(
                radius: 50.0,
                backgroundColor: const Color(0xFF778899),
                backgroundImage:
                    NetworkImage("http://tineye.com/images/widgets/mona.jpg"),
              ),
              accountName: Text("Tan Ah Kow"),
              accountEmail: Text("")
            ),
          ],
        ),
      ),
    );
  }
}

Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0x626B8C),
                currentAccountPicture: CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/SNice.svg/1200px-SNice.svg.png"),)
              ),
              child: Text('Tan Ah Kow'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),