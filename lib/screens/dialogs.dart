import 'package:flutter/material.dart';

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
