import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';

class SearchInput extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  SearchInput({this.onPressed, this.text = 'Search'});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      child: Container(
        width: double.infinity,
        height: 37.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(MyIcons.search,
                color: Theme.of(context).inputDecorationTheme.hintStyle!.color),
            SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: Theme.of(context).inputDecorationTheme.hintStyle,
            )
          ],
        ),
      ),
    );
  }
}
