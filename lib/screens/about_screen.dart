import 'package:catch_my_cadence/screens/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';

//AboutScreen introduces the user to the app
//Screen is accessible via side menu

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("About Screen"),
        ),
        drawer: SideMenu(),
        body: AboutScreenBody(),
      ),
    );
  }
}

class AboutScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    // creates a column containing a text container and an image
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
              // padding for container to allow text to be more centered in the screen
              padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
              height: 200,
              width: 350,
              child: Text(
                "Catch My Cadence is an application developed by a group of NTU students who seek to better integrate music into our exercises. The application tracks your cadence during your run, and then finds a song from Spotify that matches your cadence. We believe that this will make our runs much more enjoyable. Stay safe, and have a good run!",
                style: Theme.of(ctx).textTheme.bodyText1,
                textAlign: TextAlign.center,
              )),
        ),
        Container(
          height: 300,
          // makes image less opaque
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              "assets/images/spash_screen_without_words.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
