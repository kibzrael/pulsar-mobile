import 'package:flutter/material.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/data/categories.dart';
import 'package:pulsar/providers/theme_provider.dart';

class DiscoverTags extends StatefulWidget {
  final String selected;
  final Function(String value) onChanged;

  DiscoverTags({required this.selected, required this.onChanged});

  @override
  _DiscoverTagsState createState() => _DiscoverTagsState();
}

class _DiscoverTagsState extends State<DiscoverTags> {
  List<Interest> tags = allCategories;

  String get selected => widget.selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          itemCount: tags.length + 2,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            String name = index == 0
                ? 'For you'
                : index == 1
                    ? 'Trending'
                    : tags[index - 2].name;
            return TagWidget(
                text: name,
                isSelected: selected == name,
                onPressed: widget.onChanged);
          }),
    );
  }
}

class TagWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function(String interest) onPressed;

  TagWidget(
      {required this.text, required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(text),
      child: AnimatedContainer(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.center,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.5,
                color: Theme.of(context).dividerColor,
                style: isSelected ? BorderStyle.none : BorderStyle.solid),
            gradient: isSelected ? secondaryGradient() : null,
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16.5,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.subtitle2!.color),
        ),
      ),
    );
  }
}
