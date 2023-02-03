import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;

  final double? width;
  final double? height;

  const SecondaryButton({Key? key, this.height, required this.text, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        width: width,
        height: height,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Theme.of(context).dividerColor,
            width: 1.2,
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall,
        ));
  }
}
