import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  final Color? color;

  MyDivider({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: color ?? Theme.of(context).dividerColor,
              height: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'or',
              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              color: color ?? Theme.of(context).dividerColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
