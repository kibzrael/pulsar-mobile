import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final Function? onPressed;

  final Map<bool, String> text;

  final double height;
  final double width;

  FollowButton(
      {this.height = 45,
      this.isFollowing = false,
      this.onPressed,
      this.text = const {true: 'Following', false: 'Follow'},
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isFollowing
                ? Colors.transparent
                : Theme.of(context).buttonColor,
            gradient: isFollowing
                ? null
                : LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).buttonColor
                  ]),
            border: isFollowing
                ? Border.all(
                    width: 1.5,
                    color: Theme.of(context).dividerColor,
                  )
                : Border.all(width: 0, style: BorderStyle.none)),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text[isFollowing]!,
            maxLines: 1,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isFollowing
                    ? Theme.of(context).textTheme.bodyText1!.color
                    : Colors.white),
          ),
        ),
      ),
    );
  }
}
