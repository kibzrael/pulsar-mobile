import 'package:flutter/material.dart';
import 'package:pulsar/providers/theme_provider.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? titleColor;
  final Function? onPressed;
  final double height;
  final double width;

  const ActionButton(
      {Key? key,
      this.backgroundColor,
      this.height = 50,
      this.width = double.infinity,
      this.onPressed,
      required this.title,
      this.titleColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onPressed as void Function()?,
      child: Container(
        height: height,
        width: width,
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: backgroundColor != null ? null : primaryGradient(),
            color: backgroundColor ??
                Theme.of(context).colorScheme.primaryContainer),
        child: Center(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor ?? Colors.white),
          ),
        )),
      ),
    );
  }
}
