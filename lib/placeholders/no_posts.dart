import 'package:flutter/material.dart';

class NoPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.video_library,
            size: 75,
            color: Theme.of(context).textTheme.subtitle2!.color,
          ),
          SizedBox(height: 15),
          Text('No videos yet!',
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 24)),
        ],
      ),
    );
  }
}
