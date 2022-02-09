import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String body;
  final List<String> actions;
  final String destructive;

  const MyDialog(
      {Key? key, required this.title,
      required this.body,
      required this.actions,
      this.destructive = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(title),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(body),
      ),
      actions: [
        for (String action in actions)
          Container(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            child: CupertinoDialogAction(
              child: Text(action),
              isDestructiveAction: action == destructive,
              onPressed: () {
                Navigator.pop(context, action);
              },
            ),
          )
      ],
    );
  }
}
