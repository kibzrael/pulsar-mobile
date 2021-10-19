import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';

class ProfilePic extends StatelessWidget {
  final double radius;
  final String? url;

  final bool onMedia;

  ProfilePic(this.url, {required this.radius, this.onMedia = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              width: 1,
              style: url == null ? BorderStyle.solid : BorderStyle.none),
          color: Theme.of(context)
              .colorScheme
              .surface
              .withOpacity(onMedia ? 0.45 : 1),
          image: url != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(url!), fit: BoxFit.cover)
              : null),
      child: url != null
          ? null
          : Icon(
              MyIcons.account,
              size: radius,
              color: Theme.of(context).dividerColor,
            ),
    );
  }
}
