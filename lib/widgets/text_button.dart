import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final bool enabled;

  MyTextButton(
      {this.enabled = true,
      required this.text,
      required this.onPressed,
      this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: enabled
                ? color ?? Theme.of(context).buttonColor
                : Theme.of(context).disabledColor),
      ),
      onPressed: enabled ? onPressed as void Function()? : null,
    );
  }
}
