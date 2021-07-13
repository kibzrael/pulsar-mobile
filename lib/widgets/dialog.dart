import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String body;
  final List<String> actions;

  MyDialog({required this.title, required this.body, required this.actions});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(title),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(body),
      ),
      actions: [
        for (String action in actions)
          CupertinoDialogAction(
            child: Text(action),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ],
    );
  }
}
