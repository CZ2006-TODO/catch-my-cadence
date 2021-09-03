import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ErrorDialog : Shows an AlertDialog with an error message,
// and only a single button to dismiss the dialog.
class ErrorDialog extends AlertDialog {
  ErrorDialog(BuildContext context, String message)
      : super(title: Text("Oh no!"), content: Text(message), actions: [
    TextButton(
        child: Text("Alright!"),
        onPressed: () {
          Navigator.of(context).pop();
        }),
  ]);
}

// FatalErrorDialog: Shows an AlertDialog with an error message,
// that has a single option to close the app entirely.
class FatalErrorDialog extends AlertDialog {
  FatalErrorDialog(String message)
      : super(title: Text("App gonna crash!"), content: Text(message), actions: [
    TextButton(
      child: Text("Close App"),
      onPressed: () {
        SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      },
    )
  ]);
}
