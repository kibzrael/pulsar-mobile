import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';

class LikeButton extends StatelessWidget {
  final bool liked;
  final double size;
  final Function? onPressed;
  final bool fill;
  final EdgeInsets padding;

  const LikeButton(
      {Key? key,
      required this.liked,
      this.onPressed,
      this.fill = false,
      this.padding = const EdgeInsets.all(8.0),
      this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        width: size + 16,
        height: size + 16,
        padding: padding,
        child: Icon(liked || fill ? MyIcons.like : MyIcons.likeOutline,
            size: size,
            color:
                liked ? Colors.redAccent : Theme.of(context).iconTheme.color),
      ),
    );
  }
}

class CommentButton extends StatelessWidget {
  final Function? onPressed;
  final double size;
  final EdgeInsets padding;

  const CommentButton(
      {Key? key,
      this.onPressed,
      this.padding = const EdgeInsets.all(8.0),
      this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        padding: padding,
        width: size + 16,
        height: size + 16,
        child: Icon(MyIcons.comment, size: size),
      ),
    );
  }
}

class RepostButton extends StatelessWidget {
  final bool reposted;
  final double size;
  final Function? onPressed;
  final EdgeInsets padding;

  const RepostButton(
      {Key? key,
      required this.reposted,
      this.onPressed,
      this.padding = const EdgeInsets.all(8.0),
      this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        padding: padding,
        width: size + 16,
        height: size + 16,
        child: Icon(reposted ? MyIcons.reposted : MyIcons.repost,
            size: size,
            color: reposted
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).iconTheme.color),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  final Function? onPressed;
  final double size;
  final EdgeInsets padding;

  const ShareButton(
      {Key? key,
      this.onPressed,
      this.padding = const EdgeInsets.all(8.0),
      this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        padding: padding,
        width: size + 16,
        height: size + 16,
        child: Icon(MyIcons.share, size: size),
      ),
    );
  }
}

class ReplyButton extends StatelessWidget {
  final Function? onPressed;
  final double size;

  const ReplyButton({Key? key, this.onPressed, this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: size + 16,
        height: size + 16,
        child: Icon(MyIcons.reply, size: size),
      ),
    );
  }
}
