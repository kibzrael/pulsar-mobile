import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final bool enabled;
  final double fontSize;

  MyTextButton(
      {this.enabled = true,
      required this.text,
      required this.onPressed,
      this.fontSize = 18,
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
                              Theme.of(context).colorScheme.primaryVariant
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
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w600),
        ),
      ),
      onPressed: enabled ? onPressed as void Function()? : null,
    );
  }
}
