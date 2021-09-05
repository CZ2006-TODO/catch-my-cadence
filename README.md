# Catch My Cadence

An application that plays songs with a BPM matching your walking/running cadence.

## Getting Started
Minimal steps to run this application.
1. Clone the repo (or pull it).
2. Run the following commands:

```cmd
$ flutter pub get
```

3. Set up your `/assets/secrets.env` file. You may look at the example `.env` file provided for more
information.

## Implementation Details
The following have been implemented so far:
1. Login Flow
   - `loading_screen.dart` checks if the user has logged in before.
   - `login_screen.dart` does authentication.
   - `main_screen.dart` does connection to Spotify App.
2. Navigator to help navigate between pages (look at `routes.dart` for more details)
3. Splash screen (kinda)

## TODO list
Some of the things and thoughts I had while implementing the above:
1. Everything has been addressed! (so far)
