import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final double? titleSize;
  final Widget child;
  final Widget? trailing;
  Section(
      {required this.title,
      required this.child,
      this.titleSize,
      this.trailing});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          SectionTitle(title: title, titleSize: titleSize, trailing: trailing),
          child,
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final double? titleSize;
  final Widget? trailing;
  SectionTitle({required this.title, this.titleSize, this.trailing});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: titleSize),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
