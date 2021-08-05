import 'package:flutter/material.dart';
import 'package:pulsar/widgets/follow_button.dart';

class FollowLayout extends StatelessWidget {
  final bool isFollowed;
  final void Function() onFollow;
  final Widget child;
  final void Function() onChildPressed;

  final bool isPin;

  FollowLayout({
    required this.child,
    required this.isFollowed,
    this.isPin = false,
    required this.onChildPressed,
    required this.onFollow,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FollowButton(
            isFollowing: isFollowed,
            text: isPin
                ? {true: 'Pinned', false: 'Pin'}
                : {true: 'Following', false: 'Follow'},
            onPressed: onFollow,
            height: 35,
            width: MediaQuery.of(context).size.width / 2,
          ),
          SizedBox(width: 15),
          InkWell(
            onTap: onChildPressed,
            child: Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                child: child,
                height: 35,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
