import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Widget? child;
  final Function()? onPressed;
  final Color? color;

  const MyFloatingActionButton({Key? key, this.child, required this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: color == null
                    ? [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primaryContainer,
                      ]
                    : [color!, color!])),
        child: child,
      ),
    );
  }
}
