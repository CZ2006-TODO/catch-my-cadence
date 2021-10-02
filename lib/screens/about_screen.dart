import 'package:flutter/material.dart';

// AboutScreen provides basic information about the application.
// It is accessible via side menu options.
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        // Back arrow that returns to MainScreen
        leading: IconButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("About Screen"),
      ),
      body: AboutScreenBody(),
    );
  }
}

class AboutScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
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
                textAlign: TextAlign.center,
              )),
        ),
        Container(
          height: 300,
          // makes image less opaque
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              "assets/images/splash_screen_without_words.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
