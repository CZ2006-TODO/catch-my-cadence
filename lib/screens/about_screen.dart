import 'package:flutter/material.dart';

// AboutScreen provides basic information about the application.
// It is accessible via side menu options.
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        // Back arrow that returns to MainScreen.
        leading: IconButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("About Screen"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _AboutScreenBody(),
      ),
    );
  }
}

class _AboutScreenBody extends StatelessWidget {
  const _AboutScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Catch My Cadence",
          textAlign: TextAlign.center,
          style: Theme.of(ctx).textTheme.headline3,
        ),
        Text(
          "Catch My Cadence tracks your running cadence, "
          "and then finds a song from Spotify that matches your cadence.\n\n"
          "We believe that this will make your runs much more enjoyable! "
          "Stay safe, and have a good run!",
          textAlign: TextAlign.center,
          style: Theme.of(ctx).textTheme.headline6,
        ),
        Image.asset(
          "assets/images/splash_screen_without_words.png",
        ),
      ],
    );
  }
}
