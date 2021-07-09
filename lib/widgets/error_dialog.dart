import 'package:flutter/material.dart';

class NetworkAlertDialog {
  static showErrorDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An error occured!'),
        content: Text('Something went wrong'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'))
        ],
      ),
    );
  }
}
