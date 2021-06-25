import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';

class MyListTile extends StatelessWidget {
  final bool trailingArrow;
  final String? trailingText;
  final Widget? trailing;
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Function? onPressed;
  final List<int> flexRatio;

  MyListTile(
      {this.flexRatio = const [10, 1],
      this.leading,
      this.onPressed,
      this.subtitle,
      required this.title,
      this.trailing,
      this.trailingArrow = true,
      this.trailingText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            if (leading != null)
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: leading,
              ),
            Expanded(
              flex: flexRatio[0],
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1),
                    if (subtitle != null)
                      SizedBox(
                        height: 5,
                      ),
                    if (subtitle != null)
                      Text(subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2)
                  ]),
            ),
            SizedBox(width: 15),
            if (trailingText != null)
              Expanded(
                flex: flexRatio[1],
                child: Text(trailingText!,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2),
              )
            else
              Spacer(),
            if (trailing != null) trailing!,
            if (trailingArrow)
              Icon(
                MyIcons.trailingArrow,
                color: Theme.of(context).textTheme.subtitle2!.color,
                size: 18,
              )
          ],
        ),
      ),
    );
  }
}
