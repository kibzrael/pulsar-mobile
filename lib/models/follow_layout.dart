import 'package:flutter/material.dart';
import 'package:pulsar/widgets/follow_button.dart';

class FollowLayout extends StatelessWidget {
  final bool isFollowed;
  final void Function() onFollow;
  final Widget? middle;
  final void Function()? onMiddlePressed;
  final Widget child;
  final void Function() onChildPressed;

  final bool isPin;

  FollowLayout({
    required this.child,
    required this.isFollowed,
    this.isPin = false,
    required this.onChildPressed,
    required this.onFollow,
    this.middle,
    this.onMiddlePressed,
  });
  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).textTheme.bodyText1!.color),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
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
                width: constraints.maxWidth / 2 - (middle == null ? 0 : 45),
              ),
              SizedBox(width: 15),
              if (middle != null)
                InkWell(
                  onTap: onMiddlePressed,
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.zero,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      child: middle,
                      height: 35,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                  ),
                ),
              if (middle != null) SizedBox(width: 15),
              InkWell(
                onTap: onChildPressed,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.zero,
                  color: Theme.of(context).scaffoldBackgroundColor,
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
          );
        }),
      ),
    );
  }
}
