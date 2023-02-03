import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final bool enabled;
  final double fontSize;

  const MyTextButton(
      {Key? key,
      this.enabled = true,
      required this.text,
      required this.onPressed,
      this.fontSize = 18,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
      onPressed: enabled ? onPressed as void Function()? : null,
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
                  begin: Alignment.centerLeft,
                  colors: enabled
                      ? color == null
                          ? [
                              Theme.of(context).colorScheme.primaryContainer,
                              Theme.of(context).colorScheme.primary,
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
    );
  }
}
