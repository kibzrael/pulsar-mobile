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
  final CrossAxisAlignment? crossAxisAlignment;

  const MyListTile({Key? key, 
    this.flexRatio = const [10, 1],
    this.leading,
    this.onPressed,
    this.subtitle,
    required this.title,
    this.trailing,
    this.trailingArrow = true,
    this.trailingText,
    this.crossAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: leading,
              ),
            Expanded(
              flex: flexRatio[0],
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1),
                    if (subtitle != null)
                      const SizedBox(
                        height: 5,
                      ),
                    if (subtitle != null)
                      Text(subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2)
                  ]),
            ),
            const SizedBox(width: 12),
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
              const Spacer(),
            if (trailing != null)
              DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!,
                  child: trailing!),
            if (trailingArrow) const TraillingArrow()
          ],
        ),
      ),
    );
  }
}

class TraillingArrow extends StatelessWidget {
  final double size;
  const TraillingArrow({Key? key, this.size = 15}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Icon(
        MyIcons.trailingArrow,
        color: Theme.of(context).textTheme.subtitle2!.color,
        size: size,
      ),
    );
  }
}
