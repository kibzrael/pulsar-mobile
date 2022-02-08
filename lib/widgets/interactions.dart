import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';

class LikeButton extends StatelessWidget {
  final bool liked;
  final double size;
  final Function? onPressed;

  LikeButton({required this.liked, this.onPressed, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: size + 16,
        height: size + 16,
        padding: EdgeInsets.all(8.0),
        child: Icon(liked ? MyIcons.like : MyIcons.likeOutline,
            size: size,
            color:
                liked ? Colors.redAccent : Theme.of(context).iconTheme.color),
      ),
      onTap: onPressed as void Function()?,
    );
  }
}

class CommentButton extends StatelessWidget {
  final Function? onPressed;
  final double size;

  CommentButton({this.onPressed, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: size + 16,
        height: size + 16,
        child: Icon(MyIcons.comment, size: size),
      ),
      onTap: onPressed as void Function()?,
    );
  }
}

class RepostButton extends StatelessWidget {
  final bool reposted;
  final double size;
  final Function? onPressed;

  RepostButton({required this.reposted, this.onPressed, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: size + 16,
        height: size + 16,
        child: Icon(reposted ? MyIcons.reposted : MyIcons.repost,
            size: size,
            color: reposted
                ? Theme.of(context).colorScheme.primaryVariant
                : Theme.of(context).iconTheme.color),
      ),
      onTap: onPressed as void Function()?,
    );
  }
}

class ShareButton extends StatelessWidget {
  final Function? onPressed;
  final double size;

  ShareButton({this.onPressed, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: size + 16,
        height: size + 16,
        child: Icon(MyIcons.share, size: size),
      ),
      onTap: onPressed as void Function()?,
    );
  }
}

class ReplyButton extends StatelessWidget {
  final Function? onPressed;
  final double size;

  ReplyButton({this.onPressed, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: size + 16,
        height: size + 16,
        child: Icon(MyIcons.reply, size: size),
      ),
      onTap: onPressed as void Function()?,
    );
  }
}
