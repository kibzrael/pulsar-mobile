import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';

class ProfilePic extends StatelessWidget {
  final double radius;
  final String? url;

  ProfilePic(this.url, {required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).inputDecorationTheme.fillColor,
          image:
              url != null ? DecorationImage(image: NetworkImage(url!)) : null),
      child: url != null
          ? null
          : Icon(
              MyIcons.account,
              size: radius,
            ),
    );
  }
}
