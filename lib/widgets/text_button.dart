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
      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
                  begin: Alignment.centerLeft,
                  colors: enabled
                      ? color == null
                          ? [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).buttonColor
                            ]
                          : [color!, color!]
                      : [
                          Theme.of(context).disabledColor,
                          Theme.of(context).disabledColor
                        ])
              .createShader(rect);
        },
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
      ),
      onPressed: enabled ? onPressed as void Function()? : null,
    );
  }
}
