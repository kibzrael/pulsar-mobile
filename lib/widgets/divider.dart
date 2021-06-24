import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 9,
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).dividerColor,
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).dividerColor
              ]),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          )),
    );
  }
}
