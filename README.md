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
2. Navigator to help navigate between pages (look at `routes.dart` for more details)

## TODO list
Some of the things and thoughts I had while implementing the above:
1. Might be a good idea to add a Config class (to store all the minor config details). Currently,
they are quite scattered around. Some examples:
    - `usrToken`, which is the name of the file that stores the auth token, 
    is implemented as a string that appears more than once in multiple files (magic string???)
    - User scopes is a global list that appears in `login_screen.dart`.
2. The login flow is different for different devices (look through `loading_screen.dart` for info).
